import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/core/units/units.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/features/settings/settings_repository.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late SettingsRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = SettingsRepository(db);
  });

  tearDown(() => db.close());

  test('fresh install has defaults', () async {
    expect(await repo.load(), const AppSettings());
  });

  test('saves and reloads every field', () async {
    const settings = AppSettings(
      onboardingCompleted: true,
      unitSystem: UnitSystem.imperial,
      themeMode: ThemeMode.dark,
      localeCode: 'hi',
    );
    await repo.save(settings);
    expect(await repo.load(), settings);
  });

  test('clearing the language returns to device language', () async {
    await repo.save(const AppSettings(localeCode: 'hi'));
    await repo.save(const AppSettings());
    expect((await repo.load()).localeCode, isNull);
  });

  test('current schema creates expected tables', () async {
    final tables = await db
        .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name")
        .map((r) => r.read<String>('name'))
        .get();
    expect(
        tables,
        containsAll([
          'app_settings',
          'feature_flag',
          'user_profile',
          'goal',
          'height_record',
          'weight_record',
          'body_measurement',
          'water_log',
          'meal',
          'sleep_log',
          'activity_log',
          'exercise_session',
          'habit',
          'habit_completion',
          'routine',
          'routine_item',
          'routine_completion',
          'posture_session',
          'posture_metric',
          'face_analysis',
          'face_metric',
          'hairstyle_favorite',
          'progress_snapshot',
          'wardrobe_item',
          'outfit',
          'outfit_item',
          'outfit_wear',
        ]));
    expect(db.schemaVersion, 8);
  });
}
