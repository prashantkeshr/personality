import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/routine.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/plan_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/empty_state.dart';
import '../health/health_providers.dart';
import '../health/widgets/health_widgets.dart';
import 'reminder_sync_host.dart';
import 'routine_providers.dart';

/// Plan vs actual for today (spec §34). Adherence only — health performance
/// lives on the Health screens.
class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entries = ref.watch(todayPlanProvider);
    final summary = PlanSummary.of(entries);
    final suggestions = ref.watch(suggestionsProvider);
    final inputs = ref.watch(planInputsProvider);
    final now = ref.watch(clockProvider)();
    final format = HealthFormat.of(
        context, ref.watch(settingsControllerProvider).unitSystem);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.planTitle),
        actions: [
          IconButton(
            tooltip: l10n.featureRoutines,
            icon: const Icon(Icons.edit_calendar_outlined),
            onPressed: () => context.push(AppRoutes.routines),
          ),
        ],
      ),
      body: inputs == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                const ReminderStatusBanner(),
                for (final s in suggestions) ...[
                  SuggestionCard(suggestion: s),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (entries.isEmpty)
                  EmptyState(
                    icon: Icons.today_outlined,
                    title: l10n.planTitle,
                    message: l10n.planEmpty,
                    action: FilledButton(
                      onPressed: () => context.push(AppRoutes.routines),
                      child: Text(l10n.featureRoutines),
                    ),
                  )
                else ...[
                  Text(l10n.planSummary(summary.completed, summary.scheduled),
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.planBreakdown(summary.skipped, summary.missed,
                        summary.rescheduled, summary.open),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (final e in entries) _PlanTile(entry: e),
                  const SizedBox(height: AppSpacing.xl),
                  Text(l10n.planWeekAdherence,
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.sm),
                  () {
                    final week = Days.lastDays(now, 7);
                    final history = PlanEngine.history(
                      routines: inputs.routines,
                      items: inputs.items,
                      records: inputs.records,
                      dayKeys: week,
                      now: now,
                    );
                    return WeekBarChart(
                      dayKeys: week,
                      values: {
                        for (final e in history.entries)
                          e.key: e.value.scheduled == 0
                              ? 0
                              : 100 * e.value.completed / e.value.scheduled,
                      },
                      format: format,
                      target: 100,
                      semanticLabel: l10n.weekChartLabel(l10n.planTitle),
                    );
                  }(),
                  const SizedBox(height: AppSpacing.sm),
                  Text(l10n.planAdherenceNote,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
    );
  }
}

enum _PlanAction { done, skip, reschedule, undo }

class _PlanTile extends ConsumerWidget {
  const _PlanTile({required this.entry});

  final PlanEntry entry;

  Future<void> _act(BuildContext context, WidgetRef ref, _PlanAction a) async {
    final repo = ref.read(routineRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final error = AppLocalizations.of(context).recordSaveError;
    try {
      switch (a) {
        case _PlanAction.done:
          await repo.record(entry.item.id, entry.dayKey, PlanOutcome.completed);
        case _PlanAction.skip:
          await repo.record(entry.item.id, entry.dayKey, PlanOutcome.skipped);
        case _PlanAction.undo:
          await repo.record(entry.item.id, entry.dayKey, null);
        case _PlanAction.reschedule:
          final t = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
                hour: (entry.minute ~/ 60 + 1) % 24, minute: entry.minute % 60),
          );
          if (t == null) return;
          await repo.record(entry.item.id, entry.dayKey, PlanOutcome.rescheduled,
              rescheduledMinute: t.hour * 60 + t.minute);
      }
    } catch (e, st) {
      AppLogger.error('plan.action', e, st);
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final stateLabel = switch (entry.state) {
      PlanItemState.upcoming => l10n.planUpcoming,
      PlanItemState.due => l10n.planDue,
      PlanItemState.completed => l10n.planDone,
      PlanItemState.skipped => l10n.planSkipped,
      PlanItemState.missed => l10n.planMissed,
    };
    final time = formatMinute(context, entry.minute);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(routineKindIcon(entry.item.kind),
            color: entry.state == PlanItemState.due
                ? theme.colorScheme.primary
                : null),
        title: Text(entry.item.title,
            style: entry.state == PlanItemState.skipped
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null),
        subtitle: Text([
          time,
          stateLabel,
          if (entry.wasRescheduled)
            l10n.planMovedFrom(formatMinute(context, entry.item.minuteOfDay)),
        ].join(' · ')),
        trailing: entry.isOpen
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: l10n.reminderActionDone,
                    icon: const Icon(Icons.check_circle_outline),
                    onPressed: () => _act(context, ref, _PlanAction.done),
                  ),
                  PopupMenuButton<_PlanAction>(
                    onSelected: (a) => _act(context, ref, a),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                          value: _PlanAction.skip, child: Text(l10n.habitSkip)),
                      PopupMenuItem(
                          value: _PlanAction.reschedule,
                          child: Text(l10n.planReschedule)),
                    ],
                  ),
                ],
              )
            : TextButton(
                onPressed: () => _act(context, ref, _PlanAction.undo),
                child: Text(l10n.habitUndo),
              ),
      ),
    );
  }
}

/// "You often miss the 15:00 posture break. Move it to 16:00?" — the plan
/// only changes if the user taps Move (spec §33).
class SuggestionCard extends ConsumerWidget {
  const SuggestionCard({super.key, required this.suggestion});

  final ReminderSuggestion suggestion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final s = suggestion;
    final from = formatMinute(context, s.fromMinute);
    final to = formatMinute(context, s.toMinute);
    final reason = switch (s.basis) {
      SuggestionBasis.missed => l10n.suggestionMissed(
          s.item.title, from, s.occurrences, s.scheduledDays),
      SuggestionBasis.lateCompletion => l10n.suggestionLate(
          s.item.title, from, s.occurrences, s.scheduledDays),
      SuggestionBasis.rescheduled =>
        l10n.suggestionRescheduled(s.item.title, from, s.occurrences),
    };

    Future<void> run(Future<void> Function() action) async {
      final messenger = ScaffoldMessenger.of(context);
      try {
        await action();
      } catch (e, st) {
        AppLogger.error('suggestion.action', e, st);
        messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.lightbulb_outline,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(l10n.suggestionTitle,
                  style: Theme.of(context).textTheme.labelLarge),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Text(reason),
            const SizedBox(height: AppSpacing.xs),
            Text(l10n.suggestionQuestion(to),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                FilledButton(
                  onPressed: () => run(() => ref
                      .read(routineRepositoryProvider)
                      .updateItem(s.item.id,
                          minute: s.toMinute,
                          title: s.item.title,
                          kind: s.item.kind,
                          reminder: s.item.reminder)),
                  child: Text(l10n.suggestionAccept(to)),
                ),
                TextButton(
                  onPressed: () => run(() => ref
                      .read(reminderSettingsRepositoryProvider)
                      .dismissSuggestion(
                          s.item.id, Days.key(ref.read(clockProvider)()))),
                  child: Text(l10n.suggestionDismiss),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Explains, without blocking anything, when reminders cannot be delivered.
class ReminderStatusBanner extends ConsumerWidget {
  const ReminderStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(reminderSettingsProvider).value;
    final allowed = ref.watch(notificationsAllowedProvider).value;
    if (settings == null || !settings.enabled || allowed != false) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.notifications_off_outlined),
          title: Text(l10n.notificationsBlocked),
          trailing: TextButton(
            onPressed: () => context.push(AppRoutes.reminders),
            child: Text(l10n.featureReminders),
          ),
        ),
      ),
    );
  }
}
