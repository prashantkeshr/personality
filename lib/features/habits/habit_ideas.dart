import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/health.dart';
import '../../l10n/app_localizations.dart';

enum HabitIdeaGroup { food, body, mind, sleep }

/// A common habit to start from. Picking one opens the habit editor with it
/// filled in, so the name and days can be changed before it's added.
enum HabitIdea {
  waterOnWaking(HabitIdeaGroup.food, Icons.water_drop_outlined),
  fruitDaily(HabitIdeaGroup.food, Icons.apple),
  vegEveryMeal(HabitIdeaGroup.food, Icons.eco_outlined),
  homeCooked(HabitIdeaGroup.food, Icons.soup_kitchen_outlined),
  noSugaryDrinks(HabitIdeaGroup.food, Icons.no_drinks_outlined),
  walkAfterMeals(HabitIdeaGroup.body, Icons.directions_walk),
  stretchMorning(HabitIdeaGroup.body, Icons.self_improvement),
  stairs(HabitIdeaGroup.body, Icons.stairs_outlined),
  read10(HabitIdeaGroup.mind, Icons.menu_book_outlined),
  breathe(HabitIdeaGroup.mind, Icons.air),
  gratitude(HabitIdeaGroup.mind, Icons.favorite_outline),
  noScreensBed(HabitIdeaGroup.sleep, Icons.phonelink_off),
  sameBedtime(HabitIdeaGroup.sleep, Icons.bedtime_outlined),
  skincareNight(HabitIdeaGroup.sleep, Icons.face_retouching_natural);

  const HabitIdea(this.group, this.icon);
  final HabitIdeaGroup group;
  final IconData icon;

  /// Most ideas are daily; a few fit working days better.
  Weekdays get days => switch (this) {
    HabitIdea.stairs => const Weekdays(0x1F),
    _ => Weekdays.everyDay,
  };

  String label(AppLocalizations l) => switch (this) {
    waterOnWaking => l.ideaWaterOnWaking,
    fruitDaily => l.ideaFruitDaily,
    vegEveryMeal => l.ideaVegEveryMeal,
    homeCooked => l.ideaHomeCooked,
    noSugaryDrinks => l.ideaNoSugaryDrinks,
    walkAfterMeals => l.ideaWalkAfterMeals,
    stretchMorning => l.ideaStretchMorning,
    stairs => l.ideaStairs,
    read10 => l.ideaRead10,
    breathe => l.ideaBreathe,
    gratitude => l.ideaGratitude,
    noScreensBed => l.ideaNoScreensBed,
    sameBedtime => l.ideaSameBedtime,
    skincareNight => l.ideaSkincareNight,
  };
}

String ideaGroupLabel(AppLocalizations l, HabitIdeaGroup g) => switch (g) {
  HabitIdeaGroup.food => l.ideaGroupFood,
  HabitIdeaGroup.body => l.ideaGroupBody,
  HabitIdeaGroup.mind => l.ideaGroupMind,
  HabitIdeaGroup.sleep => l.ideaGroupSleep,
};

/// Lists the ideas by group; returns the one picked.
Future<HabitIdea?> showHabitIdeas(
  BuildContext context, {
  Set<String> existing = const {},
}) => showModalBottomSheet<HabitIdea>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (c) {
    final l = AppLocalizations.of(c);
    final theme = Theme.of(c);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (_, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          Text(l.ideasTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.ideasIntro,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          for (final g in HabitIdeaGroup.values) ...[
            const SizedBox(height: AppSpacing.md),
            Text(ideaGroupLabel(l, g), style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final idea in HabitIdea.values.where((i) => i.group == g))
                  ActionChip(
                    key: Key('idea-${idea.name}'),
                    avatar: Icon(
                      existing.contains(idea.label(l).toLowerCase())
                          ? Icons.check
                          : idea.icon,
                      size: 18,
                    ),
                    label: Text(idea.label(l)),
                    onPressed: () => Navigator.pop(c, idea),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  },
);
