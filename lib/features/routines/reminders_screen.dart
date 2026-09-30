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
