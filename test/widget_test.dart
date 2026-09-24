import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/features/settings/settings_repository.dart';

import 'helpers/app_harness.dart';

void main() {
  testWidgets('first launch goes through onboarding to Home', (tester) async {
    final app = AppHarness(tester);
    await app.start(const AppSettings());

    expect(find.text('A private space for your wellbeing'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Your data stays on this device'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await app.tapAndSettle(find.text('Imperial (ft/in, lb, oz)'));
    await app.tapAndSettle(find.text('Get started'));

    expect(find.text('Today'), findsOneWidget);
    final saved = await app.run(() => SettingsRepository(app.db).load());
    expect(saved!.onboardingCompleted, isTrue);
    expect(saved.unitSystem.name, 'imperial');
    await app.dispose();
  });

  testWidgets('returning user lands on Home and can switch tabs',
      (tester) async {
    final app = AppHarness(tester);
    await app.start(const AppSettings(onboardingCompleted: true));

    expect(find.text('Today'), findsOneWidget);
    await tester.tap(find.text('Analyze'));
    await tester.pumpAndSettle();
    expect(find.text('Posture analysis'), findsOneWidget);
    // Camera features are not implemented yet, so nothing pretends to work.
    expect(find.text('Coming soon'), findsWidgets);
    expect(find.text('Available'), findsNothing);
    await app.dispose();
  });

  testWidgets('Hindi locale is applied', (tester) async {
    final app = AppHarness(tester);
    await app.start(
        const AppSettings(onboardingCompleted: true, localeCode: 'hi'));
    expect(find.text('आज'), findsOneWidget);
    expect(find.text('स्वास्थ्य'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('tablet width uses a navigation rail', (tester) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final app = AppHarness(tester);
    await app.start(const AppSettings(onboardingCompleted: true));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    await app.dispose();
  });
}
