import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/units/units.dart';
import '../../../domain/entities/provenance.dart';
import '../../../domain/services/health_stats.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/async_view.dart';
import '../health_providers.dart';
import '../widgets/add_record_sheet.dart' show confirmDelete;
import '../widgets/health_widgets.dart';
import '../widgets/targets_sheet.dart';

class WaterScreen extends ConsumerWidget {
  const WaterScreen({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref, double ml) async {
    final messenger = ScaffoldMessenger.of(context);
    final error = AppLocalizations.of(context).recordSaveError;
    try {
      await ref.read(waterRepositoryProvider).add(Measurement(
            value: ml,
            unit: 'ml',
            source: DataSource.userEntered,
            recordedAt: ref.read(clockProvider)().toUtc(),
          ));
    } catch (e, st) {
      AppLogger.error('water.add', e, st);
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _custom(BuildContext context, WidgetRef ref) async {
    final metric = ref.read(settingsControllerProvider).unitSystem ==
        UnitSystem.metric;
    final ml = await showDialog<double>(
      context: context,
      builder: (_) => _CustomWaterDialog(metric: metric),
    );
    if (ml != null && context.mounted) await _add(context, ref, ml);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = HealthFormat.of(
        context, ref.watch(settingsControllerProvider).unitSystem);
    final targets = ref.watch(todaySummaryProvider).targets;
    final now = ref.watch(clockProvider)();
    final today = Days.key(now);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.featureWater),
        actions: [
          IconButton(
            tooltip: l10n.targetsTitle,
            icon: const Icon(Icons.flag_outlined),
            onPressed: () => showTargetsSheet(context),
          ),
        ],
      ),
      body: AsyncView(
        value: ref.watch(waterEntriesProvider),
        data: (entries) {
          final byDay = HealthStats.waterByDay(entries);
          final total = byDay[today] ?? 0;
          final todays =
              entries.where((e) => Days.key(e.recordedAt) == today).toList();
          final week = Days.lastDays(now, 7);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              DailyProgressCard(
                icon: Icons.water_drop_outlined,
                title: l10n.todayTitle,
                value: format.water(total),
                target: l10n.ofTarget(format.water(targets.waterMl.toDouble())),
                fraction: total / targets.waterMl,
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final ml in format.waterQuickAdds)
                    FilledButton.tonalIcon(
                      onPressed: () => _add(context, ref, ml),
                      icon: const Icon(Icons.add),
                      label: Text(format.water(ml)),
                    ),
                  OutlinedButton(
                    onPressed: () => _custom(context, ref),
                    child: Text(l10n.waterCustom),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.lastSevenDays,
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              WeekBarChart(
                dayKeys: week,
                values: byDay,
                format: format,
                target: targets.waterMl.toDouble(),
                semanticLabel: l10n.weekChartLabel(l10n.featureWater),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.todayEntries,
                  style: Theme.of(context).textTheme.labelLarge),
              if (todays.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text(l10n.waterEmpty),
                ),
              for (final e in todays)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.water_drop_outlined),
                  title: Text(format.water(e.value)),
                  subtitle: Text(format.time(e.recordedAt)),
                  trailing: IconButton(
                    tooltip: l10n.actionDelete,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      if (await confirmDelete(context)) {
                        await ref.read(waterRepositoryProvider).delete(e.id);
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

/// Owns its controller so it outlives the dialog's closing animation.
class _CustomWaterDialog extends StatefulWidget {
  const _CustomWaterDialog({required this.metric});

  final bool metric;

  @override
  State<_CustomWaterDialog> createState() => _CustomWaterDialogState();
}

class _CustomWaterDialogState extends State<_CustomWaterDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final v = parsePositive(_controller.text);
    final ml = v == null
        ? null
        : widget.metric
            ? v
            : UnitConversions.fluidOuncesToMl(v);
    // More than 5 L in one entry is almost certainly a typo.
    if (ml == null || ml > 5000) {
      setState(() => _error = AppLocalizations.of(context).targetOutOfRange);
      return;
    }
    Navigator.pop(context, ml);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.waterCustom),
      content: TextField(
        key: const Key('water-custom'),
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          suffixText: widget.metric ? l10n.unitMlShort : l10n.unitFlOzShort,
          errorText: _error,
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.actionAdd)),
      ],
    );
  }
}
