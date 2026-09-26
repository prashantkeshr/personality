import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/data/repositories/health_repositories.dart';
import 'package:personality/domain/entities/health.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  Future<void> openHealthFeature(AppHarness app, String name) async {
    await app.tester.tap(find.text('Health'));
    await app.tester.pumpAndSettle();
    await app.tester.scrollUntilVisible(find.text(name), 100,
        scrollable: find.byType(Scrollable).last);
    await app.tapAndSettle(find.text(name));
  }

  testWidgets('Home shows today tiles with default targets', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    expect(find.text('0 ml / 2.0 L'), findsOneWidget);
    expect(find.text('0 / 8,000'), findsOneWidget);
    expect(find.text('None today'), findsOneWidget);
    expect(find.text('None logged'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('water quick add updates the screen and Home', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await openHealthFeature(app, 'Water');

    expect(find.text('No water logged today.'), findsOneWidget);
    await app.tapAndSettle(find.text('250 ml'));
    await app.tapAndSettle(find.text('500 ml'));
    expect(find.text('750 ml'), findsWidgets);

    // Custom amounts are validated instead of silently ignored.
    await tester.tap(find.text('Custom amount'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('water-custom')), '9000');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(find.text('This value is outside the supported range.'),
        findsOneWidget);
    await tester.enterText(find.byKey(const Key('water-custom')), '1250');
    await app.tapAndSettle(find.text('Add'));
    expect(find.text('2.0 L'), findsWidgets);

    await app.tapAndSettle(find.text('Home'));
    expect(find.text('2.0 L / 2.0 L'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('habits: add, complete and see neutral counts', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await openHealthFeature(app, 'Habits');

    await tester.tap(find.text('Add habit'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('habit-name')), 'Stretch');
    await app.tapAndSettle(find.text('Save'));

    expect(find.text('You completed 0 of 1 habits today.'), findsOneWidget);
    await app.tapAndSettle(find.byType(Checkbox));
    expect(find.text('You completed 1 of 1 habits today.'), findsOneWidget);
    expect(find.textContaining('1 of 1 this week'), findsOneWidget);

    await app.tapAndSettle(find.text('Home'));
    expect(find.text('1 / 1'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('meal logging without calories', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await openHealthFeature(app, 'Meals');

    await tester.tap(find.text('Log meal'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a value'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('meal-food')), 'Poha');
    await app.tapAndSettle(find.text('Save'));
    expect(find.text('Poha'), findsOneWidget);

    await app.tapAndSettle(find.text('Home'));
    expect(find.text('1 meal'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('targets can be changed and drive progress', (tester) async {
    final app = AppHarness(tester);
    await app.run(() => TargetsRepository(app.db)
        .save(const DailyTargets(waterMl: 3000)));
    await app.start(onboarded);
    expect(find.text('0 ml / 3.0 L'), findsOneWidget);

    await openHealthFeature(app, 'Sleep');
    await tester.tap(find.byTooltip('Daily targets'));
    await tester.pumpAndSettle();
    expect(find.textContaining('not medical recommendations'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('target-sleep')), '1');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('This value is outside the supported range.'),
        findsOneWidget);
    await tester.enterText(find.byKey(const Key('target-sleep')), '7.5');
    await app.tapAndSettle(find.text('Save'));
    expect(find.text('Target: 7h 30m'), findsOneWidget);
    await app.dispose();
  });
}
