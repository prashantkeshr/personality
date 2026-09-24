import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// Key/value application settings. Typed access lives in SettingsRepository.
@DataClassName('SettingEntry')
class AppSettingsEntries extends Table {
  @override
  String get tableName => 'app_settings';

  TextColumn get key => text()();
  TextColumn get value => text()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Locally overridable feature flags (spec §48 FEATURE_FLAG).
@DataClassName('FeatureFlagEntry')
class FeatureFlags extends Table {
  @override
  String get tableName => 'feature_flag';

  TextColumn get id => text()();
  BoolColumn get enabled => boolean()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [AppSettingsEntries, FeatureFlags])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Bump together with a new `drift_schemas/` snapshot and a migration step.
  /// See docs/DATA_MODEL.md — destructive migrations are forbidden.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
