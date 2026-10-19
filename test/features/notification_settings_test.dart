import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:personality/core/notifications/notification_style.dart';
import 'package:personality/core/notifications/reminder_scheduler.dart';
import 'package:personality/data/repositories/app_kv.dart';
import 'package:personality/features/routines/routine_providers.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/features/settings/settings_repository.dart';

import '../helpers/app_harness.dart';

class _Scheduler extends NoopReminderScheduler {
  @override
  Future<bool> notificationsAllowed() async => true;
}

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  test('style survives a round trip; each sound gets its own channel', () {
    const style = NotificationStyle(
      sound: ReminderSound.zenBowl,
      vibration: VibrationLevel.strong,
      popUp: false,
      hideOnLockScreen: true,
      snoozeMinutes: 15,
    );
    expect(NotificationStyle.parse(style.encode()), style);
    expect(NotificationStyle.parse('not json'), const NotificationStyle());
    // Pulse is the app's default sound.
    expect(NotificationStyle.parse(null).sound, ReminderSound.pulse);
    expect(const NotificationStyle().channelId, 'reminders_pulse_standard_pop');
    expect(style.sound.resource, 'snd_zen_bowl');
    expect(
      style.channelId,
      isNot(style.copyWith(sound: ReminderSound.bell).channelId),
    );
    // Lock-screen privacy is per notification, so it keeps the channel.
    expect(style.channelId, style.copyWith(hideOnLockScreen: false).channelId);
  });

  Future<void> go(AppHarness app, WidgetTester tester, String path) async {
    GoRouter.of(tester.element(find.byType(Scaffold).first)).push(path);
    await app.settle();
    await app.settle();
  }

  testWidgets('choose a sound, vibration and snooze, then send a test', (
    tester,
  ) async {
    final scheduler = _Scheduler();
    final app = AppHarness(tester);
    await app.start(
      onboarded,
      overrides: [reminderSchedulerProvider.overrideWithValue(scheduler)],
    );
    await go(app, tester, '/settings/notifications');
    expect(find.text('Notifications & sounds'), findsOneWidget);

    await app.tapAndSettle(find.text('Singing bowl'));
    await app.tapAndSettle(find.text('Strong'));
    final popUp = find.byKey(const Key('notif-popup'));
    await tester.ensureVisible(popUp);
    await app.tapAndSettle(popUp);
    final snooze = find.text('15 min');
    await tester.ensureVisible(snooze);
    await app.tapAndSettle(snooze);

    final raw = await app.run(() => AppKv(app.db).get('notif.style'));
    final saved = NotificationStyle.parse(raw);
    expect(saved.sound, ReminderSound.zenBowl);
    expect(saved.vibration, VibrationLevel.strong);
    expect(saved.popUp, isFalse);
    expect(saved.snoozeMinutes, 15);

    final test = find.byKey(const Key('notif-test'));
    await tester.scrollUntilVisible(
      test.hitTestable(),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    await app.tapAndSettle(test);
    expect(scheduler.tested, saved);
    expect(find.text('Test notification sent'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('accent colour, text size and reduced motion apply app-wide', (
    tester,
  ) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await go(app, tester, '/settings');
    await app.tapAndSettle(find.byKey(const Key('accent-rose')));
    final large = find.text('Large');
    await tester.ensureVisible(large);
    await app.tapAndSettle(large);
    final motion = find.byKey(const Key('reduce-motion'));
    await tester.ensureVisible(motion);
    await app.tapAndSettle(motion);

    final settings = await app.run(() => SettingsRepository(app.db).load());
    expect(settings!.accent, 'rose');
    expect(settings.textScale, 1.15);
    expect(settings.reduceMotion, isTrue);

    final context = tester.element(find.byType(Scaffold).last);
    expect(MediaQuery.textScalerOf(context).scale(100), closeTo(115, 0.01));
    expect(MediaQuery.disableAnimationsOf(context), isTrue);
    // The colour scheme is built from the rose seed now.
    final primary = Theme.of(context).colorScheme.primary;
    expect(primary.r, greaterThan(primary.b));
    await app.dispose();
  });
}
