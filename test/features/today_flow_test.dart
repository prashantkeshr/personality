import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/data/repositories/body_record_repository.dart';
import 'package:personality/data/repositories/health_repositories.dart';
import 'package:personality/data/repositories/routine_repository.dart';
import 'package:personality/data/repositories/wellbeing_repository.dart';
import 'package:personality/domain/entities/health.dart';
import 'package:personality/domain/entities/routine.dart';
import 'package:personality/domain/services/day_agenda.dart';
import 'package:personality/features/health/health_providers.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);
  final now = DateTime(2026, 10, 10, 10); // Saturday 10:00

  Future<AppHarness> start(WidgetTester tester) async {
    final app = AppHarness(tester);
    await app.run(() async {
      await HabitRepository(app.db, clock: () => now.subtract(const Duration(days: 3)))
          .add('Read 10 pages', Weekdays.everyDay);
      final routines =
          RoutineRepository(app.db, clock: () => now.subtract(const Duration(days: 3)));
      final r = await routines.createRoutine('Day', Weekdays.everyDay);
      await routines.addItem(r, 7 * 60, 'Morning stretch', RoutineItemKind.mobility);
      await routines.addItem(r, 13 * 60, 'Lunch', RoutineItemKind.meal);
    });
    await app.start(onboarded, overrides: [clockProvider.overrideWithValue(() => now)]);
    return app;
  }

  testWidgets('check-in, low-energy day, timeline ticks and quick add',
      (tester) async {
    final app = await start(tester);
    expect(find.text('Daily plan'), findsOneWidget);
    expect(find.text('How are you feeling?'), findsOneWidget);

    // Low energy suggests a gentler day.
    await app.tapAndSettle(find.byKey(const Key('mood-3')));
    await app.tapAndSettle(find.byKey(const Key('energy-1')));
    expect(find.textContaining('Make it a low-energy day?'), findsOneWidget);
    await app.tapAndSettle(find.text('Switch'));
    final mode = await app.run(
        () => WellbeingRepository(app.db, clock: () => now).watchTodayMode().first);
    expect(mode, DayMode.lowEnergy);

    // The 7:00 stretch was missed; it can be moved or let go.
    await app.reveal(find.text('Morning stretch'));
    expect(find.textContaining('Missed'), findsOneWidget);
    await app.reveal(find.text('Skip today'));
    await app.tapAndSettle(find.text('Skip today'));
    expect(find.text('Skip today'), findsNothing);

    // Tick the habit from the timeline.
    final habitButton = find.byWidgetPredicate((w) =>
        w.key is ValueKey<String> &&
        (w.key! as ValueKey<String>).value.startsWith('task-habit:'));
    await app.reveal(habitButton);
    await app.tapAndSettle(habitButton);
    final done = await app.run(() => HabitRepository(app.db)
        .watchCompletionsSince(20261001)
        .first);
    expect(done!.single.status, HabitStatus.completed);

    // Quick add water from the + button.
    await tester.pump(const Duration(seconds: 5)); // messages close
    await tester.pumpAndSettle();
    await app.tapAndSettle(find.byKey(const Key('quick-add')));
    await app.tapAndSettle(find.byKey(const Key('quick-water-250')));
    final water = await app.run(
        () => BodyRecordRepository(app.db, app.db.waterLogs, unit: 'ml').watchAll().first);
    expect(water!.single.value, 250);
    await app.dispose();
  });

  testWidgets('busy day moves extras aside; past days are read-only',
      (tester) async {
    final app = await start(tester);
    await app.reveal(find.text('Busy'));
    await app.tapAndSettle(find.text('Busy'));
    expect(find.text('Essentials only, with a 5-minute workout.'), findsOneWidget);
    await app.reveal(find.text('1 optional today'));
    expect(find.text('1 optional today'), findsOneWidget); // the stretch

    await tester.scrollUntilVisible(find.byKey(const Key('day-20261009')).hitTestable(), -250,
        scrollable: find.byType(Scrollable).first);
    await app.tapAndSettle(find.byKey(const Key('day-20261009')));
    expect(find.textContaining('Looking back at'), findsOneWidget);
    expect(find.text('How are you feeling?'), findsNothing);
    await app.dispose();
  });

  testWidgets('quiet hours keep night reminders away', (tester) async {
    final app = await start(tester);
    await app.tapAndSettle(find.text('Health'));
    await tester.scrollUntilVisible(find.text('Reminders').hitTestable(), 100,
        scrollable: find.byType(Scrollable).last);
    await app.tapAndSettle(find.text('Reminders'));
    await app.tapAndSettle(find.byKey(const Key('quiet-hours')));
    final s = await app.run(
        () => ReminderSettingsRepository(app.db).watch().first);
    expect((s!.quietHours!.start, s.quietHours!.end), (22 * 60, 7 * 60));
    expect(find.textContaining('No reminders from'), findsOneWidget);
    await app.dispose();
  });
}
