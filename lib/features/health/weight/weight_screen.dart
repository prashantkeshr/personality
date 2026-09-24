import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/units/units.dart';
import '../../../domain/entities/body.dart';
import '../../../domain/services/weight_trends.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/format/body_format.dart';
import '../../../shared/widgets/async_view.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/provenance_chip.dart';
import '../body_providers.dart';
import '../widgets/add_record_sheet.dart';

enum WeightPeriod {
  week(7),
  month(30),
  quarter(90);

  const WeightPeriod(this.days);
  final int days;
}

class WeightScreen extends ConsumerStatefulWidget {
  const WeightScreen({super.key, this.clock = DateTime.now});

  final DateTime Function() clock;

  @override
  ConsumerState<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
  WeightPeriod _period = WeightPeriod.month;

  Future<void> _add() => showAddRecordSheet(
        context,
        kind: RecordKind.weight,
        units: ref.read(settingsControllerProvider).unitSystem,
        onSave: (d) => ref
            .read(weightRepositoryProvider)
            .add(d.measurement, notes: d.notes),
      );

  Future<void> _delete(BodyRecord r) async {
    final messenger = ScaffoldMessenger.of(context);
    final error = AppLocalizations.of(context).recordSaveError;
    try {
      if (await confirmDelete(context)) {
        await ref.read(weightRepositoryProvider).delete(r.id);
      }
    } catch (e, st) {
      AppLogger.error('weight.delete', e, st);
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final units = ref.watch(settingsControllerProvider).unitSystem;
    final format = BodyFormat.of(context, units);
    final records = ref.watch(weightRecordsProvider);
    final profile = ref.watch(profileProvider).value ?? const Profile();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.weightTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: Text(l10n.weightAdd),
      ),
      body: AsyncView(
        value: records,
        data: (list) {
          if (list.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                EmptyState(
                  icon: Icons.monitor_weight_outlined,
                  title: l10n.weightTitle,
                  message: l10n.weightEmpty,
                ),
                _GoalCard(profile: profile, format: format, units: units),
              ],
            );
          }
          final latest = list.first;
          final window =
              WeightTrends.window(list, widget.clock(), _period.days);
          final change = WeightTrends.change(window);

          return ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
            children: [
              _LatestCard(record: latest, profile: profile, format: format),
              const SizedBox(height: AppSpacing.lg),
              SegmentedButton<WeightPeriod>(
                segments: [
                  ButtonSegment(
                      value: WeightPeriod.week, label: Text(l10n.periodWeek)),
                  ButtonSegment(
                      value: WeightPeriod.month, label: Text(l10n.periodMonth)),
                  ButtonSegment(
                      value: WeightPeriod.quarter,
                      label: Text(l10n.periodQuarter)),
                ],
                selected: {_period},
                showSelectedIcon: false,
                onSelectionChanged: (s) => setState(() => _period = s.single),
              ),
              const SizedBox(height: AppSpacing.lg),
              _WeightChart(
                records: window,
                profile: profile,
                units: units,
                start: widget.clock().subtract(Duration(days: _period.days)),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                change == null
                    ? l10n.weightTrendInsufficient
                    : l10n.weightTrendChange(format.weightChange(change)),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              _GoalCard(profile: profile, format: format, units: units),
              const SizedBox(height: AppSpacing.xl),
              Semantics(
                header: true,
                child: Text(l10n.historyTitle,
                    style: Theme.of(context).textTheme.labelLarge),
              ),
              for (final r in list)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(format.weight(r.value)),
                  subtitle: Text(
                      '${format.date(r.recordedAt)} · ${l10n.sourceLabel(r.source)}'),
                  trailing: IconButton(
                    tooltip: l10n.actionDelete,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _delete(r),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _LatestCard extends StatelessWidget {
  const _LatestCard({
    required this.record,
    required this.profile,
    required this.format,
  });

  final BodyRecord record;
  final Profile profile;
  final BodyFormat format;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final position = positionInGoal(record.value, profile);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.weightLatest, style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(format.weight(record.value),
                style: theme.textTheme.displaySmall),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ProvenanceChip(source: record.source),
                Text(format.date(record.recordedAt),
                    style: theme.textTheme.bodySmall),
              ],
            ),
            if (position != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(switch (position) {
                GoalRangePosition.below => l10n.goalBelow,
                GoalRangePosition.within => l10n.goalWithin,
                GoalRangePosition.above => l10n.goalAbove,
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class _WeightChart extends StatelessWidget {
  const _WeightChart({
    required this.records,
    required this.profile,
    required this.units,
    required this.start,
  });

  final List<BodyRecord> records;
  final Profile profile;
  final UnitSystem units;
  final DateTime start;

  double _display(double kg) =>
      units == UnitSystem.metric ? kg : UnitConversions.kgToPounds(kg);

  double _x(DateTime t) => t.difference(start).inMinutes / (60 * 24);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    if (records.isEmpty) {
      return SizedBox(
        height: 80,
        child: Center(child: Text(l10n.weightTrendInsufficient)),
      );
    }

    final entries = [
      for (final r in records) FlSpot(_x(r.recordedAt), _display(r.value)),
    ];
    final average = [
      for (final p in WeightTrends.movingAverage(records))
        FlSpot(_x(p.date), _display(p.kg)),
    ];
    final values = [
      ...entries.map((s) => s.y),
      if (profile.hasWeightGoal) ...[
        _display(profile.goalWeightMinKg!),
        _display(profile.goalWeightMaxKg!),
      ],
    ];
    final minY = values.reduce(math.min) - 1;
    final maxY = values.reduce(math.max) + 1;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: l10n.weightChartLabel(records.length),
          child: SizedBox(
            height: 200,
            child: LineChart(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 200),
              LineChartData(
                minY: minY,
                maxY: maxY,
                minX: 0,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                      color: scheme.outlineVariant, strokeWidth: 0.5),
                ),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(
                  topTitles: AxisTitles(),
                  rightTitles: AxisTitles(),
                  bottomTitles: AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                ),
                rangeAnnotations: RangeAnnotations(
                  horizontalRangeAnnotations: [
                    if (profile.hasWeightGoal)
                      HorizontalRangeAnnotation(
                        y1: _display(profile.goalWeightMinKg!),
                        y2: _display(profile.goalWeightMaxKg!),
                        color: scheme.primary.withValues(alpha: 0.08),
                      ),
                  ],
                ),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: entries,
                    barWidth: 0,
                    color: Colors.transparent,
                    dotData: FlDotData(
                      getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                        radius: 3,
                        color: scheme.onSurfaceVariant,
                        strokeWidth: 0,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: average,
                    isCurved: true,
                    preventCurveOverShooting: true,
                    barWidth: 2.5,
                    color: scheme.primary,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.lg,
          children: [
            _Legend(
                marker: Icon(Icons.circle,
                    size: 8, color: scheme.onSurfaceVariant),
                label: l10n.weightEntriesLegend),
            _Legend(
                marker: Container(width: 16, height: 3, color: scheme.primary),
                label: l10n.weightAverageLegend),
          ],
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.marker, required this.label});

  final Widget marker;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          marker,
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}

class _GoalCard extends ConsumerWidget {
  const _GoalCard({
    required this.profile,
    required this.format,
    required this.units,
  });

  final Profile profile;
  final BodyFormat format;
  final UnitSystem units;

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<(double, double)?>(
      context: context,
      builder: (_) => _GoalDialog(profile: profile, units: units, format: format),
    );
    if (result == null || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final error = AppLocalizations.of(context).recordSaveError;
    try {
      final repo = ref.read(profileRepositoryProvider);
      final p = await repo.load();
      final clear = result.$1.isNaN;
      await repo.save(p.copyWith(
        goalWeightMinKg: () => clear ? null : result.$1,
        goalWeightMaxKg: () => clear ? null : result.$2,
      ));
    } catch (e, st) {
      AppLogger.error('weight.goal', e, st);
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.flag_outlined),
        title: Text(l10n.weightGoalRange),
        subtitle: Text(profile.hasWeightGoal
            ? '${format.weight(profile.goalWeightMinKg!)} – ${format.weight(profile.goalWeightMaxKg!)}'
            : l10n.weightGoalNotSet),
        trailing: TextButton(
          onPressed: () => _edit(context, ref),
          child: Text(l10n.weightSetGoal),
        ),
      ),
    );
  }
}

/// Returns (minKg, maxKg), or (NaN, NaN) to clear the goal.
class _GoalDialog extends StatefulWidget {
  const _GoalDialog({
    required this.profile,
    required this.units,
    required this.format,
  });

  final Profile profile;
  final UnitSystem units;
  final BodyFormat format;

  @override
  State<_GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends State<_GoalDialog> {
  final _form = GlobalKey<FormState>();
  late final _min = TextEditingController(
      text: widget.profile.goalWeightMinKg == null
          ? ''
          : widget.format.weightInput(widget.profile.goalWeightMinKg!));
  late final _max = TextEditingController(
      text: widget.profile.goalWeightMaxKg == null
          ? ''
          : widget.format.weightInput(widget.profile.goalWeightMaxKg!));

  @override
  void dispose() {
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  double? _kg(String s) {
    final v = double.tryParse(s.trim().replaceAll(',', '.'));
    if (v == null) return null;
    return widget.units == UnitSystem.metric
        ? v
        : UnitConversions.poundsToKg(v);
  }

  String? _validate(String? s) {
    final l10n = AppLocalizations.of(context);
    final kg = _kg(s ?? '');
    if (kg == null) return l10n.validationRequired;
    if (kg < BodyLimits.minWeightKg || kg > BodyLimits.maxWeightKg) {
      return l10n.validationRange(widget.format.weight(BodyLimits.minWeightKg),
          widget.format.weight(BodyLimits.maxWeightKg));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final suffix = widget.units == UnitSystem.metric
        ? l10n.unitKgShort
        : l10n.unitLbShort;

    return AlertDialog(
      title: Text(l10n.weightGoalRange),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              key: const Key('goal-min'),
              controller: _min,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                  labelText: l10n.weightGoalMin, suffixText: suffix),
              validator: _validate,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              key: const Key('goal-max'),
              controller: _max,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                  labelText: l10n.weightGoalMax, suffixText: suffix),
              validator: (s) {
                final base = _validate(s);
                if (base != null) return base;
                final lo = _kg(_min.text);
                if (lo != null && _kg(s!)! <= lo) return l10n.weightGoalInvalid;
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        if (widget.profile.hasWeightGoal)
          TextButton(
            onPressed: () => Navigator.pop(context, (double.nan, double.nan)),
            child: Text(l10n.weightClearGoal),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            if (!_form.currentState!.validate()) return;
            Navigator.pop(context, (_kg(_min.text)!, _kg(_max.text)!));
          },
          child: Text(l10n.actionSave),
        ),
      ],
    );
  }
}
