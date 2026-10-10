import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/insights_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/visual/reveal.dart';
import '../health/widgets/health_widgets.dart' show HealthFormat;
import '../today/today_providers.dart';
import '../today/today_widgets.dart' show moodName;
import 'insights_providers.dart';

String metricName(AppLocalizations l10n, InsightMetric m) => switch (m) {
  InsightMetric.plan => l10n.metricPlan,
  InsightMetric.habits => l10n.metricHabits,
  InsightMetric.water => l10n.metricWater,
  InsightMetric.sleep => l10n.metricSleep,
  InsightMetric.activity => l10n.metricActivity,
  InsightMetric.meals => l10n.metricMeals,
  InsightMetric.mood => l10n.metricMood,
};

IconData metricIcon(InsightMetric m) => switch (m) {
  InsightMetric.plan => Icons.event_available_outlined,
  InsightMetric.habits => Icons.task_alt,
  InsightMetric.water => Icons.water_drop_outlined,
  InsightMetric.sleep => Icons.bedtime_outlined,
  InsightMetric.activity => Icons.directions_walk,
  InsightMetric.meals => Icons.restaurant_outlined,
  InsightMetric.mood => Icons.sentiment_satisfied_outlined,
};

/// Formats a metric value (average or change) in its own unit.
String metricValue(
  BuildContext context,
  WidgetRef ref,
  InsightMetric m,
  double v, {
  bool signed = false,
}) {
  final f = HealthFormat.of(
    context,
    ref.watch(settingsControllerProvider).unitSystem,
  );
  final l10n = AppLocalizations.of(context);
  final s = signed ? v.abs() : v;
  return switch (m) {
    InsightMetric.plan || InsightMetric.habits => '${(s * 100).round()}%',
    InsightMetric.water => f.water(s),
    InsightMetric.sleep => f.duration(Duration(minutes: (s * 60).round())),
    InsightMetric.activity => f.minutes(s.round()),
    InsightMetric.meals => s.toStringAsFixed(1),
    InsightMetric.mood =>
      signed ? s.toStringAsFixed(1) : moodName(l10n, s.round().clamp(1, 5)),
  };
}

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  InsightRange _range = InsightRange.week;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    var reveal = 0;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.insightsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            l10n.insightsIntro,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<InsightRange>(
            segments: [
              ButtonSegment(
                value: InsightRange.week,
                label: Text(l10n.rangeWeek),
              ),
              ButtonSegment(
                value: InsightRange.month,
                label: Text(l10n.rangeMonth),
              ),
            ],
            selected: {_range},
            onSelectionChanged: (s) => setState(() => _range = s.first),
          ),
          const SizedBox(height: AppSpacing.lg),
          Reveal(index: reveal++, child: const SleepScoreCard()),
          const SizedBox(height: AppSpacing.md),
          for (final m in InsightMetric.values) ...[
            Reveal(
              index: reveal++,
              child: _MetricCard(metric: m, range: _range),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          const _Legend(),
        ],
      ),
    );
  }
}

class SleepScoreCard extends ConsumerWidget {
  const SleepScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final score = ref.watch(sleepScoreProvider);
    final f = HealthFormat.of(
      context,
      ref.watch(settingsControllerProvider).unitSystem,
    );
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: score == null
            ? Row(
                children: [
                  Icon(Icons.bedtime_outlined, color: scheme.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(l10n.sleepScoreEmpty)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox.square(
                        dimension: 96,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(end: score.score / 100),
                          duration: reduce
                              ? Duration.zero
                              : const Duration(milliseconds: 900),
                          builder: (_, v, _) => CustomPaint(
                            painter: _ScoreRing(v, scheme),
                            child: Center(
                              child: Text(
                                '${score.score}',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.sleepScoreTitle,
                              style: theme.textTheme.labelLarge,
                            ),
                            Text(
                              score.score >= 85
                                  ? l10n.sleepExcellent
                                  : score.score >= 70
                                  ? l10n.sleepGood
                                  : score.score >= 50
                                  ? l10n.sleepFair
                                  : l10n.sleepCare,
                              style: theme.textTheme.titleLarge,
                            ),
                            Text(
                              l10n.sleepAverage(
                                f.duration(
                                  Duration(minutes: score.averageMinutes),
                                ),
                              ),
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              l10n.sleepSpread(score.bedtimeSpreadMinutes),
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              l10n.sleepNights(score.nights),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.sleepScoreInfo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ScoreRing extends CustomPainter {
  _ScoreRing(this.value, this.scheme);
  final double value;
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.1;
    final rect = (Offset.zero & size).deflate(stroke / 2 + 1);
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = scheme.surfaceContainerHighest,
    );
    if (value <= 0) return;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * value,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          colors: [scheme.tertiary, scheme.primary, scheme.tertiary],
          transform: const GradientRotation(-math.pi / 2),
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_ScoreRing old) => old.value != value;
}

class _MetricCard extends ConsumerWidget {
  const _MetricCard({required this.metric, required this.range});
  final InsightMetric metric;
  final InsightRange range;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final s = ref.watch(insightSeriesProvider((metric, range)));
    final period = range == InsightRange.week
        ? l10n.insightsPeriodWeek
        : l10n.insightsPeriodMonth;
    final avg = s.average;
    final change = s.change;

    String? trend;
    if (change != null) {
      final small =
          metric == InsightMetric.plan || metric == InsightMetric.habits
          ? change.abs() < 0.01
          : change.abs() < 0.05 * (s.previousAverage!.abs() + 0.001);
      trend = small
          ? l10n.insightsSame(period)
          : change > 0
          ? l10n.insightsUp(
              metricValue(context, ref, metric, change, signed: true),
              period,
            )
          : l10n.insightsDown(
              metricValue(context, ref, metric, change, signed: true),
              period,
            );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(metricIcon(metric), color: scheme.primary, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    metricName(l10n, metric),
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                if (avg != null)
                  Text(
                    l10n.insightsAverage(
                      metricValue(context, ref, metric, avg),
                    ),
                    style: theme.textTheme.labelLarge,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              s.loggedDays == 0
                  ? l10n.insightsNoData
                  : metric == InsightMetric.mood ||
                        metric == InsightMetric.meals
                  ? l10n.insightsLogged(s.loggedDays)
                  : l10n.insightsMet(s.metDays, s.loggedDays),
              style: theme.textTheme.bodySmall,
            ),
            if (trend != null)
              Text(
                trend,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.primary,
                ),
              ),
            if (s.loggedDays > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              DayMarkBars(series: s),
            ],
          ],
        ),
      ),
    );
  }
}

/// One bar per day: height from the value, colour from the mark; no-data
/// days are an empty outline so they never look like failures.
class DayMarkBars extends StatelessWidget {
  const DayMarkBars({super.key, required this.series, this.height = 56});
  final MetricSeries series;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final values = [for (final d in series.days) d.value ?? 0];
    final maxV = values.fold(0.0, math.max);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final reduce = MediaQuery.disableAnimationsOf(context);
    final weekly = series.days.length <= 7;
    return Column(
      children: [
        SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final d in series.days)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: weekly ? 4 : 1),
                    child: d.mark == DayMark.noData
                        ? Container(
                            height: 6,
                            decoration: BoxDecoration(
                              border: Border.all(color: scheme.outlineVariant),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          )
                        : TweenAnimationBuilder<double>(
                            tween: Tween(
                              end: maxV == 0
                                  ? 1
                                  : (d.value! / maxV).clamp(0.12, 1.0),
                            ),
                            duration: reduce
                                ? Duration.zero
                                : const Duration(milliseconds: 600),
                            builder: (_, v, _) => FractionallySizedBox(
                              heightFactor: v,
                              alignment: Alignment.bottomCenter,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: switch (d.mark) {
                                    DayMark.met => scheme.primary,
                                    DayMark.partial =>
                                      scheme.primary.withValues(alpha: 0.45),
                                    _ => scheme.outline.withValues(alpha: 0.45),
                                  },
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
            ],
          ),
        ),
        if (weekly)
          Row(
            children: [
              for (final d in series.days)
                Expanded(
                  child: Text(
                    DateFormat.E(locale)
                        .format(Days.fromKey(d.dayKey))
                        .characters
                        .take(2)
                        .toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    Widget item(String label, Color? fill, {bool outline = false}) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: fill,
            border: outline ? Border.all(color: scheme.outlineVariant) : null,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        item(l10n.legendMet, scheme.primary),
        item(l10n.legendPartial, scheme.primary.withValues(alpha: 0.45)),
        item(l10n.legendMissed, scheme.outline.withValues(alpha: 0.45)),
        item(l10n.legendNoData, null, outline: true),
      ],
    );
  }
}

/// Monday–Wednesday: last week in one card, with one suggestion.
class WeeklyReviewCard extends ConsumerWidget {
  const WeeklyReviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final review = ref.watch(weeklyReviewProvider);
    if (review == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final f = HealthFormat.of(
      context,
      ref.watch(settingsControllerProvider).unitSystem,
    );
    final tip = switch (review.tip) {
      ReviewTip.plan => l10n.reviewTipPlan,
      ReviewTip.habits => l10n.reviewTipHabits,
      ReviewTip.water => l10n.reviewTipWater,
      ReviewTip.sleep => l10n.reviewTipSleep,
      ReviewTip.activity => l10n.reviewTipActivity,
      ReviewTip.meals => l10n.reviewTipMeals,
      ReviewTip.keepGoing => l10n.reviewTipKeep,
    };
    final sleepAvg = review.sleep.average;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        color: scheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_graph, color: scheme.onSecondaryContainer),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.reviewTitle,
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          l10n.reviewWeekOf(
                            DateFormat.MMMd(locale)
                                .format(Days.fromKey(review.weekStart)),
                          ),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('• ${l10n.reviewActive(review.activeDays)}'),
              if (review.water.loggedDays > 0)
                Text('• ${l10n.reviewWater(review.water.metDays)}'),
              if (sleepAvg != null)
                Text(
                  '• ${l10n.reviewSleep(f.duration(Duration(minutes: (sleepAvg * 60).round())))}',
                ),
              if (review.activity.loggedDays > 0)
                Text('• ${l10n.reviewActivity(review.activity.loggedDays)}'),
              if (review.bestDay != null)
                Text(
                  '• ${l10n.reviewBest(DateFormat.EEEE(locale).format(Days.fromKey(review.bestDay!)))}',
                ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                tip,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    TextButton(
                      onPressed: () => ref
                          .read(wellbeingRepositoryProvider)
                          .dismissReview(review.weekStart),
                      child: Text(l10n.reviewClose),
                    ),
                    FilledButton.tonal(
                      onPressed: () => context.push(AppRoutes.insights),
                      child: Text(l10n.reviewSeeInsights),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
