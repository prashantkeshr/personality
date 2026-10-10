import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/health.dart';
import '../../domain/services/evolution_engine.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/insights_engine.dart';
import '../../domain/services/nutrition_engine.dart' show PlanKind;
import '../../domain/services/plan_engine.dart';
import '../health/body_providers.dart';
import '../health/health_providers.dart';
import '../journey/journey_providers.dart';
import '../plans/plan_providers.dart';
import '../routines/routine_providers.dart';
import '../today/today_providers.dart';

final insightTargetsProvider = Provider<InsightTargets>((ref) {
  final t = ref.watch(targetsProvider).value;
  final plan = ref.watch(activeBodyPlanProvider).value;
  return InsightTargets(
    waterMl: plan?.waterMl ?? t?.waterMl ?? 2000,
    sleepMinutes: t?.sleepMinutes ?? 480,
    activeMinutes: t?.activeMinutes ?? 30,
  );
});

/// Facts per local day for the last [historyDays] days.
final dayFactsProvider = Provider<Map<int, DayFacts>>((ref) {
  final now = ref.watch(clockProvider)();
  final inputs = ref.watch(planInputsProvider);
  final habits = ref.watch(habitsProvider).value ?? const <Habit>[];
  final completions =
      ref.watch(habitCompletionsProvider).value ?? const <HabitCompletion>[];
  final water = ref.watch(waterEntriesProvider).value ?? const [];
  final sleep = ref.watch(sleepProvider).value ?? const [];
  final activities = ref.watch(activitiesProvider).value ?? const [];
  final exercises = ref.watch(exercisesProvider).value ?? const [];
  final meals = ref.watch(mealsProvider).value ?? const [];
  final moods = ref.watch(moodsProvider).value ?? const [];

  final waterBy = <int, double>{};
  for (final w in water) {
    final k = Days.key(w.recordedAt);
    waterBy[k] = (waterBy[k] ?? 0) + w.value;
  }
  final sleepBy = <int, int>{};
  for (final s in sleep) {
    final k = Days.key(s.wakeAt);
    sleepBy[k] = (sleepBy[k] ?? 0) + s.duration.inMinutes;
  }
  final activeBy = <int, int>{};
  for (final a in activities) {
    final k = Days.key(a.recordedAt);
    activeBy[k] = (activeBy[k] ?? 0) + (a.durationMinutes ?? 0);
  }
  for (final e in exercises) {
    final k = Days.key(e.performedAt);
    activeBy[k] = (activeBy[k] ?? 0) + e.durationMinutes;
  }
  final mealsBy = <int, int>{};
  for (final m in meals) {
    final k = Days.key(m.eatenAt);
    mealsBy[k] = (mealsBy[k] ?? 0) + 1;
  }
  final moodBy = {for (final m in moods) m.day: m.mood};
  final status = <int, Map<String, HabitStatus>>{};
  for (final c in completions) {
    (status[c.dayKey] ??= {})[c.habitId] = c.status;
  }

  final out = <int, DayFacts>{};
  for (var i = 0; i < historyDays; i++) {
    final d = DateTime(now.year, now.month, now.day - i);
    final k = Days.key(d);
    final plan = inputs == null
        ? const <PlanEntry>[]
        : PlanEngine.forDay(
            routines: inputs.routines,
            items: inputs.items,
            records: inputs.records,
            dayKey: k,
            now: now,
          );
    final due = [
      for (final h in habits)
        if (!h.archived && h.startDayKey <= k && h.schedule.includes(d.weekday))
          h.id,
    ];
    final s = status[k] ?? const {};
    out[k] = DayFacts(
      dayKey: k,
      // Today's still-open items aren't counted yet.
      planScheduled: plan.where((e) => !e.isOpen).length,
      planCompleted: plan
          .where((e) => e.state == PlanItemState.completed)
          .length,
      planSkipped: plan.where((e) => e.state == PlanItemState.skipped).length,
      habitsScheduled: due.length,
      habitsCompleted: due.where((id) => s[id] == HabitStatus.completed).length,
      habitsSkipped: due.where((id) => s[id] == HabitStatus.skipped).length,
      waterMl: waterBy[k],
      sleepMinutes: sleepBy[k],
      activeMinutes: activeBy[k],
      meals: mealsBy[k] ?? 0,
      mood: moodBy[k],
    );
  }
  return out;
});

final insightSeriesProvider =
    Provider.family<MetricSeries, (InsightMetric, InsightRange)>((ref, a) {
      return InsightsEngine.series(
        a.$1,
        ref.watch(dayFactsProvider),
        ref.watch(insightTargetsProvider),
        Days.key(ref.watch(clockProvider)()),
        a.$2,
      );
    });

/// Last 7 nights.
final sleepScoreProvider = Provider<SleepScore?>((ref) {
  final now = ref.watch(clockProvider)();
  final since = now.subtract(const Duration(days: 7));
  final nights = <(DateTime, DateTime)>[
    for (final s in ref.watch(sleepProvider).value ?? const <SleepEntry>[])
      if (s.wakeAt.isAfter(since)) (s.bedAt, s.wakeAt),
  ];
  return SleepScore.of(
    nights,
    targetMinutes: ref.watch(insightTargetsProvider).sleepMinutes,
  );
});

/// Shown Monday to Wednesday for the week just ended, until closed.
final weeklyReviewProvider = Provider<WeeklyReview?>((ref) {
  final now = ref.watch(clockProvider)();
  if (now.weekday > DateTime.wednesday) return null;
  final dismissed = ref.watch(reviewDismissedProvider).value;
  if (dismissed == WeeklyReview.weekStartFor(now)) return null;
  return WeeklyReview.build(
    ref.watch(dayFactsProvider),
    ref.watch(insightTargetsProvider),
    now,
  );
});

final reviewDismissedProvider = StreamProvider<int?>(
  (ref) => ref.watch(wellbeingRepositoryProvider).watchReviewDismissed(),
);

final milestoneNotesProvider = StreamProvider<List<Milestone>>(
  (ref) => ref.watch(wellbeingRepositoryProvider).watchNotes(),
);

final planStartsProvider = StreamProvider<List<(int, PlanKind)>>(
  (ref) => ref.watch(bodyPlanRepositoryProvider).watchStarts(),
);

final evolutionProvider = Provider<List<Milestone>>((ref) {
  final weights = [...ref.watch(weightRecordsProvider).value ?? const []]
    ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
  return EvolutionEngine.build(
    history: ref.watch(progressHistoryProvider).value ?? const [],
    plans: ref.watch(planStartsProvider).value ?? const [],
    weights: [for (final w in weights) (Days.key(w.recordedAt), w.value)],
    notes: ref.watch(milestoneNotesProvider).value ?? const [],
  );
});
