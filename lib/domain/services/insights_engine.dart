/// Plan-versus-actual insights, sleep score and weekly review (pure Dart).
///
/// Every day is marked as met / partial / missed — or "no data" when
/// nothing was logged, so a day the user simply didn't record is never
/// shown as a failure. Trends compare with the previous period.
library;

import 'dart:math' as math;

import 'health_stats.dart';

enum InsightRange { week, month }

enum InsightMetric { plan, habits, water, sleep, activity, meals, mood }

enum DayMark { noData, missed, partial, met }

class DayPoint {
  const DayPoint(this.dayKey, this.value, this.mark);
  final int dayKey;

  /// Metric-specific value: ratio 0–1 (plan, habits), ml, hours, minutes,
  /// meals or mood 1–5. Null when there's no data.
  final double? value;
  final DayMark mark;
}

class MetricSeries {
  const MetricSeries(this.metric, this.days, {this.previousAverage});

  final InsightMetric metric;

  /// Oldest first.
  final List<DayPoint> days;

  /// Average over logged days of the previous period, if any.
  final double? previousAverage;

  Iterable<DayPoint> get logged => days.where((d) => d.mark != DayMark.noData);
  int get loggedDays => logged.length;
  int get metDays => days.where((d) => d.mark == DayMark.met).length;

  double? get average {
    final l = logged.toList();
    if (l.isEmpty) return null;
    return l.fold(0.0, (s, d) => s + d.value!) / l.length;
  }

  /// Positive when better than the previous period.
  double? get change {
    final a = average, p = previousAverage;
    return a == null || p == null ? null : a - p;
  }
}

/// One day's raw facts, gathered from the user's records.
class DayFacts {
  const DayFacts({
    required this.dayKey,
    this.planScheduled = 0,
    this.planCompleted = 0,
    this.planSkipped = 0,
    this.habitsScheduled = 0,
    this.habitsCompleted = 0,
    this.habitsSkipped = 0,
    this.waterMl,
    this.sleepMinutes,
    this.activeMinutes,
    this.meals = 0,
    this.mood,
  });

  final int dayKey;
  final int planScheduled;
  final int planCompleted;
  final int planSkipped;
  final int habitsScheduled;
  final int habitsCompleted;
  final int habitsSkipped;

  /// Null when nothing was logged that day.
  final double? waterMl;
  final int? sleepMinutes;
  final int? activeMinutes;
  final int meals;
  final int? mood;
}

class InsightTargets {
  const InsightTargets({
    this.waterMl = 2000,
    this.sleepMinutes = 480,
    this.activeMinutes = 30,
  });
  final int waterMl;
  final int sleepMinutes;
  final int activeMinutes;
}

abstract final class InsightsEngine {
  static int days(InsightRange r) => r == InsightRange.week ? 7 : 30;

  static DayPoint point(InsightMetric m, DayFacts f, InsightTargets t) {
    DayPoint ratio(int scheduled, int completed, int skipped) {
      final counted = scheduled - skipped;
      if (counted <= 0) return DayPoint(f.dayKey, null, DayMark.noData);
      final r = completed / counted;
      return DayPoint(f.dayKey, r,
          r >= 0.8 ? DayMark.met : r > 0 ? DayMark.partial : DayMark.missed);
    }

    DayPoint vsTarget(num? v, int target, {num partialFrom = 0}) {
      if (v == null || v <= 0) return DayPoint(f.dayKey, null, DayMark.noData);
      final mark = v >= target
          ? DayMark.met
          : v >= partialFrom
              ? DayMark.partial
              : DayMark.missed;
      return DayPoint(f.dayKey, v.toDouble(), mark);
    }

    return switch (m) {
      InsightMetric.plan => ratio(f.planScheduled, f.planCompleted, f.planSkipped),
      InsightMetric.habits =>
        ratio(f.habitsScheduled, f.habitsCompleted, f.habitsSkipped),
      InsightMetric.water => vsTarget(f.waterMl, t.waterMl),
      // Within 30 minutes of the target counts as met.
      InsightMetric.sleep => f.sleepMinutes == null
          ? DayPoint(f.dayKey, null, DayMark.noData)
          : DayPoint(
              f.dayKey,
              f.sleepMinutes! / 60,
              f.sleepMinutes! >= t.sleepMinutes - 30
                  ? DayMark.met
                  : f.sleepMinutes! >= t.sleepMinutes - 90
                      ? DayMark.partial
                      : DayMark.missed),
      InsightMetric.activity => vsTarget(f.activeMinutes, t.activeMinutes),
      InsightMetric.meals => f.meals == 0
          ? DayPoint(f.dayKey, null, DayMark.noData)
          : DayPoint(f.dayKey, f.meals.toDouble(),
              f.meals >= 3 ? DayMark.met : DayMark.partial),
      // Mood is a feeling, never a goal: logged days are simply "logged".
      InsightMetric.mood => f.mood == null
          ? DayPoint(f.dayKey, null, DayMark.noData)
          : DayPoint(f.dayKey, f.mood!.toDouble(), DayMark.met),
    };
  }

  /// [facts] must cover the range and the previous one (by day key).
  static MetricSeries series(InsightMetric m, Map<int, DayFacts> facts,
      InsightTargets t, int todayKey, InsightRange range) {
    final n = days(range);
    final today = Days.fromKey(todayKey);
    List<DayPoint> window(int offset) => [
          for (var i = n - 1 + offset; i >= offset; i--)
            () {
              final k = Days.key(DateTime(today.year, today.month, today.day - i));
              return point(m, facts[k] ?? DayFacts(dayKey: k), t);
            }(),
        ];
    final current = window(0);
    final prev = MetricSeries(m, window(n));
    return MetricSeries(m, current, previousAverage: prev.average);
  }
}

/// A 0–100 score from logged sleep: duration against the target (70) and
/// regular bedtimes (30). No sleep stages — those need a wearable.
class SleepScore {
  const SleepScore(this.score, this.averageMinutes, this.bedtimeSpreadMinutes,
      this.nights);

  final int score;
  final int averageMinutes;
  final int bedtimeSpreadMinutes;
  final int nights;

  static SleepScore? of(List<(DateTime bed, DateTime wake)> nights,
      {int targetMinutes = 480}) {
    if (nights.isEmpty) return null;
    final durations = [for (final (b, w) in nights) w.difference(b).inMinutes];
    final durationScore = durations
            .map((d) => math.min(1.0, d / targetMinutes))
            .fold(0.0, (a, b) => a + b) /
        durations.length;
    // Bedtime as minutes from 18:00 so late-night times stay continuous.
    final beds = [
      for (final (b, _) in nights)
        ((b.toLocal().hour * 60 + b.toLocal().minute) - 18 * 60 + 24 * 60) % (24 * 60)
    ];
    final mean = beds.fold(0, (a, b) => a + b) / beds.length;
    final sd = math.sqrt(
        beds.fold(0.0, (a, b) => a + (b - mean) * (b - mean)) / beds.length);
    final consistency = nights.length < 3 ? 0.7 : 1 - (sd / 90).clamp(0.0, 1.0);
    return SleepScore(
      (durationScore * 70 + consistency * 30).round(),
      (durations.fold(0, (a, b) => a + b) / durations.length).round(),
      sd.round(),
      nights.length,
    );
  }
}

enum ReviewTip { plan, habits, water, sleep, activity, meals, keepGoing }

/// Last Monday–Sunday in one card, with one suggestion for the week ahead.
class WeeklyReview {
  const WeeklyReview({
    required this.weekStart,
    required this.activeDays,
    required this.water,
    required this.sleep,
    required this.activity,
    required this.plan,
    required this.tip,
    this.bestDay,
  });

  /// Monday of the reviewed week.
  final int weekStart;
  final int activeDays;
  final MetricSeries water;
  final MetricSeries sleep;
  final MetricSeries activity;
  final MetricSeries plan;
  final ReviewTip tip;
  final int? bestDay;

  /// The week to review on [today]: the one that ended last Sunday.
  static int weekStartFor(DateTime today) {
    final monday = DateTime(today.year, today.month, today.day - (today.weekday - 1));
    return Days.key(DateTime(monday.year, monday.month, monday.day - 7));
  }

  static WeeklyReview? build(
      Map<int, DayFacts> facts, InsightTargets t, DateTime today) {
    final start = Days.fromKey(weekStartFor(today));
    final sunday = Days.key(DateTime(start.year, start.month, start.day + 6));
    MetricSeries s(InsightMetric m) =>
        InsightsEngine.series(m, facts, t, sunday, InsightRange.week);
    final all = {for (final m in InsightMetric.values) m: s(m)};
    final active = {
      for (final series in all.values)
        for (final d in series.logged) d.dayKey
    };
    if (active.isEmpty) return null;

    // Suggest the area with data that was met least often.
    ReviewTip tip = ReviewTip.keepGoing;
    var worst = 1.0;
    for (final (m, t) in [
      (InsightMetric.plan, ReviewTip.plan),
      (InsightMetric.habits, ReviewTip.habits),
      (InsightMetric.water, ReviewTip.water),
      (InsightMetric.sleep, ReviewTip.sleep),
      (InsightMetric.activity, ReviewTip.activity),
    ]) {
      final series = all[m]!;
      if (series.loggedDays < 2) continue;
      final rate = series.metDays / series.loggedDays;
      if (rate < worst && rate < 0.6) {
        worst = rate;
        tip = t;
      }
    }

    // Best day: most areas met.
    int? best;
    var bestCount = 0;
    for (final k in active) {
      final c = all.entries
          .where((e) => e.key != InsightMetric.mood)
          .where((e) => e.value.days.any((d) => d.dayKey == k && d.mark == DayMark.met))
          .length;
      if (c > bestCount) {
        bestCount = c;
        best = k;
      }
    }
    return WeeklyReview(
      weekStart: Days.key(start),
      activeDays: active.length,
      water: all[InsightMetric.water]!,
      sleep: all[InsightMetric.sleep]!,
      activity: all[InsightMetric.activity]!,
      plan: all[InsightMetric.plan]!,
      tip: tip,
      bestDay: best,
    );
  }
}
