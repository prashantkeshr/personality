// Labels for Style DNA, Get ready, wardrobe stats and glasses.
// Generated together with the ARB strings; keep them in sync.
import 'package:flutter/material.dart';

import '../../data/repositories/style_repository.dart';
import '../../domain/services/get_ready.dart';
import '../../domain/services/glasses_fit.dart';
import '../../domain/services/wardrobe_stats.dart';
import '../../l10n/app_localizations.dart';

extension StyleStudioLabels on AppLocalizations {
  String fitName(FitPreference f) => switch (f) {
        FitPreference.slim => fitPrefSlim,
        FitPreference.regular => fitPrefRegular,
        FitPreference.relaxed => fitPrefRelaxed,
        FitPreference.oversized => fitPrefOversized,
        FitPreference.tailored => fitPrefTailored,
      };

  String culturalName(CulturalWear c) => switch (c) {
        CulturalWear.indianEthnic => culturalIndianEthnic,
        CulturalWear.modest => culturalModest,
        CulturalWear.western => culturalWestern,
        CulturalWear.fusion => culturalFusion,
      };

  String modestyName(Modesty m) => switch (m) {
        Modesty.relaxed => modestyRelaxed,
        Modesty.moderate => modestyModerate,
        Modesty.covered => modestyCovered,
      };

  String budgetName(BudgetLevel b) => switch (b) {
        BudgetLevel.value => budgetValue,
        BudgetLevel.midRange => budgetMidRange,
        BudgetLevel.premium => budgetPremium,
      };

  String readyEventName(ReadyEvent e) => switch (e) {
        ReadyEvent.interview => readyEvInterview,
        ReadyEvent.presentation => readyEvPresentation,
        ReadyEvent.office => readyEvOffice,
        ReadyEvent.date => readyEvDate,
        ReadyEvent.wedding => readyEvWedding,
        ReadyEvent.festival => readyEvFestival,
        ReadyEvent.party => readyEvParty,
        ReadyEvent.casual => readyEvCasual,
        ReadyEvent.gym => readyEvGym,
        ReadyEvent.travel => readyEvTravel,
      };

  String readySectionName(ReadySection s) => switch (s) {
        ReadySection.outfit => readySecOutfit,
        ReadySection.grooming => readySecGrooming,
        ReadySection.presentation => readySecPresentation,
        ReadySection.finalChecks => readySecFinalChecks,
      };

  /// Text for a checklist line; [style] fills hairstyle and beard lines.
  String readyText(String id, String style) => switch (id) {
        'planned' => readyPlanned,
        'suggested' => readySuggested,
        'guide_interview' => readyGuideInterview,
        'guide_presentation' => readyGuidePresentation,
        'guide_office' => readyGuideOffice,
        'guide_date' => readyGuideDate,
        'guide_wedding' => readyGuideWedding,
        'guide_festival' => readyGuideFestival,
        'guide_party' => readyGuideParty,
        'guide_casual' => readyGuideCasual,
        'guide_gym' => readyGuideGym,
        'guide_travel' => readyGuideTravel,
        'guide_ethnic' => readyGuideEthnic,
        'modest' => readyModest,
        'fit_slim' => readyFitSlim,
        'fit_regular' => readyFitRegular,
        'fit_relaxed' => readyFitRelaxed,
        'fit_oversized' => readyFitOversized,
        'fit_tailored' => readyFitTailored,
        'colours' => readyColours,
        'press' => readyPress,
        'shoes' => readyShoes,
        'layer' => readyLayer,
        'hair_style' => readyHairStyle(style),
        'hair_tidy' => readyHairTidy,
        'beard_style' => readyBeardStyle(style),
        'beard_tidy' => readyBeardTidy,
        'skin' => readySkin,
        'sunscreen' => readySunscreen,
        'nails' => readyNails,
        'scent_light' => readyScentLight,
        'gym_hair' => readyGymHair,
        'posture' => readyPosture,
        'breath' => readyBreath,
        'face_warmup' => readyFaceWarmup,
        'voice' => readyVoice,
        'eye_contact' => readyEyeContact,
        'three_points' => readyThreePoints,
        'documents' => readyDocuments,
        'travel_docs' => readyTravelDocs,
        'gym_kit' => readyGymKit,
        'gift' => readyGift,
        'water' => readyWater,
        'phone' => readyPhone,
        'early' => readyEarly,
        _ => id,
      };

  String gapName(WardrobeGap g) => switch (g) {
        WardrobeGap.bottoms => gapBottoms,
        WardrobeGap.footwear => gapFootwear,
        WardrobeGap.workTop => gapWorkTop,
        WardrobeGap.formalWear => gapFormalWear,
        WardrobeGap.festiveEthnic => gapFestiveEthnic,
        WardrobeGap.neutralBasics => gapNeutralBasics,
        WardrobeGap.sportwear => gapSportwear,
        WardrobeGap.outerwear => gapOuterwear,
      };

  String gapAdvice(WardrobeGap g) => switch (g) {
        WardrobeGap.bottoms => gapAdviceBottoms,
        WardrobeGap.footwear => gapAdviceFootwear,
        WardrobeGap.workTop => gapAdviceWorkTop,
        WardrobeGap.formalWear => gapAdviceFormalWear,
        WardrobeGap.festiveEthnic => gapAdviceFestiveEthnic,
        WardrobeGap.neutralBasics => gapAdviceNeutralBasics,
        WardrobeGap.sportwear => gapAdviceSportwear,
        WardrobeGap.outerwear => gapAdviceOuterwear,
      };

  String frameFitName(FrameFit f) => switch (f) {
        FrameFit.great => fitGreat,
        FrameFit.good => fitGood,
        FrameFit.lessBalancing => fitLess,
      };

  String fitReasonText(FitReason r) => switch (r) {
        FitReason.addsAngles => fitReasonAddsAngles,
        FitReason.softensAngles => fitReasonSoftensAngles,
        FitReason.addsLength => fitReasonAddsLength,
        FitReason.balancesForehead => fitReasonBalancesForehead,
        FitReason.liftsCheekbones => fitReasonLiftsCheekbones,
        FitReason.suitsMost => fitReasonSuitsMost,
        FitReason.echoesShape => fitReasonEchoesShape,
        FitReason.unknownShape => fitReasonUnknownShape,
      };
}

IconData readyEventIcon(ReadyEvent e) => switch (e) {
      ReadyEvent.interview => Icons.work_outline,
      ReadyEvent.presentation => Icons.co_present_outlined,
      ReadyEvent.office => Icons.business_center_outlined,
      ReadyEvent.date => Icons.favorite_outline,
      ReadyEvent.wedding => Icons.celebration_outlined,
      ReadyEvent.festival => Icons.festival_outlined,
      ReadyEvent.party => Icons.nightlife_outlined,
      ReadyEvent.casual => Icons.wb_sunny_outlined,
      ReadyEvent.gym => Icons.fitness_center,
      ReadyEvent.travel => Icons.luggage_outlined,
    };
