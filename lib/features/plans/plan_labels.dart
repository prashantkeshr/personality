import 'package:flutter/material.dart';

import '../../domain/entities/health.dart';
import '../../domain/services/meal_planner.dart';
import '../../domain/services/nutrition_engine.dart';
import '../../l10n/app_localizations.dart';

extension PlanLabels on AppLocalizations {
  String planKindName(PlanKind k) => switch (k) {
        PlanKind.loseFat => planLoseFat,
        PlanKind.maintain => planMaintain,
        PlanKind.gainWeight => planGainWeight,
        PlanKind.buildMuscle => planBuildMuscle,
      };

  String planKindInfo(PlanKind k) => switch (k) {
        PlanKind.loseFat => planLoseFatInfo,
        PlanKind.maintain => planMaintainInfo,
        PlanKind.gainWeight => planGainWeightInfo,
        PlanKind.buildMuscle => planBuildMuscleInfo,
      };

  String planBlockReason(PlanBlock b) => switch (b) {
        PlanBlock.underage => planBlockUnderage,
        PlanBlock.underweight => planBlockUnderweight,
        PlanBlock.alreadyHeavy => planBlockHeavy,
      };

  String paceName(PlanPace p) => switch (p) {
        PlanPace.gentle => paceGentle,
        PlanPace.steady => paceSteady,
        PlanPace.brisk => paceBrisk,
      };

  String slotName(MealSlot s) => switch (s) {
        MealSlot.breakfast => mealBreakfast,
        MealSlot.lunch => mealLunch,
        MealSlot.snack => mealSnack,
        MealSlot.dinner => mealDinner,
      };

  String workoutName(WorkoutType w) => switch (w) {
        WorkoutType.strengthA => workoutStrengthA,
        WorkoutType.strengthB => workoutStrengthB,
        WorkoutType.cardio => workoutCardio,
        WorkoutType.mobility => workoutMobility,
        WorkoutType.rest => workoutRest,
      };
}

MealType mealTypeFor(MealSlot s) => switch (s) {
      MealSlot.breakfast => MealType.breakfast,
      MealSlot.lunch => MealType.lunch,
      MealSlot.snack => MealType.snack,
      MealSlot.dinner => MealType.dinner,
    };

IconData slotIcon(MealSlot s) => switch (s) {
      MealSlot.breakfast => Icons.free_breakfast_outlined,
      MealSlot.lunch => Icons.lunch_dining_outlined,
      MealSlot.snack => Icons.apple,
      MealSlot.dinner => Icons.dinner_dining_outlined,
    };

IconData workoutIcon(WorkoutType w) => switch (w) {
      WorkoutType.strengthA || WorkoutType.strengthB => Icons.fitness_center,
      WorkoutType.cardio => Icons.directions_walk,
      WorkoutType.mobility => Icons.self_improvement,
      WorkoutType.rest => Icons.bedtime_outlined,
    };

/// Photo for each plan goal (bundled, credited in goals/CREDITS.md).
String planImage(PlanKind k) => switch (k) {
      PlanKind.loseFat => 'assets/images/goals/fitness.jpg',
      PlanKind.maintain => 'assets/images/goals/flexibility.jpg',
      PlanKind.gainWeight => 'assets/images/goals/weight.jpg',
      PlanKind.buildMuscle => 'assets/images/goals/feed_exercise.jpg',
    };
