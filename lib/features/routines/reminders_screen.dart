import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/plan_engine.dart';
import '../../l10n/app_localizations.dart';
import '../health/health_providers.dart';
import 'reminder_sync_host.dart';
import 'routine_providers.dart';

/// Reminder controls (spec §32–33, §83). Reminders come from routine items.
class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  Future<void> _setEnabled(BuildContext context, WidgetRef ref, bool on) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      if (on) {
        // Ask for permission only when the user turns reminders on.
        final scheduler = ref.read(reminderSchedulerProvider);
        final allowed = await scheduler.notificationsAllowed() ||
            await scheduler.requestPermission();
        ref.invalidate(notificationsAllowedProvider);
        if (!allowed) {
          messenger.showSnackBar(SnackBar(content: Text(l10n.notificationsBlocked)));
        }
      }
      await ref.read(reminderSettingsRepositoryProvider).setEnabled(on);
    } catch (e, st) {
      AppLogger.error('reminders.toggle', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(reminderSettingsProvider).value;
    final allowed = ref.watch(notificationsAllowedProvider).value;
    final inputs = ref.watch(planInputsProvider);
    final now = ref.watch(clockProvider)();
    final tag = Localizations.localeOf(context).toLanguageTag();

    final upcoming = inputs == null
        ? const <ReminderOccurrence>[]
        : ReminderPlanner.upcoming(
            routines: inputs.routines,
            items: inputs.items,
            records: inputs.records,
            now: now,
            days: 2,
          );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.featureReminders)),
      body: settings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: Text(l10n.remindersEnable),
                  subtitle: Text(settings.enabled
                      ? (allowed == false
                          ? l10n.notificationsBlocked
                          : l10n.remindersOnNote)
                      : l10n.remindersOffNote),
                  value: settings.enabled,
                  onChanged: (on) => _setEnabled(context, ref, on),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.lightbulb_outline),
                  title: Text(l10n.remindersAdaptive),
                  subtitle: Text(l10n.remindersAdaptiveNote),
                  value: settings.adaptive,
                  onChanged: (on) => ref
                      .read(reminderSettingsRepositoryProvider)
                      .setAdaptive(on),
                ),
                _QuietHoursTile(quiet: settings.quietHours),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(l10n.remindersTimingNote,
                      style: theme.textTheme.bodySmall),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text(l10n.remindersNext,
                      style: theme.textTheme.labelLarge),
                ),
                if (upcoming.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(l10n.remindersNoneUpcoming),
                  ),
                for (final o in upcoming)
                  ListTile(
                    leading: Icon(routineKindIcon(o.kind)),
                    title: Text(o.title),
                    subtitle: Text(
                        '${DateFormat.MMMEd(tag).format(o.at)} · ${DateFormat.jm(tag).format(o.at)}'),
                  ),
              ],
            ),
    );
  }
}

/// Quiet hours: on/off, then start and end times.
class _QuietHoursTile extends ConsumerWidget {
  const _QuietHoursTile({required this.quiet});
  final QuietHours? quiet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.read(reminderSettingsRepositoryProvider);
    Future<int?> pick(int minute) async {
      final t = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: minute ~/ 60, minute: minute % 60));
      return t == null ? null : t.hour * 60 + t.minute;
    }

    final q = quiet;
    return Column(children: [
      SwitchListTile(
        key: const Key('quiet-hours'),
        secondary: const Icon(Icons.do_not_disturb_on_outlined),
        title: Text(l10n.remindersQuiet),
        subtitle: Text(q == null
            ? l10n.remindersQuietOff
            : l10n.remindersQuietInfo(
                formatMinute(context, q.start), formatMinute(context, q.end))),
        value: q != null,
        onChanged: (on) =>
            repo.setQuietHours(on ? const QuietHours(22 * 60, 7 * 60) : null),
      ),
      if (q != null)
        Padding(
          padding: const EdgeInsets.only(left: 72, right: AppSpacing.lg),
          child: Row(children: [
            OutlinedButton(
              onPressed: () async {
                final m = await pick(q.start);
                if (m != null && m != q.end) {
                  await repo.setQuietHours(QuietHours(m, q.end));
                }
              },
              child: Text(formatMinute(context, q.start)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Icon(Icons.arrow_forward, size: 18),
            ),
            OutlinedButton(
              onPressed: () async {
                final m = await pick(q.end);
                if (m != null && m != q.start) {
                  await repo.setQuietHours(QuietHours(q.start, m));
                }
              },
              child: Text(formatMinute(context, q.end)),
            ),
          ]),
        ),
    ]);
  }
}
