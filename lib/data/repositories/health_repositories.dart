import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../domain/entities/health.dart';
import '../../domain/entities/provenance.dart';
import '../../domain/services/health_stats.dart';
import 'body_record_repository.dart';

int _ms(DateTime t) => t.toUtc().millisecondsSinceEpoch;
DateTime _time(int ms) => DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
String? _blank(String? s) => (s == null || s.trim().isEmpty) ? null : s.trim();

T _enum<T extends Enum>(List<T> values, String name, T fallback) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}

/// Records newer than [since] (UTC). History screens load a bounded window.
Expression<bool> _after(GeneratedColumn<int> column, DateTime since) =>
    column.isBiggerOrEqualValue(_ms(since));

class MealRepository {
  MealRepository(this._db, {Clock? clock, Uuid? uuid})
      : _clock = clock ?? DateTime.now,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  Stream<List<MealEntry>> watchSince(DateTime since) {
    final q = _db.select(_db.meals)
      ..where((t) => _after(t.eatenAt, since))
      ..orderBy([(t) => OrderingTerm.desc(t.eatenAt)]);
    return q.watch().map((rows) => rows.map(_toEntry).toList());
  }

  Future<void> add({
    required MealType type,
    required String food,
    required DateTime eatenAt,
    String? customName,
    String? quantity,
    double? calories,
    String? notes,
  }) async {
    if (_blank(food) == null) throw ArgumentError('Food is required');
    if (calories != null && calories < 0) {
      throw ArgumentError('Calories cannot be negative');
    }
    final now = _ms(_clock());
    await _db.into(_db.meals).insert(MealsCompanion.insert(
          id: _uuid.v4(),
          mealType: type.name,
          customName: Value(type == MealType.custom ? _blank(customName) : null),
          food: food.trim(),
          quantity: Value(_blank(quantity)),
          calories: Value(calories),
          eatenAt: _ms(eatenAt),
          notes: Value(_blank(notes)),
          createdAt: now,
          updatedAt: now,
        ));
  }

  Future<void> delete(String id) =>
      (_db.delete(_db.meals)..where((t) => t.id.equals(id))).go();

  MealEntry _toEntry(MealRow r) => MealEntry(
        id: r.id,
        type: _enum(MealType.values, r.mealType, MealType.custom),
        customName: r.customName,
        food: r.food,
        quantity: r.quantity,
        calories: r.calories,
        eatenAt: _time(r.eatenAt),
        notes: r.notes,
      );
}

class SleepRepository {
  SleepRepository(this._db, {Clock? clock, Uuid? uuid})
      : _clock = clock ?? DateTime.now,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  Stream<List<SleepEntry>> watchSince(DateTime since) {
    final q = _db.select(_db.sleepLogs)
      ..where((t) => _after(t.wakeAt, since))
      ..orderBy([(t) => OrderingTerm.desc(t.wakeAt)]);
    return q.watch().map((rows) => rows.map(_toEntry).toList());
  }

  /// Validates through [SleepEntry] before writing.
  Future<void> add({
    required DateTime bedAt,
    required DateTime wakeAt,
    String? notes,
  }) async {
    final entry = SleepEntry(id: _uuid.v4(), bedAt: bedAt, wakeAt: wakeAt);
    final now = _ms(_clock());
    await _db.into(_db.sleepLogs).insert(SleepLogsCompanion.insert(
          id: entry.id,
          bedAt: _ms(entry.bedAt),
          wakeAt: _ms(entry.wakeAt),
          source: DataSource.userEntered.wireName,
          notes: Value(_blank(notes)),
          createdAt: now,
          updatedAt: now,
        ));
  }

  Future<void> delete(String id) =>
      (_db.delete(_db.sleepLogs)..where((t) => t.id.equals(id))).go();

  SleepEntry _toEntry(SleepRow r) => SleepEntry(
        id: r.id,
        bedAt: _time(r.bedAt),
        wakeAt: _time(r.wakeAt),
        source: DataSource.fromWireName(r.source),
        notes: r.notes,
      );
}

class ActivityRepository {
  ActivityRepository(this._db, {Clock? clock, Uuid? uuid})
      : _clock = clock ?? DateTime.now,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  Stream<List<ActivityEntry>> watchSince(DateTime since) {
    final q = _db.select(_db.activityLogs)
      ..where((t) => _after(t.recordedAt, since))
      ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]);
    return q.watch().map((rows) => rows.map(_toEntry).toList());
  }

  Future<void> add({
    required ActivityKind kind,
    required DateTime recordedAt,
    int? durationMinutes,
    int? steps,
    double? distanceKm,
    String? notes,
  }) async {
    if (durationMinutes == null && steps == null && distanceKm == null) {
      throw ArgumentError('Enter a duration, steps or distance');
    }
    final now = _ms(_clock());
    await _db.into(_db.activityLogs).insert(ActivityLogsCompanion.insert(
          id: _uuid.v4(),
          kind: kind.name,
          durationMinutes: Value(durationMinutes),
          steps: Value(steps),
          distanceKm: Value(distanceKm),
          recordedAt: _ms(recordedAt),
          source: DataSource.userEntered.wireName,
          notes: Value(_blank(notes)),
          createdAt: now,
          updatedAt: now,
        ));
  }

  Future<void> delete(String id) =>
      (_db.delete(_db.activityLogs)..where((t) => t.id.equals(id))).go();

  ActivityEntry _toEntry(ActivityRow r) => ActivityEntry(
        id: r.id,
        kind: _enum(ActivityKind.values, r.kind, ActivityKind.other),
        durationMinutes: r.durationMinutes,
        steps: r.steps,
        distanceKm: r.distanceKm,
        recordedAt: _time(r.recordedAt),
        source: DataSource.fromWireName(r.source),
        notes: r.notes,
      );
}

class ExerciseRepository {
  ExerciseRepository(this._db, {Clock? clock, Uuid? uuid})
      : _clock = clock ?? DateTime.now,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  Stream<List<ExerciseEntry>> watchSince(DateTime since) {
    final q = _db.select(_db.exerciseSessions)
      ..where((t) => _after(t.performedAt, since))
      ..orderBy([(t) => OrderingTerm.desc(t.performedAt)]);
    return q.watch().map((rows) => rows.map(_toEntry).toList());
  }

  Future<void> add({
    required String name,
    required ExerciseCategory category,
    required int durationMinutes,
    required DateTime performedAt,
    int? sets,
    int? reps,
    String? notes,
  }) async {
    if (_blank(name) == null) throw ArgumentError('Name is required');
    if (durationMinutes <= 0) throw ArgumentError('Duration must be positive');
    final now = _ms(_clock());
    await _db.into(_db.exerciseSessions).insert(
          ExerciseSessionsCompanion.insert(
            id: _uuid.v4(),
            name: name.trim(),
            category: category.name,
            durationMinutes: durationMinutes,
            sets: Value(sets),
            reps: Value(reps),
            performedAt: _ms(performedAt),
            source: DataSource.userEntered.wireName,
            notes: Value(_blank(notes)),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> delete(String id) =>
      (_db.delete(_db.exerciseSessions)..where((t) => t.id.equals(id))).go();

  ExerciseEntry _toEntry(ExerciseSessionRow r) => ExerciseEntry(
        id: r.id,
        name: r.name,
        category: _enum(ExerciseCategory.values, r.category,
            ExerciseCategory.generalFitness),
        durationMinutes: r.durationMinutes,
        sets: r.sets,
        reps: r.reps,
        performedAt: _time(r.performedAt),
        source: DataSource.fromWireName(r.source),
        notes: r.notes,
      );
}

class HabitRepository {
  HabitRepository(this._db, {Clock? clock, Uuid? uuid})
      : _clock = clock ?? DateTime.now,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  Stream<List<Habit>> watchHabits() {
    final q = _db.select(_db.habits)
      ..where((t) => t.archived.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return q.watch().map((rows) => [
          for (final r in rows)
            Habit(
              id: r.id,
              name: r.name,
              schedule: Weekdays(r.weekdays),
              startDayKey: Days.key(_time(r.createdAt)),
              archived: r.archived,
            ),
        ]);
  }

  Stream<List<HabitCompletion>> watchCompletionsSince(int dayKey) {
    final q = _db.select(_db.habitCompletions)
      ..where((t) => t.day.isBiggerOrEqualValue(dayKey));
    return q.watch().map((rows) => [
          for (final r in rows)
            HabitCompletion(
              habitId: r.habitId,
              dayKey: r.day,
              status: _enum(
                  HabitStatus.values, r.status, HabitStatus.completed),
            ),
        ]);
  }

  Future<String> add(String name, Weekdays schedule) async {
    if (_blank(name) == null) throw ArgumentError('Name is required');
    if (schedule.isEmpty) throw ArgumentError('Choose at least one day');
    final id = _uuid.v4();
    final now = _ms(_clock());
    await _db.into(_db.habits).insert(HabitsCompanion.insert(
          id: id,
          name: name.trim(),
          weekdays: schedule.mask,
          createdAt: now,
          updatedAt: now,
        ));
    return id;
  }

  Future<void> update(String id, String name, Weekdays schedule) async {
    if (_blank(name) == null) throw ArgumentError('Name is required');
    if (schedule.isEmpty) throw ArgumentError('Choose at least one day');
    await (_db.update(_db.habits)..where((t) => t.id.equals(id))).write(
      HabitsCompanion(
        name: Value(name.trim()),
        weekdays: Value(schedule.mask),
        updatedAt: Value(_ms(_clock())),
      ),
    );
  }

  /// Archiving keeps history for progress; delete removes everything.
  Future<void> archive(String id) =>
      (_db.update(_db.habits)..where((t) => t.id.equals(id))).write(
        HabitsCompanion(
          archived: const Value(true),
          updatedAt: Value(_ms(_clock())),
        ),
      );

  Future<void> delete(String id) =>
      (_db.delete(_db.habits)..where((t) => t.id.equals(id))).go();

  /// Sets today's status, or clears it when [status] is null.
  Future<void> setStatus(String habitId, int dayKey, HabitStatus? status) async {
    if (status == null) {
      await (_db.delete(_db.habitCompletions)
            ..where((t) => t.habitId.equals(habitId) & t.day.equals(dayKey)))
          .go();
      return;
    }
    await _db.into(_db.habitCompletions).insertOnConflictUpdate(
          HabitCompletionsCompanion.insert(
            habitId: habitId,
            day: dayKey,
            status: status.name,
            recordedAt: _ms(_clock()),
          ),
        );
  }
}

/// Daily targets live in the key/value settings table.
class TargetsRepository {
  TargetsRepository(this._db, {Clock? clock}) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final Clock _clock;

  static const _water = 'target.water_ml';
  static const _sleep = 'target.sleep_minutes';
  static const _steps = 'target.steps';
  static const _active = 'target.active_minutes';

  Stream<DailyTargets> watch() {
    final q = _db.select(_db.appSettingsEntries)
      ..where((t) => t.key.isIn([_water, _sleep, _steps, _active]));
    return q.watch().map((rows) {
      final m = {for (final r in rows) r.key: int.tryParse(r.value)};
      const d = DailyTargets();
      return DailyTargets(
        waterMl: m[_water] ?? d.waterMl,
        sleepMinutes: m[_sleep] ?? d.sleepMinutes,
        steps: m[_steps] ?? d.steps,
        activeMinutes: m[_active] ?? d.activeMinutes,
      );
    });
  }

  Future<void> save(DailyTargets t) async {
    final now = _ms(_clock());
    await _db.transaction(() async {
      for (final (key, value) in [
        (_water, t.waterMl),
        (_sleep, t.sleepMinutes),
        (_steps, t.steps),
        (_active, t.activeMinutes),
      ]) {
        await _db.into(_db.appSettingsEntries).insertOnConflictUpdate(
              AppSettingsEntriesCompanion.insert(
                  key: key, value: '$value', updatedAt: now),
            );
      }
    });
  }
}
