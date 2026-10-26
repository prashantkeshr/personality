import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/data/repositories/health_repositories.dart';
import 'package:personality/data/repositories/routine_repository.dart';
import 'package:personality/domain/entities/health.dart';
import 'package:personality/domain/entities/routine.dart';
import 'package:personality/features/health/health_providers.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);
  final now = DateTime(2026, 10, 10, 10); // Saturday 10:00

  Future<void> wait(AppHarness app, WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await app.run(() => Future<void>.delayed(const Duration(milliseconds: 30)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
  }

  Future<AppHarness> start(WidgetTester tester) async {
    final app = AppHarness(tester);
    await app.run(() async {
      final created = now.subtract(const Duration(days: 3));
      await HabitRepository(app.db, clock: () => created)
          .add('Read 10 pages', Weekdays.everyDay);
      final routines = RoutineRepository(app.db, clock: () => created);
      final r = await routines.createRoutine('Day', Weekdays.everyDay);
      await routines.addItem(r, 11 * 60, 'Posture check', RoutineItemKind.mobility);
      await routines.addItem(r, 13 * 60, 'Lunch', RoutineItemKind.meal);
      await routines.addItem(r, 16 * 60, 'Walk', RoutineItemKind.mobility);
      await routines.addItem(r, 19 * 60, 'Dinner', RoutineItemKind.meal);
    });
    await app.start(onboarded,
        overrides: [clockProvider.overrideWithValue(() => now)]);
    await wait(app, tester);
    return app;
  }

  testWidgets('swiping a timeline item left skips it', (tester) async {
    final app = await start(tester);
    final habit = find.byWidgetPredicate((w) =>
        w is Dismissible &&
        w.key is ValueKey<String> &&
        (w.key! as ValueKey<String>).value.startsWith('swipe-habit'));
    await app.reveal(habit);
    await tester.drag(habit, const Offset(-500, 0));
    await tester.pumpAndSettle();
    await wait(app, tester);
    final done = await app.run(
        () => HabitRepository(app.db).watchCompletionsSince(20261001).first);
    expect(done!.single.status, HabitStatus.skipped);
    await app.dispose();
  });

  testWidgets('Home search finds exercises and offers the coach', (tester) async {
    final app = await start(tester);
    await app.tapAndSettle(find.byKey(const Key('home-search')));
    expect(find.byKey(const Key('home-search-field')), findsOneWidget);
    await tester.enterText(find.byKey(const Key('home-search-field')), 'squat');
    await wait(app, tester);
    expect(find.text('Ask the coach: "squat"'), findsOneWidget);
    expect(
        find.byWidgetPredicate((w) =>
            w is ListTile &&
            w.key is ValueKey<String> &&
            (w.key! as ValueKey<String>).value.startsWith('search-') &&
            w.key != const Key('search-ask-coach')),
        findsWidgets);
    await app.dispose();
  });
}
