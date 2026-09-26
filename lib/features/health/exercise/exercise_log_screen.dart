import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/health.dart';
import '../../../domain/services/health_stats.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/async_view.dart';
import '../../../shared/widgets/empty_state.dart';
import '../health_providers.dart';
import '../widgets/add_record_sheet.dart' show confirmDelete;
import '../widgets/health_widgets.dart';

/// Manual exercise log. The guided library and camera tracking arrive in
/// Phase 7; this records what the user did.
class ExerciseLogScreen extends ConsumerWidget {
  const ExerciseLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = HealthFormat.of(
        context, ref.watch(settingsControllerProvider).unitSystem);
    final week = Days.lastDays(ref.watch(clockProvider)(), 7);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.featureExercise)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          showDragHandle: true,
          builder: (_) => const _AddExerciseSheet(),
        ),
        icon: const Icon(Icons.add),
        label: Text(l10n.exerciseAdd),
      ),
      body: AsyncView(
        value: ref.watch(exercisesProvider),
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: EmptyState(
                icon: Icons.fitness_center,
                title: l10n.featureExercise,
                message: l10n.exerciseEmpty,
              ),
            );
          }
          final weekMinutes = entries
              .where((e) => week.contains(Days.key(e.performedAt)))
              .fold(0, (s, e) => s + e.durationMinutes);
          return ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.fitness_center),
                  title: Text(l10n.exerciseThisWeek),
                  subtitle: Text(format.minutes(weekMinutes)),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final e in entries)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(e.name),
                  subtitle: Text([
                    exerciseCategoryLabel(l10n, e.category),
                    format.day(e.performedAt),
                    format.minutes(e.durationMinutes),
                    if (e.sets != null && e.reps != null)
                      l10n.setsReps(e.sets!, e.reps!),
                  ].join(' · ')),
                  trailing: IconButton(
                    tooltip: l10n.actionDelete,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      if (await confirmDelete(context)) {
                        await ref.read(exerciseRepositoryProvider).delete(e.id);
                      }
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _AddExerciseSheet extends ConsumerStatefulWidget {
  const _AddExerciseSheet();

  @override
  ConsumerState<_AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends ConsumerState<_AddExerciseSheet> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _minutes = TextEditingController();
  final _sets = TextEditingController();
  final _reps = TextEditingController();
  ExerciseCategory _category = ExerciseCategory.generalFitness;
  late DateTime _at = ref.read(clockProvider)();
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _minutes, _sets, _reps]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(exerciseRepositoryProvider).add(
            name: _name.text,
            category: _category,
            durationMinutes: parsePositive(_minutes.text)!.round(),
            sets: parsePositive(_sets.text)?.round(),
            reps: parsePositive(_reps.text)?.round(),
            performedAt: _at,
          );
      navigator.pop();
    } catch (e, st) {
      AppLogger.error('exercise.add', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = HealthFormat.of(
        context, ref.watch(settingsControllerProvider).unitSystem);
    String? required(String? v) =>
        (v == null || v.trim().isEmpty) ? l10n.validationRequired : null;

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl),
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.exerciseAdd,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                key: const Key('exercise-name'),
                controller: _name,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.exerciseName),
                validator: required,
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<ExerciseCategory>(
                initialValue: _category,
                decoration: InputDecoration(labelText: l10n.exerciseCategory),
                items: [
                  for (final c in ExerciseCategory.values)
                    DropdownMenuItem(
                        value: c, child: Text(exerciseCategoryLabel(l10n, c))),
                ],
                onChanged: (c) => setState(() => _category = c!),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                key: const Key('exercise-minutes'),
                controller: _minutes,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: l10n.durationLabel,
                    suffixText: l10n.unitMinutesShort),
                validator: (v) {
                  final n = parsePositive(v ?? '');
                  return (n == null || n > 1440)
                      ? l10n.validationRange('1', '1440')
                      : null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sets,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: l10n.setsLabel),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _reps,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: l10n.repsLabel),
                    ),
                  ),
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule),
                title: Text(l10n.fieldTime),
                subtitle: Text('${format.day(_at)} · ${format.time(_at)}'),
                onTap: () async {
                  final t = await pickDateTime(context, _at);
                  if (t != null) setState(() => _at = t);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(l10n.actionSave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
