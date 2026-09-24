import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/app/personality_app.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/core/providers.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/features/settings/settings_repository.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> pumpApp(WidgetTester tester, AppSettings settings) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        initialSettingsProvider.overrideWithValue(settings),
      ],
      child: const PersonalityApp(),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('first launch goes through onboarding to Home', (tester) async {
    await pumpApp(tester, const AppSettings());

    expect(find.text('A private space for your wellbeing'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Your data stays on this device'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Imperial (ft/in, lb, oz)'));
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await tester.tap(find.text('Get started'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);

    final saved = await tester.runAsync(() => SettingsRepository(db).load());
    expect(saved!.onboardingCompleted, isTrue);
    expect(saved.unitSystem.name, 'imperial');
  });

  testWidgets('returning user lands on Home and can switch tabs',
      (tester) async {
    await pumpApp(tester, const AppSettings(onboardingCompleted: true));

    expect(find.text('Today'), findsOneWidget);
    await tester.tap(find.text('Analyze'));
    await tester.pumpAndSettle();
    expect(find.text('Posture analysis'), findsOneWidget);
    // Nothing is implemented yet, so nothing pretends to work.
    expect(find.text('Coming soon'), findsWidgets);
    expect(find.text('Available'), findsNothing);
  });

  testWidgets('Hindi locale is applied', (tester) async {
    await pumpApp(
        tester, const AppSettings(onboardingCompleted: true, localeCode: 'hi'));
    expect(find.text('आज'), findsOneWidget);
    expect(find.text('स्वास्थ्य'), findsOneWidget);
  });

  testWidgets('tablet width uses a navigation rail', (tester) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpApp(tester, const AppSettings(onboardingCompleted: true));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
