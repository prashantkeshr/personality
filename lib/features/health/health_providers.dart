import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/repositories/body_record_repository.dart';
import '../../data/repositories/health_repositories.dart';
import '../../domain/entities/body.dart';
import '../../domain/entities/health.dart';
import '../../domain/services/health_stats.dart';

/// Injectable clock so widget tests control "today".
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// History screens show the last [historyDays] days.
const historyDays = 30;

DateTime _since(Ref ref) =>
    ref.read(clockProvider)().subtract(const Duration(days: historyDays + 1));

final waterRepositoryProvider = Provider((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BodyRecordRepository(db, db.waterLogs, unit: 'ml');
});
final mealRepositoryProvider =
    Provider((ref) => MealRepository(ref.watch(appDatabaseProvider)));
final sleepRepositoryProvider =
    Provider((ref) => SleepRepository(ref.watch(appDatabaseProvider)));
final activityRepositoryProvider =
    Provider((ref) => ActivityRepository(ref.watch(appDatabaseProvider)));
final exerciseRepositoryProvider =
    Provider((ref) => ExerciseRepository(ref.watch(appDatabaseProvider)));
final habitRepositoryProvider =
    Provider((ref) => HabitRepository(ref.watch(appDatabaseProvider)));
final targetsRepositoryProvider =
    Provider((ref) => TargetsRepository(ref.watch(appDatabaseProvider)));

final waterEntriesProvider = StreamProvider<List<BodyRecord>>(
    (ref) => ref.watch(waterRepositoryProvider).watchAll());
final mealsProvider = StreamProvider<List<MealEntry>>(
    (ref) => ref.watch(mealRepositoryProvider).watchSince(_since(ref)));
final sleepProvider = StreamProvider<List<SleepEntry>>(
    (ref) => ref.watch(sleepRepositoryProvider).watchSince(_since(ref)));
final activitiesProvider = StreamProvider<List<ActivityEntry>>(
    (ref) => ref.watch(activityRepositoryProvider).watchSince(_since(ref)));
final exercisesProvider = StreamProvider<List<ExerciseEntry>>(
    (ref) => ref.watch(exerciseRepositoryProvider).watchSince(_since(ref)));
final habitsProvider = StreamProvider<List<Habit>>(
    (ref) => ref.watch(habitRepositoryProvider).watchHabits());
final habitCompletionsProvider = StreamProvider<List<HabitCompletion>>((ref) {
  final since = Days.lastDays(ref.read(clockProvider)(), historyDays).first;
  return ref.watch(habitRepositoryProvider).watchCompletionsSince(since);
});
final targetsProvider = StreamProvider<DailyTargets>(
    (ref) => ref.watch(targetsRepositoryProvider).watch());

/// Everything the Home "Today" section needs (spec §81).
class TodaySummary {
  const TodaySummary({
    required this.waterMl,
    required this.lastSleep,
    required this.steps,
    required this.activeMinutes,
    required this.habits,
    required this.mealCount,
    required this.targets,
  });

  final double waterMl;
  final Duration? lastSleep;
  final int steps;
  final int activeMinutes;
  final HabitAdherence habits;
  final int mealCount;
  final DailyTargets targets;
}

final todaySummaryProvider = Provider<TodaySummary>((ref) {
  final today = Days.key(ref.watch(clockProvider)());
  final water = ref.watch(waterEntriesProvider).value ?? const [];
  final sleep = ref.watch(sleepProvider).value ?? const [];
  final activities = ref.watch(activitiesProvider).value ?? const [];
  final exercises = ref.watch(exercisesProvider).value ?? const [];
  final habits = ref.watch(habitsProvider).value ?? const [];
  final completions = ref.watch(habitCompletionsProvider).value ?? const [];
  final meals = ref.watch(mealsProvider).value ?? const [];

  return TodaySummary(
    waterMl: HealthStats.waterByDay(water)[today] ?? 0,
    lastSleep: HealthStats.sleepByDay(sleep)[today],
    steps: HealthStats.stepsOn(activities, today),
    activeMinutes: HealthStats.activeMinutesOn(activities, exercises, today),
    habits: HabitAdherence.today(habits, completions, today),
    mealCount: meals.where((m) => Days.key(m.eatenAt) == today).length,
    targets: ref.watch(targetsProvider).value ?? const DailyTargets(),
  );
});
