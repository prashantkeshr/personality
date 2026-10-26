import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/health.dart' show ExerciseCategory;
import '../../domain/entities/exercise_library.dart';
import '../../domain/services/training_engine.dart';
import '../content/content_providers.dart';
import '../exercise/my_workouts.dart';
import '../health/body_providers.dart';
import '../health/health_providers.dart' show clockProvider;
import '../permissions/app_permissions.dart' show appKvProvider;

const _prefsKey = 'training.prefs';
const _progressKey = 'training.progress';

/// The user's training settings; null until set (onboarding or the plan
/// screen), then the defaults below apply.
final trainingPrefsProvider = StreamProvider<TrainingPrefs?>((ref) => ref
    .watch(appKvProvider)
    .watchPrefix(_prefsKey)
    .map((m) => TrainingPrefs.parse(m[_prefsKey])));

/// Settings with the gender-based default focus when none were chosen.
final effectiveTrainingPrefsProvider = Provider<TrainingPrefs>((ref) {
  final saved = ref.watch(trainingPrefsProvider).value;
  if (saved != null) return saved;
  final gender = ref.watch(profileProvider).value?.gender;
  return TrainingPrefs(focus: TrainingPrefs.focusFor(gender));
});

final trainingProgressProvider = StreamProvider<TrainingProgress>((ref) => ref
    .watch(appKvProvider)
    .watchPrefix(_progressKey)
    .map((m) => TrainingProgress.parse(m[_progressKey])));

/// This week's plan, Monday to Sunday.
final trainingWeekProvider = Provider<List<PlanDay>>((ref) {
  final prefs = ref.watch(effectiveTrainingPrefsProvider);
  final known = {
    for (final e in ref.watch(exerciseCatalogProvider).value ?? const <LibraryExercise>[]) e.id,
  };
  return TrainingEngine.week(
    prefs: prefs,
    goals: ref.watch(goalsProvider).value ?? const {},
    age: ref.watch(profileProvider).value?.ageRange,
    progress: ref.watch(trainingProgressProvider).value ?? const TrainingProgress(),
    available: known.isEmpty ? null : known,
  );
});

final todayPlanProvider = Provider<PlanDay?>((ref) {
  final week = ref.watch(trainingWeekProvider);
  final wd = ref.watch(clockProvider)().weekday;
  return week.where((d) => d.weekday == wd).firstOrNull;
});

String planProgramId(int weekday) => 'plan_$weekday';

int? planWeekdayOf(String programId) =>
    programId.startsWith('plan_') ? int.tryParse(programId.substring(5)) : null;

/// A plan day as a playable workout: each set is its own step.
WorkoutProgram planProgram(PlanDay day, {required String title}) => WorkoutProgram(
  id: planProgramId(day.weekday),
  title: {'en': title},
  summary: const {},
  category: switch (day.type) {
    SessionType.cardio => ExerciseCategory.cardio,
    SessionType.yoga => ExerciseCategory.yoga,
    SessionType.mobility => ExerciseCategory.mobility,
    SessionType.posture => ExerciseCategory.posture,
    SessionType.core => ExerciseCategory.core,
    _ => ExerciseCategory.strength,
  },
  steps: [
    for (final p in day.exercises)
      for (var s = 0; s < p.sets; s++)
        ProgramStep(
          exercise: p.exerciseId,
          reps: p.kind == DoseKind.reps ? p.amount : null,
          seconds: switch (p.kind) {
            DoseKind.hold => p.amount,
            DoseKind.minutes => p.amount * 60,
            DoseKind.reps => null,
          },
          rest: p.restSeconds,
          sides: p.sides,
        ),
  ],
);

/// Guided workouts plus the user's plan days, for the detail and player
/// screens (plan days stay out of the guided lists).
final playableProgramsProvider = Provider<List<WorkoutProgram>>((ref) => [
  ...ref.watch(programCatalogProvider).value ?? const [],
  ...ref.watch(myWorkoutsProvider).value ?? const [],
  for (final d in ref.watch(trainingWeekProvider))
    if (!d.isRest) planProgram(d, title: 'My plan'),
]);

class TrainingActions {
  TrainingActions(this._ref);
  final Ref _ref;

  Future<void> savePrefs(TrainingPrefs p) =>
      _ref.read(appKvProvider).put(_prefsKey, p.encode());

  /// After a plan session: adjusts the difficulty and, when the plan has
  /// moved up enough, promotes the level (and resets the steps, since the
  /// new level starts harder). Returns the new level when promoted.
  Future<FitnessLevel?> recordFeel(PlanDay day, SessionFeel feel) async {
    final kv = _ref.read(appKvProvider);
    final current = TrainingProgress.parse(await kv.get(_progressKey));
    final next = TrainingEngine.adjust(current, day, feel);
    final prefs = _ref.read(effectiveTrainingPrefsProvider);
    final week = _ref.read(trainingWeekProvider);
    final up = TrainingEngine.levelUp(prefs, week, next);
    if (up != null) {
      await savePrefs(prefs.copyWith(level: up));
      await kv.put(_progressKey, const TrainingProgress().encode());
      return up;
    }
    await kv.put(_progressKey, next.encode());
    return null;
  }
}

final trainingActionsProvider = Provider((ref) => TrainingActions(ref));
