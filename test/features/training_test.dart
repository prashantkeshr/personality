import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:personality/data/repositories/app_kv.dart';
import 'package:personality/domain/services/training_engine.dart';
import 'package:personality/features/health/health_providers.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);
  // A Monday: a training day in every plan.
  final monday = DateTime(2026, 10, 26, 9);

  Future<void> wait(AppHarness app, WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await app.run(() => Future<void>.delayed(const Duration(milliseconds: 30)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
  }

  Future<AppHarness> start(WidgetTester tester) async {
    final app = AppHarness(tester);
    await app.run(() => AppKv(app.db).put(
          'training.prefs',
          const TrainingPrefs(minutes: 10).encode(),
        ));
    await app.start(onboarded, overrides: [clockProvider.overrideWithValue(() => monday)]);
    await wait(app, tester);
    return app;
  }

  testWidgets('Home shows today\'s workout; the plan lists sets and reps', (tester) async {
    final app = await start(tester);
    await app.reveal(find.byKey(const Key('today-workout')));
    expect(find.text("Today's workout"), findsOneWidget);
    expect(find.text('Full body session'), findsOneWidget);

    GoRouter.of(tester.element(find.byType(Scaffold).first)).push('/health/training');
    await wait(app, tester);
    expect(find.text('Beginner · 3 days a week · 10 min'), findsOneWidget);
    expect(find.byKey(const Key('plan-ex-squat')), findsOneWidget);
    expect(find.text('1 × 10 reps'), findsOneWidget); // short session: 1 set
    // Tuesday is a rest day.
    await app.tapAndSettle(find.byKey(const Key('plan-day-2')));
    expect(find.text('Rest day'), findsWidgets);
    await app.dispose();
  });

  testWidgets('finishing a plan session and saying "too easy" steps it up', (tester) async {
    final app = await start(tester);
    GoRouter.of(tester.element(find.byType(Scaffold).first)).push('/health/exercise/programs/plan_1/play');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    for (var i = 0; i < 40 && find.byKey(const Key('workout-skip')).evaluate().isNotEmpty; i++) {
      await tester.tap(find.byKey(const Key('workout-skip')));
      await tester.pump();
    }
    await wait(app, tester);
    expect(find.text('How did that feel?'), findsOneWidget);
    await app.tapAndSettle(find.byKey(const Key('feel-tooEasy')));
    await wait(app, tester);
    expect(find.text('Next time you\'ll get a few more reps.'), findsOneWidget);
    final progress = TrainingProgress.parse(
      await app.run<String?>(() => AppKv(app.db).get('training.progress')),
    );
    expect(progress.stepOf('squat'), 1);
    await app.dispose();
  });
}
