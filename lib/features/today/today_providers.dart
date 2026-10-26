import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/repositories/wellbeing_repository.dart';
import '../../domain/entities/health.dart';
import '../../domain/services/day_agenda.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/meal_planner.dart';
import '../../domain/services/plan_engine.dart';
import '../health/body_providers.dart';
import '../health/health_providers.dart';
import '../plans/plan_providers.dart';
import '../routines/routine_providers.dart';

final wellbeingRepositoryProvider = Provider((ref) => WellbeingRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider)));

final todayModeProvider = StreamProvider<DayMode>(
    (ref) => ref.watch(wellbeingRepositoryProvider).watchTodayMode());

final moodsProvider = StreamProvider<List<MoodCheckIn>>(
    (ref) => ref.watch(wellbeingRepositoryProvider).watchMoods());

/// Today's check-in, if done.
final todayMoodProvider = Provider<MoodCheckIn?>((ref) {
  final today = Days.key(ref.watch(clockProvider)());
  for (final m in ref.watch(moodsProvider).value ?? const <MoodCheckIn>[]) {
    if (m.day == today) return m;
  }
  return null;
});

/// The day shown on Home (today unless the user looks back).
class SelectedDay extends Notifier<int> {
  @override
  int build() => Days.key(ref.watch(clockProvider)());
  void select(int dayKey) => state = dayKey;
}

final selectedDayProvider = NotifierProvider<SelectedDay, int>(SelectedDay.new);

MealSlot? _slotFor(MealType t) => switch (t) {
      MealType.breakfast => MealSlot.breakfast,
      MealType.lunch => MealSlot.lunch,
      MealType.snack => MealSlot.snack,
      MealType.dinner => MealSlot.dinner,
      MealType.custom => null,
    };

/// One timeline for a day, from everything the user already keeps.
final agendaProvider = Provider.family<DayAgenda?, int>((ref, dayKey) {
  final inputs = ref.watch(planInputsProvider);
  final habits = ref.watch(habitsProvider).value;
  final completions = ref.watch(habitCompletionsProvider).value;
  final targets = ref.watch(targetsProvider).value;
  if (inputs == null || habits == null || completions == null || targets == null) {
    return null;
  }
  final now = ref.watch(clockProvider)();
  final today = Days.key(now);
  final date = Days.fromKey(dayKey);

  final plan = PlanEngine.forDay(
      routines: inputs.routines,
      items: inputs.items,
      records: inputs.records,
      dayKey: dayKey,
      now: now);

  final status = {
    for (final c in completions)
      if (c.dayKey == dayKey) c.habitId: c.status,
  };
  final habitsToday = [
    for (final h in habits)
      if (!h.archived && h.startDayKey <= dayKey && h.schedule.includes(date.weekday))
        HabitToday(h.id, h.name,
            done: status[h.id] == HabitStatus.completed,
            skipped: status[h.id] == HabitStatus.skipped),
  ];

  final water = (ref.watch(waterEntriesProvider).value ?? const [])
      .where((w) => Days.key(w.recordedAt) == dayKey)
      .fold(0.0, (s, w) => s + w.value);

  final bodyPlan = ref.watch(activeBodyPlanProvider).value;
  final meals = (ref.watch(mealsProvider).value ?? const [])
      .where((m) => Days.key(m.eatenAt) == dayKey);
  final region = ref.watch(profileProvider).value?.region;
  final workout = bodyPlan == null
      ? null
      : TrainingPlanner.week(bodyPlan.kind, bodyPlan.pace, region: region)[
          date.weekday - 1];
  final workoutDone = (ref.watch(exercisesProvider).value ?? const [])
          .any((e) => Days.key(e.performedAt) == dayKey) ||
      (ref.watch(activitiesProvider).value ?? const [])
          .any((a) => Days.key(a.recordedAt) == dayKey);

  return DayAgenda.build(
    plan: plan,
    habits: habitsToday,
    waterMl: water,
    waterTargetMl: bodyPlan?.waterMl ?? targets.waterMl,
    hasMealPlan: bodyPlan != null,
    loggedMeals: {for (final m in meals) ?_slotFor(m.type)},
    workout: workout,
    workoutDone: workoutDone,
    mode: dayKey == today
        ? ref.watch(todayModeProvider).value ?? DayMode.normal
        : DayMode.normal,
    nowMinute: dayKey == today ? now.hour * 60 + now.minute : null,
  );
});
