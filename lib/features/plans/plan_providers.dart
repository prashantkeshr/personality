import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/repositories/body_plan_repository.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/meal_planner.dart';
import '../../domain/services/nutrition_engine.dart';
import '../health/body_providers.dart';
import '../health/health_providers.dart';

final bodyPlanRepositoryProvider = Provider((ref) => BodyPlanRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider)));

final activeBodyPlanProvider = StreamProvider<BodyPlan?>(
    (ref) => ref.watch(bodyPlanRepositoryProvider).watchActive());

/// Dishes for meal plans (assets/content/meals.json).
final mealLibraryProvider = FutureProvider<List<MealOption>>((ref) async {
  final raw =
      await rootBundle.loadString('assets/content/meals.json', cache: false);
  return [
    for (final j in jsonDecode(raw) as List)
      MealOption.fromJson(j as Map<String, dynamic>),
  ];
});

/// What the nutrition engine needs, or null until height and weight exist.
final nutritionInputProvider = Provider<NutritionInput?>((ref) {
  final height = ref.watch(primaryHeightProvider).value;
  final weights = ref.watch(weightRecordsProvider).value ?? const [];
  final profile = ref.watch(profileProvider).value;
  if (height == null || weights.isEmpty) return null;
  return NutritionInput(
    weightKg: weights.first.value,
    heightCm: height.value,
    ageRange: profile?.ageRange,
    gender: profile?.gender,
    activity: profile?.activityLevel,
    region: profile?.region,
  );
});

/// The planned dishes for a day under the active plan (swaps not applied).
final dayMenuProvider = Provider.family<DayMenu?, int>((ref, dayKey) {
  final plan = ref.watch(activeBodyPlanProvider).value;
  final library = ref.watch(mealLibraryProvider).value;
  if (plan == null || library == null) return null;
  final d = Days.fromKey(dayKey);
  return MealPlanner.day(
      library: library,
      calories: plan.calories,
      proteinG: plan.proteinG,
      diet: plan.diet,
      day: DateTime(d.year, d.month, d.day).difference(DateTime(2020)).inDays,
      region: ref.watch(profileProvider).value?.region);
});

/// Calories logged in meals today (only meals with a calorie value count).
final todayCaloriesProvider = Provider<int>((ref) {
  final today = Days.key(ref.watch(clockProvider)());
  final meals = ref.watch(mealsProvider).value ?? const [];
  return meals
      .where((m) => Days.key(m.eatenAt) == today)
      .fold(0.0, (s, m) => s + (m.calories ?? 0))
      .round();
});
