import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/exercise_library.dart';
import '../../domain/services/workout_plan.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/async_view.dart';
import '../content/content_providers.dart';
import '../health/health_providers.dart';
import '../health/widgets/health_widgets.dart';
import 'figure/exercise_visual.dart';
import 'workout_ranking.dart';
import '../../domain/services/training_engine.dart';
import '../training/training_providers.dart';
import '../training/training_screen.dart';

/// The name shown for a program; plan days get a localized session title.
String programTitle(WidgetRef ref, AppLocalizations l10n, WorkoutProgram p, String lang) {
  final wd = planWeekdayOf(p.id);
  if (wd == null) return LibraryExercise.pick(p.title, lang);
  final day = ref.read(trainingWeekProvider).where((d) => d.weekday == wd).firstOrNull;
  return day == null ? l10n.trainingTitle : sessionTitle(l10n, day);
}

String _levelLabel(AppLocalizations l10n, String level) => switch (level) {
      'intermediate' => l10n.levelIntermediate,
      'expert' || 'advanced' => l10n.levelAdvanced,
      _ => l10n.levelBeginner,
    };

/// Guided routines: built in, plus those from installed packs.
class WorkoutsScreen extends ConsumerWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final packs = ref.watch(installedPacksProvider).value ?? const [];
    final usage = ref.watch(workoutUsageProvider).value ?? const WorkoutUsage();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.workoutsTitle),
        actions: [
          IconButton(
            key: const Key('workouts-library'),
            tooltip: l10n.exerciseLibrary,
            onPressed: () => context.push(AppRoutes.exerciseLibrary),
            icon: const Icon(Icons.menu_book_outlined),
          ),
          IconButton(
            key: const Key('workouts-log'),
            tooltip: l10n.workoutsLog,
            onPressed: () => context.push(AppRoutes.exercise),
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: AsyncView(
        value: ref.watch(programCatalogProvider),
        data: (all) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Card(
              key: const Key('open-training'),
              color: theme.colorScheme.primaryContainer,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: ListTile(
                leading: Icon(Icons.calendar_month, color: theme.colorScheme.onPrimaryContainer),
                title: Text(l10n.trainingTitle),
                subtitle: Text(l10n.trainingEntryInfo),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.training),
              ),
            ),
            for (final p in rankWorkouts(all, usage))
              Card(
                key: Key('workout-${p.id}'),
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(categoryIcon(p.category), color: theme.colorScheme.onPrimaryContainer),
                  ),
                  title: Text(programTitle(ref, l10n, p, lang)),
                  subtitle: Text([
                    l10n.workoutMinutes(p.minutes),
                    exerciseCategoryLabel(l10n, p.category),
                    _levelLabel(l10n, p.level),
                  ].join(' · ')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('${AppRoutes.programs}/${p.id}'),
                ),
              ),
            if (packs.length < 6) ...[
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.content),
                icon: const Icon(Icons.download_for_offline_outlined),
                label: Text(l10n.workoutsMore),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ProgramDetailScreen extends ConsumerStatefulWidget {
  const ProgramDetailScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ProgramDetailScreen> createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends ConsumerState<ProgramDetailScreen> {
  String get id => widget.id;

  @override
  void initState() {
    super.initState();
    // Opening a workout counts toward its place in the lists.
    ref.read(workoutUsageRecorderProvider).opened(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final programs = ref.watch(programCatalogProvider);
    final playable = ref.watch(playableProgramsProvider);
    final exercises = ref.watch(exerciseCatalogProvider);
    return AsyncView(
      value: programs,
      data: (_) {
        final all = playable;
        final p = all.where((x) => x.id == id).firstOrNull;
        final byId = {for (final e in exercises.value ?? const <LibraryExercise>[]) e.id: e};
        if (p == null) return Scaffold(appBar: AppBar(), body: Center(child: Text(l10n.loadErrorBody)));
        return Scaffold(
          appBar: AppBar(title: Text(programTitle(ref, l10n, p, lang))),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(LibraryExercise.pick(p.summary, lang), style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(spacing: AppSpacing.sm, children: [
                Chip(avatar: const Icon(Icons.timer_outlined, size: 18), label: Text(l10n.workoutMinutes(p.minutes))),
                Chip(label: Text(_levelLabel(l10n, p.level))),
                if (p.rounds > 1) Chip(label: Text(l10n.workoutRounds(p.rounds))),
              ]),
              if (p.note.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Card(
                  color: theme.colorScheme.tertiaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Icon(Icons.info_outline, color: theme.colorScheme.onTertiaryContainer),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(LibraryExercise.pick(p.note, lang),
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: theme.colorScheme.onTertiaryContainer)),
                      ),
                    ]),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              for (final s in p.steps)
                if (byId[s.exercise] case final e?)
                  Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: ListTile(
                      leading: SizedBox.square(dimension: 48, child: ExerciseVisual(exercise: e, still: true)),
                      title: Text(LibraryExercise.pick(e.name, lang)),
                      subtitle: Text([
                        if (s.seconds != null) l10n.workoutSeconds(s.seconds!) else l10n.workoutReps(s.reps ?? 10),
                        if (s.sides) l10n.workoutEachSide,
                      ].join(' · ')),
                      onTap: () => context.push('${AppRoutes.exerciseLibrary}/${Uri.encodeComponent(e.id)}'),
                    ),
                  ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                key: const Key('start-workout'),
                onPressed: () => context.push('${AppRoutes.programs}/${p.id}/play'),
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.workoutStart),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.exerciseSafetyNote, style: theme.textTheme.bodySmall),
            ],
          ),
        );
      },
    );
  }
}

/// Plays a program: get ready, then work and rest with a big timer and the
/// figure moving. Logs the session when it's finished.
class WorkoutPlayerScreen extends ConsumerStatefulWidget {
  const WorkoutPlayerScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends ConsumerState<WorkoutPlayerScreen> {
  List<WorkoutSegment>? _segments;
  WorkoutProgram? _program;
  var _index = 0;
  var _left = 0;
  var _paused = false;
  var _done = false;
  var _saved = false;
  var _elapsed = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setup(WorkoutProgram p) {
    _program = p;
    _segments = workoutSegments(p);
    _enter(0);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _enter(int i) {
    final segs = _segments!;
    if (i >= segs.length) {
      _finish();
      return;
    }
    _index = i.clamp(0, segs.length - 1);
    _left = segs[_index].seconds ?? 0;
  }

  void _tick() {
    if (_paused || _done || !mounted) return;
    setState(() {
      _elapsed++;
      final seg = _segments![_index];
      if (seg.seconds == null) return; // reps: waits for Done
      _left--;
      if (_left <= 3 && _left > 0) HapticFeedback.selectionClick();
      if (_left <= 0) {
        HapticFeedback.mediumImpact();
        _enter(_index + 1);
      }
    });
  }

  void _go(int delta) => setState(() {
        HapticFeedback.lightImpact();
        _enter(_index + delta < 0 ? 0 : _index + delta);
      });

  SessionFeel? _feel;
  String? _feelNote;

  Future<void> _recordFeel(SessionFeel f) async {
    final l10n = AppLocalizations.of(context);
    final wd = planWeekdayOf(_program!.id);
    final day = ref.read(trainingWeekProvider).where((d) => d.weekday == wd).firstOrNull;
    if (day == null) return;
    setState(() => _feel = f);
    try {
      final up = await ref.read(trainingActionsProvider).recordFeel(day, f);
      if (!mounted) return;
      setState(() => _feelNote = up != null
          ? l10n.feelLevelUp(levelLabel(l10n, up))
          : switch (f) {
              SessionFeel.tooEasy => l10n.feelNoteHarder,
              SessionFeel.justRight => l10n.feelNoteSteady,
              SessionFeel.tooHard => l10n.feelNoteEasier,
            });
    } catch (e, st) {
      AppLogger.error('training.feel', e, st);
    }
  }

  Future<void> _finish() async {
    _done = true;
    _timer?.cancel();
    final p = _program!;
    final lang = Localizations.localeOf(context).languageCode;
    try {
      await ref.read(exerciseRepositoryProvider).add(
            name: programTitle(ref, AppLocalizations.of(context), p, lang),
            category: p.category,
            durationMinutes: (_elapsed / 60).ceil().clamp(1, 600),
            performedAt: ref.read(clockProvider)(),
          );
      await ref.read(workoutUsageRecorderProvider).finished(p.id);
      if (mounted) setState(() => _saved = true);
    } catch (e, st) {
      AppLogger.error('workout.save', e, st);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final programs = ref.watch(programCatalogProvider).value == null
        ? null
        : ref.watch(playableProgramsProvider);
    final exercises = ref.watch(exerciseCatalogProvider).value;
    if (_program == null && programs != null && exercises != null) {
      final p = programs.where((x) => x.id == widget.id).firstOrNull;
      if (p != null) _setup(p);
    }
    final segs = _segments;
    if (segs == null || exercises == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }
    final byId = {for (final e in exercises) e.id: e};
    final p = _program!;

    if (_done) {
      return Scaffold(
        appBar: AppBar(title: Text(programTitle(ref, l10n, p, lang))),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.emoji_events_outlined, size: 72, color: theme.colorScheme.primary),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.workoutDone, style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.workoutDoneMinutes((_elapsed / 60).ceil().clamp(1, 600)), textAlign: TextAlign.center),
              if (_saved) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(l10n.savedToLog, style: theme.textTheme.bodySmall),
              ],
              if (planWeekdayOf(p.id) != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.feelQuestion, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final (f, text, icon) in [
                      (SessionFeel.tooEasy, l10n.feelTooEasy, Icons.sentiment_very_satisfied),
                      (SessionFeel.justRight, l10n.feelJustRight, Icons.sentiment_satisfied),
                      (SessionFeel.tooHard, l10n.feelTooHard, Icons.sentiment_dissatisfied),
                    ])
                      ChoiceChip(
                        key: Key('feel-${f.name}'),
                        avatar: Icon(icon, size: 18),
                        label: Text(text),
                        selected: _feel == f,
                        onSelected: _feel != null ? null : (_) => _recordFeel(f),
                      ),
                  ],
                ),
                if (_feelNote != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(_feelNote!, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                ],
              ],
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                key: const Key('workout-finish'),
                onPressed: () => context.pop(),
                child: Text(l10n.actionDone),
              ),
            ]),
          ),
        ),
      );
    }

    final seg = segs[_index];
    final e = byId[seg.exercise];
    final work = seg.kind == SegmentKind.work;
    final headline = switch (seg.kind) {
      SegmentKind.ready => l10n.workoutGetReady,
      SegmentKind.rest => l10n.workoutRest,
      SegmentKind.work => e == null ? '' : LibraryExercise.pick(e.name, lang),
    };
    final nextWork = segs.skip(_index + 1).where((s) => s.kind == SegmentKind.work).firstOrNull;
    final upNext = work
        ? (nextWork == null ? null : byId[nextWork.exercise])
        : e;
    final progress = (_index + 1) / segs.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(LibraryExercise.pick(p.title, lang)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: progress),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(children: [
            if (p.rounds > 1)
              Text(l10n.workoutRoundOf(seg.round, p.rounds), style: theme.textTheme.labelLarge),
            Text(headline,
                key: const Key('segment-title'),
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            if (work && seg.side != null)
              Text(l10n.workoutSide(seg.side!), style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: e == null
                  ? const SizedBox.shrink()
                  : Opacity(
                      opacity: work ? 1 : 0.55,
                      child: ExerciseVisual(exercise: e, playing: work && !_paused),
                    ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              seg.seconds != null ? '$_left' : l10n.workoutReps(seg.reps ?? 10),
              key: const Key('segment-counter'),
              style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: work ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant),
            ),
            if (upNext != null && seg.kind != SegmentKind.ready)
              Text(l10n.workoutUpNext(LibraryExercise.pick(upNext.name, lang)),
                  style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              IconButton.outlined(
                tooltip: l10n.workoutPrevious,
                onPressed: _index > 0 ? () => _go(-1) : null,
                icon: const Icon(Icons.skip_previous),
              ),
              if (seg.seconds == null)
                FilledButton.icon(
                  key: const Key('segment-done'),
                  onPressed: () => _go(1),
                  icon: const Icon(Icons.check),
                  label: Text(l10n.actionDone),
                )
              else
                IconButton.filled(
                  key: const Key('workout-pause'),
                  iconSize: 36,
                  tooltip: _paused ? l10n.workoutResume : l10n.workoutPause,
                  onPressed: () => setState(() => _paused = !_paused),
                  icon: Icon(_paused ? Icons.play_arrow : Icons.pause),
                ),
              IconButton.outlined(
                key: const Key('workout-skip'),
                tooltip: l10n.workoutSkip,
                onPressed: () => _go(1),
                icon: const Icon(Icons.skip_next),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
