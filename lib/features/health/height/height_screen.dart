import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/body.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/format/body_format.dart';
import '../../../shared/widgets/async_view.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/provenance_chip.dart';
import '../body_providers.dart';
import '../widgets/add_record_sheet.dart';

/// Height system (spec §11): primary height, history and provenance.
class HeightScreen extends ConsumerWidget {
  const HeightScreen({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref) {
    return showAddRecordSheet(
      context,
      kind: RecordKind.height,
      units: ref.read(settingsControllerProvider).unitSystem,
      onSave: (d) => ref
          .read(heightRepositoryProvider)
          .add(d.measurement, notes: d.notes),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final records = ref.watch(heightRecordsProvider);
    final primary = ref.watch(primaryHeightProvider);
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.heightTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.heightAdd),
      ),
      body: AsyncView(
        value: records,
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: EmptyState(
                icon: Icons.height,
                title: l10n.heightTitle,
                message: l10n.heightEmpty,
              ),
            );
          }
          final primaryRecord = primary.value;
          final pinnedId = profile.value?.primaryHeightId;
          return ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
            children: [
              if (primaryRecord != null)
                _PrimaryCard(
                  record: primaryRecord,
                  pinned: pinnedId == primaryRecord.id,
                ),
              const SizedBox(height: AppSpacing.xl),
              Semantics(
                header: true,
                child: Text(l10n.historyTitle,
                    style: Theme.of(context).textTheme.labelLarge),
              ),
              for (final r in list)
                _HeightTile(record: r, isPrimary: r.id == primaryRecord?.id),
            ],
          );
        },
      ),
    );
  }
}

class _PrimaryCard extends ConsumerWidget {
  const _PrimaryCard({required this.record, required this.pinned});

  final BodyRecord record;
  final bool pinned;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final format =
        BodyFormat.of(context, ref.watch(settingsControllerProvider).unitSystem);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.heightPrimary, style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(format.height(record.value),
                style: theme.textTheme.displaySmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ProvenanceChip(
                    source: record.source,
                    confidence: record.measurement.confidence),
                Text(format.date(record.recordedAt),
                    style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              pinned ? l10n.heightPinnedNote : l10n.heightLatestManualNote,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.heightVariationNote,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

enum _HeightAction { primary, delete }

class _HeightTile extends ConsumerWidget {
  const _HeightTile({required this.record, required this.isPrimary});

  final BodyRecord record;
  final bool isPrimary;

  Future<void> _act(
      BuildContext context, WidgetRef ref, _HeightAction action) async {
    final repo = ref.read(profileRepositoryProvider);
    final messenger = ScaffoldMessenger.of(context);
    final error = AppLocalizations.of(context).recordSaveError;
    try {
      switch (action) {
        case _HeightAction.primary:
          final p = await repo.load();
          await repo.save(p.copyWith(primaryHeightId: () => record.id));
        case _HeightAction.delete:
          if (await confirmDelete(context)) await repo.deleteHeight(record.id);
      }
    } catch (e, st) {
      AppLogger.error('height.action', e, st);
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format =
        BodyFormat.of(context, ref.watch(settingsControllerProvider).unitSystem);
    final method = MeasurementMethod.fromWireName(record.measurement.method);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(isPrimary ? Icons.star : Icons.height),
      title: Text(format.height(record.value)),
      subtitle: Text([
        format.date(record.recordedAt),
        l10n.sourceLabel(record.source),
        if (method != null) l10n.methodLabel(method),
      ].join(' · ')),
      trailing: PopupMenuButton<_HeightAction>(
        onSelected: (a) => _act(context, ref, a),
        itemBuilder: (_) => [
          if (!isPrimary)
            PopupMenuItem(
                value: _HeightAction.primary,
                child: Text(l10n.heightSetPrimary)),
          PopupMenuItem(
              value: _HeightAction.delete, child: Text(l10n.actionDelete)),
        ],
      ),
    );
  }
}
