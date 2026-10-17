import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/features/feature_registry.dart';
import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/exercise_library.dart';
import '../../domain/entities/health.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/feature_labels.dart';
import '../content/content_providers.dart';
import '../health/health_providers.dart';
import '../health/widgets/health_widgets.dart';
import 'figure/exercise_visual.dart';

export '../content/content_providers.dart' show exerciseCatalogProvider;

enum _Filter { all, camera, noEquipment }

/// Data-driven exercise library: built in plus downloaded packs (spec §18, §71).
class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  const ExerciseLibraryScreen({super.key, this.cameraOnly = false});

  final bool cameraOnly;

  @override
  ConsumerState<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends ConsumerState<ExerciseLibraryScreen> {
  late _Filter _filter = widget.cameraOnly ? _Filter.camera : _Filter.all;
  ExerciseCategory? _category;
  String _query = '';

  bool _matches(LibraryExercise e, String lang) {
    if (_filter == _Filter.camera && !e.trackable) return false;
    if (_filter == _Filter.noEquipment && !e.bodyweight) return false;
    if (_category != null && e.category != _category) return false;
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return LibraryExercise.pick(e.name, lang).toLowerCase().contains(q) ||
        LibraryExercise.pick(e.name, 'en').toLowerCase().contains(q) ||
        e.muscles.any((m) => m.contains(q)) ||
        (e.equipment?.contains(q) ?? false) ||
        (e.bodyPart?.contains(q) ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final packs = ref.watch(installedPacksProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exerciseLibrary),
        actions: [
          IconButton(
            tooltip: l10n.contentTitle,
            icon: const Icon(Icons.download_for_offline_outlined),
            onPressed: () => context.push(AppRoutes.content),
          ),
        ],
      ),
      body: AsyncView(
        value: ref.watch(exerciseCatalogProvider),
        data: (all) {
          final categories = {for (final e in all) e.category}.toList()
            ..sort((a, b) => a.index.compareTo(b.index));
          final list = all.where((e) => _matches(e, lang)).toList();
          Widget chip(String label, bool selected, VoidCallback onTap, {IconData? icon}) => Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                child: ChoiceChip(
                  avatar: icon == null ? null : Icon(icon, size: 18),
                  label: Text(label),
                  selected: selected,
                  onSelected: (_) => onTap(),
                ),
              );
          final header = [
            _WorkoutsCard(onTap: () => context.push(AppRoutes.programs)),
            if (packs.isEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Card(
                color: theme.colorScheme.secondaryContainer,
                child: ListTile(
                  leading: const Icon(Icons.download_for_offline_outlined),
                  title: Text(l10n.contentGetMore),
                  subtitle: Text(l10n.contentGetMoreInfo),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.content),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            TextField(
              key: const Key('exercise-search'),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.exerciseSearch,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v.trim()),
            ),
            const SizedBox(height: AppSpacing.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                chip(l10n.filterAll, _filter == _Filter.all && _category == null, () => setState(() {
                      _filter = _Filter.all;
                      _category = null;
                    })),
                chip(l10n.filterCameraTracked, _filter == _Filter.camera,
                    () => setState(() => _filter = _filter == _Filter.camera ? _Filter.all : _Filter.camera),
                    icon: Icons.videocam_outlined),
                chip(l10n.filterNoEquipment, _filter == _Filter.noEquipment,
                    () => setState(() => _filter = _filter == _Filter.noEquipment ? _Filter.all : _Filter.noEquipment)),
                if (categories.length > 1)
                  for (final c in categories)
                    chip(exerciseCategoryLabel(l10n, c), _category == c,
                        () => setState(() => _category = _category == c ? null : c)),
              ]),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.exerciseCount(list.length), style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.sm),
          ];
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: header.length + list.length,
            itemBuilder: (context, i) {
              if (i < header.length) return header[i];
              final e = list[i - header.length];
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  leading: SizedBox.square(dimension: 52, child: ExerciseVisual(exercise: e, still: true)),
                  title: Text(LibraryExercise.pick(e.name, lang)),
                  subtitle: Text(
                    [
                      exerciseCategoryLabel(l10n, e.category),
                      if (e.dose.isNotEmpty) LibraryExercise.pick(e.dose, lang),
                      if (e.dose.isEmpty && e.muscles.isNotEmpty) e.muscles.first,
                      if (e.equipment != null && !e.bodyweight) e.equipment!,
                      if (e.trackable) l10n.cameraTracked,
                    ].join(' · '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('${AppRoutes.exerciseLibrary}/${Uri.encodeComponent(e.id)}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _WorkoutsCard extends StatelessWidget {
  const _WorkoutsCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primaryContainer,
      child: ListTile(
        key: const Key('open-workouts'),
        leading: Icon(Icons.play_circle_outline, color: scheme.onPrimaryContainer),
        title: Text(l10n.workoutsTitle,
            style: TextStyle(color: scheme.onPrimaryContainer, fontWeight: FontWeight.w600)),
        subtitle: Text(l10n.workoutsSubtitle, style: TextStyle(color: scheme.onPrimaryContainer)),
        trailing: Icon(Icons.chevron_right, color: scheme.onPrimaryContainer),
        onTap: onTap,
      ),
    );
  }
}

class ExerciseDetailScreen extends ConsumerWidget {
  const ExerciseDetailScreen({super.key, required this.id});

  final String id;

  Future<void> _logDone(BuildContext context, WidgetRef ref, LibraryExercise e) async {
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
        final steps = LibraryExercise.pickList(e.steps, lang);
        final hasVisual = e.motion != null || e.images.isNotEmpty;
        return Scaffold(
          appBar: AppBar(title: Text(LibraryExercise.pick(e.name, lang))),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              if (hasVisual)
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    height: 240,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: ExerciseVisual(exercise: e),
                    ),
                  ),
                ),
              if (e.summary.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(LibraryExercise.pick(e.summary, lang), style: theme.textTheme.bodyLarge),
              ],
              const SizedBox(height: AppSpacing.sm),
              Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.xs, children: [
                Chip(label: Text(exerciseCategoryLabel(l10n, e.category))),
                if (e.dose.isNotEmpty) Chip(label: Text(LibraryExercise.pick(e.dose, lang))),
                if (e.equipment != null) Chip(avatar: const Icon(Icons.handyman_outlined, size: 18), label: Text(e.equipment!)),
                for (final m in e.muscles) Chip(avatar: const Icon(Icons.adjust, size: 18), label: Text(m)),
              ]),
              if (e.secondary.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(l10n.exerciseAlsoWorks(e.secondary.join(', ')), style: theme.textTheme.bodySmall),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(l10n.howTo, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              for (final (i, s) in steps.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Text('${i + 1}. $s'),
                ),
              if (e.safety.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.health_and_safety_outlined),
                    title: Text(LibraryExercise.pick(e.safety, lang)),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              if (e.trackable) ...[
                FilledButton.icon(
                  onPressed: cameraState.isUsable
                      ? () => context.push('${AppRoutes.exerciseLibrary}/${e.id}/track')
                      : null,
                  icon: const Icon(Icons.videocam_outlined),
                  label: Text(l10n.trackWithCamera),
                ),
                if (!cameraState.isUsable)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(l10n.featureStateLabel(cameraState), style: theme.textTheme.bodySmall),
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
              if (e.credit != null && e.credit != 'Personality') ...[
                const SizedBox(height: AppSpacing.sm),
                Text(e.credit!,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
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
      setState(() => _error = AppLocalizations.of(context).validationRange('1', '1440'));
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
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.actionCancel)),
        FilledButton(onPressed: _submit, child: Text(l10n.actionSave)),
      ],
    );
  }
}
