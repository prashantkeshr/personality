/// Deterministic daily health calculations (spec §14, §30, §34).
library;

import 'dart:math' as math;

import '../entities/body.dart';
import '../entities/health.dart';

/// Local calendar day helpers. Records are stored in UTC; days are the
/// user's local days.
abstract final class Days {
  static int key(DateTime t) {
    final l = t.toLocal();
    return l.year * 10000 + l.month * 100 + l.day;
  }

  static DateTime fromKey(int key) =>
      DateTime(key ~/ 10000, key ~/ 100 % 100, key % 100);

  /// [start, end) of the local day containing [t], as UTC instants.
  static (DateTime, DateTime) range(DateTime t) {
    final l = t.toLocal();
    final start = DateTime(l.year, l.month, l.day);
    final end = DateTime(l.year, l.month, l.day + 1);
    return (start.toUtc(), end.toUtc());
  }

  /// The last [count] local days ending with the day containing [now],
  /// oldest first.
  static List<int> lastDays(DateTime now, int count) {
    final l = now.toLocal();
    return [
      for (var i = count - 1; i >= 0; i--)
        key(DateTime(l.year, l.month, l.day - i)),
    ];
  }
}

abstract final class HealthStats {
  /// Water per local day, in ml.
  static Map<int, double> waterByDay(List<BodyRecord> entries) {
    final result = <int, double>{};
    for (final e in entries) {
      final k = Days.key(e.recordedAt);
      result[k] = (result[k] ?? 0) + e.value;
    }
    return result;
  }

  /// Sleep is attributed to the day the user woke up.
  static Map<int, Duration> sleepByDay(List<SleepEntry> entries) {
    final result = <int, Duration>{};
    for (final e in entries) {
      final k = Days.key(e.wakeAt);
      result[k] = (result[k] ?? Duration.zero) + e.duration;
    }
    return result;
  }

  /// Typical deviation of bedtimes from their mean, in minutes, or null with
  /// fewer than two nights. Uses circular statistics so 23:30 and 00:30 are
  /// one hour apart, not 23.
  static double? bedtimeVariationMinutes(List<SleepEntry> entries) {
    if (entries.length < 2) return null;
    const minutesPerDay = 24 * 60;
    final angles = [
      for (final e in entries)
        () {
          final l = e.bedAt.toLocal();
          return (l.hour * 60 + l.minute) / minutesPerDay * 2 * math.pi;
        }(),
    ];
    final s = angles.map(math.sin).reduce((a, b) => a + b) / angles.length;
    final c = angles.map(math.cos).reduce((a, b) => a + b) / angles.length;
    final mean = math.atan2(s, c);
    var sumSq = 0.0;
    for (final a in angles) {
      var d = a - mean;
      d = math.atan2(math.sin(d), math.cos(d)); // wrap to [-pi, pi]
      final minutes = d / (2 * math.pi) * minutesPerDay;
      sumSq += minutes * minutes;
    }
    return math.sqrt(sumSq / angles.length);
  }

  static int stepsOn(List<ActivityEntry> entries, int dayKey) => entries
      .where((e) => Days.key(e.recordedAt) == dayKey)
      .fold(0, (sum, e) => sum + (e.steps ?? 0));

  /// Active minutes from activity entries and exercise sessions.
  static int activeMinutesOn(
    List<ActivityEntry> activities,
    List<ExerciseEntry> exercises,
    int dayKey,
  ) {
    final a = activities
        .where((e) => Days.key(e.recordedAt) == dayKey)
        .fold(0, (sum, e) => sum + (e.durationMinutes ?? 0));
    final x = exercises
        .where((e) => Days.key(e.performedAt) == dayKey)
        .fold(0, (sum, e) => sum + e.durationMinutes);
    return a + x;
  }
}

/// Observable habit adherence (spec §30). Never infers personality.
class HabitAdherence {
  const HabitAdherence({
    required this.scheduled,
    required this.completed,
    required this.skipped,
  });

  final int scheduled;
  final int completed;
  final int skipped;

  int get missed => math.max(0, scheduled - completed - skipped);

  static HabitAdherence forHabit(
    Habit habit,
    List<HabitCompletion> completions,
    List<int> dayKeys,
  ) {
    var scheduled = 0, completed = 0, skipped = 0;
    final byDay = {
      for (final c in completions)
        if (c.habitId == habit.id) c.dayKey: c.status,
    };
    for (final k in dayKeys) {
      if (k < habit.startDayKey) continue;
      if (!habit.schedule.includes(Days.fromKey(k).weekday)) continue;
      scheduled++;
      switch (byDay[k]) {
        case HabitStatus.completed:
          completed++;
        case HabitStatus.skipped:
          skipped++;
        case null:
          break;
      }
    }
    return HabitAdherence(
        scheduled: scheduled, completed: completed, skipped: skipped);
  }

  /// Today's habits: how many scheduled ones are done.
  static HabitAdherence today(
    List<Habit> habits,
    List<HabitCompletion> completions,
    int todayKey,
  ) {
    var scheduled = 0, completed = 0, skipped = 0;
    for (final h in habits.where((h) => !h.archived)) {
      final r = forHabit(h, completions, [todayKey]);
      scheduled += r.scheduled;
      completed += r.completed;
      skipped += r.skipped;
    }
    return HabitAdherence(
        scheduled: scheduled, completed: completed, skipped: skipped);
  }
}
