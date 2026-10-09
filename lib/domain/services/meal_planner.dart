/// Turns calorie/protein targets into a day of real meals, and a plan kind
/// into a weekly training schedule (pure Dart).
library;

import 'dart:math' as math;

import '../entities/body.dart';
import 'nutrition_engine.dart';

enum MealSlot { breakfast, lunch, snack, dinner }

/// A dish from assets/content/meals.json. Values are per serving.
class MealOption {
  const MealOption({
    required this.id,
    required this.slot,
    required this.diet,
    required this.name,
    required this.portion,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.base = '',
    this.cuisine = 'global',
  });

  final String id;
  final MealSlot slot;

  /// Main ingredient (paneer, dal, egg …), used to keep a day varied.
  final String base;

  /// Regional cuisine (northIndian, southIndian, eastAsian, western …) or
  /// 'global' for dishes common everywhere.
  final String cuisine;

  /// Most restrictive diet the dish fits: 0 vegan, 1 vegetarian, 2 egg,
  /// 3 non-vegetarian.
  final int diet;
  final Map<String, String> name;
  final Map<String, String> portion;
  final int kcal;
  final int protein;
  final int carbs;
  final int fat;

  String nameIn(String lang) => name[lang] ?? name['en']!;
  String portionIn(String lang) => portion[lang] ?? portion['en']!;
  double get proteinDensity => protein / kcal;

  static const _diets = ['vegan', 'vegetarian', 'egg', 'nonveg'];

  factory MealOption.fromJson(Map<String, dynamic> j) => MealOption(
        id: j['id'] as String,
        slot: MealSlot.values.byName(j['slot'] as String),
        diet: _diets.indexOf(j['diet'] as String),
        name: Map<String, String>.from(j['name'] as Map),
        portion: Map<String, String>.from(j['portion'] as Map),
        kcal: j['kcal'] as int,
        protein: j['protein'] as int,
        carbs: j['carbs'] as int,
        fat: j['fat'] as int,
        base: j['base'] as String? ?? '',
        cuisine: j['cuisine'] as String? ?? 'global',
      );
}

int dietRank(DietPreference? d) => switch (d) {
      DietPreference.vegan => 0,
      DietPreference.vegetarian => 1,
      DietPreference.eggetarian => 2,
      DietPreference.nonVegetarian || null => 3,
    };

class PlannedMeal {
  const PlannedMeal(this.meal, this.servings, {this.extra = false});

  final MealOption meal;

  /// Multiple of the listed portion, in quarter steps.
  final double servings;

  /// An extra protein snack added to reach the protein target.
  final bool extra;

  int get kcal => (meal.kcal * servings).round();
  int get protein => (meal.protein * servings).round();
  int get carbs => (meal.carbs * servings).round();
  int get fat => (meal.fat * servings).round();
}

class DayMenu {
  const DayMenu(this.meals);
  final List<PlannedMeal> meals;

  int get kcal => meals.fold(0, (s, m) => s + m.kcal);
  int get protein => meals.fold(0, (s, m) => s + m.protein);
  int get carbs => meals.fold(0, (s, m) => s + m.carbs);
  int get fat => meals.fold(0, (s, m) => s + m.fat);
}

/// Local cuisines first, then nearby/common ones, for each region.
const _cuisines = <Region, (Set<String>, Set<String>)>{
  Region.indiaNorth: ({'northIndian', 'indian'}, {'westIndian', 'global'}),
  Region.indiaSouth: ({'southIndian', 'indian'}, {'global'}),
  Region.indiaEast: ({'eastIndian', 'indian'}, {'northIndian', 'global'}),
  Region.indiaWest: ({'westIndian', 'indian'}, {'northIndian', 'southIndian', 'global'}),
  Region.southAsia: ({'indian', 'northIndian', 'eastIndian'}, {'southIndian', 'global'}),
  Region.eastAsia: ({'eastAsian'}, {'southeastAsian', 'global'}),
  Region.southeastAsia: ({'southeastAsian'}, {'eastAsian', 'global'}),
  Region.middleEast: ({'middleEastern', 'mediterranean'}, {'global'}),
  Region.africa: ({'african'}, {'middleEastern', 'global'}),
  Region.europe: ({'western', 'mediterranean'}, {'global'}),
  Region.northAmerica: ({'western', 'latin'}, {'global'}),
  Region.latinAmerica: ({'latin'}, {'western', 'global'}),
  Region.oceania: ({'western'}, {'eastAsian', 'mediterranean', 'global'}),
};

/// 0 = local, 1 = familiar/common, 2 = other. Everything is local when the
/// region is unknown.
int cuisineTier(MealOption m, Region? region) {
  if (region == null) return 0;
  final (local, near) = _cuisines[region]!;
  if (local.contains(m.cuisine)) return 0;
  if (near.contains(m.cuisine)) return 1;
  return 2;
}

abstract final class MealPlanner {
  static const shares = {
    MealSlot.breakfast: 0.25,
    MealSlot.lunch: 0.35,
    MealSlot.snack: 0.12,
    MealSlot.dinner: 0.28,
  };

  static double _quarter(double v) => (v * 4).round() / 4;

  /// A day of meals near [calories], favouring protein-dense dishes and
  /// rotating so consecutive days differ. [day] is any running day number;
  /// [swaps] moves a slot to its next option.
  static DayMenu day({
    required List<MealOption> library,
    required int calories,
    required int proteinG,
    required DietPreference? diet,
    required int day,
    Region? region,
    Map<MealSlot, int> swaps = const {},
  }) {
    final rank = dietRank(diet);
    final picked = <PlannedMeal>[];
    for (final (si, slot) in MealSlot.values.indexed) {
      final target = calories * shares[slot]!;
      final all = [
        for (final m in library)
          if (m.slot == slot && m.diet <= rank) m
      ]..sort((a, b) {
          final t = cuisineTier(a, region).compareTo(cuisineTier(b, region));
          if (t != 0) return t;
          final c = b.proteinDensity.compareTo(a.proteinDensity);
          return c != 0 ? c : a.id.compareTo(b.id);
        });
      if (all.isEmpty) continue;
      // Draw from local dishes; add familiar ones only when local choice is
      // thin (fewer than three for this slot and diet).
      var maxTier = 0;
      while (maxTier < 2 &&
          all.where((m) => cuisineTier(m, region) <= maxTier).length < 3) {
        maxTier++;
      }
      final regional = [
        for (final m in all)
          if (cuisineTier(m, region) <= maxTier) m
      ]..sort((a, b) {
          final c = b.proteinDensity.compareTo(a.proteinDensity);
          return c != 0 ? c : a.id.compareTo(b.id);
        });
      // Prefer dishes whose portion fits without extreme scaling, then the
      // more protein-dense part of that list.
      final fitting = [
        for (final m in regional)
          if ((target / m.kcal) >= 0.75 && (target / m.kcal) <= 1.75) m
      ];
      final pool = fitting.isEmpty ? regional : fitting;
      final top = pool.sublist(0, math.max(3, (pool.length * 0.7).ceil()).clamp(1, pool.length));
      // Rotate through the list, skipping a main ingredient already used
      // today so a day isn't paneer, paneer and paneer.
      final used = {for (final p in picked) p.meal.base};
      final start = day + si * 3 + (swaps[slot] ?? 0);
      // Prefer the rotation within the best fits; widen to every dish for
      // the slot before repeating an ingredient.
      final order = [
        for (var k = 0; k < top.length; k++) top[(start + k) % top.length],
        for (final c in pool) if (!top.contains(c)) c,
        for (final c in regional) if (!pool.contains(c)) c,
        for (final c in all) if (!regional.contains(c)) c,
      ];
      final m = order.firstWhere(
          (c) => c.base.isEmpty || !used.contains(c.base),
          orElse: () => order.first);
      picked.add(PlannedMeal(m, _quarter((target / m.kcal).clamp(0.5, 2.0))));
    }
    var menu = DayMenu(picked);
    // Short on protein: add a protein-rich snack that keeps calories close.
    if (menu.protein < proteinG * 0.85) {
      final snacks = [
        for (final m in library)
          if (m.slot == MealSlot.snack &&
              m.diet <= rank &&
              !picked.any((p) => p.meal.base == m.base)) m
      ]..sort((a, b) {
          final t = cuisineTier(a, region).compareTo(cuisineTier(b, region));
          return t != 0 ? t : b.proteinDensity.compareTo(a.proteinDensity);
        });
      if (snacks.isNotEmpty) {
        final extra = PlannedMeal(snacks.first, 1, extra: true);
        // Make room for it so the day stays near the calorie target.
        final scale = (calories - extra.kcal) / menu.kcal;
        menu = DayMenu([
          for (final p in picked)
            PlannedMeal(p.meal, _quarter((p.servings * scale).clamp(0.5, 2.0))),
          extra,
        ]);
      }
    }
    return menu;
  }
}

enum WorkoutType { strengthA, strengthB, cardio, mobility, rest }

class TrainingDay {
  const TrainingDay(this.weekday, this.type, this.exerciseIds, this.minutes);

  /// 1 = Monday … 7 = Sunday.
  final int weekday;
  final WorkoutType type;
  final List<String> exerciseIds;
  final int minutes;
}

abstract final class TrainingPlanner {
  static List<String> _a(PlanPace pace) => [
        'squat',
        pace == PlanPace.gentle ? 'incline_push_up' : 'push_up',
        'backpack_row',
        'plank',
      ];

  static List<String> _b(PlanPace pace) => [
        'reverse_lunge',
        pace == PlanPace.gentle ? 'incline_push_up' : 'chair_dip',
        'glute_bridge',
        'calf_raise',
        'bird_dog',
      ];

  static const _mobility = ['cat_cow', 'hamstring_stretch', 'child_pose'];

  /// In India the mobility day is built around Surya Namaskar.
  static const _mobilityIndia = ['surya_namaskar', 'cat_cow', 'child_pose'];

  /// A simple, repeatable week. Strength days are never back to back.
  static List<TrainingDay> week(PlanKind kind, PlanPace pace,
      {Region? region}) {
    final a = TrainingDay(0, WorkoutType.strengthA, _a(pace), 30);
    final b = TrainingDay(0, WorkoutType.strengthB, _b(pace), 30);
    const walk = TrainingDay(0, WorkoutType.cardio, ['brisk_walk'], 30);
    final mob = TrainingDay(0, WorkoutType.mobility,
        region?.isIndia ?? false ? _mobilityIndia : _mobility, 15);
    const rest = TrainingDay(0, WorkoutType.rest, <String>[], 0);
    final List<TrainingDay> days = switch (kind) {
      PlanKind.loseFat => [a, walk, b, walk, a, pace == PlanPace.gentle ? mob : walk, rest],
      PlanKind.maintain => [a, rest, walk, b, rest, walk, mob],
      PlanKind.gainWeight || PlanKind.buildMuscle => [
          a, mob, b, rest, a, pace == PlanPace.brisk ? walk : mob, rest
        ],
    };
    return [
      for (final (i, d) in days.indexed)
        TrainingDay(i + 1, d.type, d.exerciseIds, d.minutes),
    ];
  }
}
