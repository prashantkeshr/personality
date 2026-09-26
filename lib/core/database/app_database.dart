import 'package:drift/drift.dart';

import 'app_database.steps.dart';

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

/// Single-row profile (id is always [ProfileRow.singletonId]).
@DataClassName('ProfileRow')
class UserProfiles extends Table {
  @override
  String get tableName => 'user_profile';

  TextColumn get id => text()();
  TextColumn get displayName => text().nullable()();
  TextColumn get ageRange => text().nullable()();
  TextColumn get activityLevel => text().nullable()();
  TextColumn get primaryHeightId => text().nullable()();
  RealColumn get goalWeightMinKg => real().nullable()();
  RealColumn get goalWeightMaxKg => real().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GoalRow')
class Goals extends Table {
  @override
  String get tableName => 'goal';

  TextColumn get type => text()();
  BoolColumn get active => boolean()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {type};
}

/// Provenance block shared by every measurement table (docs/DATA_MODEL.md).
mixin ProvenanceColumns on Table {
  TextColumn get id => text()();
  RealColumn get value => real()();
  TextColumn get unit => text()();
  TextColumn get source => text()();
  TextColumn get method => text().nullable()();
  TextColumn get confidence => text().nullable()();
  RealColumn get lowerBound => real().nullable()();
  RealColumn get upperBound => real().nullable()();
  IntColumn get recordedAt => integer()();
  TextColumn get notes => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('HeightRow')
@TableIndex(name: 'idx_height_recorded_at', columns: {#recordedAt})
class HeightRecords extends Table with ProvenanceColumns {
  @override
  String get tableName => 'height_record';
}

@DataClassName('WeightRow')
@TableIndex(name: 'idx_weight_recorded_at', columns: {#recordedAt})
class WeightRecords extends Table with ProvenanceColumns {
  @override
  String get tableName => 'weight_record';
}

@DataClassName('BodyMeasurementRow')
@TableIndex(
    name: 'idx_measurement_type_recorded_at', columns: {#type, #recordedAt})
class BodyMeasurements extends Table with ProvenanceColumns {
  @override
  String get tableName => 'body_measurement';

  TextColumn get type => text()();
  TextColumn get customLabel => text().nullable()();
}

@DataClassName('WaterRow')
@TableIndex(name: 'idx_water_recorded_at', columns: {#recordedAt})
class WaterLogs extends Table with ProvenanceColumns {
  @override
  String get tableName => 'water_log';
}

@DataClassName('MealRow')
@TableIndex(name: 'idx_meal_eaten_at', columns: {#eatenAt})
class Meals extends Table {
  @override
  String get tableName => 'meal';

  TextColumn get id => text()();
  TextColumn get mealType => text()();
  TextColumn get customName => text().nullable()();
  TextColumn get food => text()();
  TextColumn get quantity => text().nullable()();
  RealColumn get calories => real().nullable()();
  IntColumn get eatenAt => integer()();
  TextColumn get notes => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SleepRow')
@TableIndex(name: 'idx_sleep_wake_at', columns: {#wakeAt})
class SleepLogs extends Table {
  @override
  String get tableName => 'sleep_log';

  TextColumn get id => text()();
  IntColumn get bedAt => integer()();
  IntColumn get wakeAt => integer()();
  TextColumn get source => text()();
  TextColumn get notes => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ActivityRow')
@TableIndex(name: 'idx_activity_recorded_at', columns: {#recordedAt})
class ActivityLogs extends Table {
  @override
  String get tableName => 'activity_log';

  TextColumn get id => text()();
  TextColumn get kind => text()();
  IntColumn get durationMinutes => integer().nullable()();
  IntColumn get steps => integer().nullable()();
  RealColumn get distanceKm => real().nullable()();
  IntColumn get recordedAt => integer()();
  TextColumn get source => text()();
  TextColumn get notes => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExerciseSessionRow')
@TableIndex(name: 'idx_exercise_performed_at', columns: {#performedAt})
class ExerciseSessions extends Table {
  @override
  String get tableName => 'exercise_session';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  IntColumn get durationMinutes => integer()();
  IntColumn get sets => integer().nullable()();
  IntColumn get reps => integer().nullable()();
  IntColumn get performedAt => integer()();
  TextColumn get source => text()();
  TextColumn get notes => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('HabitRow')
class Habits extends Table {
  @override
  String get tableName => 'habit';

  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get weekdays => integer()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('HabitCompletionRow')
@TableIndex(name: 'idx_habit_completion_day', columns: {#day})
class HabitCompletions extends Table {
  @override
  String get tableName => 'habit_completion';

  TextColumn get habitId =>
      text().references(Habits, #id, onDelete: KeyAction.cascade)();

  /// Local calendar day, yyyymmdd.
  IntColumn get day => integer()();
  TextColumn get status => text()();
  IntColumn get recordedAt => integer()();

  @override
  Set<Column> get primaryKey => {habitId, day};
}

@DriftDatabase(tables: [
  AppSettingsEntries,
  FeatureFlags,
  UserProfiles,
  Goals,
  HeightRecords,
  WeightRecords,
  BodyMeasurements,
  WaterLogs,
  Meals,
  SleepLogs,
  ActivityLogs,
  ExerciseSessions,
  Habits,
  HabitCompletions,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Bump together with `dart run drift_dev make-migrations` and a new step
  /// below. Destructive migrations are forbidden (docs/DATA_MODEL.md).
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: stepByStep(
          from1To2: (m, schema) async {
            await m.createTable(schema.userProfile);
            await m.createTable(schema.goal);
            await m.createTable(schema.heightRecord);
            await m.createTable(schema.weightRecord);
            await m.createTable(schema.bodyMeasurement);
            await m.createIndex(schema.idxHeightRecordedAt);
            await m.createIndex(schema.idxWeightRecordedAt);
            await m.createIndex(schema.idxMeasurementTypeRecordedAt);
          },
          from2To3: (m, schema) async {
            await m.createTable(schema.waterLog);
            await m.createTable(schema.meal);
            await m.createTable(schema.sleepLog);
            await m.createTable(schema.activityLog);
            await m.createTable(schema.exerciseSession);
            await m.createTable(schema.habit);
            await m.createTable(schema.habitCompletion);
            await m.createIndex(schema.idxWaterRecordedAt);
            await m.createIndex(schema.idxMealEatenAt);
            await m.createIndex(schema.idxSleepWakeAt);
            await m.createIndex(schema.idxActivityRecordedAt);
            await m.createIndex(schema.idxExercisePerformedAt);
            await m.createIndex(schema.idxHabitCompletionDay);
          },
        ),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
