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

  // v10: personalisation, all optional.
  TextColumn get gender => text().nullable()();
  TextColumn get dietPreference => text().nullable()();
  TextColumn get styleFit => text().nullable()();
  TextColumn get region => text().nullable()();

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

@DataClassName('RoutineRow')
class Routines extends Table {
  @override
  String get tableName => 'routine';

  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get weekdays => integer()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RoutineItemRow')
@TableIndex(name: 'idx_routine_item_routine', columns: {#routineId})
class RoutineItems extends Table {
  @override
  String get tableName => 'routine_item';

  TextColumn get id => text()();
  TextColumn get routineId =>
      text().references(Routines, #id, onDelete: KeyAction.cascade)();

  /// Local time, minutes after midnight.
  IntColumn get minuteOfDay => integer()();
  TextColumn get title => text()();
  TextColumn get kind => text()();
  BoolColumn get reminder => boolean().withDefault(const Constant(true))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Plan vs actual: what happened to a routine item on a day (spec §34).
/// Also serves as reminder history — reminders are routine items.
@DataClassName('PlanRecordRow')
@TableIndex(name: 'idx_plan_record_day', columns: {#day})
class PlanRecords extends Table {
  @override
  String get tableName => 'routine_completion';

  TextColumn get itemId =>
      text().references(RoutineItems, #id, onDelete: KeyAction.cascade)();
  IntColumn get day => integer()();
  TextColumn get outcome => text()();
  IntColumn get rescheduledMinute => integer().nullable()();
  IntColumn get recordedAt => integer()();

  @override
  Set<Column> get primaryKey => {itemId, day};
}

/// One saved posture check. Stores numbers only — never images (spec §69).
@DataClassName('PostureSessionRow')
@TableIndex(name: 'idx_posture_session_recorded_at', columns: {#recordedAt})
class PostureSessions extends Table {
  @override
  String get tableName => 'posture_session';

  TextColumn get id => text()();
  IntColumn get recordedAt => integer()();
  TextColumn get view => text()();
  IntColumn get framesUsed => integer()();
  TextColumn get confidence => text()();
  RealColumn get visibility => real()();
  TextColumn get source => text()();
  TextColumn get method => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PostureMetricRow')
class PostureMetrics extends Table {
  @override
  String get tableName => 'posture_metric';

  TextColumn get sessionId =>
      text().references(PostureSessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get metric => text()();
  RealColumn get value => real()();
  TextColumn get unit => text()();
  TextColumn get direction => text()();
  TextColumn get band => text()();
  RealColumn get spread => real()();
  TextColumn get confidence => text()();

  @override
  Set<Column> get primaryKey => {sessionId, metric};
}

/// A saved face-shape estimate. Proportions only — never images (spec §69).
@DataClassName('FaceAnalysisRow')
@TableIndex(name: 'idx_face_analysis_recorded_at', columns: {#recordedAt})
class FaceAnalyses extends Table {
  @override
  String get tableName => 'face_analysis';

  TextColumn get id => text()();
  IntColumn get recordedAt => integer()();
  TextColumn get shape => text()();
  TextColumn get alsoLike => text().nullable()();
  TextColumn get confidence => text()();
  IntColumn get framesUsed => integer()();
  TextColumn get source => text()();
  TextColumn get method => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FaceMetricRow')
class FaceMetrics extends Table {
  @override
  String get tableName => 'face_metric';

  TextColumn get analysisId =>
      text().references(FaceAnalyses, #id, onDelete: KeyAction.cascade)();
  TextColumn get metric => text()();
  RealColumn get value => real()();

  @override
  Set<Column> get primaryKey => {analysisId, metric};
}

/// Style suggestions the user marked as favourite (hair, beard, glasses).
@DataClassName('StyleFavoriteRow')
class StyleFavorites extends Table {
  @override
  String get tableName => 'hairstyle_favorite';

  TextColumn get itemId => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {itemId};
}

/// Opt-in progress photo (face or body). The JPEG lives inside this
/// encrypted database — never as a loose file or in the gallery — and is
/// only created when the user taps Save.
@DataClassName('SnapshotRow')
@TableIndex(name: 'idx_snapshot_kind_taken', columns: {#kind, #takenAt})
class Snapshots extends Table {
  @override
  String get tableName => 'progress_snapshot';

  TextColumn get id => text()();

  /// face, bodyFront or bodySide.
  TextColumn get kind => text()();
  IntColumn get takenAt => integer()();
  BlobColumn get jpeg => blob()();
  IntColumn get width => integer()();
  IntColumn get height => integer()();
  TextColumn get note => text().nullable()();
  IntColumn get createdAt => integer()();

  /// Eye centres as fractions of width/height, for aligning the face
  /// time-lapse (v9). Null when not detected; [alignChecked] records that
  /// detection already ran so it is never repeated.
  RealColumn get leftEyeX => real().nullable()();
  RealColumn get leftEyeY => real().nullable()();
  RealColumn get rightEyeX => real().nullable()();
  RealColumn get rightEyeY => real().nullable()();
  BoolColumn get alignChecked =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// A diet + training plan (v10). Targets are stored as calculated when the
/// plan started, so history stays stable; the app offers a recalculation
/// when the weight changes.
@DataClassName('BodyPlanRow')
class BodyPlans extends Table {
  @override
  String get tableName => 'body_plan';

  TextColumn get id => text()();

  /// loseFat, maintain, gainWeight or buildMuscle.
  TextColumn get kind => text()();

  /// gentle, steady or brisk.
  TextColumn get pace => text()();
  TextColumn get diet => text()();
  IntColumn get startDay => integer()();
  RealColumn get startWeightKg => real()();
  RealColumn get targetWeightKg => real().nullable()();
  IntColumn get calories => integer()();
  IntColumn get proteinG => integer()();
  IntColumn get carbsG => integer()();
  IntColumn get fatG => integer()();
  IntColumn get waterMl => integer()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  IntColumn get createdAt => integer()();
  IntColumn get endedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Daily mood and energy check-in (v11): one row per local day, 1–5 each.
@DataClassName('MoodRow')
class MoodLogs extends Table {
  @override
  String get tableName => 'mood_log';

  IntColumn get day => integer()();
  IntColumn get mood => integer()();
  IntColumn get energy => integer()();
  IntColumn get recordedAt => integer()();

  @override
  Set<Column> get primaryKey => {day};
}

/// A user's own note on their evolution timeline (v12).
@DataClassName('MilestoneNoteRow')
class MilestoneNotes extends Table {
  @override
  String get tableName => 'milestone_note';

  TextColumn get id => text()();
  IntColumn get day => integer()();
  TextColumn get body => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A garment in the user's wardrobe. The optional photo is stored inside
/// this encrypted database, never as a file.
@DataClassName('WardrobeRow')
@TableIndex(name: 'idx_wardrobe_category', columns: {#category})
class WardrobeItems extends Table {
  @override
  String get tableName => 'wardrobe_item';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get colorHex => text()();
  TextColumn get pattern => text()();
  IntColumn get formality => integer()();

  /// Comma-separated occasion names; empty means any occasion.
  TextColumn get occasions => text().withDefault(const Constant(''))();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  BlobColumn get photo => blob().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OutfitRow')
class Outfits extends Table {
  @override
  String get tableName => 'outfit';

  TextColumn get id => text()();
  TextColumn get occasion => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OutfitItemRow')
class OutfitItems extends Table {
  @override
  String get tableName => 'outfit_item';

  TextColumn get outfitId =>
      text().references(Outfits, #id, onDelete: KeyAction.cascade)();
  TextColumn get itemId =>
      text().references(WardrobeItems, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {outfitId, itemId};
}

/// Days an outfit was worn (for variety in suggestions).
@DataClassName('OutfitWearRow')
class OutfitWears extends Table {
  @override
  String get tableName => 'outfit_wear';

  TextColumn get outfitId =>
      text().references(Outfits, #id, onDelete: KeyAction.cascade)();
  IntColumn get day => integer()();

  @override
  Set<Column> get primaryKey => {outfitId, day};
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
  Routines,
  RoutineItems,
  PlanRecords,
  PostureSessions,
  PostureMetrics,
  FaceAnalyses,
  FaceMetrics,
  StyleFavorites,
  Snapshots,
  WardrobeItems,
  Outfits,
  OutfitItems,
  OutfitWears,
  BodyPlans,
  MoodLogs,
  MilestoneNotes,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Bump together with `dart run drift_dev make-migrations` and a new step
  /// below. Destructive migrations are forbidden (docs/DATA_MODEL.md).
  @override
  int get schemaVersion => 12;

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
          from3To4: (m, schema) async {
            await m.createTable(schema.routine);
            await m.createTable(schema.routineItem);
            await m.createTable(schema.routineCompletion);
            await m.createIndex(schema.idxRoutineItemRoutine);
            await m.createIndex(schema.idxPlanRecordDay);
          },
          from4To5: (m, schema) async {
            await m.createTable(schema.postureSession);
            await m.createTable(schema.postureMetric);
            await m.createIndex(schema.idxPostureSessionRecordedAt);
          },
          from5To6: (m, schema) async {
            await m.createTable(schema.faceAnalysis);
            await m.createTable(schema.faceMetric);
            await m.createTable(schema.hairstyleFavorite);
            await m.createIndex(schema.idxFaceAnalysisRecordedAt);
          },
          from6To7: (m, schema) async {
            await m.createTable(schema.progressSnapshot);
            await m.createIndex(schema.idxSnapshotKindTaken);
          },
          from7To8: (m, schema) async {
            await m.createTable(schema.wardrobeItem);
            await m.createTable(schema.outfit);
            await m.createTable(schema.outfitItem);
            await m.createTable(schema.outfitWear);
            await m.createIndex(schema.idxWardrobeCategory);
          },
          from8To9: (m, schema) async {
            final t = schema.progressSnapshot;
            await m.addColumn(t, t.leftEyeX);
            await m.addColumn(t, t.leftEyeY);
            await m.addColumn(t, t.rightEyeX);
            await m.addColumn(t, t.rightEyeY);
            await m.addColumn(t, t.alignChecked);
          },
          from9To10: (m, schema) async {
            final p = schema.userProfile;
            await m.addColumn(p, p.gender);
            await m.addColumn(p, p.dietPreference);
            await m.addColumn(p, p.styleFit);
            await m.addColumn(p, p.region);
            await m.createTable(schema.bodyPlan);
          },
          from10To11: (m, schema) async {
            await m.createTable(schema.moodLog);
          },
          from11To12: (m, schema) async {
            await m.createTable(schema.milestoneNote);
          },
        ),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
