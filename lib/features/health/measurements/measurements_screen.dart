import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/body.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/format/body_format.dart';
import '../../../shared/widgets/async_view.dart';
import '../body_providers.dart';
import '../widgets/add_record_sheet.dart';

/// Body measurements (spec §12). One row per type with its latest value;
/// tapping opens that type's history.
class MeasurementsScreen extends ConsumerWidget {
  const MeasurementsScreen({super.key});

  static Future<void> addMeasurement(
    BuildContext context,
    WidgetRef ref, {
    BodyMeasurementType? type,
  }) {
    return showAddRecordSheet(
      context,
      kind: RecordKind.measurement,
      presetType: type,
      units: ref.read(settingsControllerProvider).unitSystem,
      onSave: (d) => ref.read(measurementRepositoryProvider).add(
            d.type!,
            d.measurement,
            customLabel: d.customLabel,
            notes: d.notes,
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final format =
        BodyFormat.of(context, ref.watch(settingsControllerProvider).unitSystem);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.measurementsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => addMeasurement(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.measurementAdd),
      ),
      body: AsyncView(
        value: ref.watch(measurementRecordsProvider),
        data: (records) {
          final customLabels = <String>{
            for (final r in records)
              if (r.type == BodyMeasurementType.custom && r.customLabel != null)
                r.customLabel!,
          };
          BodyMeasurementRecord? latest(BodyMeasurementType t, [String? label]) {
            for (final r in records) {
              if (r.type == t && (label == null || r.customLabel == label)) {
                return r;
              }
            }
            return null;
          }

          Widget tile(BodyMeasurementType t, [String? label]) {
            final r = latest(t, label);
            return ListTile(
              leading: const Icon(Icons.straighten),
              title: Text(l10n.measurementName(t, label)),
              subtitle: Text(r == null
                  ? l10n.measurementNotRecorded
                  : '${format.length(r.value)} · ${format.date(r.recordedAt)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showModalBottomSheet<void>(
                context: context,
                useSafeArea: true,
                showDragHandle: true,
                isScrollControlled: true,
                builder: (_) => _MeasurementHistorySheet(
                  type: t,
                  customLabel: label,
                  onAdd: () => addMeasurement(context, ref, type: t),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(l10n.measurementsIntro,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ),
              for (final t in BodyMeasurementType.values)
                if (t != BodyMeasurementType.custom) tile(t),
              for (final label in customLabels)
                tile(BodyMeasurementType.custom, label),
            ],
          );
        },
      ),
    );
  }
}

class _MeasurementHistorySheet extends ConsumerWidget {
  const _MeasurementHistorySheet({
    required this.type,
    required this.onAdd,
    this.customLabel,
  });

  final BodyMeasurementType type;
  final String? customLabel;

  /// Opens the add sheet from the screen's context once this sheet closes.
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format =
        BodyFormat.of(context, ref.watch(settingsControllerProvider).unitSystem);
    final records = (ref.watch(measurementRecordsProvider).value ?? const [])
        .where((r) =>
            r.type == type &&
            (customLabel == null || r.customLabel == customLabel))
        .toList();
    final help = l10n.measurementHelp(type);

    Future<void> delete(BodyMeasurementRecord r) async {
      final messenger = ScaffoldMessenger.of(context);
      final error = l10n.recordSaveError;
      try {
        if (await confirmDelete(context)) {
          await ref.read(measurementRepositoryProvider).delete(r.id);
        }
      } catch (e, st) {
        AppLogger.error('measurement.delete', e, st);
        messenger.showSnackBar(SnackBar(content: Text(error)));
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.measurementName(type, customLabel),
              style: Theme.of(context).textTheme.titleMedium),
          if (help != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(help, style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: AppSpacing.md),
          if (records.isEmpty)
            Text(l10n.measurementNotRecorded)
          else
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final r in records)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(format.length(r.value)),
                      subtitle: Text(
                          '${format.date(r.recordedAt)} · ${l10n.sourceLabel(r.source)}'),
                      trailing: IconButton(
                        tooltip: l10n.actionDelete,
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => delete(r),
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          if (type != BodyMeasurementType.custom)
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onAdd();
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.measurementAdd),
            ),
        ],
      ),
    );
  }
}
