import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/data/repositories/style_repository.dart';
import 'package:personality/domain/services/outfit_engine.dart';
import 'package:personality/domain/services/palette_engine.dart';
import 'package:personality/features/health/health_providers.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 3200);
  tester.view.devicePixelRatio = 2.5;
  addTearDown(tester.view.reset);
}

Future<void> waitFor(AppHarness app, Finder f) async {
  for (var i = 0; i < 80 && f.evaluate().isEmpty; i++) {
    await app.run(() => Future<void>.delayed(const Duration(milliseconds: 30)));
    await app.tester.pump(const Duration(milliseconds: 100));
  }
  expect(f, findsWidgets);
}

/// Scrolls [f] to the middle of its scroll view (clear of sheet handles
/// and app bars), then taps it.
Future<void> tapVisible(WidgetTester tester, Finder f) async {
  await Scrollable.ensureVisible(tester.element(f.first), alignment: 0.5);
  await tester.pump();
  await tester.tap(f.first);
}

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  test('repository: profile, wardrobe, outfits, wear log, cascade', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final repo = StyleRepository(db, clock: () => DateTime(2026, 10, 8, 9));
    expect((await repo.watchProfile().first).hasPalette, isFalse);
    await repo.setPalette(Undertone.warm, SkinDepth.medium);
    await repo.setStyles({StylePreference.classic, StylePreference.traditional});
    final p = await repo.watchProfile().first;
    expect((p.undertone, p.depth), (Undertone.warm, SkinDepth.medium));
    expect(p.styles, {StylePreference.classic, StylePreference.traditional});

    expect(repo.addItem(name: ' ', category: GarmentCategory.top, colorHex: '#FFFFFF'),
        throwsArgumentError);
    expect(repo.addItem(name: 'x', category: GarmentCategory.top, colorHex: 'blue'),
        throwsArgumentError);
    final shirt = await repo.addItem(
        name: 'Shirt', category: GarmentCategory.top, colorHex: '#ffffff',
        occasions: {Occasion.work});
    final chinos = await repo.addItem(
        name: 'Chinos', category: GarmentCategory.bottom, colorHex: '#1F2A44');
    final items = await repo.watchWardrobe().first;
    expect(items.map((i) => i.colorHex), containsAll(['#FFFFFF', '#1F2A44']));
    expect(items.firstWhere((i) => i.id == shirt).occasions, {Occasion.work});

    final outfit = await repo.saveOutfit(Occasion.work, [shirt, chinos]);
    await repo.markWorn(outfit);
    expect(await repo.recentlyWornItems(), {shirt, chinos});
    expect((await repo.watchOutfits().first).single.wornDays, [20261008]);

    // Deleting a piece removes outfits that would be left incomplete.
    await repo.deleteItem(chinos);
    expect(await repo.watchOutfits().first, isEmpty);
    await db.close();
  });

  testWidgets('colour quiz produces a palette and style chips',
      (tester) async {
    usePhoneScreen(tester);
    final app = AppHarness(tester);
    await app.start(onboarded);
    await tester.tap(find.text('Style'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Style recommendations'));
    await waitFor(app, find.textContaining('veins on your inner wrist'));

    await tester.tap(find.text('Greenish'));
    await tester.pump(const Duration(milliseconds: 600));
    await waitFor(app, find.text('Gold'));
    await tester.tap(find.text('Gold'));
    await tester.pump(const Duration(milliseconds: 600));
    await waitFor(app, find.text('Tans easily'));
    await tester.tap(find.text('Tans easily'));
    await tester.pump(const Duration(milliseconds: 600));
    await waitFor(app, find.text('Medium'));
    await tester.tap(find.text('Medium'));
    await tester.pump();
    await tapVisible(tester, find.text('See my palette'));
    await waitFor(app, find.text('Best colours'));
    expect(find.text('Warm undertone · Medium'), findsOneWidget);
    expect(find.text('Try colours on live'), findsOneWidget);

    await tapVisible(tester, find.text('Traditional / ethnic'));
    await app.settle();
    final profile = await app.run(() => StyleRepository(app.db).watchProfile().first);
    expect(profile!.styles, {StylePreference.traditional});
    await app.dispose();
  });

  testWidgets('wardrobe to saved outfit to worn', (tester) async {
    usePhoneScreen(tester);
    final app = AppHarness(tester);
    await app.run(() async {
      final repo = StyleRepository(app.db);
      await repo.addItem(name: 'White shirt', category: GarmentCategory.top,
          colorHex: '#FFFFFF', formality: 4);
      await repo.addItem(name: 'Navy chinos', category: GarmentCategory.bottom,
          colorHex: '#1F2A44', formality: 3);
    });
    await app.start(onboarded, overrides: [
      clockProvider.overrideWithValue(() => DateTime(2026, 10, 8, 9)),
    ]);
    await tester.tap(find.text('Style'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wardrobe'));
    await waitFor(app, find.text('White shirt'));

    // Add shoes through the sheet.
    await tester.tap(find.text('Add clothing'));
    await tester.pumpAndSettle(); // let the sheet finish opening
    await tester.enterText(find.byKey(const Key('garment-name')), 'Brown loafers');
    await tapVisible(tester, find.text('Footwear'));
    await tester.pump();
    await tapVisible(tester, find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('garment-name')), findsNothing); // sheet closed
    await waitFor(app, find.text('Brown loafers'));

    await tester.tap(find.text('Outfit ideas'));
    await waitFor(app, find.text('Why this?'));
    expect(find.textContaining('Every piece suits the occasion'), findsWidgets);
    await tapVisible(tester, find.text('Save outfit').first);
    await app.settle();

    await tester.tap(find.textContaining('Saved ·'));
    await waitFor(app, find.text('Wore it today'));
    await tapVisible(tester, find.text('Wore it today'));
    await app.settle();
    final worn = await app.run(() => StyleRepository(app.db).watchOutfits().first);
    expect(worn!.single.wornDays, [20261008]);
    await waitFor(app, find.textContaining('Worn once'));
    await app.dispose();
  });
}
