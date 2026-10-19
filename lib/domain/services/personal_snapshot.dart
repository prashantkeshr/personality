import '../entities/body.dart';
import 'insights_engine.dart';
import 'posture_engine.dart';

/// Areas rated on the About page, each from the user's own data only.
enum SnapshotArea { body, posture, activity, sleep, hydration, consistency }

/// Per-area rating. There is deliberately no overall score.
enum RatingLevel { great, good, fair, needsWork }

class AreaRating {
  const AreaRating(this.area, this.level, {this.value});
  final SnapshotArea area;
  final RatingLevel level;

  /// The number behind the rating (BMI, minutes, hours, % of days, streak).
  final double? value;

  bool get needsAttention =>
      level == RatingLevel.fair || level == RatingLevel.needsWork;
}

/// Why an exercise is suggested.
sealed class SuggestReason {
  const SuggestReason();
}

class ForPosture extends SuggestReason {
  const ForPosture(this.metric);
  final PostureMetric metric;
}

class ForWeight extends SuggestReason {
  const ForWeight({required this.gain});

  /// True when the BMI is under the healthy range (build strength), false
  /// when over it (move more).
  final bool gain;
}

class ForArea extends SuggestReason {
  const ForArea(this.area);
  final SnapshotArea area;
}

class ForGoal extends SuggestReason {
  const ForGoal(this.goal);
  final GoalType goal;
}

class ExerciseSuggestion {
  const ExerciseSuggestion(this.exerciseId, this.reason);
  final String exerciseId;
  final SuggestReason reason;
}

class PersonalSnapshot {
  const PersonalSnapshot({
    required this.ratings,
    required this.improvements,
    required this.suggestions,
  });

  final List<AreaRating> ratings;

  /// The areas most worth working on, the user's focus and worst first.
  final List<AreaRating> improvements;
  final List<ExerciseSuggestion> suggestions;

  bool get isEmpty => ratings.isEmpty;
}

/// Turns the user's checks and logs into per-area ratings, the main things
/// to improve and exercises that fit. Wellness guidance only, never medical.
abstract final class PersonalSnapshotEngine {
  static const _postureExercises = {
    PostureMetric.headForward: ['chin_tuck', 'wall_angels'],
    PostureMetric.headTilt: ['neck_stretch', 'chin_tuck'],
    PostureMetric.shoulderLevel: ['shoulder_rolls', 'wall_angels'],
    PostureMetric.hipLevel: ['glute_bridge', 'bird_dog'],
    PostureMetric.torsoLean: ['plank', 'cat_cow'],
    PostureMetric.kneeAlignment: ['glute_bridge', 'wall_sit'],
  };

  static const _goalExercises = {
    GoalType.posture: ['wall_angels', 'chin_tuck'],
    GoalType.weightManagement: ['brisk_walk', 'squat'],
    GoalType.fitness: ['brisk_walk', 'plank', 'squat'],
    GoalType.strength: ['push_up', 'squat', 'reverse_lunge'],
    GoalType.flexibility: ['downward_dog', 'hamstring_stretch', 'cat_cow'],
    GoalType.mindfulness: ['seated_breath', 'tree_pose'],
    GoalType.sleep: ['seated_breath', 'child_pose'],
    GoalType.energy: ['surya_namaskar', 'knee_raise'],
    GoalType.confidence: ['mountain_pose', 'warrior_2'],
  };

  static PersonalSnapshot build({
    double? bmi,
    List<MetricResult> posture = const [],
    MetricSeries? activity,
    MetricSeries? sleep,
    MetricSeries? water,
    int? streak,
    Set<GoalType> goals = const {},
    int maxSuggestions = 6,
  }) {
    final ratings = <AreaRating>[
      if (bmi != null) AreaRating(SnapshotArea.body, _bmi(bmi), value: bmi),
      if (posture.isNotEmpty)
        AreaRating(SnapshotArea.posture, _posture(posture)),
      if (_avg(activity) case final m?)
        AreaRating(SnapshotArea.activity, _activity(m), value: m),
      if (_avg(sleep) case final h?)
        AreaRating(SnapshotArea.sleep, _sleep(h), value: h),
      if (water != null && water.loggedDays >= 3)
        AreaRating(
          SnapshotArea.hydration,
          _ratio(water.metDays / water.loggedDays),
          value: water.metDays / water.loggedDays,
        ),
      if (streak != null)
        AreaRating(
          SnapshotArea.consistency,
          _streak(streak),
          value: streak.toDouble(),
        ),
    ];

    bool isFocus(SnapshotArea a) => switch (a) {
      SnapshotArea.body => goals.contains(GoalType.weightManagement),
      SnapshotArea.posture => goals.contains(GoalType.posture),
      SnapshotArea.activity =>
        goals.contains(GoalType.fitness) || goals.contains(GoalType.energy),
      SnapshotArea.sleep => goals.contains(GoalType.sleep),
      SnapshotArea.hydration => goals.contains(GoalType.hydration),
      SnapshotArea.consistency => goals.contains(GoalType.habits),
    };
    final improvements = ratings.where((r) => r.needsAttention).toList()
      ..sort((a, b) {
        final f = (isFocus(b.area) ? 1 : 0) - (isFocus(a.area) ? 1 : 0);
        return f != 0 ? f : b.level.index - a.level.index;
      });

    // Suggestions: what the data shows first, then the user's goals.
    final picks = <ExerciseSuggestion>[];
    void add(String id, SuggestReason why) {
      if (picks.length < maxSuggestions &&
          !picks.any((p) => p.exerciseId == id)) {
        picks.add(ExerciseSuggestion(id, why));
      }
    }

    final offAxis =
        posture.where((m) => m.band != AlignmentBand.aligned).toList()
          ..sort((a, b) => b.band.index - a.band.index);
    for (final m in offAxis) {
      for (final id in _postureExercises[m.metric] ?? const <String>[]) {
        add(id, ForPosture(m.metric));
      }
    }
    if (bmi != null && bmi >= 25) {
      for (final id in ['brisk_walk', 'squat', 'knee_raise']) {
        add(id, const ForWeight(gain: false));
      }
    } else if (bmi != null && bmi < 18.5) {
      for (final id in ['incline_push_up', 'squat', 'glute_bridge']) {
        add(id, const ForWeight(gain: true));
      }
    }
    for (final r in improvements) {
      final ids = switch (r.area) {
        SnapshotArea.activity => ['brisk_walk', 'surya_namaskar'],
        SnapshotArea.sleep => ['seated_breath', 'child_pose', 'forward_fold'],
        SnapshotArea.consistency => ['arm_raise', 'calf_raise'],
        _ => const <String>[],
      };
      for (final id in ids) {
        add(id, ForArea(r.area));
      }
    }
    for (final g in GoalType.values.where(goals.contains)) {
      for (final id in _goalExercises[g] ?? const <String>[]) {
        add(id, ForGoal(g));
      }
    }
    if (picks.isEmpty) {
      add('mountain_pose', const ForArea(SnapshotArea.posture));
      add('brisk_walk', const ForArea(SnapshotArea.activity));
    }

    return PersonalSnapshot(
      ratings: ratings,
      improvements: improvements.take(3).toList(),
      suggestions: picks,
    );
  }

  /// Average over logged days, once there are at least three of them.
  static double? _avg(MetricSeries? s) =>
      s == null || s.loggedDays < 3 ? null : s.average;

  static RatingLevel _bmi(double b) => b >= 18.5 && b < 25
      ? RatingLevel.great
      : (b >= 17 && b < 18.5) || (b >= 25 && b < 30)
      ? RatingLevel.fair
      : RatingLevel.needsWork;

  static RatingLevel _posture(List<MetricResult> ms) {
    if (ms.any((m) => m.band == AlignmentBand.noticeable)) {
      return RatingLevel.needsWork;
    }
    final slight = ms.where((m) => m.band == AlignmentBand.slight).length;
    return slight == 0
        ? RatingLevel.great
        : slight == 1
        ? RatingLevel.good
        : RatingLevel.fair;
  }

  /// Daily active minutes.
  static RatingLevel _activity(double m) => m >= 30
      ? RatingLevel.great
      : m >= 20
      ? RatingLevel.good
      : m >= 10
      ? RatingLevel.fair
      : RatingLevel.needsWork;

  /// Hours a night.
  static RatingLevel _sleep(double h) => h >= 7 && h <= 9
      ? RatingLevel.great
      : (h >= 6.5 && h < 7) || (h > 9 && h <= 10)
      ? RatingLevel.good
      : h >= 6
      ? RatingLevel.fair
      : RatingLevel.needsWork;

  /// Share of logged days the target was met.
  static RatingLevel _ratio(double r) => r >= .8
      ? RatingLevel.great
      : r >= .5
      ? RatingLevel.good
      : r >= .25
      ? RatingLevel.fair
      : RatingLevel.needsWork;

  static RatingLevel _streak(int d) => d >= 7
      ? RatingLevel.great
      : d >= 3
      ? RatingLevel.good
      : d >= 1
      ? RatingLevel.fair
      : RatingLevel.needsWork;
}
