import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/services/training_engine.dart';

void main() {
  List<SessionType> types(List<PlanDay> w) => [for (final d in w) d.type];

  test('training days are spread, with rest in between', () {
    final w = TrainingEngine.week(prefs: const TrainingPrefs(daysPerWeek: 3));
    expect(w, hasLength(7));
    expect([for (final d in w) if (!d.isRest) d.weekday], [1, 3, 5]);
    expect(w[1].isRest, isTrue);
  });

  test('gender sets the starting focus; strength weeks tilt to it', () {
    expect(TrainingPrefs.focusFor(Gender.female), FocusArea.lower);
    expect(TrainingPrefs.focusFor(Gender.male), FocusArea.upper);
    expect(TrainingPrefs.focusFor(null), FocusArea.balanced);
    final lower = TrainingEngine.week(
      prefs: const TrainingPrefs(daysPerWeek: 4, focus: FocusArea.lower),
      goals: {GoalType.strength},
    );
    expect(types(lower).where((t) => t != SessionType.rest).toList(),
        [SessionType.lower, SessionType.upper, SessionType.core, SessionType.lower]);
  });

  test('each goal gets its own week', () {
    List<SessionType> trained(Set<GoalType> g) => types(TrainingEngine.week(
      prefs: const TrainingPrefs(daysPerWeek: 4),
      goals: g,
    )).where((t) => t != SessionType.rest).toList();
    expect(trained({GoalType.weightManagement}), contains(SessionType.cardio));
    expect(trained({GoalType.posture}).first, SessionType.posture);
    expect(trained({GoalType.flexibility}).first, SessionType.yoga);
  });

  test('sets, reps and holds scale with level and session length', () {
    final b = TrainingEngine.prescribe('squat', level: FitnessLevel.beginner, minutes: 20);
    final a = TrainingEngine.prescribe('squat', level: FitnessLevel.advanced, minutes: 20);
    expect((b.sets, b.amount, b.kind), (2, 10, DoseKind.reps));
    expect((a.sets, a.amount), (4, 18));
    final plank = TrainingEngine.prescribe('plank', level: FitnessLevel.beginner, minutes: 10);
    expect((plank.sets, plank.amount, plank.kind), (1, 20, DoseKind.hold));
    final lunge = TrainingEngine.prescribe('reverse_lunge', level: FitnessLevel.beginner, minutes: 20);
    expect(lunge.sides, isTrue);
    // Short sessions get fewer exercises.
    final w10 = TrainingEngine.week(prefs: const TrainingPrefs(minutes: 10));
    final w45 = TrainingEngine.week(prefs: const TrainingPrefs(minutes: 45));
    expect(w10.first.exercises, hasLength(3));
    expect(w45.first.exercises, hasLength(6));
  });

  test('beginners and older users get easier variants and low impact', () {
    final w = TrainingEngine.week(
      prefs: const TrainingPrefs(daysPerWeek: 6),
      goals: {GoalType.weightManagement},
      age: AgeRange.over65,
    );
    final ids = {for (final d in w) for (final e in d.exercises) e.exerciseId};
    expect(ids, contains('incline_push_up'));
    expect(ids, isNot(contains('push_up')));
    expect(ids, isNot(contains('knee_raise'))); // no high-knee cardio
    expect(ids, contains('brisk_walk'));
  });

  test('home basics add the chair and backpack exercises', () {
    final w = TrainingEngine.week(
      prefs: const TrainingPrefs(equipment: Equipment.homeBasics, focus: FocusArea.upper, minutes: 30),
      goals: {GoalType.strength},
    );
    expect(w.first.exercises.map((e) => e.exerciseId), containsAll(['backpack_row', 'chair_dip']));
  });

  test('too easy steps up; too hard eases; two just-right also step up', () {
    final day = TrainingEngine.week(prefs: const TrainingPrefs()).first;
    final id = day.exercises.first.exerciseId;
    var p = TrainingEngine.adjust(const TrainingProgress(), day, SessionFeel.tooEasy);
    expect(p.stepOf(id), 1);
    p = TrainingEngine.adjust(p, day, SessionFeel.tooHard);
    expect(p.stepOf(id), 0);
    p = TrainingEngine.adjust(p, day, SessionFeel.justRight);
    expect(p.stepOf(id), 0);
    p = TrainingEngine.adjust(p, day, SessionFeel.justRight);
    expect(p.stepOf(id), 1);
    // A step adds reps; three steps add a set.
    final at3 = TrainingEngine.prescribe('squat', level: FitnessLevel.beginner, minutes: 20, step: 3);
    expect((at3.sets, at3.amount), (3, 16));
    // Saved and loaded intact.
    expect(TrainingProgress.parse(p.encode()).stepOf(id), 1);
  });

  test('levels up once the plan is about four steps harder', () {
    const prefs = TrainingPrefs();
    final w = TrainingEngine.week(prefs: prefs);
    expect(TrainingEngine.levelUp(prefs, w, const TrainingProgress()), isNull);
    final ids = {for (final d in w) for (final e in d.exercises) e.exerciseId};
    final p = TrainingProgress(steps: {for (final id in ids) id: 4});
    expect(TrainingEngine.levelUp(prefs, w, p), FitnessLevel.intermediate);
    expect(
      TrainingEngine.levelUp(prefs.copyWith(level: FitnessLevel.advanced), w, p),
      isNull,
    );
  });

  test('prefs survive a round trip', () {
    const prefs = TrainingPrefs(
      level: FitnessLevel.intermediate,
      daysPerWeek: 5,
      minutes: 30,
      equipment: Equipment.homeBasics,
      focus: FocusArea.lower,
    );
    expect(TrainingPrefs.parse(prefs.encode()), prefs);
    expect(TrainingPrefs.parse('nope'), isNull);
  });
}
