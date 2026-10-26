import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/exercise_library.dart';
import '../../domain/services/training_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/clock_format.dart';
import '../content/content_providers.dart';
import '../exercise/figure/exercise_visual.dart';
import '../health/health_providers.dart' show clockProvider;
import 'training_providers.dart';

String sessionLabel(AppLocalizations l, SessionType t) => switch (t) {
  SessionType.fullBody => l.sessionFullBody,
  SessionType.upper => l.sessionUpper,
  SessionType.lower => l.sessionLower,
  SessionType.core => l.sessionCore,
  SessionType.cardio => l.sessionCardio,
  SessionType.mobility => l.sessionMobility,
  SessionType.yoga => l.sessionYoga,
  SessionType.posture => l.sessionPosture,
  SessionType.rest => l.sessionRest,
};

IconData sessionIcon(SessionType t) => switch (t) {
  SessionType.fullBody => Icons.accessibility_new,
  SessionType.upper => Icons.fitness_center,
  SessionType.lower => Icons.directions_walk,
  SessionType.core => Icons.center_focus_strong,
  SessionType.cardio => Icons.directions_run,
  SessionType.mobility => Icons.self_improvement,
  SessionType.yoga => Icons.spa_outlined,
  SessionType.posture => Icons.airline_seat_recline_normal,
  SessionType.rest => Icons.bedtime_outlined,
};

String levelLabel(AppLocalizations l, FitnessLevel v) => switch (v) {
  FitnessLevel.beginner => l.levelBeginner,
  FitnessLevel.intermediate => l.levelIntermediate,
  FitnessLevel.advanced => l.levelAdvanced,
};

/// "3 × 12", "2 × 30 s", "1 × 10 min", with "each side" when needed.
String doseLabel(AppLocalizations l, Prescription p) {
  final amount = switch (p.kind) {
    DoseKind.reps => l.doseReps(p.amount),
    DoseKind.hold => l.doseSeconds(p.amount),
    DoseKind.minutes => l.doseMinutes(p.amount),
  };
  final base = '${p.sets} × $amount';
  return p.sides ? '$base · ${l.workoutEachSide}' : base;
}

String sessionTitle(AppLocalizations l, PlanDay d) => l.planSessionTitle(sessionLabel(l, d.type));

/// Opens today's (or [day]'s) plan session in the player.
void startPlanDay(BuildContext context, PlanDay day) =>
    context.push('${AppRoutes.programs}/${planProgramId(day.weekday)}/play');

class TrainingScreen extends ConsumerStatefulWidget {
  const TrainingScreen({super.key});

  @override
  ConsumerState<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends ConsumerState<TrainingScreen> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final week = ref.watch(trainingWeekProvider);
    final prefs = ref.watch(effectiveTrainingPrefsProvider);
    final today = ref.watch(clockProvider)().weekday;
    final selected = _selected ?? today;
    final day = week.where((d) => d.weekday == selected).firstOrNull;
    final exercises = {
      for (final e in ref.watch(exerciseCatalogProvider).value ?? const <LibraryExercise>[]) e.id: e,
    };
    final lang = Localizations.localeOf(context).languageCode;
    final monday = DateTime(2024, 1, 1); // a Monday, for weekday names

    return Scaffold(
      appBar: AppBar(
        title: Text(l.trainingTitle),
        actions: [
          IconButton(
            key: const Key('training-settings'),
            tooltip: l.trainingSettings,
            onPressed: () => showTrainingSettings(context),
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
        children: [
          Text(
            l.trainingSummary(
              levelLabel(l, prefs.level),
              prefs.daysPerWeek,
              prefs.minutes,
            ),
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.md),
          // The week: tap a day to see it.
          Row(children: [
            for (final d in week)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: InkWell(
                    key: Key('plan-day-${d.weekday}'),
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => setState(() => _selected = d.weekday),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: d.weekday == selected
                            ? scheme.primary
                            : d.isRest
                            ? scheme.surfaceContainerHigh
                            : scheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(14),
                        border: d.weekday == today ? Border.all(color: scheme.primary, width: 2) : null,
                      ),
                      child: Column(children: [
                        Text(
                          shortWeekday(locale, monday.add(Duration(days: d.weekday - 1))),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: d.weekday == selected ? scheme.onPrimary : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Icon(
                          sessionIcon(d.type),
                          size: 18,
                          color: d.weekday == selected ? scheme.onPrimary : scheme.primary,
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
          ]),
          const SizedBox(height: AppSpacing.lg),
          if (day != null) ...[
            Text(
              day.isRest ? l.sessionRest : sessionTitle(l, day),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              day.isRest ? l.planRestInfo : l.planDayInfo(day.exercises.length, day.minutes),
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final p in day.exercises)
              if (exercises[p.exerciseId] case final e?)
                Card(
                  key: Key('plan-ex-${p.exerciseId}'),
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: ListTile(
                    leading: SizedBox.square(dimension: 48, child: ExerciseVisual(exercise: e, still: true)),
                    title: Text(LibraryExercise.pick(e.name, lang)),
                    subtitle: Text(doseLabel(l, p)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('${AppRoutes.exerciseLibrary}/${Uri.encodeComponent(e.id)}'),
                  ),
                ),
            if (!day.isRest) ...[
              const SizedBox(height: AppSpacing.md),
              FilledButton.icon(
                key: const Key('plan-start'),
                onPressed: () => startPlanDay(context, day),
                icon: const Icon(Icons.play_arrow),
                label: Text(l.workoutStart),
              ),
            ],
          ],
          const SizedBox(height: AppSpacing.lg),
          Card(
            color: scheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.trending_up, color: scheme.onTertiaryContainer),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    l.planProgressInfo,
                    style: theme.textTheme.bodySmall?.copyWith(color: scheme.onTertiaryContainer),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(l.exerciseSafetyNote, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// Level, days, minutes, equipment and focus. Used in onboarding and in the
/// plan's settings sheet.
class TrainingPrefsForm extends StatelessWidget {
  const TrainingPrefsForm({super.key, required this.value, required this.onChanged});
  final TrainingPrefs value;
  final ValueChanged<TrainingPrefs> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Widget label(String t) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
      child: Text(t, style: theme.textTheme.labelLarge),
    );
    Widget choices<T>(Key key, List<(T, String)> items, T selected, ValueChanged<T> pick) => Wrap(
      key: key,
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final (v, text) in items)
          ChoiceChip(label: Text(text), selected: v == selected, onSelected: (_) => pick(v)),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label(l.trainingLevel),
        choices(const Key('pref-level'), [
          for (final v in FitnessLevel.values) (v, levelLabel(l, v)),
        ], value.level, (v) => onChanged(value.copyWith(level: v))),
        label(l.trainingDays),
        choices(const Key('pref-days'), [
          for (final d in TrainingPrefs.dayChoices) (d, l.trainingDaysValue(d)),
        ], value.daysPerWeek, (v) => onChanged(value.copyWith(daysPerWeek: v))),
        label(l.trainingMinutes),
        choices(const Key('pref-minutes'), [
          for (final m in TrainingPrefs.minuteChoices) (m, l.workoutMinutes(m)),
        ], value.minutes, (v) => onChanged(value.copyWith(minutes: v))),
        label(l.trainingEquipment),
        choices(const Key('pref-equipment'), [
          (Equipment.none, l.equipmentNone),
          (Equipment.homeBasics, l.equipmentHome),
        ], value.equipment, (v) => onChanged(value.copyWith(equipment: v))),
        label(l.trainingFocus),
        choices(const Key('pref-focus'), [
          (FocusArea.balanced, l.focusBalanced),
          (FocusArea.upper, l.focusUpper),
          (FocusArea.lower, l.focusLower),
        ], value.focus, (v) => onChanged(value.copyWith(focus: v))),
      ],
    );
  }
}

Future<void> showTrainingSettings(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => const _SettingsSheet(),
);

class _SettingsSheet extends ConsumerStatefulWidget {
  const _SettingsSheet();
  @override
  ConsumerState<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends ConsumerState<_SettingsSheet> {
  late TrainingPrefs _value = ref.read(effectiveTrainingPrefsProvider);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.trainingSettings, style: Theme.of(context).textTheme.titleLarge),
            TrainingPrefsForm(value: _value, onChanged: (v) => setState(() => _value = v)),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              key: const Key('training-save'),
              onPressed: () async {
                final nav = Navigator.of(context);
                await ref.read(trainingActionsProvider).savePrefs(_value);
                nav.pop();
              },
              child: Text(l.actionSave),
            ),
          ],
        ),
      ),
    );
  }
}

/// Home: today's plan session, or a rest-day note, with a Start button.
class TodayWorkoutCard extends ConsumerWidget {
  const TodayWorkoutCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final day = ref.watch(todayPlanProvider);
    if (day == null) return const SizedBox.shrink();
    final lang = Localizations.localeOf(context).languageCode;
    final names = {
      for (final e in ref.watch(exerciseCatalogProvider).value ?? const <LibraryExercise>[])
        e.id: LibraryExercise.pick(e.name, lang),
    };
    return Card(
      key: const Key('today-workout'),
      color: day.isRest ? null : scheme.secondaryContainer,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.training),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: scheme.primary,
              child: Icon(sessionIcon(day.type), color: scheme.onPrimary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.todaysWorkout, style: theme.textTheme.labelMedium),
                  Text(
                    day.isRest ? l.sessionRest : sessionTitle(l, day),
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    day.isRest
                        ? l.planRestInfo
                        : day.exercises
                              .take(3)
                              .map((p) => '${names[p.exerciseId] ?? p.exerciseId} ${doseLabel(l, p)}')
                              .join(' · '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (!day.isRest)
              IconButton.filled(
                key: const Key('today-workout-start'),
                tooltip: l.workoutStart,
                onPressed: () => startPlanDay(context, day),
                icon: const Icon(Icons.play_arrow),
              ),
          ]),
        ),
      ),
    );
  }
}
