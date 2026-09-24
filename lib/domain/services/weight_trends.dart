import '../entities/body.dart';

class WeightPoint {
  const WeightPoint(this.date, this.kg);
  final DateTime date;
  final double kg;
}

/// Deterministic weight trend calculations (spec §14).
abstract final class WeightTrends {
  /// Records within [days] before [now], oldest first.
  static List<BodyRecord> window(
    List<BodyRecord> records,
    DateTime now,
    int days,
  ) {
    final from = now.subtract(Duration(days: days));
    return records
        .where((r) => !r.recordedAt.isBefore(from) && !r.recordedAt.isAfter(now))
        .toList()
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
  }

  /// Trailing average over the previous [windowDays] for each record.
  /// Smooths day-to-day fluctuation (water, meals) so trends are readable.
  static List<WeightPoint> movingAverage(
    List<BodyRecord> sortedRecords, {
    int windowDays = 7,
  }) {
    final result = <WeightPoint>[];
    for (var i = 0; i < sortedRecords.length; i++) {
      final end = sortedRecords[i].recordedAt;
      final start = end.subtract(Duration(days: windowDays));
      var sum = 0.0;
      var n = 0;
      for (var j = i; j >= 0; j--) {
        final r = sortedRecords[j];
        if (r.recordedAt.isBefore(start)) break;
        sum += r.value;
        n++;
      }
      result.add(WeightPoint(end, sum / n));
    }
    return result;
  }

  /// Change between the first and last trailing averages in the window,
  /// or null when there are fewer than two records.
  static double? change(List<BodyRecord> sortedRecords) {
    if (sortedRecords.length < 2) return null;
    final avg = movingAverage(sortedRecords);
    return avg.last.kg - avg.first.kg;
  }
}

enum GoalRangePosition { below, within, above }

GoalRangePosition? positionInGoal(double kg, Profile profile) {
  if (!profile.hasWeightGoal) return null;
  if (kg < profile.goalWeightMinKg!) return GoalRangePosition.below;
  if (kg > profile.goalWeightMaxKg!) return GoalRangePosition.above;
  return GoalRangePosition.within;
}
