/// Energy and macro targets for a body plan (pure Dart).
///
/// Uses the Mifflin–St Jeor equation with standard activity factors. These
/// are population estimates — a starting point the user adjusts by watching
/// their weekly trend, not medical advice. Deficits and surpluses are kept
/// moderate and calories never go below a safe floor.
library;

import 'dart:math' as math;

import '../entities/body.dart';

enum PlanKind { loseFat, maintain, gainWeight, buildMuscle }

enum PlanPace { gentle, steady, brisk }

/// Why a plan kind can't be offered for this person.
enum PlanBlock { underage, underweight, alreadyHeavy }

class NutritionInput {
  const NutritionInput({
    required this.weightKg,
    required this.heightCm,
    this.ageRange,
    this.gender,
    this.activity,
    this.region,
  });

  final double weightKg;
  final Region? region;
  final double heightCm;
  final AgeRange? ageRange;
  final Gender? gender;
  final ActivityLevel? activity;

  double get bmi => weightKg / math.pow(heightCm / 100, 2);

  /// Representative age for the range (30 when unknown).
  int get age => switch (ageRange) {
        AgeRange.under18 => 16,
        AgeRange.from18to24 => 21,
        AgeRange.from25to34 => 30,
        AgeRange.from35to44 => 40,
        AgeRange.from45to54 => 50,
        AgeRange.from55to64 => 60,
        AgeRange.over65 => 70,
        null => 30,
      };
}

class PlanTargets {
  const PlanTargets({
    required this.kind,
    required this.pace,
    required this.bmr,
    required this.maintenance,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.waterMl,
    required this.weeklyChangeKg,
    this.limitedByFloor = false,
  });

  final PlanKind kind;
  final PlanPace pace;
  final int bmr;

  /// Estimated calories to keep weight steady.
  final int maintenance;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int waterMl;

  /// Expected change per week (negative = losing).
  final double weeklyChangeKg;

  /// True when the safe calorie floor made the deficit smaller than asked.
  final bool limitedByFloor;

  /// Weeks to reach [targetKg] from [fromKg] at this pace, or null.
  int? weeksTo(double fromKg, double? targetKg) {
    if (targetKg == null || weeklyChangeKg == 0) return null;
    final diff = targetKg - fromKg;
    if (diff.sign != weeklyChangeKg.sign) return null;
    return (diff / weeklyChangeKg).ceil();
  }
}

abstract final class NutritionEngine {
  /// Kilocalories per kilogram of body-weight change (rule of thumb).
  static const kcalPerKg = 7700.0;

  static const _activity = {
    ActivityLevel.sedentary: 1.2,
    ActivityLevel.light: 1.375,
    ActivityLevel.moderate: 1.55,
    ActivityLevel.active: 1.725,
    ActivityLevel.veryActive: 1.9,
  };

  /// Weekly rate (kg) per pace.
  static const _rates = {
    PlanKind.loseFat: [0.25, 0.5, 0.75],
    PlanKind.gainWeight: [0.2, 0.3, 0.45],
    PlanKind.buildMuscle: [0.1, 0.15, 0.25],
  };

  static int bmr(NutritionInput i) {
    final base = 10 * i.weightKg + 6.25 * i.heightCm - 5 * i.age;
    final offset = switch (i.gender) {
      Gender.male => 5.0,
      Gender.female => -161.0,
      _ => -78.0, // midpoint when not specified
    };
    return (base + offset).round();
  }

  static int maintenance(NutritionInput i) =>
      (bmr(i) * _activity[i.activity ?? ActivityLevel.light]!).round();

  /// Lowest daily target the app will suggest.
  static int floorFor(NutritionInput i) => switch (i.gender) {
        Gender.male => 1500,
        Gender.female => 1200,
        _ => 1350,
      };

  /// Healthy weight range for the height (BMI 18.5–24.9).
  static (double, double) healthyRange(double heightCm) {
    final m2 = math.pow(heightCm / 100, 2);
    return (18.5 * m2, 24.9 * m2);
  }

  /// Why [kind] isn't suitable, or null when it is.
  static PlanBlock? blockFor(PlanKind kind, NutritionInput i) {
    if (i.ageRange == AgeRange.under18 && kind != PlanKind.maintain) {
      return PlanBlock.underage;
    }
    if (kind == PlanKind.loseFat && i.bmi < 18.5) return PlanBlock.underweight;
    if (kind == PlanKind.gainWeight && i.bmi >= 25) {
      return PlanBlock.alreadyHeavy;
    }
    return null;
  }

  /// Weight used for protein: actual weight, or the weight at BMI 25 when
  /// higher (protein needs follow lean mass, not total mass).
  static double referenceWeight(NutritionInput i) =>
      math.min(i.weightKg, healthyRange(i.heightCm).$2);

  static PlanTargets targets(NutritionInput i, PlanKind kind, PlanPace pace) {
    final b = bmr(i);
    final tdee = maintenance(i);
    var limited = false;
    double delta;
    if (kind == PlanKind.maintain) {
      delta = 0;
    } else {
      final rate = _rates[kind]![pace.index];
      delta = rate * kcalPerKg / 7;
      if (kind == PlanKind.loseFat) {
        // Never more than 25% below maintenance, never below the floor.
        delta = -math.min(delta, tdee * 0.25);
        final floor = math.max(floorFor(i).toDouble(), b * 0.9);
        if (tdee + delta < floor) {
          delta = math.min(0.0, floor - tdee);
          limited = true;
        }
      } else {
        delta = math.min(delta, kind == PlanKind.buildMuscle ? 350 : 600);
      }
    }
    final calories = ((tdee + delta) / 10).round() * 10;

    final ref = referenceWeight(i);
    final proteinPerKg = switch (kind) {
      PlanKind.loseFat => 2.0,
      PlanKind.maintain => 1.6,
      PlanKind.gainWeight => 1.8,
      PlanKind.buildMuscle => 2.0,
    };
    var protein = (ref * proteinPerKg).round();
    var fat = math.max(calories * 0.27 / 9, ref * 0.6).round();
    var carbs = ((calories - protein * 4 - fat * 9) / 4).round();
    if (carbs < 100) {
      // Keep a sensible minimum of carbohydrate; take it from fat first.
      fat = math.max((ref * 0.6).round(), fat - ((100 - carbs) * 4 / 9).ceil());
      carbs = ((calories - protein * 4 - fat * 9) / 4).round();
      if (carbs < 100) {
        protein = ((calories - fat * 9 - 400) / 4).round();
        carbs = 100;
      }
    }
    // Warm climates need more fluid.
    final extra = i.region?.hotClimate ?? false ? 300 : 0;
    final water =
        ((i.weightKg * 35 + extra).clamp(1500, 4000) / 100).round() * 100;

    return PlanTargets(
      kind: kind,
      pace: pace,
      bmr: b,
      maintenance: tdee,
      calories: calories,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
      waterMl: water,
      weeklyChangeKg: (calories - tdee) * 7 / kcalPerKg,
      limitedByFloor: limited,
    );
  }
}
