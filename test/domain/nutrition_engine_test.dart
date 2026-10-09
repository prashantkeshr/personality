import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/services/meal_planner.dart';
import 'package:personality/domain/services/nutrition_engine.dart';

void main() {
  const man = NutritionInput(
      weightKg: 70,
      heightCm: 175,
      ageRange: AgeRange.from25to34,
      gender: Gender.male,
      activity: ActivityLevel.moderate);

  group('nutrition engine', () {
    test('Mifflin–St Jeor and activity', () {
      expect(NutritionEngine.bmr(man), 1649);
      expect(NutritionEngine.maintenance(man), 2556);
    });

    test('steady fat loss: ~0.5 kg/week, high protein, macros add up', () {
      final t = NutritionEngine.targets(man, PlanKind.loseFat, PlanPace.steady);
      expect(t.calories, 2010);
      expect(t.proteinG, 140);
      expect(t.fatG, 60);
      expect(t.waterMl, 2500);
      expect(t.weeklyChangeKg, closeTo(-0.5, 0.01));
      expect(t.limitedByFloor, isFalse);
      final kcal = t.proteinG * 4 + t.carbsG * 4 + t.fatG * 9;
      expect(kcal, closeTo(t.calories, 10));
      expect(t.weeksTo(70, 65), 11);
      expect(t.weeksTo(70, 75), isNull); // wrong direction
    });

    test('never below the safe floor', () {
      const small = NutritionInput(
          weightKg: 50,
          heightCm: 160,
          ageRange: AgeRange.from25to34,
          gender: Gender.female,
          activity: ActivityLevel.sedentary);
      final t = NutritionEngine.targets(small, PlanKind.loseFat, PlanPace.brisk);
      expect(t.calories, 1200);
      expect(t.limitedByFloor, isTrue);
      expect(t.carbsG, greaterThanOrEqualTo(100));
    });

    test('gain plans add a moderate surplus; muscle gain is leaner', () {
      final gain = NutritionEngine.targets(man, PlanKind.gainWeight, PlanPace.steady);
      final muscle = NutritionEngine.targets(man, PlanKind.buildMuscle, PlanPace.steady);
      expect(gain.calories - 2556, inInclusiveRange(300, 600));
      expect(muscle.calories - 2556, inInclusiveRange(100, 350));
      expect(muscle.proteinG, greaterThan(gain.proteinG));
      expect(gain.weeklyChangeKg, greaterThan(0));
    });

    test('protein follows healthy weight for higher BMI', () {
      const heavy = NutritionInput(weightKg: 110, heightCm: 170, gender: Gender.male);
      final t = NutritionEngine.targets(heavy, PlanKind.loseFat, PlanPace.steady);
      final (_, maxHealthy) = NutritionEngine.healthyRange(170);
      expect(t.proteinG, (maxHealthy * 2).round());
    });

    test('unsuitable plans are blocked with a reason', () {
      expect(NutritionEngine.blockFor(PlanKind.loseFat,
          const NutritionInput(weightKg: 60, heightCm: 170, ageRange: AgeRange.under18)),
          PlanBlock.underage);
      expect(NutritionEngine.blockFor(PlanKind.maintain,
          const NutritionInput(weightKg: 60, heightCm: 170, ageRange: AgeRange.under18)),
          isNull);
      expect(NutritionEngine.blockFor(PlanKind.loseFat,
          const NutritionInput(weightKg: 50, heightCm: 175)), PlanBlock.underweight);
      expect(NutritionEngine.blockFor(PlanKind.gainWeight,
          const NutritionInput(weightKg: 80, heightCm: 170)), PlanBlock.alreadyHeavy);
      expect(NutritionEngine.blockFor(PlanKind.buildMuscle,
          const NutritionInput(weightKg: 80, heightCm: 170)), isNull);
    });
  });

  group('meal planner', () {
    final library = [
      for (final j in jsonDecode(File('assets/content/meals.json').readAsStringSync()) as List)
        MealOption.fromJson(j as Map<String, dynamic>),
    ];

    test('library covers every slot for every diet', () {
      for (final d in DietPreference.values) {
        for (final s in MealSlot.values) {
          expect(library.where((m) => m.slot == s && m.diet <= dietRank(d)).length,
              greaterThanOrEqualTo(4), reason: '$d $s');
        }
      }
    });

    test('menus respect the diet, land near the target and vary daily', () {
      for (final d in DietPreference.values) {
        for (final kcal in [1500, 2000, 2600, 3000]) {
          final menus = [
            for (var day = 0; day < 7; day++)
              MealPlanner.day(
                  library: library, calories: kcal, proteinG: 110, diet: d, day: day),
          ];
          for (final m in menus) {
            expect(m.meals.every((p) => p.meal.diet <= dietRank(d)), isTrue);
            // No main ingredient twice in one day.
            final bases = m.meals.map((p) => p.meal.base).toList();
            expect(bases.toSet().length, bases.length, reason: '$d $kcal $bases');
            expect(m.kcal, closeTo(kcal, kcal * 0.2), reason: '$d $kcal');
          }
          // Consecutive days don't repeat the whole menu.
          for (var i = 1; i < menus.length; i++) {
            expect(menus[i].meals.map((p) => p.meal.id),
                isNot(menus[i - 1].meals.map((p) => p.meal.id)));
          }
        }
      }
    });

    test('menus favour the local cuisine for every region and diet', () {
      for (final region in Region.values) {
        for (final d in DietPreference.values) {
          var local = 0, total = 0;
          for (var day = 0; day < 7; day++) {
            final m = MealPlanner.day(
                library: library, calories: 2200, proteinG: 110,
                diet: d, day: day, region: region);
            for (final p in m.meals.where((p) => !p.extra)) {
              total++;
              if (cuisineTier(p.meal, region) <= 1) local++;
            }
          }
          expect(local / total, greaterThanOrEqualTo(0.75),
              reason: '$region $d $local/$total');
        }
      }
    });

    test('South India gets South Indian dishes', () {
      final ids = {
        for (var day = 0; day < 7; day++)
          for (final p in MealPlanner.day(
                  library: library, calories: 2000, proteinG: 100,
                  diet: DietPreference.vegetarian, day: day,
                  region: Region.indiaSouth)
              .meals)
            p.meal.cuisine,
      };
      expect(ids, contains('southIndian'));
      expect(ids, isNot(contains('eastAsian')));
    });

    test('adds a protein snack when short of the target', () {
      final m = MealPlanner.day(
          library: library, calories: 1600, proteinG: 150,
          diet: DietPreference.vegan, day: 3);
      expect(m.meals.any((p) => p.extra), isTrue);
    });
  });

  test('warm climates add water; India gets Surya Namaskar', () {
    const cool = NutritionInput(weightKg: 70, heightCm: 175, region: Region.europe);
    const warm = NutritionInput(weightKg: 70, heightCm: 175, region: Region.indiaSouth);
    expect(
        NutritionEngine.targets(warm, PlanKind.maintain, PlanPace.steady).waterMl -
            NutritionEngine.targets(cool, PlanKind.maintain, PlanPace.steady).waterMl,
        300);
    final week = TrainingPlanner.week(PlanKind.maintain, PlanPace.steady,
        region: Region.indiaNorth);
    expect(week.expand((d) => d.exerciseIds), contains('surya_namaskar'));
    expect(
        TrainingPlanner.week(PlanKind.maintain, PlanPace.steady, region: Region.europe)
            .expand((d) => d.exerciseIds),
        isNot(contains('surya_namaskar')));
  });

  group('training planner', () {
    test('strength days are never back to back and exercises exist', () {
      final ids = {
        for (final j in jsonDecode(File('assets/content/exercises.json').readAsStringSync()) as List)
          (j as Map)['id'],
      };
      for (final kind in PlanKind.values) {
        for (final pace in PlanPace.values) {
          final week = TrainingPlanner.week(kind, pace);
          expect(week.map((d) => d.weekday), [1, 2, 3, 4, 5, 6, 7]);
          bool strength(TrainingDay d) =>
              d.type == WorkoutType.strengthA || d.type == WorkoutType.strengthB;
          for (var i = 1; i < 7; i++) {
            expect(strength(week[i]) && strength(week[i - 1]), isFalse,
                reason: '$kind $pace day ${i + 1}');
          }
          for (final d in week) {
            expect(ids, containsAll(d.exerciseIds));
          }
        }
      }
    });
  });
}
