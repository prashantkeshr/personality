import '../../data/repositories/style_repository.dart';
import '../../domain/services/outfit_engine.dart';
import '../../domain/services/palette_engine.dart';
import '../../l10n/app_localizations.dart';

extension StyleLabels on AppLocalizations {
  String undertoneName(Undertone u) => switch (u) {
        Undertone.warm => undertoneWarm,
        Undertone.cool => undertoneCool,
        Undertone.neutral => undertoneNeutral,
      };

  String undertoneExplain(Undertone u) => switch (u) {
        Undertone.warm => undertoneWarmExplain,
        Undertone.cool => undertoneCoolExplain,
        Undertone.neutral => undertoneNeutralExplain,
      };

  String depthName(SkinDepth d) => switch (d) {
        SkinDepth.light => depthLight,
        SkinDepth.medium => depthMedium,
        SkinDepth.deep => depthDeep,
      };

  String stylePrefName(StylePreference s) => switch (s) {
        StylePreference.classic => prefClassic,
        StylePreference.minimal => prefMinimal,
        StylePreference.smartCasual => prefSmartCasual,
        StylePreference.street => prefStreet,
        StylePreference.traditional => prefTraditional,
        StylePreference.sporty => prefSporty,
      };

  String categoryName(GarmentCategory c) => switch (c) {
        GarmentCategory.top => catTop,
        GarmentCategory.bottom => catBottom,
        GarmentCategory.onePiece => catOnePiece,
        GarmentCategory.outerwear => catOuterwear,
        GarmentCategory.footwear => catFootwear,
        GarmentCategory.ethnicTop => catEthnicTop,
        GarmentCategory.ethnicBottom => catEthnicBottom,
        GarmentCategory.accessory => catAccessory,
      };

  String patternName(GarmentPattern p) => switch (p) {
        GarmentPattern.solid => patSolid,
        GarmentPattern.stripes => patStripes,
        GarmentPattern.checks => patChecks,
        GarmentPattern.print => patPrint,
      };

  String occasionName(Occasion o) => switch (o) {
        Occasion.casual => occCasual,
        Occasion.work => occWork,
        Occasion.formal => occFormal,
        Occasion.festive => occFestive,
        Occasion.sport => occSport,
      };

  String formalityName(int f) => switch (f) {
        1 => form1,
        2 => form2,
        3 => form3,
        4 => form4,
        _ => form5,
      };

  String outfitReason(OutfitReason r) => switch (r) {
        OutfitReason.allNeutral => reasonAllNeutral,
        OutfitReason.oneAccent => reasonOneAccent,
        OutfitReason.tonal => reasonTonal,
        OutfitReason.analogous => reasonAnalogous,
        OutfitReason.complementary => reasonComplementary,
        OutfitReason.inPalette => reasonInPalette,
        OutfitReason.onePattern => reasonOnePattern,
        OutfitReason.matchedFormality => reasonMatchedFormality,
        OutfitReason.includesFavourite => reasonFavourite,
        OutfitReason.notWornRecently => reasonNotWorn,
      };
}
