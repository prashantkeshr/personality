import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/services/now_recommendations.dart';

List<NowKind> kinds(NowInput i) => [
  for (final r in NowRecommendations.build(i)) r.kind,
];

void main() {
  DateTime at(int h, [int m = 0]) => DateTime(2026, 10, 19, h, m); // a Monday

  test('morning: breakfast first, then posture check and a stretch', () {
    expect(kinds(NowInput(now: at(8), lastFaceSnapshot: at(7))), [
      NowKind.breakfast,
      NowKind.postureCheck,
      NowKind.wakeStretch,
    ]);
  });

  test('weigh-in only for a weight goal, and once a day', () {
    final goal = {GoalType.weightManagement};
    expect(kinds(NowInput(now: at(7), goals: goal)), contains(NowKind.weighIn));
    expect(
      kinds(NowInput(now: at(7), goals: goal, weighedToday: true)),
      isNot(contains(NowKind.weighIn)),
    );
    expect(kinds(NowInput(now: at(7))), isNot(contains(NowKind.weighIn)));
  });

  test('lunch at 1 pm until a meal is logged, then a walk', () {
    expect(kinds(NowInput(now: at(13))).first, NowKind.lunch);
    final after = kinds(NowInput(now: at(13, 20), mealTimesToday: [at(13)]));
    expect(after, isNot(contains(NowKind.lunch)));
    expect(after, contains(NowKind.walkAfterMeal));
    // An hour later the walk suggestion has passed.
    expect(
      kinds(NowInput(now: at(14, 30), mealTimesToday: [at(13)])),
      isNot(contains(NowKind.walkAfterMeal)),
    );
  });

  test('dinner in the evening, wind-down before bed', () {
    expect(kinds(NowInput(now: at(20))), contains(NowKind.dinner));
    expect(kinds(NowInput(now: at(22))), [NowKind.windDown]);
  });

  test('micro sets start small and grow as sets are logged', () {
    final push = MicroExercise.byId('push_up');
    expect(push.target(null, 0), 5);
    expect(push.target(ActivityLevel.sedentary, 1), 5);
    expect(push.target(ActivityLevel.sedentary, 2), 6);
    expect(push.target(ActivityLevel.active, 0), 10);
    expect(push.target(null, 500), 30); // capped
    expect(MicroExercise.byId('squat').target(null, 0), 15);
    expect(MicroExercise.byId('squat').target(null, 4), 21);
  });

  test('one micro set by day, sized from the log', () {
    final r = NowRecommendations.build(
      NowInput(
        now: at(11),
        lastFaceSnapshot: at(9),
        setsLogged: const {
          'push_up': 4,
          'squat': 4,
          'plank': 4,
          'glute_bridge': 4,
          'lunge': 4,
        },
      ),
    );
    final set = r.singleWhere((x) => x.kind == NowKind.microSet);
    expect(set.amount, set.exercise!.target(null, 4));
    // The afternoon brings a different exercise.
    final pm = NowRecommendations.build(NowInput(now: at(16)))
        .singleWhere((x) => x.kind == NowKind.microSet);
    expect(pm.exercise!.id, isNot(set.exercise!.id));
  });

  test('chosen skills rotate by day in the evening', () {
    final r = NowRecommendations.build(
      NowInput(now: at(18), mySkills: const ['karate', 'kushti']),
    );
    expect(r.map((x) => x.kind), contains(NowKind.skillPractice));
    expect(
      r.firstWhere((x) => x.kind == NowKind.skillPractice).skillId,
      isIn(['karate', 'kushti']),
    );
  });

  test('done or "not now" hides a suggestion for the day', () {
    final i = NowInput(now: at(8), handledToday: const {'breakfast'});
    expect(kinds(i), isNot(contains(NowKind.breakfast)));
  });

  test('meal reminders are offered once, unless turned down', () {
    expect(
      kinds(NowInput(now: at(16), mealRemindersOn: false)),
      contains(NowKind.mealReminders),
    );
    expect(
      kinds(
        NowInput(
          now: at(16),
          mealRemindersOn: false,
          neverAgain: const {'mealReminders'},
        ),
      ),
      isNot(contains(NowKind.mealReminders)),
    );
  });

  test('never more than four at once', () {
    final r = NowRecommendations.build(
      NowInput(
        now: at(8),
        goals: const {GoalType.weightManagement, GoalType.flexibility},
        waterFraction: 0,
        mealRemindersOn: false,
      ),
    );
    expect(r.length, NowRecommendations.maxShown);
    expect(r.first.kind, NowKind.breakfast);
  });
}
