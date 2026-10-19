import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/health.dart';
import '../../../domain/services/meal_planner.dart';
import '../../../domain/services/nutrition_engine.dart';
import '../../../l10n/app_localizations.dart';
import '../../plans/plan_providers.dart';
import '../body_providers.dart';
import '../health_providers.dart';
import 'meals_screen.dart' show suggestMealType;

MealSlot slotFor(MealType t) => switch (t) {
  MealType.breakfast => MealSlot.breakfast,
  MealType.lunch => MealSlot.lunch,
  MealType.dinner => MealSlot.dinner,
  _ => MealSlot.snack,
};

MealType typeFor(MealSlot s) => switch (s) {
  MealSlot.breakfast => MealType.breakfast,
  MealSlot.lunch => MealType.lunch,
  MealSlot.snack => MealType.snack,
  MealSlot.dinner => MealType.dinner,
};

String slotLabel(AppLocalizations l, MealSlot s) => switch (s) {
  MealSlot.breakfast => l.mealBreakfast,
  MealSlot.lunch => l.mealLunch,
  MealSlot.snack => l.mealSnack,
  MealSlot.dinner => l.mealDinner,
};

int _daysSince2020(DateTime now) =>
    DateTime(now.year, now.month, now.day).difference(DateTime(2020)).inDays;

/// A few dishes for the meal that fits right now, from the user's diet and
/// region (local cuisine first), rotating daily so the list stays fresh.
final mealIdeasProvider = Provider<(MealSlot, List<MealOption>)?>((ref) {
  final library = ref.watch(mealLibraryProvider).value;
  if (library == null) return null;
  final now = ref.watch(clockProvider)();
  final profile = ref.watch(profileProvider).value;
  final slot = slotFor(suggestMealType(now));
  final rank = dietRank(profile?.dietPreference);
  final fits =
      [
        for (final m in library)
          if (m.slot == slot && m.diet <= rank) m,
      ]..sort((a, b) {
        final t = cuisineTier(
          a,
          profile?.region,
        ).compareTo(cuisineTier(b, profile?.region));
        return t != 0 ? t : a.id.compareTo(b.id);
      });
  if (fits.isEmpty) return (slot, const []);
  // Local dishes first, then a daily rotation within the best tier.
  final best = fits
      .where(
        (m) =>
            cuisineTier(m, profile?.region) ==
            cuisineTier(fits.first, profile?.region),
      )
      .toList();
  final start = _daysSince2020(now) % best.length;
  final rotated = [...best.sublist(start), ...best.sublist(0, start)];
  final rest = fits.where((m) => !best.contains(m));
  return (slot, [...rotated, ...rest].take(5).toList());
});

/// A balanced sample day: the body plan's targets when there is one, the
/// user's estimated maintenance when height and weight are known, else a
/// common 2,000 kcal day. [offset] moves to another day's combination.
final sampleDayProvider = Provider.family<DayMenu?, int>((ref, offset) {
  final library = ref.watch(mealLibraryProvider).value;
  if (library == null) return null;
  final plan = ref.watch(activeBodyPlanProvider).value;
  final input = ref.watch(nutritionInputProvider);
  final profile = ref.watch(profileProvider).value;
  final now = ref.watch(clockProvider)();
  final (kcal, protein) = plan != null
      ? (plan.calories, plan.proteinG)
      : input != null
      ? (NutritionEngine.maintenance(input), (input.weightKg * 1.0).round())
      : (2000, 60);
  return MealPlanner.day(
    library: library,
    calories: kcal,
    proteinG: protein,
    diet: plan?.diet ?? profile?.dietPreference,
    day: _daysSince2020(now) + offset,
    region: profile?.region,
  );
});

Future<void> logDish(
  BuildContext context,
  WidgetRef ref,
  MealOption meal, {
  double servings = 1,
}) async {
  final l = AppLocalizations.of(context);
  final lang = Localizations.localeOf(context).languageCode;
  final messenger = ScaffoldMessenger.of(context);
  try {
    final portion = servings == 1
        ? meal.portionIn(lang)
        : '${servings.toStringAsFixed(servings % 1 == 0 ? 0 : 2)} × ${meal.portionIn(lang)}';
    await ref
        .read(mealRepositoryProvider)
        .add(
          type: typeFor(meal.slot),
          food: meal.nameIn(lang),
          eatenAt: ref.read(clockProvider)(),
          quantity: portion,
          calories: meal.kcal * servings,
        );
    HapticFeedback.selectionClick();
    messenger.showSnackBar(
      SnackBar(content: Text(l.mealIdeaLogged(meal.nameIn(lang)))),
    );
  } catch (e, st) {
    AppLogger.error('meal.idea', e, st);
    messenger.showSnackBar(SnackBar(content: Text(l.recordSaveError)));
  }
}

/// Meals screen: "Ideas for lunch", swipeable, each loggable in one tap.
class MealIdeasSection extends ConsumerWidget {
  const MealIdeasSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final ideas = ref.watch(mealIdeasProvider);
    if (ideas == null || ideas.$2.isEmpty) return const SizedBox.shrink();
    final (slot, dishes) = ideas;

    return Column(
      key: const Key('meal-ideas'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.mealIdeasFor(slotLabel(l, slot)),
          style: theme.textTheme.titleMedium,
        ),
        Text(
          l.mealIdeasInfo,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dishes.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (_, i) {
              final m = dishes[i];
              return SizedBox(
                width: 200,
                child: Card(
                  key: Key('meal-idea-${m.id}'),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.nameIn(lang),
                          style: theme.textTheme.titleSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          m.portionIn(lang),
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l.mealIdeaNutrition(m.kcal, m.protein),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            IconButton.filledTonal(
                              key: Key('meal-idea-log-${m.id}'),
                              tooltip: l.mealIdeaLog,
                              onPressed: () => logDish(context, ref, m),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// A whole day of meals that fits the user's targets, diet and region.
class SampleDayCard extends ConsumerStatefulWidget {
  const SampleDayCard({super.key});

  @override
  ConsumerState<SampleDayCard> createState() => _SampleDayCardState();
}

class _SampleDayCardState extends ConsumerState<SampleDayCard> {
  int _offset = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final menu = ref.watch(sampleDayProvider(_offset));
    if (menu == null || menu.meals.isEmpty) return const SizedBox.shrink();

    return Card(
      key: const Key('sample-day'),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    l.sampleDayTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  key: const Key('sample-day-next'),
                  onPressed: () => setState(() => _offset++),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(l.sampleDayAnother),
                ),
              ],
            ),
            Text(
              l.sampleDayTotals(menu.kcal, menu.protein),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final p in menu.meals)
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text(p.meal.nameIn(lang)),
                subtitle: Text(
                  '${p.extra ? l.bodyPlanProteinBoost : slotLabel(l, p.meal.slot)}'
                  ' · ${p.servings == 1 ? p.meal.portionIn(lang) : '${p.servings} × ${p.meal.portionIn(lang)}'}'
                  ' · ${l.bodyPlanKcal(p.kcal)}',
                ),
                trailing: IconButton(
                  tooltip: l.mealIdeaLog,
                  onPressed: () =>
                      logDish(context, ref, p.meal, servings: p.servings),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ),
            Text(
              l.sampleDayNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
