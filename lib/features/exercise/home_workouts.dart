import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/exercise_library.dart';
import '../../l10n/app_localizations.dart';
import '../content/content_providers.dart';
import 'figure/exercise_visual.dart';
import 'workout_ranking.dart';

/// Home: "Let's try …" for the user's go-to workout, then every guided
/// workout in ranked order (most used, then most popular).
class HomeWorkouts extends ConsumerWidget {
  const HomeWorkouts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final lang = Localizations.localeOf(context).languageCode;
    final ranked = ref.watch(rankedWorkoutsProvider);
    final tryNext = ref.watch(letsTryWorkoutProvider);
    if (ranked.isEmpty || tryNext == null) return const SizedBox.shrink();
    final exercises = {
      for (final e in ref.watch(exerciseCatalogProvider).value ?? const <LibraryExercise>[]) e.id: e,
    };
    LibraryExercise? firstOf(WorkoutProgram p) =>
        p.steps.isEmpty ? null : exercises[p.steps.first.exercise];
    final (pick, fromHabit) = tryNext;
    final pickFirst = firstOf(pick);

    return Column(
      key: const Key('home-workouts'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          key: const Key('lets-try'),
          color: scheme.primaryContainer,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.push('${AppRoutes.programs}/${pick.id}'),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(children: [
                SizedBox.square(
                  dimension: 72,
                  child: pickFirst == null
                      ? Icon(Icons.fitness_center, size: 40, color: scheme.onPrimaryContainer)
                      : ExerciseVisual(exercise: pickFirst, still: false),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.letsTry(LibraryExercise.pick(pick.title, lang)),
                        style: theme.textTheme.titleMedium?.copyWith(color: scheme.onPrimaryContainer),
                      ),
                      Text(
                        [
                          l.workoutMinutes(pick.minutes),
                          fromHabit ? l.letsTryYourFavourite : l.letsTryPopular,
                        ].join(' · '),
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onPrimaryContainer),
                      ),
                    ],
                  ),
                ),
                IconButton.filled(
                  key: const Key('lets-try-start'),
                  tooltip: l.workoutStart,
                  onPressed: () {
                    ref.read(workoutUsageRecorderProvider).opened(pick.id);
                    context.push('${AppRoutes.programs}/${pick.id}/play');
                  },
                  icon: const Icon(Icons.play_arrow),
                ),
              ]),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(children: [
          Expanded(child: Text(l.workoutsTitle, style: theme.textTheme.titleMedium)),
          TextButton(
            key: const Key('home-workouts-all'),
            onPressed: () => context.push(AppRoutes.programs),
            child: Text(l.skillsSeeAll),
          ),
        ]),
        SizedBox(
          height: 168,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ranked.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (_, i) {
              final p = ranked[i];
              final first = firstOf(p);
              return SizedBox(
                width: 150,
                child: Card(
                  key: Key('home-workout-${p.id}'),
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => context.push('${AppRoutes.programs}/${p.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 92,
                          width: double.infinity,
                          color: scheme.secondaryContainer,
                          padding: const EdgeInsets.all(6),
                          child: first == null
                              ? Icon(Icons.fitness_center, color: scheme.onSecondaryContainer)
                              : ExerciseVisual(exercise: first, still: true),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
                          child: Text(
                            LibraryExercise.pick(p.title, lang),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
                          child: Text(
                            l.workoutMinutes(p.minutes),
                            style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                          ),
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
