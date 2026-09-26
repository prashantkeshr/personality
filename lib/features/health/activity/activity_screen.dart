import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/units/units.dart';
import '../../../domain/entities/health.dart';
import '../../../domain/services/health_stats.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/async_view.dart';
import '../../../shared/widgets/provenance_chip.dart';
import '../health_providers.dart';
import '../widgets/add_record_sheet.dart' show confirmDelete;
import '../widgets/health_widgets.dart';
import '../widgets/targets_sheet.dart';

/// Steps and activity, entered manually until Health Connect (Phase 12).
/// Every entry shows its source.
class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final units = ref.watch(settingsControllerProvider).unitSystem;
    final format = HealthFormat.of(context, units);
    final summary = ref.watch(todaySummaryProvider);
    final now = ref.watch(clockProvider)();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.featureActivity),
        actions: [
          IconButton(
            tooltip: l10n.targetsTitle,
            icon: const Icon(Icons.flag_outlined),
            onPressed: () => showTargetsSheet(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          showDragHandle: true,
          builder: (_) => const _AddActivitySheet(),
        ),
        icon: const Icon(Icons.add),
        label: Text(l10n.activityAdd),
      ),
      body: AsyncView(
        value: ref.watch(activitiesProvider),
        data: (entries) {
          final week = Days.lastDays(now, 7);
          return ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
            children: [
              DailyProgressCard(
                icon: Icons.directions_walk,
                title: l10n.stepsLabel,
                value: format.steps(summary.steps),
                target: l10n.ofTarget(format.steps(summary.targets.steps)),
                fraction: summary.steps / summary.targets.steps,
              ),
              const SizedBox(height: AppSpacing.md),
              DailyProgressCard(
                icon: Icons.timer_outlined,
                title: l10n.activeMinutesLabel,
                value: format.minutes(summary.activeMinutes),
                target: l10n
                    .ofTarget(format.minutes(summary.targets.activeMinutes)),
                fraction:
                    summary.activeMinutes / summary.targets.activeMinutes,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.activeMinutesNote,
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.lastSevenDays,
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              WeekBarChart(
                dayKeys: week,
                values: {
                  for (final k in week)
                    k: HealthStats.stepsOn(entries, k).toDouble(),
                },
                format: format,
                target: summary.targets.steps.toDouble(),
                semanticLabel: l10n.weekChartLabel(l10n.stepsLabel),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.historyTitle,
                  style: Theme.of(context).textTheme.labelLarge),
              if (entries.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text(l10n.activityEmpty),
                ),
              for (final e in entries)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(activityKindLabel(l10n, e.kind)),
                  subtitle: Wrap(
                    spacing: AppSpacing.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text([
                        format.day(e.recordedAt),
                        if (e.durationMinutes != null)
                          format.minutes(e.durationMinutes!),
                        if (e.steps != null) format.steps(e.steps!),
                        if (e.distanceKm != null) format.distance(e.distanceKm!),
                      ].join(' · ')),
                      ProvenanceChip(source: e.source),
                    ],
                  ),
                  trailing: IconButton(
                    tooltip: l10n.actionDelete,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      if (await confirmDelete(context)) {
                        await ref.read(activityRepositoryProvider).delete(e.id);
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

class _AddActivitySheet extends ConsumerStatefulWidget {
  const _AddActivitySheet();

  @override
  ConsumerState<_AddActivitySheet> createState() => _AddActivitySheetState();
}

class _AddActivitySheetState extends ConsumerState<_AddActivitySheet> {
  final _form = GlobalKey<FormState>();
  final _minutes = TextEditingController();
  final _steps = TextEditingController();
  final _distance = TextEditingController();
  ActivityKind _kind = ActivityKind.walking;
  late DateTime _at = ref.read(clockProvider)();
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_minutes, _steps, _distance]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_form.currentState!.validate()) return;
    final minutes = parsePositive(_minutes.text)?.round();
    final steps = parsePositive(_steps.text)?.round();
    final distance = parsePositive(_distance.text);
    if (minutes == null && steps == null && distance == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.activityNeedsValue)));
      return;
    }
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final metric =
        ref.read(settingsControllerProvider).unitSystem == UnitSystem.metric;
    try {
      await ref.read(activityRepositoryProvider).add(
            kind: _kind,
            recordedAt: _at,
            durationMinutes: minutes,
            steps: steps,
            distanceKm: distance == null
                ? null
                : metric
                    ? distance
                    : UnitConversions.milesToKm(distance),
          );
      navigator.pop();
    } catch (e, st) {
      AppLogger.error('activity.add', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _optionalNumber(String? v, num max) {
    if (v == null || v.trim().isEmpty) return null;
    final n = parsePositive(v);
    if (n == null || n > max) return AppLocalizations.of(context).targetOutOfRange;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final metric =
        ref.watch(settingsControllerProvider).unitSystem == UnitSystem.metric;
    final format = HealthFormat.of(
        context, ref.watch(settingsControllerProvider).unitSystem);
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl),
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.activityAdd,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<ActivityKind>(
                initialValue: _kind,
                decoration: InputDecoration(labelText: l10n.activityKindLabel),
                items: [
                  for (final k in ActivityKind.values)
                    DropdownMenuItem(
                        value: k, child: Text(activityKindLabel(l10n, k))),
                ],
                onChanged: (k) => setState(() => _kind = k!),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                key: const Key('activity-steps'),
                controller: _steps,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.stepsLabel),
                validator: (v) => _optionalNumber(v, 100000),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                key: const Key('activity-minutes'),
                controller: _minutes,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: l10n.durationLabel,
                    suffixText: l10n.unitMinutesShort),
                validator: (v) => _optionalNumber(v, 1440),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _distance,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                    labelText: l10n.distanceLabel,
                    suffixText: metric ? l10n.unitKmShort : l10n.unitMiShort),
                validator: (v) => _optionalNumber(v, 500),
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
