import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/exercise_library.dart';
import '../../l10n/app_localizations.dart';
import '../content/content_providers.dart';
import '../health/health_providers.dart';
import 'figure/exercise_visual.dart';
import 'my_workouts.dart';

/// Build (or edit) a workout: pick exercises in order, each with reps or a
/// time, rest and "each side"; set the rounds; save. It then shows up in
/// the workout lists and plays like any other workout.
class WorkoutBuilderScreen extends ConsumerStatefulWidget {
  const WorkoutBuilderScreen({super.key, this.id});

  /// The workout being edited; null for a new one.
  final String? id;

  @override
  ConsumerState<WorkoutBuilderScreen> createState() => _WorkoutBuilderScreenState();
}

class _WorkoutBuilderScreenState extends ConsumerState<WorkoutBuilderScreen> {
  final _name = TextEditingController();
  var _steps = <ProgramStep>[];
  var _rounds = 1;
  var _loaded = false;
  var _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _loadExisting(List<WorkoutProgram> mine) {
    if (_loaded) return;
    final p = mine.where((x) => x.id == widget.id).firstOrNull;
    if (widget.id != null && p == null) return; // still loading
    _loaded = true;
    if (p != null) {
      _name.text = LibraryExercise.pick(p.title, 'en');
      _steps = [...p.steps];
      _rounds = p.rounds;
    }
  }

  void _update(int i, ProgramStep s) => setState(() => _steps[i] = s);

  ProgramStep _with(ProgramStep s, {bool? timed, int? amount, int? rest, bool? sides}) {
    final isTimed = timed ?? (s.seconds != null);
    final value = amount ??
        (timed == null ? (isTimed ? s.seconds : s.reps) : (isTimed ? 30 : 10));
    return ProgramStep(
      exercise: s.exercise,
      seconds: isTimed ? value : null,
      reps: isTimed ? null : value,
      rest: rest ?? s.rest,
      sides: sides ?? s.sides,
    );
  }

  Future<void> _add(List<LibraryExercise> all) async {
    final picked = await showModalBottomSheet<LibraryExercise>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _ExercisePicker(all: all),
    );
    if (picked == null) return;
    setState(() => _steps = [
          ..._steps,
          ProgramStep(exercise: picked.id, reps: 10, rest: 20),
        ]);
  }

  Future<void> _save(Map<String, LibraryExercise> byId) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      final id = await ref.read(myWorkoutActionsProvider).save(
            id: widget.id,
            name: _name.text.trim(),
            steps: _steps,
            rounds: _rounds,
            category: categoryFor(_steps, byId),
            now: ref.read(clockProvider)(),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.builderSaved)));
      if (widget.id != null) {
        context.pop();
      } else {
        context.pushReplacement('${AppRoutes.programs}/$id');
      }
    } catch (e, st) {
      AppLogger.error('myworkout.save', e, st);
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.builderDeleteAsk),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.actionCancel)),
          FilledButton(
            key: const Key('builder-delete-confirm'),
            onPressed: () => Navigator.pop(c, true),
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await ref.read(myWorkoutActionsProvider).delete(widget.id!);
    if (mounted) context.go(AppRoutes.programs);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final all = ref.watch(exerciseCatalogProvider).value ?? const <LibraryExercise>[];
    _loadExisting(ref.watch(myWorkoutsProvider).value ?? const []);
    final byId = {for (final e in all) e.id: e};
    final valid = _name.text.trim().isNotEmpty && _steps.isNotEmpty;
    final preview = WorkoutProgram(
      id: 'preview',
      title: const {},
      summary: const {},
      category: categoryFor(_steps, byId),
      steps: _steps,
      rounds: _rounds,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? l10n.builderTitle : l10n.builderEditTitle),
        actions: [
          if (widget.id != null)
            IconButton(
              key: const Key('builder-delete'),
              tooltip: l10n.actionDelete,
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
            ),
          TextButton(
            key: const Key('builder-save'),
            onPressed: valid && !_saving ? () => _save(byId) : null,
            child: Text(l10n.actionSave),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          TextField(
            key: const Key('builder-name'),
            controller: _name,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 40,
            decoration: InputDecoration(labelText: l10n.builderName, border: const OutlineInputBorder()),
            onChanged: (_) => setState(() {}),
          ),
          Row(children: [
            Text(l10n.builderRoundsLabel, style: theme.textTheme.titleSmall),
            const Spacer(),
            _Stepper(
              id: 'rounds',
              value: '$_rounds',
              onMinus: _rounds > 1 ? () => setState(() => _rounds--) : null,
              onPlus: _rounds < 6 ? () => setState(() => _rounds++) : null,
            ),
          ]),
          const SizedBox(height: AppSpacing.sm),
          if (_steps.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Text(l10n.builderEmpty,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ),
          for (final (i, s) in _steps.indexed)
            _StepCard(
              key: Key('builder-step-$i'),
              index: i,
              step: s,
              exercise: byId[s.exercise],
              lang: lang,
              isFirst: i == 0,
              isLast: i == _steps.length - 1,
              onTimed: (t) => _update(i, _with(s, timed: t)),
              onAmount: (v) => _update(i, _with(s, amount: v)),
              onRest: (v) => _update(i, _with(s, rest: v)),
              onSides: (v) => _update(i, _with(s, sides: v)),
              onMove: (d) => setState(() {
                final x = _steps.removeAt(i);
                _steps.insert(i + d, x);
              }),
              onRemove: () => setState(() => _steps.removeAt(i)),
            ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            key: const Key('builder-add'),
            onPressed: all.isEmpty ? null : () => _add(all),
            icon: const Icon(Icons.add),
            label: Text(l10n.builderAdd),
          ),
          const SizedBox(height: AppSpacing.md),
          if (_steps.isNotEmpty)
            Text(
              [l10n.workoutMinutes(preview.minutes), if (_rounds > 1) l10n.workoutRounds(_rounds)].join(' · '),
              key: const Key('builder-total'),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
          if (!valid)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(l10n.builderHint,
                  textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
            ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    super.key,
    required this.index,
    required this.step,
    required this.exercise,
    required this.lang,
    required this.isFirst,
    required this.isLast,
    required this.onTimed,
    required this.onAmount,
    required this.onRest,
    required this.onSides,
    required this.onMove,
    required this.onRemove,
  });

  final int index;
  final ProgramStep step;
  final LibraryExercise? exercise;
  final String lang;
  final bool isFirst;
  final bool isLast;
  final ValueChanged<bool> onTimed;
  final ValueChanged<int> onAmount;
  final ValueChanged<int> onRest;
  final ValueChanged<bool> onSides;
  final ValueChanged<int> onMove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final timed = step.seconds != null;
    final amount = timed ? step.seconds! : (step.reps ?? 10);
    final (stepBy, min, max) = timed ? (5, 10, 300) : (1, 1, 50);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.xs, AppSpacing.sm),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            if (exercise != null)
              SizedBox.square(dimension: 44, child: ExerciseVisual(exercise: exercise!, still: true)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                '${index + 1}. ${exercise == null ? step.exercise : LibraryExercise.pick(exercise!.name, lang)}',
                style: theme.textTheme.titleSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              tooltip: l10n.builderMoveUp,
              onPressed: isFirst ? null : () => onMove(-1),
              icon: const Icon(Icons.arrow_upward, size: 20),
            ),
            IconButton(
              tooltip: l10n.builderMoveDown,
              onPressed: isLast ? null : () => onMove(1),
              icon: const Icon(Icons.arrow_downward, size: 20),
            ),
            IconButton(
              key: Key('builder-remove-$index'),
              tooltip: l10n.builderRemove,
              onPressed: onRemove,
              icon: const Icon(Icons.close, size: 20),
            ),
          ]),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SegmentedButton<bool>(
                key: Key('builder-kind-$index'),
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: false, label: Text(l10n.builderReps)),
                  ButtonSegment(value: true, label: Text(l10n.builderTime)),
                ],
                selected: {timed},
                onSelectionChanged: (v) => onTimed(v.first),
              ),
              _Stepper(
                id: 'amount-$index',
                value: timed ? l10n.workoutSeconds(amount) : l10n.workoutReps(amount),
                onMinus: amount - stepBy >= min ? () => onAmount(amount - stepBy) : null,
                onPlus: amount + stepBy <= max ? () => onAmount(amount + stepBy) : null,
              ),
              _Stepper(
                id: 'rest-$index',
                value: l10n.builderRest(step.rest),
                onMinus: step.rest >= 5 ? () => onRest(step.rest - 5) : null,
                onPlus: step.rest <= 115 ? () => onRest(step.rest + 5) : null,
              ),
              FilterChip(
                key: Key('builder-sides-$index'),
                label: Text(l10n.builderEachSide),
                selected: step.sides,
                onSelected: onSides,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.id, required this.value, this.onMinus, this.onPlus});
  final String id;
  final String value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
          key: Key('builder-$id-minus'),
          onPressed: onMinus,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(value, key: Key('builder-$id-value')),
        IconButton(
          key: Key('builder-$id-plus'),
          onPressed: onPlus,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ]);
}

/// Searchable list of every exercise (built in and from installed packs).
class _ExercisePicker extends StatefulWidget {
  const _ExercisePicker({required this.all});
  final List<LibraryExercise> all;

  @override
  State<_ExercisePicker> createState() => _ExercisePickerState();
}

class _ExercisePickerState extends State<_ExercisePicker> {
  var _q = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final q = _q.trim().toLowerCase();
    final list = [
      for (final e in widget.all)
        if (q.isEmpty ||
            LibraryExercise.pick(e.name, lang).toLowerCase().contains(q) ||
            LibraryExercise.pick(e.name, 'en').toLowerCase().contains(q))
          e,
    ]..sort((a, b) => LibraryExercise.pick(a.name, lang).compareTo(LibraryExercise.pick(b.name, lang)));
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: TextField(
            key: const Key('picker-search'),
            decoration: InputDecoration(
              hintText: l10n.builderSearch,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _q = v),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final e = list[i];
              return ListTile(
                key: Key('pick-${e.id}'),
                leading: SizedBox.square(dimension: 40, child: ExerciseVisual(exercise: e, still: true)),
                title: Text(LibraryExercise.pick(e.name, lang)),
                onTap: () => Navigator.pop(context, e),
              );
            },
          ),
        ),
      ]),
    );
  }
}
