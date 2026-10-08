/// Personal colour palette from undertone and depth (spec §23).
///
/// The undertone comes from a short guided quiz (vein colour, jewellery,
/// sun response); depth is chosen by the user. Palettes are curated
/// colour-theory sets, offered as suggestions — any colour can be worn.
library;

import 'color_science.dart';

enum Undertone { warm, cool, neutral }

enum SkinDepth { light, medium, deep }

enum VeinAnswer { blueOrPurple, green, both }

enum JewelleryAnswer { silver, gold, both }

enum SunAnswer { burns, tans, both }

class UndertoneResult {
  const UndertoneResult(this.undertone, this.agreement);

  final Undertone undertone;

  /// How many of the three answers point the same way (1–3).
  final int agreement;
}

abstract final class UndertoneQuiz {
  static UndertoneResult evaluate(
      VeinAnswer vein, JewelleryAnswer jewellery, SunAnswer sun) {
    final votes = <Undertone>[
      switch (vein) {
        VeinAnswer.blueOrPurple => Undertone.cool,
        VeinAnswer.green => Undertone.warm,
        VeinAnswer.both => Undertone.neutral,
      },
      switch (jewellery) {
        JewelleryAnswer.silver => Undertone.cool,
        JewelleryAnswer.gold => Undertone.warm,
        JewelleryAnswer.both => Undertone.neutral,
      },
      switch (sun) {
        SunAnswer.burns => Undertone.cool,
        SunAnswer.tans => Undertone.warm,
        SunAnswer.both => Undertone.neutral,
      },
    ];
    final counts = {
      for (final u in Undertone.values) u: votes.where((v) => v == u).length,
    };
    final warm = counts[Undertone.warm]!, cool = counts[Undertone.cool]!;
    // Mixed warm and cool signals mean neutral rather than a coin toss.
    final Undertone result = warm > cool
        ? (warm >= 2 ? Undertone.warm : Undertone.neutral)
        : cool > warm
            ? (cool >= 2 ? Undertone.cool : Undertone.neutral)
            : Undertone.neutral;
    return UndertoneResult(result, counts[result]!.clamp(1, 3));
  }
}

class Palette {
  const Palette({
    required this.best,
    required this.neutrals,
    required this.sparingly,
  });

  /// Colours that tend to flatter.
  final List<String> best;

  /// Base colours for trousers, outerwear and shoes.
  final List<String> neutrals;

  /// Colours to use away from the face or in small amounts.
  final List<String> sparingly;

  List<Rgb> get bestRgb => [for (final h in best) Rgb.hex(h)];
  List<Rgb> get allWearable => [
        for (final h in [...best, ...neutrals]) Rgb.hex(h),
      ];

  /// 0–1: how close [c] is to the palette (1 = on palette).
  double fit(Rgb c) {
    var best = double.infinity;
    for (final p in allWearable) {
      final d = deltaE(c, p);
      if (d < best) best = d;
    }
    return (1 - best / 40).clamp(0.0, 1.0);
  }
}

abstract final class PaletteEngine {
  static Palette palette(Undertone u, SkinDepth d) {
    final contrastNeutrals = switch (d) {
      SkinDepth.light => ['#2F3A4F', '#8A8D91', '#E8E2D6', '#6B5B4B'],
      SkinDepth.medium => ['#1F2A44', '#5B5F66', '#D9CBB3', '#5A4130'],
      SkinDepth.deep => ['#111111', '#F5F2EA', '#2C3E66', '#C8A97E'],
    };
    return switch (u) {
      Undertone.warm => Palette(
          best: switch (d) {
            SkinDepth.light => ['#E9A178', '#F2C57C', '#9CB380', '#7FB7A5', '#D98E73', '#C8A2C8'],
            SkinDepth.medium => ['#C8553D', '#E1A140', '#6B8E23', '#2E8B78', '#B5651D', '#8B4513'],
            SkinDepth.deep => ['#E07A2E', '#F4C430', '#228B22', '#008080', '#B22222', '#DAA520'],
          },
          neutrals: [...contrastNeutrals, '#C19A6B'],
          sparingly: ['#FF69B4', '#B0C4DE', '#C0C0C0'],
        ),
      Undertone.cool => Palette(
          best: switch (d) {
            SkinDepth.light => ['#9DB4D8', '#C8A2C8', '#E6A8B8', '#7FA6A0', '#5F6CAF', '#B5D0E0'],
            SkinDepth.medium => ['#4169E1', '#8E4585', '#C71585', '#2E8B57', '#4682B4', '#6A5ACD'],
            SkinDepth.deep => ['#0047AB', '#8B008B', '#DC143C', '#00A86B', '#E0E0FF', '#FF1493'],
          },
          neutrals: [...contrastNeutrals, '#708090'],
          sparingly: ['#FF8C00', '#DAA520', '#8B4513'],
        ),
      Undertone.neutral => Palette(
          best: switch (d) {
            SkinDepth.light => ['#D8A39D', '#9FC5B8', '#A7B7D6', '#E3C48F', '#B497BD', '#8FB996'],
            SkinDepth.medium => ['#B85C5C', '#3E8E7E', '#5B7DB1', '#C9A227', '#7D5BA6', '#D2691E'],
            SkinDepth.deep => ['#C0392B', '#16A085', '#2E5BBA', '#F1C40F', '#8E44AD', '#E67E22'],
          },
          neutrals: [...contrastNeutrals, '#7A7A7A'],
          sparingly: ['#FFFF66', '#FF00FF', '#00FFFF'],
        ),
    };
  }
}
