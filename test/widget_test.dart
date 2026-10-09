import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/features/settings/settings_repository.dart';
import 'package:personality/app/app_shell.dart';
import 'package:personality/data/repositories/body_record_repository.dart';
import 'package:personality/data/repositories/profile_repository.dart';
import 'package:personality/domain/entities/body.dart';

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
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // About you: optional, in the chosen units.
    expect(find.text('About you'), findsOneWidget);
    Future<void> reveal(Finder f) async {
      await tester.scrollUntilVisible(f.hitTestable(), 150,
          scrollable: find.byType(Scrollable).last);
    }

    await tester.enterText(find.byKey(const Key('about-name')), 'Asha Rao');
    await reveal(find.text('South India'));
    await app.tapAndSettle(find.text('South India'));
    await reveal(find.text('Female'));
    await app.tapAndSettle(find.text('Female'));
    await reveal(find.byKey(const Key('about-height-ft')));
    await tester.enterText(find.byKey(const Key('about-height-ft')), '5');
    await tester.enterText(find.byKey(const Key('about-height-in')), '4');
    await reveal(find.byKey(const Key('about-weight')));
    await tester.enterText(find.byKey(const Key('about-weight')), '9999');
    await app.tapAndSettle(find.text('Get started'));
    // An impossible weight is caught instead of saved.
    expect(find.text('Check this value'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5)); // let the message close
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('about-weight')), '130');
    await app.tapAndSettle(find.text('Get started'));

    expect(find.text('Today'), findsOneWidget);
    expect(find.textContaining('Asha'), findsOneWidget);
    final saved = await app.run(() => SettingsRepository(app.db).load());
    expect(saved!.onboardingCompleted, isTrue);
    expect(saved.unitSystem.name, 'imperial');
    final profile = await app.run(() => ProfileRepository(app.db).load());
    expect((profile!.displayName, profile.gender, profile.region),
        ('Asha Rao', Gender.female, Region.indiaSouth));
    expect(profile.effectiveStyleFit, StyleFit.womenswear);
    final heights = await app.run(() => BodyRecordRepository(
            app.db, app.db.heightRecords, unit: 'cm')
        .watchAll()
        .first);
    expect(heights!.single.value, closeTo(162.56, 0.01));
    final weights = await app.run(() => BodyRecordRepository(
            app.db, app.db.weightRecords, unit: 'kg')
        .watchAll()
        .first);
    expect(weights!.single.value, closeTo(58.97, 0.01));
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
    expect(find.byType(FloatingNavBar), findsNothing);
    await app.dispose();
  });
}
