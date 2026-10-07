import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/features/feature_registry.dart';
import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/exercise_library.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/feature_labels.dart';
import '../health/health_providers.dart';
import '../health/widgets/health_widgets.dart';

/// Data-driven exercise library (spec §18, §71).
final exerciseCatalogProvider =
    FutureProvider<List<LibraryExercise>>((ref) async {
  final raw = await rootBundle.loadString('assets/content/exercises.json', cache: false);
  return [
    for (final e in jsonDecode(raw) as List)
      LibraryExercise.fromJson(e as Map<String, dynamic>),
  ];
});

class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  const ExerciseLibraryScreen({super.key, this.cameraOnly = false});

  final bool cameraOnly;

  @override
  ConsumerState<ExerciseLibraryScreen> createState() =>
      _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends ConsumerState<ExerciseLibraryScreen> {
  late bool _cameraOnly = widget.cameraOnly;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.exerciseLibrary)),
      body: AsyncView(
        value: ref.watch(exerciseCatalogProvider),
        data: (all) {
          final list = _cameraOnly ? all.where((e) => e.trackable).toList() : all;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Wrap(spacing: AppSpacing.sm, children: [
                ChoiceChip(
                  label: Text(l10n.filterAll),
                  selected: !_cameraOnly,
                  onSelected: (_) => setState(() => _cameraOnly = false),
                ),
                ChoiceChip(
                  avatar: const Icon(Icons.videocam_outlined, size: 18),
                  label: Text(l10n.filterCameraTracked),
                  selected: _cameraOnly,
                  onSelected: (_) => setState(() => _cameraOnly = true),
                ),
              ]),
              const SizedBox(height: AppSpacing.md),
              for (final e in list)
                Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    leading: Icon(e.trackable
                        ? Icons.videocam_outlined
                        : Icons.fitness_center),
                    title: Text(LibraryExercise.pick(e.name, lang)),
                    subtitle: Text([
                      exerciseCategoryLabel(l10n, e.category),
                      LibraryExercise.pick(e.dose, lang),
                      if (e.trackable) l10n.cameraTracked,
                    ].join(' · ')),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        context.push('${AppRoutes.exerciseLibrary}/${e.id}'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class ExerciseDetailScreen extends ConsumerWidget {
  const ExerciseDetailScreen({super.key, required this.id});

  final String id;

  Future<void> _logDone(
      BuildContext context, WidgetRef ref, LibraryExercise e) async {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final minutes = await showDialog<int>(
      context: context,
      builder: (_) => const _MinutesDialog(),
    );
    if (minutes == null || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(exerciseRepositoryProvider).add(
            name: LibraryExercise.pick(e.name, lang),
            category: e.category,
            durationMinutes: minutes,
            performedAt: ref.read(clockProvider)(),
          );
      messenger.showSnackBar(SnackBar(content: Text(l10n.savedToLog)));
    } catch (err, st) {
      AppLogger.error('exercise.logDone', err, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final cameraState = ref.watch(featureRegistryProvider).stateOf(
        AppFeature.exerciseCameraTracking, ref.watch(capabilityContextProvider));

    return AsyncView(
      value: ref.watch(exerciseCatalogProvider),
      data: (all) {
        final e = all.where((x) => x.id == id).firstOrNull;
        if (e == null) {
          return Scaffold(appBar: AppBar(), body: Center(child: Text(l10n.loadErrorBody)));
        }
        return Scaffold(
          appBar: AppBar(title: Text(LibraryExercise.pick(e.name, lang))),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(LibraryExercise.pick(e.summary, lang),
                  style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(spacing: AppSpacing.sm, children: [
                Chip(label: Text(exerciseCategoryLabel(l10n, e.category))),
                Chip(label: Text(LibraryExercise.pick(e.dose, lang))),
              ]),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.howTo, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              for (final (i, s) in LibraryExercise.pickList(e.steps, lang).indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Text('${i + 1}. $s'),
                ),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.health_and_safety_outlined),
                  title: Text(LibraryExercise.pick(e.safety, lang)),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (e.trackable) ...[
                FilledButton.icon(
                  onPressed: cameraState.isUsable
                      ? () => context.push(
                          '${AppRoutes.exerciseLibrary}/${e.id}/track')
                      : null,
                  icon: const Icon(Icons.videocam_outlined),
                  label: Text(l10n.trackWithCamera),
                ),
                if (!cameraState.isUsable)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(l10n.featureStateLabel(cameraState),
                        style: theme.textTheme.bodySmall),
                  ),
                const SizedBox(height: AppSpacing.sm),
              ],
              OutlinedButton.icon(
                onPressed: () => _logDone(context, ref, e),
                icon: const Icon(Icons.check),
                label: Text(l10n.logAsDone),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.exerciseSafetyNote, style: theme.textTheme.bodySmall),
            ],
          ),
        );
      },
    );
  }
}

/// Owns its controller so it outlives the dialog's closing animation.
class _MinutesDialog extends StatefulWidget {
  const _MinutesDialog();

  @override
  State<_MinutesDialog> createState() => _MinutesDialogState();
}

class _MinutesDialogState extends State<_MinutesDialog> {
  final _controller = TextEditingController(text: '5');
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final v = parsePositive(_controller.text)?.round();
    if (v == null || v > 1440) {
      setState(() => _error =
          AppLocalizations.of(context).validationRange('1', '1440'));
      return;
    }
    Navigator.pop(context, v);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.logAsDone),
      content: TextField(
        key: const Key('done-minutes'),
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: l10n.durationLabel,
          suffixText: l10n.unitMinutesShort,
          errorText: _error,
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.actionCancel)),
        FilledButton(onPressed: _submit, child: Text(l10n.actionSave)),
      ],
    );
  }
}
