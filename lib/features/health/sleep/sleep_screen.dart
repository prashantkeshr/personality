import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/health.dart';
import '../../../domain/services/health_stats.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/async_view.dart';
import '../health_providers.dart';
import '../widgets/add_record_sheet.dart' show confirmDelete;
import '../widgets/health_widgets.dart';
import '../widgets/targets_sheet.dart';

/// Sleep log (spec §14). Describes timing and consistency; never diagnoses.
class SleepScreen extends ConsumerWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = HealthFormat.of(
        context, ref.watch(settingsControllerProvider).unitSystem);
    final targets = ref.watch(todaySummaryProvider).targets;
    final now = ref.watch(clockProvider)();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.featureSleep),
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
          builder: (_) => const _AddSleepSheet(),
        ),
        icon: const Icon(Icons.add),
        label: Text(l10n.sleepAdd),
      ),
      body: AsyncView(
        value: ref.watch(sleepProvider),
        data: (entries) {
          final byDay = HealthStats.sleepByDay(entries);
          final week = Days.lastDays(now, 7);
          final lastNight = byDay[Days.key(now)];
          final weekEntries = entries
              .where((e) => week.contains(Days.key(e.wakeAt)))
              .toList();
          final variation = HealthStats.bedtimeVariationMinutes(weekEntries);
          final target = Duration(minutes: targets.sleepMinutes);

          return ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
            children: [
              DailyProgressCard(
                icon: Icons.bedtime_outlined,
                title: l10n.sleepLastNight,
                value: lastNight == null
                    ? l10n.measurementNotRecorded
                    : format.duration(lastNight),
                target: l10n.ofTarget(format.duration(target)),
                fraction: lastNight == null
                    ? 0
                    : lastNight.inMinutes / targets.sleepMinutes,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.lastSevenDays,
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              WeekBarChart(
                dayKeys: week,
                values: {
                  for (final e in byDay.entries) e.key: e.value.inMinutes / 60,
                },
                format: format,
                target: targets.sleepMinutes / 60,
                semanticLabel: l10n.weekChartLabel(l10n.featureSleep),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                variation == null
                    ? l10n.sleepConsistencyInsufficient
                    : l10n.sleepConsistency(variation.round()),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.sleepDisclaimer,
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.historyTitle,
                  style: Theme.of(context).textTheme.labelLarge),
              if (entries.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text(l10n.sleepEmpty),
                ),
              for (final e in entries)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(format.duration(e.duration)),
                  subtitle: Text(
                      '${format.day(e.bedAt)} ${format.time(e.bedAt)} – ${format.time(e.wakeAt)}'),
                  trailing: IconButton(
                    tooltip: l10n.actionDelete,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      if (await confirmDelete(context)) {
                        await ref.read(sleepRepositoryProvider).delete(e.id);
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

class _AddSleepSheet extends ConsumerStatefulWidget {
  const _AddSleepSheet();

  @override
  ConsumerState<_AddSleepSheet> createState() => _AddSleepSheetState();
}

class _AddSleepSheetState extends ConsumerState<_AddSleepSheet> {
  late DateTime _wake = () {
    final n = ref.read(clockProvider)();
    return DateTime(n.year, n.month, n.day, 7);
  }();
  late DateTime _bed = _wake.subtract(const Duration(hours: 8));
  String? _error;
  bool _saving = false;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_wake.isAfter(_bed)) {
      setState(() => _error = l10n.sleepWakeBeforeBed);
      return;
    }
    if (_wake.difference(_bed) > SleepLimits.maxDuration) {
      setState(() => _error = l10n.sleepTooLong);
      return;
    }
    setState(() {
      _error = null;
      _saving = true;
    });
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(sleepRepositoryProvider).add(bedAt: _bed, wakeAt: _wake);
      navigator.pop();
    } catch (e, st) {
      AppLogger.error('sleep.add', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = HealthFormat.of(
        context, ref.watch(settingsControllerProvider).unitSystem);
    final now = ref.read(clockProvider)();

    Widget picker(String label, DateTime value, ValueChanged<DateTime> set) =>
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.schedule),
          title: Text(label),
          subtitle: Text('${format.day(value)} · ${format.time(value)}'),
          onTap: () async {
            final t = await pickDateTime(context, value,
                last: now.add(const Duration(days: 1)));
            if (t != null) setState(() => set(t));
          },
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.sleepAdd, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          picker(l10n.sleepBedtime, _bed, (t) => _bed = t),
          picker(l10n.sleepWakeTime, _wake, (t) => _wake = t),
          if (_wake.isAfter(_bed))
            Text(l10n.sleepDurationPreview(format.duration(_wake.difference(_bed)))),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(_error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(l10n.actionSave),
          ),
        ],
      ),
    );
  }
}
