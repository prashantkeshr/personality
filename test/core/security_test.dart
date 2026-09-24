import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/core/database/encrypted_connection.dart';
import 'package:personality/core/security/database_key_store.dart';
import 'package:personality/core/units/units.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/features/settings/settings_repository.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('SecureDatabaseKeyStore', () {
    test('generates a 256-bit hex key once and reuses it', () async {
      FlutterSecureStorage.setMockInitialValues({});
      final store = SecureDatabaseKeyStore();
      final first = await store.obtainKey();
      expect(SecureDatabaseKeyStore.isValidKey(first), isTrue);
      expect(await store.obtainKey(), first);
    });

    test('never overwrites a malformed stored key', () async {
      FlutterSecureStorage.setMockInitialValues(
          {'personality.db.key.v1': 'not-a-key'});
      expect(SecureDatabaseKeyStore().obtainKey(), throwsStateError);
    });

    test('keys differ between generations', () {
      final random = Random.secure();
      expect(SecureDatabaseKeyStore.generateKey(random),
          isNot(SecureDatabaseKeyStore.generateKey(random)));
    });
  });

  group('encrypted database', () {
    late Directory dir;
    late File file;
    final key = SecureDatabaseKeyStore.generateKey(Random(1));
    final wrongKey = SecureDatabaseKeyStore.generateKey(Random(2));

    setUp(() {
      dir = Directory.systemTemp.createTempSync('personality_db');
      file = File('${dir.path}/test.sqlite');
    });

    tearDown(() => dir.deleteSync(recursive: true));

    AppDatabase open(String k) => AppDatabase(
        NativeDatabase(file, setup: (db) => applyEncryptionKey(db, k)));

    test('data round-trips with the right key and is unreadable otherwise',
        () async {
      final db = open(key);
      await SettingsRepository(db).save(const AppSettings(
          onboardingCompleted: true, unitSystem: UnitSystem.imperial));
      await db.close();

      // File on disk is not a plaintext SQLite database.
      final header = file.readAsBytesSync().take(15).toList();
      expect(String.fromCharCodes(header), isNot('SQLite format 3'));

      // Opening without a key fails.
      final raw = sqlite3.open(file.path);
      expect(() => raw.select('SELECT * FROM app_settings'),
          throwsA(isA<SqliteException>()));
      raw.close();

      // Wrong key fails.
      final wrong = open(wrongKey);
      await expectLater(SettingsRepository(wrong).load(), throwsA(anything));
      await wrong.close();

      // Right key reads the data back.
      final again = open(key);
      final loaded = await SettingsRepository(again).load();
      expect(loaded.onboardingCompleted, isTrue);
      expect(loaded.unitSystem, UnitSystem.imperial);
      await again.close();
    });

    test('rejects malformed keys before touching the database', () {
      final db = sqlite3.openInMemory();
      expect(() => applyEncryptionKey(db, "abc'; DROP TABLE x; --"),
          throwsArgumentError);
      db.close();
    });
  });
}
