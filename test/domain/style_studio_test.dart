import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/data/repositories/style_repository.dart';
import 'package:personality/domain/services/face_engine.dart';
import 'package:personality/domain/services/get_ready.dart';
import 'package:personality/domain/services/glasses_fit.dart';
import 'package:personality/domain/services/outfit_engine.dart';
import 'package:personality/domain/services/wardrobe_stats.dart';
import 'package:personality/shared/visual/style_art.dart';

WardrobeItem w(String id, GarmentCategory c, String hex,
        {int formality = 3, Set<Occasion> occasions = const {}, double? price}) =>
    WardrobeItem(id: id, name: id, category: c, colorHex: hex, formality: formality, occasions: occasions, price: price);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('wardrobe stats', () {
    final shirt = w('shirt', GarmentCategory.top, '#FFFFFF', price: 1200);
    final jeans = w('jeans', GarmentCategory.bottom, '#2C3E66', price: 2000);
    final red = w('red', GarmentCategory.top, '#C0392B');

    test('one wear per item per day, cost per wear, never worn', () {
      final s = WardrobeStats.compute(wardrobe: [shirt, jeans, red], outfits: [
        (itemIds: ['shirt', 'jeans'], wornDays: [20261001, 20261005]),
        (itemIds: ['shirt'], wornDays: [20261005, 20261009]), // same day as above counts once
      ]);
      final byId = {for (final i in s.items) i.item.id: i};
      expect(byId['shirt']!.wears, 3);
      expect(byId['shirt']!.lastWornDay, 20261009);
      expect(byId['shirt']!.costPerWear, 400);
      expect(byId['jeans']!.costPerWear, 1000);
      expect(s.items.first.item.id, 'shirt'); // most worn first
      expect(s.neverWorn.map((i) => i.item.id), ['red']);
      expect(s.bestValue.first.item.id, 'shirt');
      expect(s.totalWears, 5);
    });

    test('gaps follow the Style DNA and climate', () {
      final s = WardrobeStats.compute(
        // Casual pieces only: a formality-2 top doesn't count as work wear.
        wardrobe: [w('polo', GarmentCategory.top, '#C0392B', formality: 2), w('tee', GarmentCategory.top, '#27AE60', formality: 1)],
        outfits: const [],
        occasions: {Occasion.work, Occasion.formal, Occasion.sport},
        ethnicWear: true,
        hotClimate: false,
      );
      expect(s.gaps, containsAll([
        WardrobeGap.bottoms,
        WardrobeGap.footwear,
        WardrobeGap.workTop,
        WardrobeGap.formalWear,
        WardrobeGap.festiveEthnic,
        WardrobeGap.outerwear,
      ]));
      expect(s.gaps, isNot(contains(WardrobeGap.sportwear))); // the tee counts
      // An empty wardrobe isn't told it lacks shoes.
      expect(WardrobeStats.compute(wardrobe: const [], outfits: const []).gaps, isEmpty);
    });
  });

  group('get ready', () {
    test('a planned outfit wins; interviews get presentation and document checks', () {
      final planned = [w('blazer', GarmentCategory.outerwear, '#1F2A44'), w('shirt', GarmentCategory.top, '#FFFFFF')];
      final list = GetReady.checklist(
          ReadyEvent.interview,
          ReadyContext(plannedToday: planned, menswear: true, hairStyleId: 'side_part', beardStyleId: 'stubble'));
      final ids = list.map((i) => i.id).toList();
      expect(list.first.id, 'planned');
      expect(list.first.outfit, planned);
      expect(ids, containsAll(['press', 'shoes', 'hair_style', 'beard_style', 'posture', 'breath', 'voice', 'three_points', 'documents', 'early']));
      expect(list.firstWhere((i) => i.id == 'hair_style').styleId, 'side_part');
      expect(ids, isNot(contains('sunscreen')));
    });

    test('Style DNA shapes the outfit lines; gym is kept simple', () {
      const dna = StyleProfile(cultural: {CulturalWear.indianEthnic}, modesty: Modesty.covered, fits: {FitPreference.tailored});
      final wedding = GetReady.checklist(ReadyEvent.wedding, const ReadyContext(profile: dna, womenswear: true));
      final ids = wedding.map((i) => i.id).toList();
      expect(ids.first, 'guide_ethnic'); // empty wardrobe: traditional guidance
      expect(ids, containsAll(['modest', 'fit_tailored', 'gift', 'sunscreen']));
      expect(ids, isNot(contains('beard_tidy'))); // womenswear
      final gym = GetReady.checklist(ReadyEvent.gym, const ReadyContext());
      expect(gym.map((i) => i.id), containsAll(['guide_gym', 'gym_hair', 'gym_kit', 'water']));
      expect(gym.map((i) => i.id), isNot(contains('press')));
    });

    test('suggests from the wardrobe when nothing is planned', () {
      final list = GetReady.checklist(
          ReadyEvent.office,
          ReadyContext(wardrobe: [
            w('shirt', GarmentCategory.top, '#FFFFFF', occasions: {Occasion.work}),
            w('trousers', GarmentCategory.bottom, '#333333', occasions: {Occasion.work}),
          ]));
      expect(list.first.id, 'suggested');
      expect(list.first.outfit!.map((i) => i.id), containsAll(['shirt', 'trousers']));
    });
  });

  group('glasses', () {
    final frames = [
      for (final f in jsonDecode(File('assets/content/glasses.json').readAsStringSync()) as List)
        GlassesFrame.fromJson(f as Map<String, dynamic>),
    ];

    test('twenty frames, every shape drawable, bilingual names', () {
      expect(frames.length, 20);
      expect(frames.map((f) => f.id).toSet().length, 20);
      for (final f in frames) {
        expect(GlassesStyle.values.asNameMap(), contains(f.shape), reason: f.id);
        expect(f.name.keys, containsAll(['en', 'hi']));
        expect(RegExp(r'^#[0-9A-F]{6}$').hasMatch(f.colorHex), isTrue, reason: f.id);
        expect(glassesStyleFor('frame:${f.shape}'), GlassesStyle.values.byName(f.shape));
      }
    });

    test('contrast rules: angles for round faces, curves for square ones', () {
      GlassesFrame shape(String s) => frames.firstWhere((f) => f.shape == s);
      expect(GlassesFit.fit(shape('rectangular'), FaceShape.round).$1, FrameFit.great);
      expect(GlassesFit.fit(shape('round'), FaceShape.round), (FrameFit.lessBalancing, FitReason.echoesShape));
      expect(GlassesFit.fit(shape('round'), FaceShape.square), (FrameFit.great, FitReason.softensAngles));
      expect(GlassesFit.fit(shape('round'), null), (FrameFit.good, FitReason.unknownShape));
      final ranked = GlassesFit.ranked(frames, FaceShape.round);
      expect(GlassesFit.fit(ranked.first, FaceShape.round).$1, FrameFit.great);
      expect(GlassesFit.fit(ranked.last, FaceShape.round).$1, FrameFit.lessBalancing);
      // Every face shape has several great frames to choose from.
      for (final s in FaceShape.values) {
        expect(frames.where((f) => GlassesFit.fit(f, s).$1 == FrameFit.great).length, greaterThanOrEqualTo(4),
            reason: s.name);
      }
    });
  });

  test('repository: Style DNA, prices and outfit plans', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final repo = StyleRepository(db, clock: () => DateTime(2026, 10, 17, 9));
    await repo.setDna(
        fits: {FitPreference.slim},
        budget: BudgetLevel.value,
        modesty: Modesty.moderate,
        cultural: {CulturalWear.indianEthnic, CulturalWear.fusion},
        occasions: {Occasion.work, Occasion.festive});
    await repo.setStyles({StylePreference.traditional});
    final p = await repo.watchProfile().first;
    expect(p.fits, {FitPreference.slim});
    expect(p.budget, BudgetLevel.value);
    expect(p.modesty, Modesty.moderate);
    expect(p.cultural, {CulturalWear.indianEthnic, CulturalWear.fusion});
    expect(p.occasions, {Occasion.work, Occasion.festive});
    expect(p.completeness, closeTo(6 / 7, 1e-9)); // palette not set

    final a = await repo.addItem(name: 'Kurta', category: GarmentCategory.ethnicTop, colorHex: '#E8B04A', price: 1500);
    final b = await repo.addItem(name: 'Churidar', category: GarmentCategory.ethnicBottom, colorHex: '#F5F0E6');
    await repo.setPrice(b, 800);
    final items = await repo.watchWardrobe().first;
    expect({for (final i in items) i.name: i.price}, {'Kurta': 1500, 'Churidar': 800});

    final outfit = await repo.saveOutfit(Occasion.festive, [a, b]);
    await repo.planOutfit(20261020, outfit, Occasion.festive, note: '  Diwali  ');
    await repo.planOutfit(20261020, outfit, Occasion.festive); // same day + occasion: replaced
    var plans = await repo.watchPlans(20261015, 20261025).first;
    expect(plans.single.day, 20261020);
    expect(plans.single.note, isNull);
    await repo.markWornOn(outfit, 20261020);
    expect((await repo.watchOutfits().first).single.wornDays, [20261020]);
    // Deleting the outfit removes its plans.
    await repo.deleteOutfit(outfit);
    plans = await repo.watchPlans(20261015, 20261025).first;
    expect(plans, isEmpty);
    await db.close();
  });
}
