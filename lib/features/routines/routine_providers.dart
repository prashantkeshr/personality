import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/notifications/reminder_scheduler.dart';
import '../../core/providers.dart';
import '../../data/repositories/routine_repository.dart';
import '../../domain/entities/routine.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/plan_engine.dart';
import '../health/health_providers.dart';

/// Overridden in main with the platform scheduler; a no-op by default so
/// tests and unsupported platforms still get the full in-app plan.
final reminderSchedulerProvider =
    Provider<ReminderScheduler>((ref) => NoopReminderScheduler());

/// Taps and actions on reminder notifications, delivered from main.
final reminderResponses = StreamController<ReminderResponse>.broadcast();

final routineRepositoryProvider = Provider((ref) => RoutineRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider)));
final reminderSettingsRepositoryProvider = Provider((ref) =>
    ReminderSettingsRepository(ref.watch(appDatabaseProvider),
        clock: ref.watch(clockProvider)));

final routinesProvider = StreamProvider<List<Routine>>(
    (ref) => ref.watch(routineRepositoryProvider).watchRoutines());
final routineItemsProvider = StreamProvider<List<RoutineItem>>(
    (ref) => ref.watch(routineRepositoryProvider).watchItems());

/// Outcomes for the adaptive window plus today.
final planRecordsProvider = StreamProvider<List<PlanRecord>>((ref) {
  final since = Days.lastDays(ref.read(clockProvider)(),
          AdaptiveReminders.windowDays + 8)
      .first;
  return ref.watch(routineRepositoryProvider).watchRecordsSince(since);
});

final reminderSettingsProvider = StreamProvider<ReminderSettings>(
    (ref) => ref.watch(reminderSettingsRepositoryProvider).watch());

/// Whether Android currently allows our notifications. Invalidate to recheck.
final notificationsAllowedProvider = FutureProvider<bool>(
    (ref) => ref.watch(reminderSchedulerProvider).notificationsAllowed());

class PlanInputs {
  const PlanInputs(this.routines, this.items, this.records);
  final List<Routine> routines;
  final List<RoutineItem> items;
  final List<PlanRecord> records;
}

final planInputsProvider = Provider<PlanInputs?>((ref) {
  final r = ref.watch(routinesProvider).value;
  final i = ref.watch(routineItemsProvider).value;
  final p = ref.watch(planRecordsProvider).value;
  if (r == null || i == null || p == null) return null;
  return PlanInputs(r, i, p);
});

final todayPlanProvider = Provider<List<PlanEntry>>((ref) {
  final inputs = ref.watch(planInputsProvider);
  if (inputs == null) return const [];
  final now = ref.watch(clockProvider)();
  return PlanEngine.forDay(
    routines: inputs.routines,
    items: inputs.items,
    records: inputs.records,
    dayKey: Days.key(now),
    now: now,
  );
});

final suggestionsProvider = Provider<List<ReminderSuggestion>>((ref) {
  final inputs = ref.watch(planInputsProvider);
  final settings = ref.watch(reminderSettingsProvider).value;
  if (inputs == null || settings == null || !settings.adaptive) return const [];
  return AdaptiveReminders.suggest(
    routines: inputs.routines,
    items: inputs.items,
    records: inputs.records,
    now: ref.watch(clockProvider)(),
    dismissedOn: settings.dismissedOn,
  );
});
