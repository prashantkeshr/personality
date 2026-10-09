import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:personality/core/notifications/reminder_scheduler.dart';
import 'package:personality/data/repositories/routine_repository.dart';
import 'package:personality/domain/entities/health.dart';
import 'package:personality/domain/entities/routine.dart';
import 'package:personality/domain/services/health_stats.dart';
import 'package:personality/domain/services/plan_engine.dart';
import 'package:personality/features/health/health_providers.dart';
import 'package:personality/features/routines/routine_providers.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

/// Records syncs and lets tests choose the permission answer.
class FakeScheduler extends NoopReminderScheduler {
  FakeScheduler({this.grant = true});
  final bool grant;
  bool allowed = false;
  int syncCount = 0;

  @override
  Future<bool> notificationsAllowed() async => allowed;
  @override
  Future<bool> requestPermission() async => allowed = grant;
  @override
  Future<void> sync(List<ReminderOccurrence> o, ReminderTexts texts) async {
    syncCount++;
    await super.sync(o, texts);
  }
}

/// Formats like the app does (CLDR uses a narrow no-break space before PM).
String hm(int h, [int m = 0]) =>
    DateFormat.jm('en').format(DateTime(2000, 1, 1, h, m));

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);
  // Wednesday 09:00, fixed so plan states are deterministic.
  final now = DateTime(2026, 9, 30, 9);

  Future<AppHarness> start(WidgetTester tester, FakeScheduler scheduler) async {
    final app = AppHarness(tester);
    await app.start(onboarded, overrides: [
      clockProvider.overrideWithValue(() => now),
      reminderSchedulerProvider.overrideWithValue(scheduler),
    ]);
    return app;
  }

  Future<void> openHealthFeature(AppHarness app, String name) async {
    await app.tester.tap(find.text('Health'));
    await app.tester.pumpAndSettle();
    await app.tester.scrollUntilVisible(find.text(name).hitTestable(), 100,
        scrollable: find.byType(Scrollable).last);
    await app.tester.ensureVisible(find.text(name));
    await app.tester.pumpAndSettle();
    await app.tapAndSettle(find.text(name));
  }

  testWidgets('example routine feeds the plan and Home', (tester) async {
    final app = await start(tester, FakeScheduler());
    expect(find.text('No plan for today yet'), findsOneWidget);

    await openHealthFeature(app, 'Routines');
    await app.tapAndSettle(find.text('Start from an example'));
    // Editor for the new routine, with the spec's 11 steps.
    expect(find.text('My daily routine'), findsOneWidget);
    expect(find.text('Posture break'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.textContaining('11 items'), findsOneWidget);

    await app.tapAndSettle(find.text("Today's plan"));
    // Created at 09:00, so today's plan starts with the 10:30 posture break;
    // earlier items are not counted as missed on the day they were created.
    expect(find.text('Completed 0 of 6 planned'), findsOneWidget);
    expect(find.text('Skipped 0 · Missed 0 · Moved 0 · Remaining 6'),
        findsOneWidget);
    expect(find.text('Suggestion'), findsNothing);

    await app.tapAndSettle(find.byTooltip('Done').first);
    expect(find.text('Completed 1 of 6 planned'), findsOneWidget);

    await app.tapAndSettle(find.text('Home'));
    expect(find.text('Next: Lunch — ${hm(13)}'), findsOneWidget);
    expect(find.text('Completed 1 of 6 planned'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('turning reminders on asks permission and syncs the plan',
      (tester) async {
    final scheduler = FakeScheduler();
    final app = AppHarness(tester);
    // Seed before starting: writing while the app's streams are live can
    // deadlock under the test clock.
    await app.run(() async {
      final repo = RoutineRepository(app.db, clock: () => now);
      final id = await repo.createRoutine('Day', Weekdays.everyDay);
      await repo.addItem(id, 10 * 60 + 30, 'Posture break',
          RoutineItemKind.posture);
      await repo.addItem(id, 12 * 60, 'Quiet item', RoutineItemKind.custom,
          reminder: false);
    });
    await app.start(onboarded, overrides: [
      clockProvider.overrideWithValue(() => now),
      reminderSchedulerProvider.overrideWithValue(scheduler),
    ]);

    await openHealthFeature(app, 'Reminders');
    expect(find.text('Off. Your plan is still available in the app.'),
        findsOneWidget);
    expect(scheduler.synced, isEmpty);

    await app.tapAndSettle(find.text('Routine reminders'));
    await tester.pump(const Duration(milliseconds: 500)); // sync debounce
    await app.settle();

    expect(scheduler.allowed, isTrue);
    // One reminder-enabled item × 7 days; the silent item is excluded.
    expect(scheduler.synced, hasLength(7));
    expect(scheduler.synced.first.title, 'Posture break');
    expect(scheduler.synced.first.at, DateTime(2026, 9, 30, 10, 30));
    expect(find.text('Posture break'), findsWidgets); // next reminders list
    await app.dispose();
  });

  testWidgets('denied permission keeps the plan and explains why',
      (tester) async {
    final app = await start(tester, FakeScheduler(grant: false));
    await openHealthFeature(app, 'Reminders');
    await app.tapAndSettle(find.text('Routine reminders'));
    expect(find.textContaining('Notifications are off for this app'),
        findsWidgets);
    await app.dispose();
  });

  testWidgets('a suggestion changes the plan only when accepted',
      (tester) async {
    final app = AppHarness(tester);
    late String itemId;
    await app.run(() async {
      // Created three weeks ago, so there is history to learn from.
      final repo = RoutineRepository(app.db,
          clock: () => now.subtract(const Duration(days: 21)));
      final id = await repo.createRoutine('Day', Weekdays.everyDay);
      itemId = await repo.addItem(
          id, 15 * 60, 'Posture break', RoutineItemKind.posture);
      // Done only on 4 of the last 14 days → usually missed.
      for (var d = 11; d <= 14; d++) {
        await repo.record(itemId, Days.key(now.subtract(Duration(days: d))),
            PlanOutcome.completed);
      }
    });
    await app.start(onboarded, overrides: [
      clockProvider.overrideWithValue(() => now),
    ]);

    expect(find.text('Move it to ${hm(16)}?'), findsOneWidget);
    expect(find.textContaining('missed on 10 of the last 14'), findsOneWidget);

    // Nothing changed yet.
    var items = await app.run(() => RoutineRepository(app.db).watchItems().first);
    expect(items!.single.minuteOfDay, 15 * 60);

    await app.tapAndSettle(find.text('Move to ${hm(16)}'));
    items = await app.run(() => RoutineRepository(app.db).watchItems().first);
    expect(items!.single.minuteOfDay, 16 * 60);
    expect(find.text('Move it to ${hm(16)}?'), findsNothing);
    await app.dispose();
  });

  testWidgets('dismissing keeps the current time', (tester) async {
    final app = AppHarness(tester);
    await app.run(() async {
      final repo = RoutineRepository(app.db,
          clock: () => now.subtract(const Duration(days: 21)));
      final id = await repo.createRoutine('Day', Weekdays.everyDay);
      await repo.addItem(id, 15 * 60, 'Posture break', RoutineItemKind.posture);
    });
    await app.start(onboarded, overrides: [
      clockProvider.overrideWithValue(() => now),
    ]);
    await tester.scrollUntilVisible(
        find.text('Keep current time').hitTestable(), 200,
        scrollable: find.byType(Scrollable).first);
    await app.tapAndSettle(find.text('Keep current time'));
    expect(find.text('Move it to ${hm(16)}?'), findsNothing);
    final s = await app.run(
        () => ReminderSettingsRepository(app.db).watch().first);
    expect(s!.dismissedOn.values.single, Days.key(now));
    await app.dispose();
  });
}
