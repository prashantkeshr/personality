import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/notifications/notification_style.dart';
import '../../core/notifications/reminder_scheduler.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../routines/routine_providers.dart';
import '../permissions/app_permissions.dart' show appKvProvider;

const _styleKey = 'notif.style';

/// The reminder style from Settings (a device preference, backed up with the
/// rest of app_settings).
final notificationStyleProvider = StreamProvider<NotificationStyle>(
  (ref) => ref
      .watch(appKvProvider)
      .watchPrefix(_styleKey)
      .map((m) => NotificationStyle.parse(m[_styleKey])),
);

Future<void> saveNotificationStyle(WidgetRef ref, NotificationStyle style) =>
    ref.read(appKvProvider).put(_styleKey, style.encode());

/// Plays a sound once as a preview. Best-effort: silent where unsupported.
Future<void> previewSound(ReminderSound sound) async {
  try {
    await const MethodChannel('personality/device').invokeMethod('playSound', {
      'name': switch (sound) {
        ReminderSound.system => 'system',
        ReminderSound.silent => 'silent',
        _ => sound.resource,
      },
    });
  } on MissingPluginException {
    // Tests and unsupported platforms.
  } catch (e, st) {
    AppLogger.error('sound.preview', e, st);
  }
}

String soundLabel(AppLocalizations l, ReminderSound s) => switch (s) {
  ReminderSound.system => l.soundSystem,
  ReminderSound.silent => l.soundSilent,
  ReminderSound.chime => l.soundChime,
  ReminderSound.bell => l.soundBell,
  ReminderSound.marimba => l.soundMarimba,
  ReminderSound.kalimba => l.soundKalimba,
  ReminderSound.zenBowl => l.soundZenBowl,
  ReminderSound.droplet => l.soundDroplet,
  ReminderSound.pop => l.soundPop,
  ReminderSound.rise => l.soundRise,
  ReminderSound.harp => l.soundHarp,
  ReminderSound.sparkle => l.soundSparkle,
  ReminderSound.pulse => l.soundPulse,
  ReminderSound.birdsong => l.soundBirdsong,
};

IconData _soundIcon(ReminderSound s) => switch (s) {
  ReminderSound.system => Icons.phone_android,
  ReminderSound.silent => Icons.notifications_off_outlined,
  ReminderSound.chime ||
  ReminderSound.bell => Icons.notifications_active_outlined,
  ReminderSound.marimba ||
  ReminderSound.kalimba ||
  ReminderSound.harp => Icons.music_note_outlined,
  ReminderSound.zenBowl => Icons.self_improvement,
  ReminderSound.droplet => Icons.water_drop_outlined,
  ReminderSound.pop => Icons.bubble_chart_outlined,
  ReminderSound.rise => Icons.trending_up,
  ReminderSound.sparkle => Icons.auto_awesome_outlined,
  ReminderSound.pulse => Icons.graphic_eq,
  ReminderSound.birdsong => Icons.flutter_dash,
};

String _vibrationLabel(AppLocalizations l, VibrationLevel v) => switch (v) {
  VibrationLevel.off => l.vibrationOff,
  VibrationLevel.gentle => l.vibrationGentle,
  VibrationLevel.standard => l.vibrationStandard,
  VibrationLevel.strong => l.vibrationStrong,
};

/// Settings → Notifications & sounds.
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  Future<void> _set(
    BuildContext context,
    WidgetRef ref,
    NotificationStyle style,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = AppLocalizations.of(context).settingsSaveError;
    try {
      await saveNotificationStyle(ref, style);
    } catch (e, st) {
      AppLogger.error('notif.save', e, st);
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _test(
    BuildContext context,
    WidgetRef ref,
    NotificationStyle style,
  ) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final scheduler = ref.read(reminderSchedulerProvider);
    try {
      final allowed =
          await scheduler.notificationsAllowed() ||
          await scheduler.requestPermission();
      ref.invalidate(notificationsAllowedProvider);
      if (!allowed) {
        messenger.showSnackBar(SnackBar(content: Text(l.notificationsBlocked)));
        return;
      }
      await scheduler.showTest(
        l.notifTestTitle,
        l.notifTestBody(soundLabel(l, style.sound)),
        ReminderTexts(
          channelName: l.remindersChannelName,
          channelDescription: l.remindersChannelDescription,
          actionDone: l.reminderActionDone,
          actionSnooze: l.reminderActionSnoozeFor(style.snoozeMinutes),
          body: (_) => '',
          style: style,
        ),
      );
      messenger.showSnackBar(SnackBar(content: Text(l.notifTestSent)));
    } catch (e, st) {
      AppLogger.error('notif.test', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l.recordSaveError)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final style =
        ref.watch(notificationStyleProvider).value ?? const NotificationStyle();

    Widget header(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Semantics(
        header: true,
        child: Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.notifSettingsTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              0,
            ),
            child: FilledButton.tonalIcon(
              key: const Key('notif-test'),
              onPressed: () => _test(context, ref, style),
              icon: const Icon(Icons.notifications_active_outlined),
              label: Text(l.notifTest),
            ),
          ),
          header(l.notifSound),
          RadioGroup<ReminderSound>(
            groupValue: style.sound,
            onChanged: (s) {
              if (s == null) return;
              previewSound(s);
              _set(context, ref, style.copyWith(sound: s));
            },
            child: Column(
              children: [
                for (final s in ReminderSound.values)
                  RadioListTile<ReminderSound>(
                    key: Key('sound-${s.name}'),
                    value: s,
                    title: Text(soundLabel(l, s)),
                    secondary: s == ReminderSound.silent
                        ? Icon(_soundIcon(s))
                        : IconButton(
                            key: Key('sound-play-${s.name}'),
                            tooltip: l.soundPreview,
                            onPressed: () => previewSound(s),
                            icon: Icon(_soundIcon(s)),
                          ),
                  ),
              ],
            ),
          ),
          header(l.notifVibration),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: SegmentedButton<VibrationLevel>(
              key: const Key('notif-vibration'),
              segments: [
                for (final v in VibrationLevel.values)
                  ButtonSegment(value: v, label: Text(_vibrationLabel(l, v))),
              ],
              selected: {style.vibration},
              showSelectedIcon: false,
              onSelectionChanged: (s) {
                HapticFeedback.mediumImpact();
                _set(context, ref, style.copyWith(vibration: s.single));
              },
            ),
          ),
          header(l.notifBehaviour),
          SwitchListTile(
            key: const Key('notif-popup'),
            secondary: const Icon(Icons.open_in_new),
            title: Text(l.notifPopUp),
            subtitle: Text(l.notifPopUpInfo),
            value: style.popUp,
            onChanged: (v) => _set(context, ref, style.copyWith(popUp: v)),
          ),
          SwitchListTile(
            key: const Key('notif-hide'),
            secondary: const Icon(Icons.lock_outline),
            title: Text(l.notifHideLock),
            subtitle: Text(l.notifHideLockInfo),
            value: style.hideOnLockScreen,
            onChanged: (v) =>
                _set(context, ref, style.copyWith(hideOnLockScreen: v)),
          ),
          header(l.notifSnooze),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: SegmentedButton<int>(
              key: const Key('notif-snooze'),
              segments: [
                for (final m in NotificationStyle.snoozeChoices)
                  ButtonSegment(value: m, label: Text(l.bodyPlanMinutes(m))),
              ],
              selected: {style.snoozeMinutes},
              showSelectedIcon: false,
              onSelectionChanged: (s) =>
                  _set(context, ref, style.copyWith(snoozeMinutes: s.single)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            key: const Key('notif-schedule'),
            leading: const Icon(Icons.bedtime_outlined),
            title: Text(l.notifSchedule),
            subtitle: Text(l.notifScheduleInfo),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.reminders),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              l.notifPhoneNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
