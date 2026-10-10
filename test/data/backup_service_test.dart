import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/data/backup/backup_service.dart';
import 'package:personality/data/repositories/body_record_repository.dart';
import 'package:personality/data/repositories/health_repositories.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/features/settings/settings_repository.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final now = DateTime(2026, 10, 10, 9);
  const pass = 'correct horse battery';
  final jpeg = Uint8List.fromList(List.generate(300, (i) => i % 256));

  /// A phone with a weight, a night of sleep, a photo and settings.
  Future<AppDatabase> filled() async {
    final db = AppDatabase(NativeDatabase.memory());
    await BodyRecordRepository(db, db.weightRecords, unit: 'kg').add(Measurement(
        value: 72.5, unit: CanonicalUnits.mass, source: DataSource.userEntered,
        recordedAt: now));
    await SleepRepository(db, clock: () => now)
        .add(bedAt: DateTime(2026, 10, 9, 23), wakeAt: DateTime(2026, 10, 10, 6, 30),
            notes: 'slept "well", mostly');
    await db.into(db.snapshots).insert(SnapshotsCompanion.insert(
        id: 'p1', kind: 'face', takenAt: now.millisecondsSinceEpoch, jpeg: jpeg,
        width: 10, height: 10, createdAt: now.millisecondsSinceEpoch));
    await SettingsRepository(db).save(const AppSettings(
        onboardingCompleted: true, themeMode: ThemeMode.dark, localeCode: 'hi'));
    await db.customStatement(
        "INSERT INTO app_settings (key, value, updated_at) VALUES ('sync.steps', 'true', 0)");
    return db;
  }

  Future<int> count(AppDatabase db, String table) async =>
      (await db.customSelect('SELECT COUNT(*) AS n FROM "$table"').getSingle()).read<int>('n');

  test('encrypted round trip to a new phone, photos and settings included', () async {
    final a = await filled();
    final file = await BackupService(a, clock: () => now, iterations: 1000).createBackup(pass);
    // The plaintext never shows in the file.
    expect(latin1.decode(file, allowInvalid: true).contains('slept'), isFalse);

    final b = AppDatabase(NativeDatabase.memory());
    final service = BackupService(b, iterations: 1000);
    final contents = await service.open(file, pass);
    expect(contents.records, greaterThanOrEqualTo(3));
    expect(contents.photos, 1);
    await service.restore(contents, mode: RestoreMode.replace);

    expect(await count(b, 'weight_record'), 1);
    final nights = await SleepRepository(b).watchSince(DateTime(2026, 10, 1)).first;
    expect(nights.single.notes, 'slept "well", mostly');
    final photo = await b.select(b.snapshots).getSingle();
    expect(photo.jpeg, jpeg);
    final settings = await SettingsRepository(b).load();
    expect(settings.themeMode, ThemeMode.dark);
    expect(settings.localeCode, 'hi');
    // Device-only settings stay behind.
    expect(await count(b, 'app_settings'),
        (await b.customSelect("SELECT COUNT(*) AS n FROM app_settings WHERE key NOT LIKE 'sync.%'")
            .getSingle()).read<int>('n'));
    final sync = await b.customSelect("SELECT * FROM app_settings WHERE key = 'sync.steps'").get();
    expect(sync, isEmpty);
    await a.close();
    await b.close();
  });

  test('wrong passphrase, other files and damaged files are refused', () async {
    final a = await filled();
    final s = BackupService(a, iterations: 1000);
    final file = await s.createBackup(pass, photos: false);
    Future<BackupErrorKind?> kind(Uint8List bytes, String p) async {
      try {
        await s.open(bytes, p);
        return null;
      } on BackupError catch (e) {
        return e.kind;
      }
    }

    expect(await kind(file, 'wrong passphrase'), BackupErrorKind.wrongPassphrase);
    expect(await kind(Uint8List.fromList(utf8.encode('hello world, not a backup')), pass),
        BackupErrorKind.notABackup);
    expect(await kind(Uint8List.sublistView(file, 0, 30), pass), BackupErrorKind.damaged);
    final flipped = Uint8List.fromList(file)..[file.length - 40] ^= 1;
    expect(await kind(flipped, pass), BackupErrorKind.wrongPassphrase); // tag check fails
    expect(() => s.createBackup('short'), throwsArgumentError);
    await a.close();
  });

  test('merge adds what is missing and never duplicates', () async {
    final a = await filled();
    final file = await BackupService(a, iterations: 1000).createBackup(pass);
    final b = await filled(); // its own, different records
    final s = BackupService(b, iterations: 1000);
    final c = await s.open(file, pass);
    await s.restore(c, mode: RestoreMode.merge);
    await s.restore(c, mode: RestoreMode.merge);
    expect(await count(b, 'weight_record'), 2);
    expect(await count(b, 'sleep_log'), 2);
    expect(await count(b, 'progress_snapshot'), 1); // same id 'p1'
    // Device setting on this phone is kept.
    expect(await b.customSelect("SELECT * FROM app_settings WHERE key = 'sync.steps'").get(),
        hasLength(1));
    await a.close();
    await b.close();
  });

  test('older backups without newer columns or tables still restore', () async {
    final b = AppDatabase(NativeDatabase.memory());
    final s = BackupService(b);
    await s.restore(
        BackupContents(createdAt: now, schemaVersion: 8, tables: {
          'weight_record': [
            {
              'id': 'w-old',
              'value': 80.0,
              'unit': 'kg',
              'source': 'userEntered',
              'recorded_at': now.millisecondsSinceEpoch,
              'created_at': now.millisecondsSinceEpoch,
              'updated_at': now.millisecondsSinceEpoch,
              'retired_column': 'ignored',
            },
          ],
          'table_from_the_past': [
            {'id': 'x'}
          ],
        }),
        mode: RestoreMode.merge);
    expect(await count(b, 'weight_record'), 1);
    await b.close();
  });

  test('CSV zip has a table per record kind, readable times, no photos', () async {
    final a = await filled();
    final zip = ZipDecoder().decodeBytes(await BackupService(a, clock: () => now).exportCsvZip());
    final names = zip.files.map((f) => f.name).toSet();
    expect(names, containsAll(['weight_record.csv', 'sleep_log.csv', 'README.txt']));
    expect(names.contains('progress_snapshot.csv'), isFalse);
    final sleep = utf8.decode(zip.findFile('sleep_log.csv')!.content as List<int>);
    expect(sleep, contains('"slept ""well"", mostly"'));
    expect(sleep, contains('2026-10-09T23:00:00'));

    final json = jsonDecode(utf8.decode(await BackupService(a, clock: () => now).exportJson()))
        as Map<String, dynamic>;
    expect((json['tables'] as Map).containsKey('progress_snapshot'), isFalse);
    expect(json['schemaVersion'], a.schemaVersion);
    await a.close();
  });
}
