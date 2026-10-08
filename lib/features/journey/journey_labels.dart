import 'package:flutter/material.dart';

import '../../domain/services/progress_engine.dart';
import '../../l10n/app_localizations.dart';

String questLabel(AppLocalizations l10n, QuestKind k) => switch (k) {
      QuestKind.drinkTarget => l10n.questDrinkTarget,
      QuestKind.logMeals => l10n.questLogMeals,
      QuestKind.postureCheck => l10n.questPostureCheck,
      QuestKind.completePlan => l10n.questCompletePlan,
      QuestKind.allHabits => l10n.questAllHabits,
      QuestKind.logSleep => l10n.questLogSleep,
      QuestKind.workout => l10n.questWorkout,
      QuestKind.wearOutfit => l10n.questWearOutfit,
      QuestKind.snapshot => l10n.questSnapshot,
      QuestKind.logWeight => l10n.questLogWeight,
    };

IconData questIcon(QuestKind k) => switch (k) {
      QuestKind.drinkTarget => Icons.water_drop_outlined,
      QuestKind.logMeals => Icons.restaurant_outlined,
      QuestKind.postureCheck => Icons.accessibility_new,
      QuestKind.completePlan => Icons.event_available_outlined,
      QuestKind.allHabits => Icons.task_alt,
      QuestKind.logSleep => Icons.bedtime_outlined,
      QuestKind.workout => Icons.directions_run,
      QuestKind.wearOutfit => Icons.checkroom_outlined,
      QuestKind.snapshot => Icons.photo_camera_front_outlined,
      QuestKind.logWeight => Icons.monitor_weight_outlined,
    };

String badgeTitle(AppLocalizations l10n, Award b) => switch (b) {
      Award.firstSteps => l10n.badgeFirstSteps,
      Award.streak7 => l10n.badgeStreak7,
      Award.streak30 => l10n.badgeStreak30,
      Award.hydrationHero => l10n.badgeHydration,
      Award.postureRegular => l10n.badgePosture,
      Award.faceExplorer => l10n.badgeFace,
      Award.journeyKeeper => l10n.badgeJourney,
      Award.planner => l10n.badgePlanner,
      Award.habitHero => l10n.badgeHabits,
      Award.stylist => l10n.badgeStylist,
      Award.level5 => l10n.badgeLevel5,
      Award.level10 => l10n.badgeLevel10,
    };

String badgeInfo(AppLocalizations l10n, Award b) => switch (b) {
      Award.firstSteps => l10n.badgeFirstStepsInfo,
      Award.streak7 => l10n.badgeStreak7Info,
      Award.streak30 => l10n.badgeStreak30Info,
      Award.hydrationHero => l10n.badgeHydrationInfo,
      Award.postureRegular => l10n.badgePostureInfo,
      Award.faceExplorer => l10n.badgeFaceInfo,
      Award.journeyKeeper => l10n.badgeJourneyInfo,
      Award.planner => l10n.badgePlannerInfo,
      Award.habitHero => l10n.badgeHabitsInfo,
      Award.stylist => l10n.badgeStylistInfo,
      Award.level5 => l10n.badgeLevel5Info,
      Award.level10 => l10n.badgeLevel10Info,
    };

enum MedalTier { bronze, silver, gold }

MedalTier badgeTier(Award b) => switch (b) {
      Award.firstSteps || Award.faceExplorer => MedalTier.bronze,
      Award.streak30 || Award.habitHero || Award.level10 => MedalTier.gold,
      _ => MedalTier.silver,
    };

IconData badgeIcon(Award b) => switch (b) {
      Award.firstSteps => Icons.flag_outlined,
      Award.streak7 || Award.streak30 => Icons.local_fire_department_outlined,
      Award.hydrationHero => Icons.water_drop_outlined,
      Award.postureRegular => Icons.accessibility_new,
      Award.faceExplorer => Icons.face_retouching_natural_outlined,
      Award.journeyKeeper => Icons.photo_library_outlined,
      Award.planner => Icons.event_available_outlined,
      Award.habitHero => Icons.task_alt,
      Award.stylist => Icons.checkroom_outlined,
      Award.level5 || Award.level10 => Icons.workspace_premium_outlined,
    };
