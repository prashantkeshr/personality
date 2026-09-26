import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/units/units.dart';
import '../../../domain/entities/health.dart';
import '../../../domain/services/health_stats.dart';
import '../../../l10n/app_localizations.dart';

/// Locale- and unit-aware formatting for daily health values.
class HealthFormat {
  HealthFormat(this.l10n, this.system, Locale locale)
      : _tag = locale.toLanguageTag();

  factory HealthFormat.of(BuildContext context, UnitSystem system) =>
      HealthFormat(AppLocalizations.of(context), system,
          Localizations.localeOf(context));

  final AppLocalizations l10n;
  final UnitSystem system;
  final String _tag;

  String _num(num v, int decimals) =>
      NumberFormat.decimalPatternDigits(locale: _tag, decimalDigits: decimals)
          .format(v);

  /// "1.8 L" / "750 ml" or "61 fl oz".
  String water(double ml) {
    if (system == UnitSystem.imperial) {
      return l10n.valueFlOz(_num(UnitConversions.mlToFluidOunces(ml), 0));
    }
    return ml >= 1000
        ? l10n.valueLitres(_num(ml / 1000, 1))
        : l10n.valueMl(_num(ml, 0));
  }

  String duration(Duration d) =>
      l10n.durationHm(d.inHours, d.inMinutes.remainder(60));

  String minutes(int m) => l10n.valueMinutes(m);

  String steps(int s) => l10n.valueSteps(_num(s, 0));

  /// Plain grouped number, for compact "done / target" displays.
  String count(int n) => _num(n, 0);

  String distance(double km) => system == UnitSystem.metric
      ? l10n.valueKm(_num(km, 1))
      : l10n.valueMiles(_num(UnitConversions.kmToMiles(km), 1));

  String time(DateTime t) => DateFormat.jm(_tag).format(t.toLocal());

  String day(DateTime t) => DateFormat.MMMEd(_tag).format(t.toLocal());

  String shortDay(int dayKey) => DateFormat.E(_tag).format(Days.fromKey(dayKey));

  /// Quick-add amounts for water, in ml.
  List<double> get waterQuickAdds => system == UnitSystem.metric
      ? const [250, 500]
      : [UnitConversions.fluidOuncesToMl(8), UnitConversions.fluidOuncesToMl(16)];
}

/// Progress towards a daily target. Shows numbers, not judgement.
class DailyProgressCard extends StatelessWidget {
  const DailyProgressCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.target,
    required this.fraction,
    this.action,
  });

  final IconData icon;
  final String title;
  final String value;
  final String target;
  final double fraction;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clamped = fraction.isNaN ? 0.0 : fraction.clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: clamped,
                      strokeWidth: 7,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  Icon(icon, color: theme.colorScheme.primary),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(value, style: theme.textTheme.headlineSmall),
                  Text(target,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            ?action,
          ],
        ),
      ),
    );
  }
}

/// Seven-day bar chart with an optional target line and an accessible label.
class WeekBarChart extends StatelessWidget {
  const WeekBarChart({
    super.key,
    required this.dayKeys,
    required this.values,
    required this.format,
    required this.semanticLabel,
    this.target,
  });

  final List<int> dayKeys;
  final Map<int, double> values;
  final HealthFormat format;
  final String semanticLabel;
  final double? target;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxValue = [
      ...dayKeys.map((k) => values[k] ?? 0),
      target ?? 0,
    ].fold<double>(0, (a, b) => a > b ? a : b);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      label: semanticLabel,
      child: SizedBox(
        height: 160,
        child: BarChart(
          duration:
              reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
          BarChartData(
            maxY: maxValue == 0 ? 1 : maxValue * 1.15,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              leftTitles: const AxisTitles(),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, meta) => SideTitleWidget(
                    meta: meta,
                    child: Text(format.shortDay(dayKeys[v.toInt()]),
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ),
              ),
            ),
            extraLinesData: ExtraLinesData(horizontalLines: [
              if (target != null)
                HorizontalLine(
                  y: target!,
                  color: scheme.outline,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
            ]),
            barGroups: [
              for (var i = 0; i < dayKeys.length; i++)
                BarChartGroupData(x: i, barRods: [
                  BarChartRodData(
                    toY: values[dayKeys[i]] ?? 0,
                    width: 18,
                    color: scheme.primary,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ]),
            ],
          ),
        ),
      ),
    );
  }
}

/// Picks a date and time; returns null when cancelled.
Future<DateTime?> pickDateTime(BuildContext context, DateTime initial,
    {DateTime? last}) async {
  final lastDate = last ?? DateTime.now();
  final date = await showDatePicker(
    context: context,
    initialDate: initial.isAfter(lastDate) ? lastDate : initial,
    firstDate: DateTime(2000),
    lastDate: lastDate,
  );
  if (date == null || !context.mounted) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial),
  );
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

String mealTypeLabel(AppLocalizations l10n, MealType t) => switch (t) {
      MealType.breakfast => l10n.mealBreakfast,
      MealType.lunch => l10n.mealLunch,
      MealType.snack => l10n.mealSnack,
      MealType.dinner => l10n.mealDinner,
      MealType.custom => l10n.mealCustom,
    };

String activityKindLabel(AppLocalizations l10n, ActivityKind k) => switch (k) {
      ActivityKind.walking => l10n.activityWalking,
      ActivityKind.running => l10n.activityRunning,
      ActivityKind.cycling => l10n.activityCycling,
      ActivityKind.swimming => l10n.activitySwimming,
      ActivityKind.sports => l10n.activitySports,
      ActivityKind.other => l10n.activityOther,
    };

String exerciseCategoryLabel(AppLocalizations l10n, ExerciseCategory c) =>
    switch (c) {
      ExerciseCategory.neck => l10n.exNeck,
      ExerciseCategory.shoulder => l10n.exShoulder,
      ExerciseCategory.upperBack => l10n.exUpperBack,
      ExerciseCategory.lowerBack => l10n.exLowerBack,
      ExerciseCategory.core => l10n.exCore,
      ExerciseCategory.mobility => l10n.exMobility,
      ExerciseCategory.yoga => l10n.exYoga,
      ExerciseCategory.stretching => l10n.exStretching,
      ExerciseCategory.posture => l10n.exPosture,
      ExerciseCategory.generalFitness => l10n.exGeneralFitness,
      ExerciseCategory.strength => l10n.exStrength,
      ExerciseCategory.cardio => l10n.exCardio,
    };

/// Parses a positive number typed in the user's locale.
double? parsePositive(String s) {
  final v = double.tryParse(s.trim().replaceAll(',', '.'));
  return (v == null || v <= 0) ? null : v;
}
