import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/providers.dart';
import '../../domain/entities/body.dart';
import '../../domain/entities/health.dart';
import '../../domain/entities/routine.dart';
import '../../l10n/app_localizations.dart';
import '../routines/routine_providers.dart';

/// Ready-made reminders tied to a goal. Each one is an ordinary routine with
/// reminders, so it shares quiet hours, Done / Snooze, plan history and the
/// routines screen; this layer only remembers which routine belongs to it.
enum GoalReminderKind {
  weighIn(
    GoalType.weightManagement,
    RoutineItemKind.custom,
    Icons.monitor_weight_outlined,
    Weekdays(1),
    [7 * 60 + 30],
  ),
  water(
    GoalType.hydration,
    RoutineItemKind.water,
    Icons.water_drop_outlined,
    Weekdays.everyDay,
    [10 * 60, 13 * 60, 16 * 60, 19 * 60],
  ),
  bedtime(
    GoalType.sleep,
    RoutineItemKind.windDown,
    Icons.bedtime_outlined,
    Weekdays.everyDay,
    [22 * 60],
  ),
  move(
    GoalType.fitness,
    RoutineItemKind.exercise,
    Icons.directions_walk,
    Weekdays(0x1F),
    [11 * 60, 15 * 60 + 30],
  ),
  posture(
    GoalType.posture,
    RoutineItemKind.posture,
    Icons.accessibility_new,
    Weekdays(0x1F),
    [12 * 60, 17 * 60],
  );

  const GoalReminderKind(
    this.goal,
    this.itemKind,
    this.icon,
    this.defaultDays,
    this.defaultTimes,
  );

  final GoalType goal;
  final RoutineItemKind itemKind;
  final IconData icon;

  /// Weigh-ins default to once a week: the trend matters, not each day.
  final Weekdays defaultDays;
  final List<int> defaultTimes;

  String title(AppLocalizations l) => switch (this) {
    weighIn => l.goalRemindWeighIn,
    water => l.goalRemindWater,
    bedtime => l.goalRemindBedtime,
    move => l.goalRemindMove,
    posture => l.goalRemindPosture,
  };

  /// What the notification says.
  String itemTitle(AppLocalizations l) => switch (this) {
    weighIn => l.goalRemindWeighInItem,
    water => l.goalRemindWaterItem,
    bedtime => l.goalRemindBedtimeItem,
    move => l.goalRemindMoveItem,
    posture => l.goalRemindPostureItem,
  };

  String info(AppLocalizations l) => switch (this) {
    weighIn => l.goalRemindWeighInInfo,
    water => l.goalRemindWaterInfo,
    bedtime => l.goalRemindBedtimeInfo,
    move => l.goalRemindMoveInfo,
    posture => l.goalRemindPostureInfo,
  };
}

class GoalReminder {
  const GoalReminder({
    required this.kind,
    required this.routineId,
    required this.days,
    required this.times,
  });

  final GoalReminderKind kind;

  /// Null while switched off.
  final String? routineId;
  final Weekdays days;

  /// Minutes after midnight, sorted.
  final List<int> times;

  bool get on => routineId != null;
}

/// Which routine belongs to which goal reminder (app_settings keys).
class GoalReminderLinks {
  GoalReminderLinks(this._db);
  final AppDatabase _db;

  static const _prefix = 'goalReminder.';

  Stream<Map<GoalReminderKind, String>> watch() {
    final q = _db.select(_db.appSettingsEntries)
      ..where((t) => t.key.like('$_prefix%'));
    return q.watch().map(
      (rows) => {
        for (final r in rows)
          for (final k in GoalReminderKind.values)
            if (r.key == '$_prefix${k.name}' && r.value.isNotEmpty) k: r.value,
      },
    );
  }

  Future<void> set(GoalReminderKind k, String? routineId) => _db
      .into(_db.appSettingsEntries)
      .insertOnConflictUpdate(
        AppSettingsEntriesCompanion.insert(
          key: '$_prefix${k.name}',
          value: routineId ?? '',
          updatedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
        ),
      );
}

final goalReminderLinksProvider = Provider(
  (ref) => GoalReminderLinks(ref.watch(appDatabaseProvider)),
);

final _linksProvider = StreamProvider<Map<GoalReminderKind, String>>(
  (ref) => ref.watch(goalReminderLinksProvider).watch(),
);

/// Every goal reminder with its current schedule. A routine deleted from the
/// routines screen simply shows as off here.
final goalRemindersProvider = Provider<Map<GoalReminderKind, GoalReminder>?>((
  ref,
) {
  final links = ref.watch(_linksProvider).value;
  final routines = ref.watch(routinesProvider).value;
  final items = ref.watch(routineItemsProvider).value;
  if (links == null || routines == null || items == null) return null;
  return {
    for (final k in GoalReminderKind.values)
      k: () {
        final id = links[k];
        final r = routines.where((r) => r.id == id).firstOrNull;
        if (r == null) {
          return GoalReminder(
            kind: k,
            routineId: null,
            days: k.defaultDays,
            times: k.defaultTimes,
          );
        }
        final times = [
          for (final i in items)
            if (i.routineId == r.id) i.minuteOfDay,
        ]..sort();
        return GoalReminder(
          kind: k,
          routineId: r.id,
          days: r.days,
          times: times,
        );
      }(),
  };
});

/// Switches goal reminders on and off and edits their schedule.
class GoalReminderActions {
  GoalReminderActions(this._ref);
  final Ref _ref;

  /// Turns on the app's reminders (asking for notification permission once).
  /// Returns false when Android blocks notifications for the app.
  Future<bool> _ensureRemindersOn() async {
    final scheduler = _ref.read(reminderSchedulerProvider);
    final allowed =
        await scheduler.notificationsAllowed() ||
        await scheduler.requestPermission();
    _ref.invalidate(notificationsAllowedProvider);
    await _ref.read(reminderSettingsRepositoryProvider).setEnabled(true);
    return allowed;
  }

  /// Returns whether notifications can be shown.
  Future<bool> turnOn(GoalReminder r, AppLocalizations l) async {
    final repo = _ref.read(routineRepositoryProvider);
    final id = await repo.createRoutine(r.kind.title(l), r.days);
    for (final t in r.times) {
      await repo.addItem(id, t, r.kind.itemTitle(l), r.kind.itemKind);
    }
    await _ref.read(goalReminderLinksProvider).set(r.kind, id);
    return _ensureRemindersOn();
  }

  Future<void> turnOff(GoalReminder r) async {
    final id = r.routineId;
    if (id == null) return;
    await _ref.read(routineRepositoryProvider).deleteRoutine(id);
    await _ref.read(goalReminderLinksProvider).set(r.kind, null);
  }

  /// Replaces the schedule of a reminder that is on.
  Future<void> reschedule(
    GoalReminder r,
    AppLocalizations l, {
    Weekdays? days,
    List<int>? times,
  }) async {
    final id = r.routineId;
    if (id == null) return;
    final repo = _ref.read(routineRepositoryProvider);
    if (days != null && !days.isEmpty) await repo.updateRoutine(id, days: days);
    if (times != null && times.isNotEmpty) {
      final items = _ref.read(routineItemsProvider).value ?? const [];
      for (final i in items.where((i) => i.routineId == id)) {
        await repo.deleteItem(i.id);
      }
      for (final t in {...times}.toList()..sort()) {
        await repo.addItem(id, t, r.kind.itemTitle(l), r.kind.itemKind);
      }
    }
  }
}

final goalReminderActionsProvider = Provider((ref) => GoalReminderActions(ref));
