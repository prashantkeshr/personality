import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:personality/data/repositories/profile_repository.dart';
import 'package:personality/data/repositories/routine_repository.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  testWidgets('goal reminders: on, edit, off', (tester) async {
    final app = AppHarness(tester);
    await app.run(
      () => ProfileRepository(app.db).setGoals({GoalType.hydration}),
    );
    await app.start(onboarded);
    GoRouter.of(tester.element(find.byType(Scaffold).first))
        .push('/health/goal-reminders');
    await app.settle();

    // The user's own goal comes first, marked as theirs.
    final cards = find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key as ValueKey<String>).value.startsWith('goal-reminder-') &&
          !(w.key as ValueKey<String>).value.contains('-switch-'),
    );
    expect(tester.widget(cards.first).key, const Key('goal-reminder-water'));
    expect(find.text('Your goal'), findsOneWidget);

    Future<List<int>> times() async {
      final repo = RoutineRepository(app.db);
      final items = await app.run(() => repo.watchItems().first);
      return [for (final i in items!) i.minuteOfDay]..sort();
    }

    await app.tapAndSettle(find.byKey(const Key('goal-reminder-switch-water')));
    expect(await times(), [600, 780, 960, 1140]);
    // Turning a reminder on turns the app's reminders on.
    final settings = await app.run(
      () => ReminderSettingsRepository(app.db).watch().first,
    );
    expect(settings!.enabled, isTrue);

    // Remove 13:00.
    final chip = find.byKey(const Key('goal-reminder-time-water-780'));
    await app.reveal(chip);
    // The delete button is the chip's last icon (after the clock).
    await app.tapAndSettle(
      find.descendant(of: chip, matching: find.byType(Icon)).last,
    );
    expect(await times(), [600, 960, 1140]);

    // Skip Sundays.
    final sunday = find.byKey(const Key('goal-reminder-day-water-7'));
    await app.reveal(sunday);
    await app.tapAndSettle(sunday);
    final routine = await app.run(
      () => RoutineRepository(app.db).watchRoutines().first,
    );
    expect(routine!.single.days.includes(7), isFalse);
    expect(routine.single.name, 'Drink water');

    // Off removes the routine and its reminders.
    final toggle = find.byKey(const Key('goal-reminder-switch-water'));
    await app.reveal(toggle);
    await app.tapAndSettle(toggle);
    expect(await times(), isEmpty);
    await app.dispose();
  });
}
