/// Plan vs actual, reminders and adaptive suggestions (spec §32–34).
///
/// Pure functions over routines and recorded outcomes. Nothing here changes
/// the plan; suggestions are returned for the user to accept or dismiss.
library;

import '../entities/routine.dart';
import 'health_stats.dart';

/// State of a plan item as the user sees it.
enum PlanItemState { upcoming, due, completed, skipped, missed }

class PlanEntry {
  const PlanEntry({
    required this.item,
    required this.routine,
    required this.dayKey,
    required this.minute,
    required this.state,
    this.record,
  });

  final RoutineItem item;
  final Routine routine;
  final int dayKey;

  /// Effective time: the rescheduled time if the user moved it.
  final int minute;
  final PlanItemState state;
  final PlanRecord? record;

  bool get wasRescheduled => record?.rescheduledMinute != null;
  bool get isOpen =>
      state == PlanItemState.upcoming || state == PlanItemState.due;
}

/// Adherence (did the plan happen) — kept separate from performance
/// (health metrics against targets), per spec §34.
class PlanSummary {
  const PlanSummary({
    required this.scheduled,
    required this.completed,
    required this.skipped,
    required this.missed,
    required this.rescheduled,
    required this.open,
  });

  final int scheduled;
  final int completed;
  final int skipped;
  final int missed;
  final int rescheduled;
  final int open;

  factory PlanSummary.of(List<PlanEntry> entries) => PlanSummary(
        scheduled: entries.length,
        completed:
            entries.where((e) => e.state == PlanItemState.completed).length,
        skipped: entries.where((e) => e.state == PlanItemState.skipped).length,
        missed: entries.where((e) => e.state == PlanItemState.missed).length,
        rescheduled: entries.where((e) => e.wasRescheduled).length,
        open: entries.where((e) => e.isOpen).length,
      );
}

abstract final class PlanEngine {
  /// An open item stays "due" for this long after its time, then is missed.
  static const dueWindowMinutes = 60;

  static bool _scheduled(Routine r, int dayKey) =>
      r.active && r.days.includes(Days.fromKey(dayKey).weekday);

  /// The plan for [dayKey], ordered by effective time.
  static List<PlanEntry> forDay({
    required List<Routine> routines,
    required List<RoutineItem> items,
    required List<PlanRecord> records,
    required int dayKey,
    required DateTime now,
  }) {
    final byId = {for (final r in routines) r.id: r};
    final recordFor = {
      for (final r in records)
        if (r.dayKey == dayKey) r.itemId: r,
    };
    final todayKey = Days.key(now);
    final nowMinute = Minutes.of(now);

    final entries = <PlanEntry>[];
    for (final item in items) {
      final routine = byId[item.routineId];
      if (routine == null || !_scheduled(routine, dayKey)) continue;
      final record = recordFor[item.id];
      // Skip occurrences from before the item existed, unless the user
      // recorded an outcome for them anyway.
      if (record == null &&
          Minutes.on(dayKey, item.minuteOfDay).isBefore(item.createdAt)) {
        continue;
      }
      final minute = record?.rescheduledMinute ?? item.minuteOfDay;

      final PlanItemState state;
      switch (record?.outcome) {
        case PlanOutcome.completed:
          state = PlanItemState.completed;
        case PlanOutcome.skipped:
          state = PlanItemState.skipped;
        case PlanOutcome.rescheduled || null:
          if (dayKey < todayKey) {
            state = PlanItemState.missed;
          } else if (dayKey > todayKey || nowMinute < minute) {
            state = PlanItemState.upcoming;
          } else if (nowMinute < minute + dueWindowMinutes) {
            state = PlanItemState.due;
          } else {
            state = PlanItemState.missed;
          }
      }
      entries.add(PlanEntry(
        item: item,
        routine: routine,
        dayKey: dayKey,
        minute: minute,
        state: state,
        record: record,
      ));
    }
    entries.sort((a, b) => a.minute.compareTo(b.minute));
    return entries;
  }

  /// The next open item today, if any.
  static PlanEntry? next(List<PlanEntry> today) {
    for (final e in today) {
      if (e.isOpen) return e;
    }
    return null;
  }

  /// Completed / scheduled per day for [dayKeys].
  static Map<int, PlanSummary> history({
    required List<Routine> routines,
    required List<RoutineItem> items,
    required List<PlanRecord> records,
    required List<int> dayKeys,
    required DateTime now,
  }) =>
      {
        for (final k in dayKeys)
          k: PlanSummary.of(forDay(
              routines: routines,
              items: items,
              records: records,
              dayKey: k,
              now: now)),
      };
}

/// A reminder notification to schedule.
class ReminderOccurrence {
  const ReminderOccurrence({
    required this.id,
    required this.itemId,
    required this.dayKey,
    required this.at,
    required this.title,
    required this.kind,
  });

  /// Stable per item and day, so a single occurrence can be cancelled.
  final int id;
  final String itemId;
  final int dayKey;
  final DateTime at;
  final String title;
  final RoutineItemKind kind;
}

abstract final class ReminderPlanner {
  /// Rolling window: the app re-syncs whenever it opens or the plan changes.
  static const windowDays = 7;

  /// Stable 30-bit id (FNV-1a) for an item on a day.
  static int notificationId(String itemId, int dayKey) {
    var h = 0x811c9dc5;
    for (final c in '$itemId|$dayKey'.codeUnits) {
      h ^= c;
      h = (h * 0x01000193) & 0xffffffff;
    }
    return h & 0x3fffffff; // bit 30 is reserved for snoozes
  }

  /// Future reminders for open, reminder-enabled items.
  static List<ReminderOccurrence> upcoming({
    required List<Routine> routines,
    required List<RoutineItem> items,
    required List<PlanRecord> records,
    required DateTime now,
    int days = windowDays,
  }) {
    final result = <ReminderOccurrence>[];
    final l = now.toLocal();
    for (var i = 0; i < days; i++) {
      final dayKey = Days.key(DateTime(l.year, l.month, l.day + i));
      final plan = PlanEngine.forDay(
          routines: routines,
          items: items,
          records: records,
          dayKey: dayKey,
          now: now);
      for (final e in plan) {
        if (!e.item.reminder || !e.isOpen) continue;
        final at = Minutes.on(dayKey, e.minute);
        if (!at.isAfter(now)) continue;
        result.add(ReminderOccurrence(
          id: notificationId(e.item.id, dayKey),
          itemId: e.item.id,
          dayKey: dayKey,
          at: at,
          title: e.item.title,
          kind: e.item.kind,
        ));
      }
    }
    result.sort((a, b) => a.at.compareTo(b.at));
    return result;
  }
}

enum SuggestionBasis { lateCompletion, rescheduled, missed }

/// "You often miss the 15:00 posture break. Move it to 16:00?" (spec §33)
class ReminderSuggestion {
  const ReminderSuggestion({
    required this.item,
    required this.fromMinute,
    required this.toMinute,
    required this.basis,
    required this.occurrences,
    required this.scheduledDays,
  });

  final RoutineItem item;
  final int fromMinute;
  final int toMinute;
  final SuggestionBasis basis;

  /// How many of [scheduledDays] support the suggestion.
  final int occurrences;
  final int scheduledDays;
}

abstract final class AdaptiveReminders {
  static const windowDays = 14;
  static const minScheduledDays = 4;
  static const lateThresholdMinutes = 45;
  static const minEvidence = 3;
  static const dismissForDays = 14;

  /// Suggestions based only on observable outcomes over past days.
  /// [dismissedOn] maps item id → day key the user dismissed a suggestion.
  static List<ReminderSuggestion> suggest({
    required List<Routine> routines,
    required List<RoutineItem> items,
    required List<PlanRecord> records,
    required DateTime now,
    Map<String, int> dismissedOn = const {},
  }) {
    final l = now.toLocal();
    // Past days only: today is still in progress.
    final days = [
      for (var i = windowDays; i >= 1; i--)
        Days.key(DateTime(l.year, l.month, l.day - i)),
    ];
    final dismissCutoff =
        Days.key(DateTime(l.year, l.month, l.day - dismissForDays));

    final perItem = <String, List<PlanEntry>>{};
    for (final k in days) {
      for (final e in PlanEngine.forDay(
          routines: routines,
          items: items,
          records: records,
          dayKey: k,
          now: now)) {
        perItem.putIfAbsent(e.item.id, () => []).add(e);
      }
    }

    final result = <ReminderSuggestion>[];
    for (final item in items) {
      final entries = perItem[item.id] ?? const [];
      if (entries.length < minScheduledDays) continue;
      final dismissed = dismissedOn[item.id];
      if (dismissed != null && dismissed > dismissCutoff) continue;

      ReminderSuggestion? make(SuggestionBasis basis, List<int> minutes) {
        if (minutes.length < minEvidence) return null;
        final sorted = [...minutes]..sort();
        final to = Minutes.roundTo(sorted[sorted.length ~/ 2], 15);
        if ((to - item.minuteOfDay).abs() < 15) return null;
        return ReminderSuggestion(
          item: item,
          fromMinute: item.minuteOfDay,
          toMinute: to,
          basis: basis,
          occurrences: minutes.length,
          scheduledDays: entries.length,
        );
      }

      final late = [
        for (final e in entries)
          if (e.state == PlanItemState.completed &&
              e.record!.outcome == PlanOutcome.completed &&
              Days.key(e.record!.recordedAt) == e.dayKey &&
              Minutes.of(e.record!.recordedAt) - item.minuteOfDay >=
                  lateThresholdMinutes)
            Minutes.of(e.record!.recordedAt),
      ];
      final moved = [
        for (final e in entries)
          if (e.record?.rescheduledMinute != null) e.record!.rescheduledMinute!,
      ];
      final missed =
          entries.where((e) => e.state == PlanItemState.missed).length;

      final suggestion = make(SuggestionBasis.rescheduled, moved) ??
          make(SuggestionBasis.lateCompletion, late) ??
          (missed >= minEvidence && missed * 2 >= entries.length
              ? make(SuggestionBasis.missed, [
                  for (var i = 0; i < missed; i++)
                    (item.minuteOfDay + 60).clamp(0, Minutes.perDay - 15),
                ])
              : null);
      if (suggestion != null) result.add(suggestion);
    }
    return result;
  }
}
