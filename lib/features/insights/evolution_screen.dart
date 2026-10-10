import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/evolution_engine.dart';
import '../../domain/services/health_stats.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/body_format.dart';
import '../../shared/visual/reveal.dart';
import '../plans/plan_labels.dart';
import '../today/today_providers.dart';
import 'insights_providers.dart';

IconData milestoneIcon(MilestoneKind k) => switch (k) {
  MilestoneKind.firstStep => Icons.flag_outlined,
  MilestoneKind.firstPosture => Icons.accessibility_new,
  MilestoneKind.firstFace => Icons.face_retouching_natural_outlined,
  MilestoneKind.firstSnapshot => Icons.photo_camera_front_outlined,
  MilestoneKind.firstOutfit => Icons.checkroom_outlined,
  MilestoneKind.planStarted => Icons.restaurant_menu,
  MilestoneKind.streak7 ||
  MilestoneKind.streak30 => Icons.local_fire_department_outlined,
  MilestoneKind.habits30 => Icons.task_alt,
  MilestoneKind.weightChange => Icons.monitor_weight_outlined,
  MilestoneKind.note => Icons.edit_note,
};

String milestoneText(BuildContext context, WidgetRef ref, Milestone m) {
  final l10n = AppLocalizations.of(context);
  final f = BodyFormat.of(
    context,
    ref.watch(settingsControllerProvider).unitSystem,
  );
  return switch (m.kind) {
    MilestoneKind.firstStep => l10n.msFirstStep,
    MilestoneKind.firstPosture => l10n.msFirstPosture,
    MilestoneKind.firstFace => l10n.msFirstFace,
    MilestoneKind.firstSnapshot => l10n.msFirstSnapshot,
    MilestoneKind.firstOutfit => l10n.msFirstOutfit,
    MilestoneKind.planStarted => l10n.msPlanStarted(l10n.planKindName(m.plan!)),
    MilestoneKind.streak7 => l10n.msStreak7,
    MilestoneKind.streak30 => l10n.msStreak30,
    MilestoneKind.habits30 => l10n.msHabits30,
    MilestoneKind.weightChange =>
      m.value! < 0
          ? l10n.msWeightDown(f.weight(m.value!.abs()))
          : l10n.msWeightUp(f.weight(m.value!)),
    MilestoneKind.note => m.text ?? '',
  };
}

/// One milestone row on a vertical rail.
class MilestoneTile extends ConsumerWidget {
  const MilestoneTile({super.key, required this.m, this.last = false});
  final Milestone m;
  final bool last;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final note = m.kind == MilestoneKind.note;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: note
                      ? scheme.tertiaryContainer
                      : scheme.primaryContainer,
                  child: Icon(
                    milestoneIcon(m.kind),
                    size: 18,
                    color: note
                        ? scheme.onTertiaryContainer
                        : scheme.onPrimaryContainer,
                  ),
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: scheme.outlineVariant.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg, top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMd(locale).format(Days.fromKey(m.dayKey)),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    milestoneText(context, ref, m),
                    style: note
                        ? theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          )
                        : theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          if (note)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              tooltip: AppLocalizations.of(context).actionDelete,
              onPressed: () =>
                  ref.read(wellbeingRepositoryProvider).deleteNote(m.noteId!),
            ),
        ],
      ),
    );
  }
}

Future<void> addMilestoneNote(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final text = await showDialog<String>(
    context: context,
    builder: (_) => const _NoteDialog(),
  );
  if (text == null || text.trim().isEmpty) return;
  await ref.read(wellbeingRepositoryProvider).addNote(text);
  if (context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.quickAdded)));
  }
}

class _NoteDialog extends StatefulWidget {
  const _NoteDialog();
  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  final _c = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.evolutionAddNote),
      content: TextField(
        key: const Key('note-text'),
        controller: _c,
        autofocus: true,
        maxLines: 4,
        maxLength: 500,
        decoration: InputDecoration(hintText: l10n.evolutionNoteHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_c.text),
          child: Text(l10n.actionSave),
        ),
      ],
    );
  }
}

class EvolutionScreen extends ConsumerWidget {
  const EvolutionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ms = ref.watch(evolutionProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.evolutionTitle)),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('add-note'),
        icon: const Icon(Icons.edit_note),
        label: Text(l10n.evolutionAddNote),
        onPressed: () => addMilestoneNote(context, ref),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          96,
        ),
        children: [
          Text(
            l10n.evolutionIntro,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (ms.isEmpty) Text(l10n.evolutionEmpty),
          for (final (i, m) in ms.indexed)
            Reveal(
              index: i,
              child: MilestoneTile(m: m, last: i == ms.length - 1),
            ),
        ],
      ),
    );
  }
}
