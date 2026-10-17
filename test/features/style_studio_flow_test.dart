import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/data/repositories/style_repository.dart';
import 'package:personality/domain/services/outfit_engine.dart';
import 'package:personality/features/health/health_providers.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/shared/visual/outfit_silhouette.dart';

import '../helpers/app_harness.dart';

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);
  final now = DateTime(2026, 10, 17, 9);
  const today = 20261017;

  Future<String> seedOutfit(AppHarness app, {bool plan = false}) async {
    return (await app.run(() async {
      final repo = StyleRepository(app.db, clock: () => now);
      final shirt = await repo.addItem(
          name: 'White shirt', category: GarmentCategory.top, colorHex: '#FFFFFF', formality: 4);
      final trousers = await repo.addItem(
          name: 'Grey trousers', category: GarmentCategory.bottom, colorHex: '#555555', formality: 4);
      final id = await repo.saveOutfit(Occasion.work, [shirt, trousers]);
      if (plan) await repo.planOutfit(today, id, Occasion.work);
      return id;
    }))!;
  }

  Future<void> openStyle(AppHarness app, WidgetTester tester, String feature) async {
    await app.tapAndSettle(find.text('Style'));
    await tester.scrollUntilVisible(find.text(feature).hitTestable(), 200, scrollable: find.byType(Scrollable).first);
    await app.tapAndSettle(find.text(feature));
  }

  testWidgets('Style DNA: pick fits, traditions and coverage, then save', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await openStyle(app, tester, 'Style DNA');
    expect(find.text('Your Style DNA'), findsOneWidget);
    for (final key in ['dna-fit-FitPreference.tailored', 'dna-cultural-CulturalWear.indianEthnic', 'dna-occasion-Occasion.work']) {
      await tester.scrollUntilVisible(find.byKey(Key(key)).hitTestable(), 200, scrollable: find.byType(Scrollable).first);
      await app.tapAndSettle(find.byKey(Key(key)));
    }
    await tester.scrollUntilVisible(find.text('Fully covered').hitTestable(), 200, scrollable: find.byType(Scrollable).first);
    await app.tapAndSettle(find.text('Fully covered'));
    await app.tapAndSettle(find.byKey(const Key('dna-save')));
    expect(find.text('Style DNA saved'), findsOneWidget);
    final p = await app.run(() => StyleRepository(app.db).watchProfile().first);
    expect(p!.fits, {FitPreference.tailored});
    expect(p.cultural, {CulturalWear.indianEthnic});
    expect(p.occasions, {Occasion.work});
    expect(p.modesty, Modesty.covered);
    await app.dispose();
  });

  testWidgets('Get ready: the planned outfit leads the checklist and ticks are kept', (tester) async {
    final app = AppHarness(tester);
    await seedOutfit(app, plan: true);
    await app.start(onboarded, overrides: [clockProvider.overrideWithValue(() => now)]);
    await openStyle(app, tester, 'Get ready for…');
    await app.tapAndSettle(find.byKey(const Key('ready-interview')));
    expect(find.text('Wear the outfit you planned for today'), findsOneWidget);
    expect(find.byType(OutfitSilhouette), findsOneWidget);
    await tester.scrollUntilVisible(find.byKey(const Key('ready-item-press')).hitTestable(), 200,
        scrollable: find.byType(Scrollable).first);
    await app.tapAndSettle(find.byKey(const Key('ready-item-press')));
    await tester.scrollUntilVisible(find.text('Know your three key points by heart').hitTestable(), 200,
        scrollable: find.byType(Scrollable).first);

    // Leave and come back: the event and tick are remembered for today.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await app.tapAndSettle(find.text('Get ready for…'));
    await app.run(() => Future<void>.delayed(const Duration(milliseconds: 50)));
    await tester.pumpAndSettle();
    expect(find.textContaining('1 of '), findsOneWidget);
    await app.dispose();
  });

  testWidgets('Outfit calendar: plan today, then mark it worn', (tester) async {
    final app = AppHarness(tester);
    final outfit = await seedOutfit(app);
    await app.start(onboarded, overrides: [clockProvider.overrideWithValue(() => now)]);
    await openStyle(app, tester, 'Outfit calendar');
    await app.tapAndSettle(find.byKey(const Key('plan-$today')));
    await app.tapAndSettle(find.byKey(Key('pick-$outfit')));
    expect(find.text('Work'), findsWidgets);
    await app.tapAndSettle(find.byKey(const Key('wore-$today:work')));
    expect(find.text('Worn'), findsOneWidget);
    final outfits = await app.run(() => StyleRepository(app.db).watchOutfits().first);
    expect(outfits!.single.wornDays, [today]);
    await app.dispose();
  });

  testWidgets('Glasses finder: frames with honest fit notes and live try-on', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await openStyle(app, tester, 'Glasses finder');
    expect(find.text('Analyse your face shape for personal fits'), findsOneWidget);
    await app.tapAndSettle(find.byKey(const Key('frame-aviator_gold')));
    expect(find.text('Aviator, gold'), findsWidgets);
    expect(find.textContaining('Analyse your face to see'), findsOneWidget);
    expect(find.byKey(const Key('glasses-try-on')), findsOneWidget);
    await app.dispose();
  });

  testWidgets('Wardrobe stats: gaps, unworn items and a price', (tester) async {
    final app = AppHarness(tester);
    await app.run(() async {
      final repo = StyleRepository(app.db, clock: () => now);
      await repo.setDna(fits: const {}, cultural: const {}, occasions: {Occasion.work});
      await repo.addItem(name: 'Red tee', category: GarmentCategory.top, colorHex: '#C0392B', formality: 1);
    });
    await app.start(onboarded, overrides: [clockProvider.overrideWithValue(() => now)]);
    await openStyle(app, tester, 'Wardrobe stats');
    expect(find.byKey(const Key('gap-footwear')), findsOneWidget);
    expect(find.byKey(const Key('gap-workTop')), findsOneWidget);
    expect(find.text('Not worn yet'), findsOneWidget);
    await app.tapAndSettle(find.text('Add price'));
    await tester.enterText(find.byKey(const Key('price-field')), '999');
    await app.tapAndSettle(find.text('Save'));
    expect(find.textContaining('999'), findsOneWidget);
    final items = await app.run(() => StyleRepository(app.db).watchWardrobe().first);
    expect(items!.single.price, 999);
    await app.dispose();
  });
}
