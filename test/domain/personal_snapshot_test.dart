import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/domain/services/insights_engine.dart';
import 'package:personality/domain/services/personal_snapshot.dart';
import 'package:personality/domain/services/posture_engine.dart';

MetricResult m(PostureMetric metric, AlignmentBand band) => MetricResult(
  metric: metric,
  degrees: 10,
  direction: MetricDirection.forward,
  band: band,
  spread: 1,
  confidence: Confidence.high,
);

MetricSeries series(
  InsightMetric metric,
  List<double?> values, {
  DayMark mark = DayMark.met,
}) => MetricSeries(metric, [
  for (var i = 0; i < values.length; i++)
    DayPoint(i, values[i], values[i] == null ? DayMark.noData : mark),
]);

void main() {
  test('nothing known: no ratings, a gentle starting point', () {
    final s = PersonalSnapshotEngine.build();
    expect(s.isEmpty, isTrue);
    expect(s.improvements, isEmpty);
    expect(s.suggestions.map((e) => e.exerciseId), [
      'mountain_pose',
      'brisk_walk',
    ]);
  });

  test('rates each area from the data behind it', () {
    final s = PersonalSnapshotEngine.build(
      bmi: 22.4,
      posture: [
        m(PostureMetric.headForward, AlignmentBand.slight),
        m(PostureMetric.shoulderLevel, AlignmentBand.aligned),
      ],
      activity: series(InsightMetric.activity, [12, 8, 15, null]),
      sleep: series(InsightMetric.sleep, [7.5, 8, 7]),
      water: series(InsightMetric.water, [
        2000,
        2000,
        1000,
        900,
      ], mark: DayMark.partial),
      streak: 4,
    );
    final byArea = {for (final r in s.ratings) r.area: r.level};
    expect(byArea, {
      SnapshotArea.body: RatingLevel.great,
      SnapshotArea.posture: RatingLevel.good,
      SnapshotArea.activity: RatingLevel.fair, // ~11.7 min a day
      SnapshotArea.sleep: RatingLevel.great,
      SnapshotArea.hydration: RatingLevel.needsWork, // 0 of 4 days met
      SnapshotArea.consistency: RatingLevel.good,
    });
    // Worst first.
    expect(s.improvements.map((r) => r.area), [
      SnapshotArea.hydration,
      SnapshotArea.activity,
    ]);
  });

  test('fewer than three logged days is not enough to rate', () {
    final s = PersonalSnapshotEngine.build(
      activity: series(InsightMetric.activity, [40, null, null]),
    );
    expect(s.ratings, isEmpty);
  });

  test('suggestions follow posture first, then weight, areas and goals', () {
    final s = PersonalSnapshotEngine.build(
      bmi: 27,
      posture: [
        m(PostureMetric.shoulderLevel, AlignmentBand.slight),
        m(PostureMetric.headForward, AlignmentBand.noticeable),
      ],
      goals: {GoalType.strength},
      maxSuggestions: 10,
    );
    final ids = s.suggestions.map((e) => e.exerciseId).toList();
    // The noticeable issue leads; duplicates are dropped.
    expect(ids.take(4), [
      'chin_tuck',
      'wall_angels',
      'shoulder_rolls',
      'brisk_walk',
    ]);
    expect(ids.toSet().length, ids.length);
    expect(s.suggestions.first.reason, isA<ForPosture>());
    expect(
      s.suggestions
          .where((e) => e.reason is ForWeight)
          .map((e) => e.exerciseId),
      ['brisk_walk', 'squat', 'knee_raise'],
    );
    expect(ids, contains('push_up')); // from the strength goal
    expect(
      s.ratings.firstWhere((r) => r.area == SnapshotArea.posture).level,
      RatingLevel.needsWork,
    );
  });

  test('the user\'s focus goes first among things to improve', () {
    final s = PersonalSnapshotEngine.build(
      bmi: 31, // needs work
      sleep: series(InsightMetric.sleep, [6.2, 6.1, 6.3]), // fair
      goals: {GoalType.sleep},
    );
    expect(s.improvements.first.area, SnapshotArea.sleep);
    expect(s.suggestions.any((e) => e.exerciseId == 'seated_breath'), isTrue);
  });
}
