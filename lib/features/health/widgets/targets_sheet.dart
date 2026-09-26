import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/units/units.dart';
import '../../../domain/entities/health.dart';
import '../../../l10n/app_localizations.dart';
import '../health_providers.dart';
import 'health_widgets.dart';

Future<void> showTargetsSheet(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const _TargetsSheet(),
    );

class _TargetsSheet extends ConsumerStatefulWidget {
  const _TargetsSheet();

  @override
  ConsumerState<_TargetsSheet> createState() => _TargetsSheetState();
}

class _TargetsSheetState extends ConsumerState<_TargetsSheet> {
  final _form = GlobalKey<FormState>();
  late final UnitSystem _units =
      ref.read(settingsControllerProvider).unitSystem;
  late final DailyTargets _initial =
      ref.read(targetsProvider).value ?? const DailyTargets();
  late final _water = TextEditingController(
      text: _units == UnitSystem.metric
          ? (_initial.waterMl / 1000).toStringAsFixed(1)
          : UnitConversions.mlToFluidOunces(_initial.waterMl.toDouble())
              .round()
              .toString());
  late final _sleep =
      TextEditingController(text: (_initial.sleepMinutes / 60).toString());
  late final _steps = TextEditingController(text: '${_initial.steps}');
  late final _active = TextEditingController(text: '${_initial.activeMinutes}');
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_water, _sleep, _steps, _active]) {
      c.dispose();
    }
    super.dispose();
  }

  int? _waterMl() {
    final v = parsePositive(_water.text);
    if (v == null) return null;
    return (_units == UnitSystem.metric
            ? v * 1000
            : UnitConversions.fluidOuncesToMl(v))
        .round();
  }

  int? _sleepMinutes() {
    final v = parsePositive(_sleep.text);
    return v == null ? null : (v * 60).round();
  }

  String? _check(int? v, int min, int max) {
    final l10n = AppLocalizations.of(context);
    if (v == null) return l10n.validationRequired;
    if (v < min || v > max) return l10n.targetOutOfRange;
    return null;
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final error = AppLocalizations.of(context).recordSaveError;
    try {
      await ref.read(targetsRepositoryProvider).save(DailyTargets(
            waterMl: _waterMl()!,
            sleepMinutes: _sleepMinutes()!,
            steps: parsePositive(_steps.text)!.round(),
            activeMinutes: parsePositive(_active.text)!.round(),
          ));
      navigator.pop();
    } catch (e, st) {
      AppLogger.error('targets.save', e, st);
      messenger.showSnackBar(SnackBar(content: Text(error)));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const number = TextInputType.numberWithOptions(decimal: true);
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl),
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.targetsTitle,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.targetsIntro,
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                key: const Key('target-water'),
                controller: _water,
                keyboardType: number,
                decoration: InputDecoration(
                  labelText: l10n.featureWater,
                  suffixText: _units == UnitSystem.metric
                      ? l10n.unitLitreShort
                      : l10n.unitFlOzShort,
                ),
                validator: (_) => _check(_waterMl(), TargetLimits.minWaterMl,
                    TargetLimits.maxWaterMl),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                key: const Key('target-sleep'),
                controller: _sleep,
                keyboardType: number,
                decoration: InputDecoration(
                    labelText: l10n.featureSleep,
                    suffixText: l10n.unitHoursShort),
                validator: (_) => _check(_sleepMinutes(),
                    TargetLimits.minSleepMinutes, TargetLimits.maxSleepMinutes),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _steps,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.stepsLabel),
                validator: (_) => _check(parsePositive(_steps.text)?.round(),
                    TargetLimits.minSteps, TargetLimits.maxSteps),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _active,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: l10n.activeMinutesLabel,
                    suffixText: l10n.unitMinutesShort),
                validator: (_) => _check(parsePositive(_active.text)?.round(),
                    TargetLimits.minActiveMinutes,
                    TargetLimits.maxActiveMinutes),
              ),
              const SizedBox(height: AppSpacing.xl),
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
