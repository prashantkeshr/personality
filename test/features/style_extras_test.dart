import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:personality/data/repositories/face_repository.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  Future<void> go(AppHarness app, WidgetTester tester, String path) async {
    GoRouter.of(tester.element(find.byType(Scaffold).first)).push(path);
    await app.settle();
    await app.settle();
  }

  testWidgets('the Style tab offers the lookbook, makeup, trends and Q&A', (
    tester,
  ) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await app.tapAndSettle(find.text('Style'));
    for (final name in ['My lookbook', 'Makeup guide', 'Style trends', 'Ask about style']) {
      final f = find.text(name);
      await app.reveal(f);
      expect(f, findsWidgets, reason: name);
    }
    await app.dispose();
  });

  testWidgets('the lookbook gathers saved hairstyles and makeup shades', (
    tester,
  ) async {
    final app = AppHarness(tester);
    await app.run(() async {
      final repo = FaceRepository(app.db);
      await repo.setFavorite('curtain_bangs', true);
      await repo.setFavorite('makeup:berry', true);
    });
    await app.start(onboarded);
    await go(app, tester, '/style/lookbook');
    expect(find.byKey(const Key('look-curtain_bangs')), findsOneWidget);
    expect(find.text('Curtain bangs'), findsOneWidget);
    expect(find.byKey(const Key('look-shade-berry')), findsOneWidget);

    // Removing a style takes it out of the lookbook.
    await app.tapAndSettle(find.descendant(
      of: find.byKey(const Key('look-curtain_bangs')),
      matching: find.byIcon(Icons.favorite),
    ));
    await app.settle();
    expect(find.byKey(const Key('look-curtain_bangs')), findsNothing);
    await app.dispose();
  });

  testWidgets('an empty lookbook explains how to fill it', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await go(app, tester, '/style/lookbook');
    expect(find.textContaining('Nothing saved yet'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('style Q&A filters by search and topic, offline', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await go(app, tester, '/style/ask');
    await tester.enterText(find.byKey(const Key('qa-search')), 'frizz');
    await app.settle();
    expect(find.text('How do I control frizz?'), findsOneWidget);
    expect(find.text('How should glasses fit?'), findsNothing);
    await app.tapAndSettle(find.text('How do I control frizz?'));
    expect(find.textContaining('leave-in'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('qa-search')), '');
    await app.tapAndSettle(find.byKey(const Key('qa-topic-glasses')));
    expect(find.text('How should glasses fit?'), findsOneWidget);
    expect(find.text('How do I control frizz?'), findsNothing);
    await app.dispose();
  });

  testWidgets('trends list hair, makeup and colours from the built-in set', (
    tester,
  ) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await go(app, tester, '/style/trends');
    expect(find.text('Autumn–winter 2026'), findsOneWidget);
    expect(find.byKey(const Key('trend-curtain_bangs')), findsOneWidget);
    final colour = find.byKey(const Key('trend-burgundy'));
    await app.reveal(colour);
    expect(colour, findsOneWidget);
    await app.dispose();
  });

  testWidgets('makeup guide shows placement, shades and basics', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await go(app, tester, '/analyze/face/makeup');
    expect(find.text('Makeup guide'), findsWidgets);
    expect(find.text('Find your face shape'), findsOneWidget);
    expect(find.text('Placement for oval faces'), findsOneWidget);
    final berry = find.byKey(const Key('shade-berry'));
    await app.reveal(berry);
    expect(berry, findsOneWidget); // all shades while the undertone is unknown
    await app.reveal(find.text('Basics'));
    expect(find.textContaining('Patch-test'), findsOneWidget);
    await app.dispose();
  });
}
