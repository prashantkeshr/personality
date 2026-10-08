import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/services/color_science.dart';
import 'package:personality/domain/services/outfit_engine.dart';
import 'package:personality/domain/services/palette_engine.dart';

WardrobeItem item(String id, GarmentCategory c, String hex,
        {GarmentPattern p = GarmentPattern.solid,
        int f = 3,
        Set<Occasion> occ = const {},
        bool fav = false}) =>
    WardrobeItem(
        id: id,
        name: id,
        category: c,
        colorHex: hex,
        pattern: p,
        formality: f,
        occasions: occ,
        favorite: fav);

void main() {
  group('colour science', () {
    test('hex round-trip and Lab sanity', () {
      expect(Rgb.hex('#1F2A44').hex, '#1F2A44');
      expect(toLab(const Rgb(255, 255, 255)).l, closeTo(100, 0.1));
      expect(toLab(const Rgb(0, 0, 0)).l, closeTo(0, 0.1));
      expect(deltaE(Rgb.hex('#FF0000'), Rgb.hex('#FF0000')), 0);
      expect(deltaE(Rgb.hex('#FF0000'), Rgb.hex('#0000FF')), greaterThan(150));
    });

    test('neutrals are recognised', () {
      for (final h in ['#000000', '#FFFFFF', '#808080', '#1F2A44', '#C8B79E', '#5A4130', '#4A6A8A']) {
        expect(isNeutral(Rgb.hex(h)), isTrue, reason: h);
      }
      for (final h in ['#E53935', '#43A047', '#FDD835', '#8E24AA', '#FF7043']) {
        expect(isNeutral(Rgb.hex(h)), isFalse, reason: h);
      }
    });

    test('harmony classification', () {
      Harmony h(List<String> hex) => harmonyOf([for (final x in hex) Rgb.hex(x)]);
      expect(h(['#000000', '#FFFFFF', '#1F2A44']), Harmony.neutral);
      expect(h(['#1F2A44', '#E53935']), Harmony.monochrome);
      expect(h(['#E53935', '#FF7043']), Harmony.monochrome); // ~11° apart
      expect(h(['#E53935', '#FB8C00']), Harmony.analogous); // ~31° apart
      expect(h(['#1E88E5', '#FB8C00']), Harmony.complementary);
      expect(h(['#E53935', '#43A047', '#8E24AA']), Harmony.clash);
    });
  });

  group('undertone and palette', () {
    test('quiz majority with neutral for mixed signals', () {
      expect(
          UndertoneQuiz.evaluate(VeinAnswer.green, JewelleryAnswer.gold, SunAnswer.tans)
              .undertone,
          Undertone.warm);
      final cool = UndertoneQuiz.evaluate(
          VeinAnswer.blueOrPurple, JewelleryAnswer.silver, SunAnswer.both);
      expect((cool.undertone, cool.agreement), (Undertone.cool, 2));
      expect(
          UndertoneQuiz.evaluate(VeinAnswer.green, JewelleryAnswer.silver, SunAnswer.both)
              .undertone,
          Undertone.neutral);
    });

    test('every palette is valid and fits its own colours', () {
      for (final u in Undertone.values) {
        for (final d in SkinDepth.values) {
          final p = PaletteEngine.palette(u, d);
          expect(p.best, hasLength(6));
          for (final c in p.bestRgb) {
            expect(p.fit(c), 1.0);
          }
        }
      }
      final warm = PaletteEngine.palette(Undertone.warm, SkinDepth.medium);
      expect(warm.fit(Rgb.hex('#FF00FF')), lessThan(0.5)); // magenta: far
    });
  });

  group('outfit engine', () {
    final wardrobe = [
      item('white-shirt', GarmentCategory.top, '#FFFFFF', f: 4),
      item('rust-tee', GarmentCategory.top, '#C8553D', f: 2, fav: true),
      item('check-shirt', GarmentCategory.top, '#3A5A8C', p: GarmentPattern.checks, f: 3),
      item('navy-chinos', GarmentCategory.bottom, '#1F2A44', f: 3),
      item('jeans', GarmentCategory.bottom, '#4A6A8A', f: 2),
      item('stripe-trousers', GarmentCategory.bottom, '#555555', p: GarmentPattern.stripes, f: 3),
      item('loafers', GarmentCategory.footwear, '#5A4130', f: 4),
      item('sneakers', GarmentCategory.footwear, '#FFFFFF', f: 1),
      item('blazer', GarmentCategory.outerwear, '#2F3A4F', f: 5, occ: {Occasion.work, Occasion.formal}),
      item('green-pants', GarmentCategory.bottom, '#43A047', f: 2),
    ];

    test('never pairs two patterns or clashing colours', () {
      final ideas = OutfitEngine.suggest(
          wardrobe: wardrobe, occasion: Occasion.casual, limit: 50);
      expect(ideas, isNotEmpty);
      for (final o in ideas) {
        final patterned = o.items.where((i) => i.pattern != GarmentPattern.solid);
        expect(patterned.length, lessThanOrEqualTo(1), reason: o.key);
        expect(harmonyOf([for (final i in o.items) i.color]),
            isNot(Harmony.clash), reason: o.key);
      }
      // Rust tee with green pants clashes and must not appear.
      expect(ideas.any((o) => o.key.contains('green-pants') && o.key.contains('rust-tee')),
          isFalse);
    });

    test('work suggestions lean formal and explain themselves', () {
      final ideas = OutfitEngine.suggest(wardrobe: wardrobe, occasion: Occasion.work);
      final best = ideas.first;
      expect(best.items.map((i) => i.id), contains('white-shirt'));
      expect(best.reasons, contains(OutfitReason.matchedFormality));
      expect(best.items.any((i) => i.category == GarmentCategory.footwear), isTrue);
    });

    test('occasion filter, palette preference and variety', () {
      final casual = OutfitEngine.suggest(wardrobe: wardrobe, occasion: Occasion.casual, limit: 50);
      expect(casual.any((o) => o.key.contains('blazer')), isFalse);

      final palette = PaletteEngine.palette(Undertone.warm, SkinDepth.medium);
      final warm = OutfitEngine.suggest(
          wardrobe: wardrobe, occasion: Occasion.casual, palette: palette);
      expect(warm.first.items.map((i) => i.id), contains('rust-tee'));
      expect(warm.first.reasons, contains(OutfitReason.inPalette));

      final rested = OutfitEngine.suggest(
          wardrobe: wardrobe,
          occasion: Occasion.casual,
          palette: palette,
          recentlyWorn: {'rust-tee'});
      expect(rested.first.items.map((i) => i.id), isNot(contains('rust-tee')));
      expect(rested.first.reasons, contains(OutfitReason.notWornRecently));
    });

    test('one-pieces work without bottoms; empty wardrobe gives nothing', () {
      final dress = [
        item('dress', GarmentCategory.onePiece, '#8E4585', f: 4),
        item('heels', GarmentCategory.footwear, '#111111', f: 4),
      ];
      final ideas = OutfitEngine.suggest(wardrobe: dress, occasion: Occasion.festive);
      expect(ideas.single.items.map((i) => i.id), ['dress', 'heels']);
      expect(OutfitEngine.suggest(wardrobe: const [], occasion: Occasion.casual), isEmpty);
    });
  });
}
