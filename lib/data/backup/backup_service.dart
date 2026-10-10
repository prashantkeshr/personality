import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import '../repositories/body_record_repository.dart';

/// Portable copy of everything the user keeps — no server involved.
///
/// File layout (`.personality`):
///   "PRSNLTY1" | u32 header length | header JSON | AES-256-GCM ciphertext | 16-byte tag
/// The plaintext is gzipped JSON of every table. The key comes from the
/// user's passphrase (PBKDF2-HMAC-SHA256); without it the file is unreadable.
class BackupService {
  BackupService(this._db, {Clock? clock, this.iterations = 210000})
      : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final Clock _clock;

  /// PBKDF2 rounds for new backups (stored in the file, so restores use
  /// whatever the backup was made with).
  final int iterations;

  static const _magic = 'PRSNLTY1';
  static const format = 1;

  /// Settings that belong to this device, not to the person.
  static const _deviceKeys = ['sync.', 'backup.'];

  static bool _deviceSetting(String key) => _deviceKeys.any(key.startsWith);

  // ---------------------------------------------------------------- collect

  Future<Map<String, List<Map<String, Object?>>>> collect({bool photos = true}) async {
    final out = <String, List<Map<String, Object?>>>{};
    for (final t in _db.allTables) {
      final name = t.actualTableName;
      if (!photos && name == 'progress_snapshot') continue;
      final blobs = {
        for (final c in t.$columns)
          if (c.type == DriftSqlType.blob) c.name
      };
      final rows = await _db.customSelect('SELECT * FROM "$name"').get();
      out[name] = [
        for (final r in rows)
          {
            for (final e in r.data.entries)
              if (!(name == 'app_settings' && e.key == 'key' && _deviceSetting(e.value as String)))
                e.key: blobs.contains(e.key)
                    ? (photos && e.value != null
                        ? {r'$b64': base64Encode(e.value as Uint8List)}
                        : null)
                    : e.value,
          },
      ]..removeWhere((row) => name == 'app_settings' && !row.containsKey('key'));
    }
    return out;
  }

  Map<String, Object?> _payload(Map<String, List<Map<String, Object?>>> tables) => {
        'format': format,
        'schemaVersion': _db.schemaVersion,
        'createdAt': _clock().toUtc().toIso8601String(),
        'tables': tables,
      };

  /// Unencrypted JSON (for other apps). Photos only when asked.
  Future<Uint8List> exportJson({bool photos = false}) async => Uint8List.fromList(
      utf8.encode(const JsonEncoder.withIndent(' ').convert(_payload(await collect(photos: photos)))));

  // ----------------------------------------------------------- encrypt

  static final _aes = AesGcm.with256bits();

  static Future<SecretKey> _key(String passphrase, List<int> salt, int rounds) =>
      Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: rounds, bits: 256)
          .deriveKeyFromPassword(password: passphrase, nonce: salt);

  static List<int> _random(int n) {
    final r = Random.secure();
    return List<int>.generate(n, (_) => r.nextInt(256));
  }

  Future<Uint8List> createBackup(String passphrase, {bool photos = true}) async {
    if (passphrase.length < 8) throw ArgumentError('Passphrase too short');
    final json = jsonEncode(_payload(await collect(photos: photos)));
    final rounds = iterations;
    // Key stretching and encryption are slow in Dart; keep the UI smooth.
    return Isolate.run(() => _seal(json, passphrase, rounds));
  }

  static Future<Uint8List> _seal(String json, String passphrase, int rounds) async {
    final plain = const GZipEncoder().encode(utf8.encode(json));
    final salt = _random(16);
    final nonce = _random(12);
    final box = await _aes.encrypt(plain,
        secretKey: await _key(passphrase, salt, rounds), nonce: nonce);
    final header = utf8.encode(jsonEncode({
      'v': format,
      'kdf': 'pbkdf2-sha256',
      'iter': rounds,
      'salt': base64Encode(salt),
      'nonce': base64Encode(nonce),
    }));
    final b = BytesBuilder()
      ..add(ascii.encode(_magic))
      ..add((ByteData(4)..setUint32(0, header.length)).buffer.asUint8List())
      ..add(header)
      ..add(box.cipherText)
      ..add(box.mac.bytes);
    return b.takeBytes();
  }

  /// Decrypts a backup. Throws [BackupError] with a reason.
  Future<BackupContents> open(Uint8List bytes, String passphrase) async {
    final payload = await Isolate.run(() => _unseal(bytes, passphrase));
    if ((payload['schemaVersion'] as int) > _db.schemaVersion) {
      throw const BackupError(BackupErrorKind.tooNew);
    }
    return BackupContents(
      createdAt: DateTime.parse(payload['createdAt'] as String),
      schemaVersion: payload['schemaVersion'] as int,
      tables: {
        for (final e in (payload['tables'] as Map<String, dynamic>).entries)
          e.key: [for (final r in e.value as List) (r as Map).cast<String, Object?>()],
      },
    );
  }

  static Future<Map<String, dynamic>> _unseal(Uint8List bytes, String passphrase) async {
    if (bytes.length < 12 || ascii.decode(bytes.sublist(0, 8), allowInvalid: true) != _magic) {
      throw const BackupError(BackupErrorKind.notABackup);
    }
    final len = ByteData.sublistView(bytes, 8, 12).getUint32(0);
    if (12 + len + 16 > bytes.length) throw const BackupError(BackupErrorKind.damaged);
    final Map<String, dynamic> h;
    try {
      h = jsonDecode(utf8.decode(bytes.sublist(12, 12 + len))) as Map<String, dynamic>;
    } catch (_) {
      throw const BackupError(BackupErrorKind.damaged);
    }
    if ((h['v'] as int? ?? 99) > format) throw const BackupError(BackupErrorKind.tooNew);
    final body = bytes.sublist(12 + len);
    final key = await _key(passphrase, base64Decode(h['salt'] as String), h['iter'] as int);
    final List<int> plain;
    try {
      plain = await _aes.decrypt(
          SecretBox(body.sublist(0, body.length - 16),
              nonce: base64Decode(h['nonce'] as String),
              mac: Mac(body.sublist(body.length - 16))),
          secretKey: key);
    } on SecretBoxAuthenticationError {
      throw const BackupError(BackupErrorKind.wrongPassphrase);
    }
    try {
      return jsonDecode(utf8.decode(const GZipDecoder().decodeBytes(plain)))
          as Map<String, dynamic>;
    } catch (_) {
      throw const BackupError(BackupErrorKind.damaged);
    }
  }

  // ----------------------------------------------------------- restore

  /// Writes [c] into this database. Only tables and columns this version
  /// knows are used, so older backups restore cleanly; new columns keep
  /// their defaults. Device-specific settings on this phone are kept.
  Future<void> restore(BackupContents c, {required RestoreMode mode}) async {
    final known = {
      for (final t in _db.allTables) t.actualTableName: {for (final col in t.$columns) col.name}
    };
    await _db.transaction(() async {
      // Check foreign keys once everything is in.
      await _db.customStatement('PRAGMA defer_foreign_keys = ON');
      if (mode == RestoreMode.replace) {
        for (final name in known.keys) {
          await _db.customStatement(name == 'app_settings'
              ? "DELETE FROM app_settings WHERE key NOT LIKE 'sync.%' AND key NOT LIKE 'backup.%'"
              : 'DELETE FROM "$name"');
        }
      }
      for (final e in c.tables.entries) {
        final cols = known[e.key];
        if (cols == null) continue;
        for (final row in e.value) {
          if (e.key == 'app_settings' && _deviceSetting('${row['key']}')) continue;
          final keys = [for (final k in row.keys) if (cols.contains(k)) k];
          if (keys.isEmpty) continue;
          final values = [
            for (final k in keys)
              switch (row[k]) {
                {r'$b64': final String s} => Uint8List.fromList(base64Decode(s)),
                final v => v,
              },
          ];
          final verb = mode == RestoreMode.replace || e.key == 'app_settings'
              ? 'INSERT OR REPLACE'
              : 'INSERT OR IGNORE';
          await _db.customStatement(
              '$verb INTO "${e.key}" (${keys.map((k) => '"$k"').join(', ')}) '
              'VALUES (${List.filled(keys.length, '?').join(', ')})',
              values);
        }
      }
    });
    _db.notifyUpdates({for (final t in _db.allTables) TableUpdate.onTable(t)});
  }

  // ----------------------------------------------------------- CSV export

  /// A zip of one CSV per table (no photos). Times become local ISO dates.
  Future<Uint8List> exportCsvZip() async {
    final tables = await collect(photos: false);
    final archive = Archive();
    for (final e in tables.entries) {
      if (e.value.isEmpty) continue;
      final cols = <String>{for (final r in e.value) ...r.keys}.toList();
      final b = StringBuffer()..writeln(cols.map(_csv).join(','));
      for (final r in e.value) {
        b.writeln(cols.map((c) => _csv(_cell(c, r[c]))).join(','));
      }
      final data = utf8.encode(b.toString());
      archive.addFile(ArchiveFile('${e.key}.csv', data.length, data));
    }
    final readme = utf8.encode(
        'Personality export ${_clock().toIso8601String()}\n'
        'One CSV per kind of record. Columns ending in _at are local times; '
        'day columns are yyyymmdd. Photos are not included.\n');
    archive.addFile(ArchiveFile('README.txt', readme.length, readme));
    return Uint8List.fromList(ZipEncoder().encode(archive));
  }

  static Object? _cell(String col, Object? v) {
    if (v is int && (col.endsWith('_at') || col == 'taken_at') && v > 1000000000000) {
      return DateTime.fromMillisecondsSinceEpoch(v).toIso8601String();
    }
    return v;
  }

  static String _csv(Object? v) {
    if (v == null) return '';
    final s = '$v';
    return s.contains(RegExp(r'[",\n\r]')) ? '"${s.replaceAll('"', '""')}"' : s;
  }
}

enum RestoreMode { merge, replace }

enum BackupErrorKind { notABackup, damaged, wrongPassphrase, tooNew }

class BackupError implements Exception {
  const BackupError(this.kind);
  final BackupErrorKind kind;
  @override
  String toString() => 'BackupError(${kind.name})';
}

class BackupContents {
  const BackupContents({
    required this.createdAt,
    required this.schemaVersion,
    required this.tables,
  });

  final DateTime createdAt;
  final int schemaVersion;
  final Map<String, List<Map<String, Object?>>> tables;

  int get records => tables.entries
      .where((e) => e.key != 'app_settings')
      .fold(0, (s, e) => s + e.value.length);
  int get photos => tables['progress_snapshot']?.length ?? 0;
}
