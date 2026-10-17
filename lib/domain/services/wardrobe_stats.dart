import 'color_science.dart';
import 'outfit_engine.dart';

/// How often one garment has been worn (through saved outfits marked worn).
class ItemWear {
  const ItemWear(this.item, this.wears, this.lastWornDay);
  final WardrobeItem item;
  final int wears;

  /// yyyymmdd, or null if never worn.
  final int? lastWornDay;

  /// Price divided by wears; null without a price. Unworn items count as
  /// one wear so the number stays meaningful ("this is what it costs so far").
  double? get costPerWear => item.price == null ? null : item.price! / (wears == 0 ? 1 : wears);
}

/// Something the wardrobe is missing for the way the user dresses.
enum WardrobeGap { bottoms, footwear, workTop, formalWear, festiveEthnic, neutralBasics, sportwear, outerwear }

class WardrobeStats {
  const WardrobeStats({required this.items, required this.gaps, required this.neutralShare});

  /// Every item, most worn first.
  final List<ItemWear> items;
  final List<WardrobeGap> gaps;

  /// Share of tops and bottoms in neutral colours (0–1).
  final double neutralShare;

  List<ItemWear> get mostWorn => items.where((i) => i.wears > 0).take(5).toList();
  List<ItemWear> get neverWorn => items.where((i) => i.wears == 0).toList();
  int get totalWears => items.fold(0, (s, i) => s + i.wears);

  /// Best value: lowest cost per wear among priced, worn items.
  List<ItemWear> get bestValue {
    final priced = items.where((i) => i.item.price != null && i.wears > 0).toList()
      ..sort((a, b) => a.costPerWear!.compareTo(b.costPerWear!));
    return priced.take(3).toList();
  }

  static WardrobeStats compute({
    required List<WardrobeItem> wardrobe,
    required List<({List<String> itemIds, List<int> wornDays})> outfits,
    Set<Occasion> occasions = const {},
    bool ethnicWear = false,
    bool hotClimate = true,
  }) {
    // One wear per item per day, however many outfits contained it.
    final days = <String, Set<int>>{};
    for (final o in outfits) {
      for (final id in o.itemIds) {
        (days[id] ??= <int>{}).addAll(o.wornDays);
      }
    }
    final items = [
      for (final w in wardrobe)
        ItemWear(
          w,
          days[w.id]?.length ?? 0,
          (days[w.id]?.isEmpty ?? true) ? null : days[w.id]!.reduce((a, b) => a > b ? a : b),
        ),
    ]..sort((a, b) => b.wears.compareTo(a.wears));

    bool any(bool Function(WardrobeItem) test) => wardrobe.any(test);
    bool has(GarmentCategory c) => any((w) => w.category == c);
    final gaps = <WardrobeGap>[
      if (wardrobe.isNotEmpty &&
          !has(GarmentCategory.bottom) &&
          !has(GarmentCategory.onePiece) &&
          !has(GarmentCategory.ethnicBottom))
        WardrobeGap.bottoms,
      if (wardrobe.isNotEmpty && !has(GarmentCategory.footwear)) WardrobeGap.footwear,
      if (occasions.contains(Occasion.work) &&
          !any((w) =>
              (w.category == GarmentCategory.top || w.category == GarmentCategory.onePiece) &&
              w.formality >= 3 &&
              w.suits(Occasion.work)))
        WardrobeGap.workTop,
      if (occasions.contains(Occasion.formal) && !any((w) => w.formality >= 4)) WardrobeGap.formalWear,
      if ((ethnicWear || occasions.contains(Occasion.festive)) &&
          !has(GarmentCategory.ethnicTop) &&
          !any((w) => w.suits(Occasion.festive) && w.occasions.isNotEmpty))
        WardrobeGap.festiveEthnic,
      if (occasions.contains(Occasion.sport) &&
          !any((w) => w.occasions.contains(Occasion.sport) || w.formality == 1))
        WardrobeGap.sportwear,
      if (!hotClimate && wardrobe.isNotEmpty && !has(GarmentCategory.outerwear)) WardrobeGap.outerwear,
    ];
    final basics = wardrobe
        .where((w) => const {GarmentCategory.top, GarmentCategory.bottom}.contains(w.category))
        .toList();
    final neutrals = basics.where((w) => isNeutral(w.color)).length;
    final share = basics.isEmpty ? 0.0 : neutrals / basics.length;
    if (basics.length >= 4 && neutrals < 2) gaps.add(WardrobeGap.neutralBasics);
    return WardrobeStats(items: items, gaps: gaps, neutralShare: share);
  }
}
