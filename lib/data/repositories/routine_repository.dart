import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../domain/entities/health.dart';
import '../../domain/entities/routine.dart';
import '../../domain/services/plan_engine.dart' show QuietHours;
import 'body_record_repository.dart';

T _enum<T extends Enum>(List<T> values, String name, T fallback) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}

/// Routines, their items and plan outcomes. Every change is explicit and
/// user-initiated; nothing here reschedules on its own (spec §33, §83).
class RoutineRepository {
  RoutineRepository(this._db, {Clock? clock, Uuid? uuid})
      : _clock = clock ?? DateTime.now,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  int get _now => _clock().toUtc().millisecondsSinceEpoch;

  Stream<List<Routine>> watchRoutines() {
    final q = _db.select(_db.routines)
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return q.watch().map((rows) => [
          for (final r in rows)
            Routine(
                id: r.id,
                name: r.name,
                days: Weekdays(r.weekdays),
                active: r.active),
        ]);
  }

  Stream<List<RoutineItem>> watchItems() {
    final q = _db.select(_db.routineItems)
      ..orderBy([(t) => OrderingTerm.asc(t.minuteOfDay)]);
    return q.watch().map((rows) => rows.map(_toItem).toList());
  }

  Stream<List<PlanRecord>> watchRecordsSince(int dayKey) {
    final q = _db.select(_db.planRecords)
      ..where((t) => t.day.isBiggerOrEqualValue(dayKey));
    return q.watch().map((rows) => [
          for (final r in rows)
            PlanRecord(
              itemId: r.itemId,
              dayKey: r.day,
              outcome: _enum(
                  PlanOutcome.values, r.outcome, PlanOutcome.completed),
              rescheduledMinute: r.rescheduledMinute,
              recordedAt: DateTime.fromMillisecondsSinceEpoch(r.recordedAt,
                  isUtc: true),
            ),
        ]);
  }

  static void _validateRoutine(String name, Weekdays days) {
    if (name.trim().isEmpty) throw ArgumentError('Name is required');
    if (days.isEmpty) throw ArgumentError('Choose at least one day');
  }

  static void _validateItem(int minute, String title) {
    if (minute < 0 || minute >= Minutes.perDay) {
      throw ArgumentError.value(minute, 'minute');
    }
    if (title.trim().isEmpty) throw ArgumentError('Title is required');
  }

  Future<String> createRoutine(String name, Weekdays days) async {
    _validateRoutine(name, days);
    final id = _uuid.v4();
    await _db.into(_db.routines).insert(RoutinesCompanion.insert(
          id: id,
          name: name.trim(),
          weekdays: days.mask,
          createdAt: _now,
          updatedAt: _now,
        ));
    return id;
  }

  Future<void> updateRoutine(String id,
      {String? name, Weekdays? days, bool? active}) async {
    if (name != null || days != null) {
      _validateRoutine(name ?? 'x', days ?? Weekdays.everyDay);
    }
    await (_db.update(_db.routines)..where((t) => t.id.equals(id))).write(
      RoutinesCompanion(
        name: name == null ? const Value.absent() : Value(name.trim()),
        weekdays: days == null ? const Value.absent() : Value(days.mask),
        active: active == null ? const Value.absent() : Value(active),
        updatedAt: Value(_now),
      ),
    );
  }

  /// Deletes the routine; its items and their history cascade.
  Future<void> deleteRoutine(String id) =>
      (_db.delete(_db.routines)..where((t) => t.id.equals(id))).go();

  /// Copies a routine and all its items (history is not copied).
  Future<String> duplicateRoutine(String id, String newName) async {
    return _db.transaction(() async {
      final r = await (_db.select(_db.routines)..where((t) => t.id.equals(id)))
          .getSingle();
      final newId = await createRoutine(newName, Weekdays(r.weekdays));
      final items = await (_db.select(_db.routineItems)
            ..where((t) => t.routineId.equals(id)))
          .get();
      for (final i in items) {
        await addItem(newId, i.minuteOfDay, i.title,
            _enum(RoutineItemKind.values, i.kind, RoutineItemKind.custom),
            reminder: i.reminder);
      }
      return newId;
    });
  }

  /// Creates a routine from template steps with already-localized titles.
  Future<String> createFromTemplate(String name,
      List<(int, String, RoutineItemKind)> steps) async {
    return _db.transaction(() async {
      final id = await createRoutine(name, Weekdays.everyDay);
      for (final (minute, title, kind) in steps) {
        await addItem(id, minute, title, kind);
      }
      return id;
    });
  }

  Future<String> addItem(
    String routineId,
    int minute,
    String title,
    RoutineItemKind kind, {
    bool reminder = true,
  }) async {
    _validateItem(minute, title);
    final id = _uuid.v4();
    await _db.into(_db.routineItems).insert(RoutineItemsCompanion.insert(
          id: id,
          routineId: routineId,
          minuteOfDay: minute,
          title: title.trim(),
          kind: kind.name,
          reminder: Value(reminder),
          createdAt: _now,
          updatedAt: _now,
        ));
    return id;
  }

  Future<void> updateItem(
    String id, {
    required int minute,
    required String title,
    required RoutineItemKind kind,
    required bool reminder,
  }) async {
    _validateItem(minute, title);
    await (_db.update(_db.routineItems)..where((t) => t.id.equals(id))).write(
      RoutineItemsCompanion(
        minuteOfDay: Value(minute),
        title: Value(title.trim()),
        kind: Value(kind.name),
        reminder: Value(reminder),
        updatedAt: Value(_now),
      ),
    );
  }

  Future<void> deleteItem(String id) =>
      (_db.delete(_db.routineItems)..where((t) => t.id.equals(id))).go();

  /// Records an outcome for [dayKey], or clears it when [outcome] is null.
  Future<void> record(
    String itemId,
    int dayKey,
    PlanOutcome? outcome, {
    int? rescheduledMinute,
  }) async {
    if (outcome == null) {
      await (_db.delete(_db.planRecords)
            ..where((t) => t.itemId.equals(itemId) & t.day.equals(dayKey)))
          .go();
      return;
    }
    if (outcome == PlanOutcome.rescheduled &&
        (rescheduledMinute == null ||
            rescheduledMinute < 0 ||
            rescheduledMinute >= Minutes.perDay)) {
      throw ArgumentError('A rescheduled item needs a valid new time');
    }
    await _db.transaction(() async {
      // Completing or skipping a moved item keeps the time it was moved to,
      // so the plan shows the real time and suggestions see the move.
      final existing = await (_db.select(_db.planRecords)
            ..where((t) => t.itemId.equals(itemId) & t.day.equals(dayKey)))
          .getSingleOrNull();
      await _db.into(_db.planRecords).insertOnConflictUpdate(
            PlanRecordsCompanion.insert(
              itemId: itemId,
              day: dayKey,
              outcome: outcome.name,
              rescheduledMinute: Value(outcome == PlanOutcome.rescheduled
                  ? rescheduledMinute
                  : existing?.rescheduledMinute),
              recordedAt: _now,
            ),
          );
    });
  }

  RoutineItem _toItem(RoutineItemRow r) => RoutineItem(
        id: r.id,
        routineId: r.routineId,
        minuteOfDay: r.minuteOfDay,
        title: r.title,
        kind: _enum(RoutineItemKind.values, r.kind, RoutineItemKind.custom),
        reminder: r.reminder,
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(r.createdAt, isUtc: true),
      );
}

/// Reminder preferences and dismissed suggestions, in `app_settings`.
class ReminderSettingsRepository {
  ReminderSettingsRepository(this._db, {Clock? clock})
      : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final Clock _clock;

  static const _enabled = 'reminders.enabled';
  static const _adaptive = 'reminders.adaptive';
  static const _quiet = 'reminders.quiet';
  static const _dismissPrefix = 'suggestion.dismissed.';

  Stream<ReminderSettings> watch() {
    final q = _db.select(_db.appSettingsEntries)
      ..where((t) =>
          t.key.isIn([_enabled, _adaptive, _quiet]) |
          t.key.like('$_dismissPrefix%'));
    return q.watch().map((rows) {
      final m = {for (final r in rows) r.key: r.value};
      return ReminderSettings(
        enabled: m[_enabled] == 'true',
        adaptive: m[_adaptive] != 'false',
        quietHours: QuietHours.parse(m[_quiet]),
        dismissedOn: {
          for (final e in m.entries)
            if (e.key.startsWith(_dismissPrefix))
              e.key.substring(_dismissPrefix.length): int.parse(e.value),
        },
      );
    });
  }

  Future<void> _put(String key, String value) =>
      _db.into(_db.appSettingsEntries).insertOnConflictUpdate(
            AppSettingsEntriesCompanion.insert(
              key: key,
              value: value,
              updatedAt: _clock().toUtc().millisecondsSinceEpoch,
            ),
          );

  Future<void> setEnabled(bool on) => _put(_enabled, '$on');
  Future<void> setAdaptive(bool on) => _put(_adaptive, '$on');

  /// Null turns quiet hours off.
  Future<void> setQuietHours(QuietHours? q) =>
      _put(_quiet, q == null ? '' : '${q.start}-${q.end}');
  Future<void> dismissSuggestion(String itemId, int dayKey) =>
      _put('$_dismissPrefix$itemId', '$dayKey');
}

class ReminderSettings {
  const ReminderSettings({
    this.enabled = false,
    this.adaptive = true,
    this.quietHours,
    this.dismissedOn = const {},
  });

  /// No reminders inside this window (e.g. 22:00–07:00).
  final QuietHours? quietHours;

  /// Off until the user turns reminders on (and grants permission).
  final bool enabled;

  /// Suggestions only — never applied without the user's approval.
  final bool adaptive;
  final Map<String, int> dismissedOn;
}
