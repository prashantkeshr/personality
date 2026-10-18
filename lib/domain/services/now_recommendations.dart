import 'dart:math' as math;

import '../entities/body.dart';

/// What the Home "Recommended for now" section can suggest.
enum NowKind {
  breakfast,
  lunch,
  dinner,
  water,
  postureCheck,
  weighIn,
  wakeStretch,
  walkAfterMeal,
  microSet,
  skillPractice,
  yoga,
  faceSnapshot,
  windDown,
  mealReminders,
}

/// A short exercise set that starts small and grows as sets are logged.
class MicroExercise {
  const MicroExercise({
    required this.id,
    required this.base,
    required this.step,
    required this.max,
    this.seconds = false,
    this.eachSide = false,
  });

  /// Exercise library and motion id.
  final String id;

  /// Starting amount for (low, medium, high) activity levels.
  final (int, int, int) base;

  /// Added after every two logged sets, up to [max].
  final int step;
  final int max;

  /// Held for seconds rather than counted.
  final bool seconds;
  final bool eachSide;

  static const all = [
    MicroExercise(id: 'push_up', base: (5, 8, 10), step: 1, max: 30),
    MicroExercise(id: 'squat', base: (15, 20, 25), step: 3, max: 60),
    MicroExercise(
      id: 'plank',
      base: (20, 30, 40),
      step: 5,
      max: 120,
      seconds: true,
    ),
    MicroExercise(id: 'glute_bridge', base: (10, 12, 15), step: 2, max: 40),
    MicroExercise(
      id: 'lunge',
      base: (6, 8, 10),
      step: 1,
      max: 20,
      eachSide: true,
    ),
  ];

  static MicroExercise byId(String id) => all.firstWhere((e) => e.id == id);

  /// The amount to do now, after [setsLogged] earlier sets.
  int target(ActivityLevel? level, int setsLogged) {
    final start = switch (level) {
      ActivityLevel.moderate => base.$2,
      ActivityLevel.active || ActivityLevel.veryActive => base.$3,
      _ => base.$1,
    };
    return math.min(max, start + step * (setsLogged ~/ 2));
  }
}

class NowRecommendation {
  const NowRecommendation(
    this.kind, {
    this.exercise,
    this.amount,
    this.skillId,
  });

  final NowKind kind;
  final MicroExercise? exercise;

  /// Reps or seconds for a micro set.
  final int? amount;
  final String? skillId;

  /// Stable per day: what "done" and "not now" are stored against.
  String get key => switch (kind) {
    NowKind.microSet => 'micro:${exercise!.id}',
    NowKind.skillPractice => 'skill:$skillId',
    _ => kind.name,
  };
}

class NowInput {
  const NowInput({
    required this.now,
    this.goals = const {},
    this.level,
    this.mealTimesToday = const [],
    this.waterFraction,
    this.postureCheckedToday = false,
    this.weighedToday = false,
    this.lastFaceSnapshot,
    this.setsLogged = const {},
    this.mySkills = const [],
    this.handledToday = const {},
    this.mealRemindersOn = true,
    this.neverAgain = const {},
  });

  final DateTime now;
  final Set<GoalType> goals;
  final ActivityLevel? level;

  /// Local times of meals logged today.
  final List<DateTime> mealTimesToday;

  /// Share of today's water target already logged, or null with no target.
  final double? waterFraction;
  final bool postureCheckedToday;
  final bool weighedToday;
  final DateTime? lastFaceSnapshot;

  /// Micro-set exercise id → sets logged so far.
  final Map<String, int> setsLogged;

  /// Skills (discipline ids) the user chose to practise regularly.
  final List<String> mySkills;

  /// Keys done or set aside ("Not now") today.
  final Set<String> handledToday;
  final bool mealRemindersOn;

  /// One-off suggestions the user turned down for good.
  final Set<String> neverAgain;
}

/// Picks a few small, doable things for this time of day — a nudge, never a
/// to-do list. Each window only suggests what still makes sense now (no
/// lunch reminder once lunch is logged, no posture check twice a day).
abstract final class NowRecommendations {
  static const maxShown = 4;

  static List<NowRecommendation> build(NowInput i) {
    final m = i.now.hour * 60 + i.now.minute;
    bool between(int fromH, int fromM, int toH, int toM) =>
        m >= fromH * 60 + fromM && m < toH * 60 + toM;
    bool mealSince(int h) => i.mealTimesToday.any((t) => t.hour >= h);
    final day = i.now.difference(DateTime(i.now.year)).inDays;

    final out = <(int, NowRecommendation)>[]; // (priority, item)
    void add(int priority, NowRecommendation r) => out.add((priority, r));

    // Meals at regular times: around 8:30, 13:00 and 20:00.
    if (between(7, 0, 10, 30) && !mealSince(5)) {
      add(1, const NowRecommendation(NowKind.breakfast));
    }
    if (between(12, 30, 15, 0) && !mealSince(11)) {
      add(1, const NowRecommendation(NowKind.lunch));
    }
    if (between(19, 30, 22, 0) && !mealSince(17)) {
      add(1, const NowRecommendation(NowKind.dinner));
    }

    // Behind on water for the time of day.
    final w = i.waterFraction;
    if (w != null && between(9, 0, 21, 0)) {
      final expected = ((m - 7 * 60) / (14 * 60)).clamp(0.0, 1.0);
      if (w + 0.15 < expected) add(2, const NowRecommendation(NowKind.water));
    }

    // Mornings: posture check, weigh-in, a stretch.
    if (between(5, 0, 12, 0) && !i.postureCheckedToday) {
      add(2, const NowRecommendation(NowKind.postureCheck));
    }
    if (between(5, 0, 11, 0) &&
        !i.weighedToday &&
        i.goals.contains(GoalType.weightManagement)) {
      add(3, const NowRecommendation(NowKind.weighIn));
    }
    if (between(5, 0, 10, 0)) {
      add(4, const NowRecommendation(NowKind.wakeStretch));
    }

    // A short walk within an hour after a meal.
    final lastMeal = i.mealTimesToday.isEmpty
        ? null
        : i.mealTimesToday.reduce((a, b) => a.isAfter(b) ? a : b);
    if (lastMeal != null) {
      final after = i.now.difference(lastMeal).inMinutes;
      if (after >= 0 && after <= 60 && between(8, 0, 21, 30)) {
        add(3, const NowRecommendation(NowKind.walkAfterMeal));
      }
    }

    // Daytime: one micro set, a different exercise each day and each half
    // of the day, sized from the sets already logged.
    if (between(10, 0, 20, 30)) {
      final slot = m < 15 * 60 ? 0 : 1;
      final ex = MicroExercise.all[(day * 2 + slot) % MicroExercise.all.length];
      add(
        3,
        NowRecommendation(
          NowKind.microSet,
          exercise: ex,
          amount: ex.target(i.level, i.setsLogged[ex.id] ?? 0),
        ),
      );
    }

    // Chosen skills, one a day, in the late afternoon and evening.
    if (i.mySkills.isNotEmpty && between(16, 0, 21, 30)) {
      add(
        3,
        NowRecommendation(
          NowKind.skillPractice,
          skillId: i.mySkills[day % i.mySkills.length],
        ),
      );
    }

    // Flexibility goal: a short yoga flow morning or evening.
    if (i.goals.contains(GoalType.flexibility) &&
        (between(6, 0, 9, 30) || between(17, 0, 21, 0))) {
      add(4, const NowRecommendation(NowKind.yoga));
    }

    // Weekly face snapshot for the time-lapse.
    final face = i.lastFaceSnapshot;
    if (between(8, 0, 20, 0) &&
        (face == null || i.now.difference(face).inDays >= 7)) {
      add(5, const NowRecommendation(NowKind.faceSnapshot));
    }

    if (between(21, 30, 24, 0)) {
      add(2, const NowRecommendation(NowKind.windDown));
    }

    // Once: offer meal-time reminders to anyone who hasn't got them.
    if (!i.mealRemindersOn &&
        !i.neverAgain.contains(NowKind.mealReminders.name) &&
        between(8, 0, 21, 0)) {
      add(2, const NowRecommendation(NowKind.mealReminders));
    }

    // By priority (meals first), keeping the order above for ties.
    final shown =
        [
          for (var n = 0; n < out.length; n++)
            if (!i.handledToday.contains(out[n].$2.key))
              (out[n].$1, n, out[n].$2),
        ]..sort(
          (a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2),
        );
    return [for (final (_, _, r) in shown.take(maxShown)) r];
  }
}
