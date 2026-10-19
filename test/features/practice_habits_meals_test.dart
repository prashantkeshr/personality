import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:personality/data/repositories/app_kv.dart';
import 'package:personality/data/repositories/routine_repository.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  test('built-in content: every pose has a motion, every flow its poses', () {
    final motions = (jsonDecode(
      File('assets/content/motions.json').readAsStringSync(),
    ) as Map).keys.toSet();
    final exercises = jsonDecode(
      File('assets/content/exercises.json').readAsStringSync(),
    ) as List;
    final ids = {for (final e in exercises) e['id'] as String};
    for (final e in exercises) {
      expect(motions, contains(e['motion']), reason: e['id'] as String);
    }
    final yoga = [
      for (final e in exercises)
        if (e['discipline'] == 'yoga') e['id'],
    ];
    expect(yoga.length, greaterThanOrEqualTo(15));
    final programs = jsonDecode(
      File('assets/content/programs.json').readAsStringSync(),
    ) as List;
    final flows = programs.where((p) => p['discipline'] == 'yoga').toList();
    expect(flows.map((p) => p['id']), [
      'yoga_sun_flow',
      'yoga_balance',
      'yoga_evening_calm',
    ]);
    for (final p in flows) {
      for (final s in p['steps'] as List) {
        // Built-in, so the flow is never hidden for a missing pack.
        expect(ids, contains(s['exercise']), reason: '${p['id']}');
      }
    }
  });

  Future<void> go(AppHarness app, WidgetTester tester, String path) async {
    GoRouter.of(tester.element(find.byType(Scaffold).first)).push(path);
    await app.settle();
    await app.settle();
  }

  testWidgets('yoga is a skill; add it to my day with a time and length', (
    tester,
  ) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await go(app, tester, '/growth/skills');
    expect(find.text('Yoga & mind-body'), findsOneWidget);
    await go(app, tester, '/growth/skills/yoga');
    expect(find.text('Yoga'), findsWidgets);

    final add = find.byKey(const Key('skill-add-to-day'));
    await app.reveal(add);
    await app.tapAndSettle(add);
    await app.tapAndSettle(find.text('15 min'));
    await app.tapAndSettle(find.byKey(const Key('practice-save')));

    final repo = RoutineRepository(app.db);
    final routines = await app.run(() => repo.watchRoutines().first);
    expect(routines!.single.name, 'My practice');
    final items = await app.run(() => repo.watchItems().first);
    expect(items!.single.title, 'Practise Yoga · 15 min');
    expect(items.single.minuteOfDay, 18 * 60);
    // Chosen skills also feed the Home recommendations.
    final skills = await app.run(() => AppKv(app.db).get('now.skills'));
    expect(skills, 'yoga');
    await app.dispose();
  });

  testWidgets('find your focus offers the new goals', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await go(app, tester, '/home/goals');
    for (final g in [GoalType.strength, GoalType.mindfulness]) {
      final card = find.byKey(Key('goal-${g.name}'));
      await app.reveal(card);
      expect(card, findsOneWidget);
    }
    expect(find.text('Calm & mindfulness'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('habit ideas open the editor filled in, ready to change', (
    tester,
  ) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await go(app, tester, '/health/habits');
    await app.tapAndSettle(find.byKey(const Key('habit-ideas-empty')));
    await app.tapAndSettle(find.byKey(const Key('idea-fruitDaily')));
    final name = find.byKey(const Key('habit-name'));
    expect(tester.widget<TextFormField>(name).controller!.text, 'Eat a fruit');
    await tester.enterText(name, 'Eat two fruits');
    await app.tapAndSettle(find.text('Save'));
    final habits = await app.run(() => app.db.select(app.db.habits).get());
    expect(habits!.single.name, 'Eat two fruits');
    await app.dispose();
  });

  testWidgets('meal ideas and a sample day; log one in a tap', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await go(app, tester, '/health/meals');
    expect(find.byKey(const Key('meal-ideas')), findsOneWidget);
    expect(find.textContaining('Ideas for'), findsOneWidget);
    final log = find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key as ValueKey<String>).value.startsWith('meal-idea-log-'),
    );
    await app.tapAndSettle(log.first);
    final meals = await app.run(() => app.db.select(app.db.meals).get());
    expect(meals!.single.calories, greaterThan(0));
    expect(find.textContaining('Logged:'), findsOneWidget);

    final sample = find.byKey(const Key('sample-day'));
    await tester.ensureVisible(sample);
    await tester.pumpAndSettle();
    expect(find.textContaining('kcal and'), findsOneWidget);
    await app.dispose();
  });
}
