import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/notifications/reminder_scheduler.dart';
import '../../domain/entities/routine.dart';
import '../../domain/services/plan_engine.dart';
import '../../l10n/app_localizations.dart';
import '../health/health_providers.dart';
import 'routine_providers.dart';

/// Keeps scheduled notifications equal to the plan and handles responses.
///
/// Sits below MaterialApp so it can localize notification text. Syncs when
/// the plan or settings change and whenever the app resumes, which also
/// extends the rolling reminder window.
class ReminderSyncHost extends ConsumerStatefulWidget {
  const ReminderSyncHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ReminderSyncHost> createState() => _ReminderSyncHostState();
}

class _ReminderSyncHostState extends ConsumerState<ReminderSyncHost> {
  Timer? _debounce;
  StreamSubscription<ReminderResponse>? _responses;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _responses = reminderResponses.stream.listen(_handle);
    _lifecycle = AppLifecycleListener(onResume: () {
      ref.invalidate(notificationsAllowedProvider);
      _schedule();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final launch =
          await ref.read(reminderSchedulerProvider).launchResponse();
      if (launch != null) _handle(launch);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _responses?.cancel();
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _handle(ReminderResponse r) async {
    try {
      if (r.action == ReminderScheduler.actionDone) {
        await ref
            .read(routineRepositoryProvider)
            .record(r.itemId, r.dayKey, PlanOutcome.completed);
      }
    } catch (e, st) {
      AppLogger.error('reminder.response', e, st);
    }
    ref.read(routerProvider).go(AppRoutes.plan);
  }

  void _schedule() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _sync);
  }

  Future<void> _sync() async {
    if (!mounted) return;
    final scheduler = ref.read(reminderSchedulerProvider);
    final settings = ref.read(reminderSettingsProvider).value;
    final inputs = ref.read(planInputsProvider);
    if (settings == null || inputs == null) return;
    try {
      if (!settings.enabled) {
        await scheduler.cancelAll();
        return;
      }
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final tag = Localizations.localeOf(context).toLanguageTag();
      final occurrences = ReminderPlanner.upcoming(
        routines: inputs.routines,
        items: inputs.items,
        records: inputs.records,
        now: ref.read(clockProvider)(),
      );
      await scheduler.sync(
        occurrences,
        ReminderTexts(
          channelName: l10n.remindersChannelName,
          channelDescription: l10n.remindersChannelDescription,
          actionDone: l10n.reminderActionDone,
          actionSnooze: l10n.reminderActionSnooze,
          body: (o) => l10n.reminderBody(DateFormat.jm(tag).format(o.at)),
        ),
      );
    } catch (e, st) {
      AppLogger.error('reminder.sync', e, st);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(planInputsProvider, (_, _) => _schedule());
    ref.listen(reminderSettingsProvider, (_, _) => _schedule());
    return widget.child;
  }
}

/// "07:30" style in the user's locale.
String formatMinute(BuildContext context, int minute) {
  final tag = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.jm(tag).format(DateTime(2000, 1, 1, minute ~/ 60, minute % 60));
}

IconData routineKindIcon(RoutineItemKind k) => switch (k) {
      RoutineItemKind.wake => Icons.wb_twilight,
      RoutineItemKind.water => Icons.water_drop_outlined,
      RoutineItemKind.meal => Icons.restaurant_outlined,
      RoutineItemKind.exercise => Icons.fitness_center,
      RoutineItemKind.mobility => Icons.self_improvement,
      RoutineItemKind.posture => Icons.accessibility_new,
      RoutineItemKind.habit => Icons.check_circle_outline,
      RoutineItemKind.grooming => Icons.face_retouching_natural,
      RoutineItemKind.windDown => Icons.nights_stay_outlined,
      RoutineItemKind.sleep => Icons.bedtime_outlined,
      RoutineItemKind.custom => Icons.event_note_outlined,
    };

String routineKindLabel(AppLocalizations l10n, RoutineItemKind k) =>
    switch (k) {
      RoutineItemKind.wake => l10n.kindWake,
      RoutineItemKind.water => l10n.featureWater,
      RoutineItemKind.meal => l10n.kindMeal,
      RoutineItemKind.exercise => l10n.featureExercise,
      RoutineItemKind.mobility => l10n.exMobility,
      RoutineItemKind.posture => l10n.exPosture,
      RoutineItemKind.habit => l10n.habitName,
      RoutineItemKind.grooming => l10n.goalGrooming,
      RoutineItemKind.windDown => l10n.kindWindDown,
      RoutineItemKind.sleep => l10n.featureSleep,
      RoutineItemKind.custom => l10n.kindCustom,
    };

String templateStepTitle(AppLocalizations l10n, TemplateStep s) => switch (s) {
      TemplateStep.wake => l10n.kindWake,
      TemplateStep.water => l10n.featureWater,
      TemplateStep.mobility => l10n.exMobility,
      TemplateStep.grooming => l10n.goalGrooming,
      TemplateStep.breakfast => l10n.mealBreakfast,
      TemplateStep.postureBreak => l10n.templatePostureBreak,
      TemplateStep.lunch => l10n.mealLunch,
      TemplateStep.exercise => l10n.featureExercise,
      TemplateStep.windDown => l10n.kindWindDown,
      TemplateStep.sleep => l10n.featureSleep,
    };
