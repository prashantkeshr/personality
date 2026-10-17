import 'dart:math' as math;

import '../entities/body.dart';
import 'weight_trends.dart';

/// Where someone is on the way from their starting weight to their goal.
///
/// Uses the 7-day trailing average rather than single weigh-ins, so one
/// salty dinner doesn't move the marker backwards (spec §14).
class WeightJourney {
  const WeightJourney({
    required this.startKg,
    required this.startDate,
    required this.latestKg,
    required this.trendKg,
    required this.targetKg,
    required this.weekChangeKg,
    required this.streakWeeks,
    required this.entries,
  });

  /// Milestones along the way, as shares of the distance.
  static const milestones = [0.25, 0.5, 0.75, 1.0];

  final double startKg;
  final DateTime startDate;
  final double latestKg;
  final double trendKg;

  /// The weight to reach, or null when no goal is set or the start was
  /// already inside the goal range (then the journey is about staying there).
  final double? targetKg;

  /// Change of the trend over the last 7 days; null without two weigh-ins.
  final double? weekChangeKg;

  /// Consecutive weeks (Monday–Sunday) with at least one weigh-in, counting
  /// back from this week, or from last week while this week has none yet.
  final int streakWeeks;
  final int entries;

  double get changeSinceStartKg => trendKg - startKg;

  /// 0 at the start, 1 at the target. Never negative: moving the other way
  /// is shown as "at the start", not as a failure.
  double? get progress {
    final t = targetKg;
    if (t == null) return null;
    final total = t - startKg;
    if (total.abs() < 0.05) return 1;
    return ((trendKg - startKg) / total).clamp(0.0, 1.0);
  }

  /// Distance still to go, or null without a target.
  double? get toGoKg {
    final t = targetKg;
    if (t == null) return null;
    final p = progress!;
    return p >= 1 ? 0 : (t - trendKg).abs();
  }

  int get milestonesReached =>
      progress == null ? 0 : milestones.where((m) => progress! >= m).length;

  /// The weight at milestone [m] (a share of the way).
  double milestoneKg(double m) => startKg + (targetKg! - startKg) * m;

  /// Builds the journey from [records] (any order). The start is the active
  /// body plan's starting point when there is one, otherwise the first
  /// weigh-in. The target is the plan's target weight, otherwise the nearer
  /// edge of the profile's goal range.
  static WeightJourney? build(
    List<BodyRecord> records,
    Profile profile, {
    required DateTime now,
    double? planStartKg,
    DateTime? planStartDate,
    double? planTargetKg,
  }) {
    if (records.isEmpty) return null;
    final sorted = [...records]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    final avg = WeightTrends.movingAverage(sorted);

    final startKg = planStartKg ?? sorted.first.value;
    final startDate = planStartDate ?? sorted.first.recordedAt;

    double? target = planTargetKg;
    if (target == null && profile.hasWeightGoal) {
      final lo = profile.goalWeightMinKg!, hi = profile.goalWeightMaxKg!;
      if (startKg > hi) target = hi;
      if (startKg < lo) target = lo;
    }

    final week = WeightTrends.window(sorted, now, 7);
    return WeightJourney(
      startKg: startKg,
      startDate: startDate,
      latestKg: sorted.last.value,
      trendKg: avg.last.kg,
      targetKg: target,
      weekChangeKg: WeightTrends.change(week),
      streakWeeks: _streak(sorted, now),
      entries: sorted.length,
    );
  }

  static DateTime _monday(DateTime d) {
    final day = DateTime(d.year, d.month, d.day);
    return day.subtract(Duration(days: day.weekday - 1));
  }

  static int _streak(List<BodyRecord> sorted, DateTime now) {
    final weeks = {for (final r in sorted) _monday(r.recordedAt.toLocal())};
    var week = _monday(now);
    if (!weeks.contains(week)) week = week.subtract(const Duration(days: 7));
    var n = 0;
    // Calendar weeks, so the step is a date, not 7×24 h (DST-safe).
    while (weeks.contains(week)) {
      n++;
      week = DateTime(week.year, week.month, week.day - 7);
    }
    return n;
  }

  /// The highest milestone passed between [before] and [after], if any:
  /// used to celebrate right after a weigh-in.
  static double? milestoneCrossed(WeightJourney? before, WeightJourney after) {
    final a = after.progress;
    if (a == null) return null;
    final b = before?.progress ?? 0;
    double? crossed;
    for (final m in milestones) {
      if (b < m && a >= m) crossed = m;
    }
    return crossed;
  }
}

/// Snap [kg] to the ruler's step in the user's units: 0.1 kg or 0.2 lb.
double snapWeight(double kg, {required bool metric}) {
  if (metric) return (kg * 10).round() / 10;
  const lbPerKg = 2.20462262185;
  final lb = (kg * lbPerKg / 0.2).round() * 0.2;
  return lb / lbPerKg;
}

/// Clamp to the app's plausible weight range.
double clampWeight(double kg) =>
    math.min(BodyLimits.maxWeightKg, math.max(BodyLimits.minWeightKg, kg));
