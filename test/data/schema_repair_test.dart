import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/data/repositories/profile_repository.dart';
import 'package:personality/domain/entities/body.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('a missing optional column is added back when the database opens',
      () async {
    final dir = await Directory.systemTemp.createTemp('repair');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/db.sqlite');

    // A database whose profile table lost a column (as one made by a
    // pre-release build had): every profile save failed.
    var db = AppDatabase(NativeDatabase(file));
    await db.customSelect('SELECT 1').get();
    await db.customStatement('ALTER TABLE user_profile DROP COLUMN region');
    await db.close();

    db = AppDatabase(NativeDatabase(file));
    final cols = await db
        .customSelect('PRAGMA table_info("user_profile")')
        .map((r) => r.read<String>('name'))
        .get();
    expect(cols, contains('region'));

    final repo = ProfileRepository(db);
    await repo.save(const Profile(goalWeightMinKg: 64, goalWeightMaxKg: 66));
    expect((await repo.load()).goalWeightMaxKg, 66);
    await db.close();
  });
}
