import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/body_format.dart';
import '../../shared/widgets/empty_state.dart';
import '../health/body_providers.dart';
import '../health/health_providers.dart';
import '../health/widgets/health_widgets.dart';

/// Today-first dashboard (spec §63). Summary cards appear as features ship.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.clock = DateTime.now});

  final DateTime Function() clock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat.yMMMMEEEEd(locale).format(clock());

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Semantics(
            header: true,
            child: Text(l10n.todayTitle, style: theme.textTheme.headlineSmall),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(date,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.xl),
          const _TodaySection(),
          const SizedBox(height: AppSpacing.xl),
          Semantics(
            header: true,
            child: Text(l10n.homeBodyTitle, style: theme.textTheme.titleMedium),
          ),
          const SizedBox(height: AppSpacing.sm),
          const _BodySummary(),
        ],
      ),
    );
  }
}

class _BodySummary extends ConsumerWidget {
  const _BodySummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format =
        BodyFormat.of(context, ref.watch(settingsControllerProvider).unitSystem);
    final height = ref.watch(primaryHeightProvider).value;
    final weights = ref.watch(weightRecordsProvider).value ?? const [];

    if (height == null) {
      return Card(
        child: EmptyState(
          icon: Icons.height,
          title: l10n.heightTitle,
          message: l10n.heightEmpty,
          action: FilledButton(
            onPressed: () => context.push(AppRoutes.height),
            child: Text(l10n.heightAdd),
          ),
        ),
      );
    }

    Widget metric(String label, String value, String route) => Expanded(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.push(route),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Text(value, style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            ),
          ),
        );

    return Row(
      children: [
        metric(l10n.heightTitle, format.height(height.value), AppRoutes.height),
        const SizedBox(width: AppSpacing.md),
        metric(
          l10n.weightTitle,
          weights.isEmpty
              ? l10n.measurementNotRecorded
              : format.weight(weights.first.value),
          AppRoutes.weight,
        ),
      ],
    );
  }
}

/// Today's plan-vs-actual numbers (spec §81). Each tile opens its feature.
class _TodaySection extends ConsumerWidget {
  const _TodaySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = HealthFormat.of(
        context, ref.watch(settingsControllerProvider).unitSystem);
    final s = ref.watch(todaySummaryProvider);
    final t = s.targets;

    final tiles = [
      _Tile(Icons.water_drop_outlined, l10n.featureWater,
          '${format.water(s.waterMl)} / ${format.water(t.waterMl.toDouble())}',
          s.waterMl / t.waterMl, AppRoutes.water),
      _Tile(
          Icons.bedtime_outlined,
          l10n.featureSleep,
          s.lastSleep == null
              ? l10n.measurementNotRecorded
              : format.duration(s.lastSleep!),
          (s.lastSleep?.inMinutes ?? 0) / t.sleepMinutes,
          AppRoutes.sleep),
      _Tile(Icons.directions_walk, l10n.stepsLabel,
          '${format.count(s.steps)} / ${format.count(t.steps)}',
          s.steps / t.steps, AppRoutes.activity),
      _Tile(Icons.timer_outlined, l10n.activeMinutesLabel,
          '${s.activeMinutes} / ${format.minutes(t.activeMinutes)}',
          s.activeMinutes / t.activeMinutes, AppRoutes.activity),
      _Tile(
          Icons.check_circle_outline,
          l10n.featureHabits,
          s.habits.scheduled == 0
              ? l10n.habitsNoneToday
              : '${s.habits.completed} / ${s.habits.scheduled}',
          s.habits.scheduled == 0 ? 0 : s.habits.completed / s.habits.scheduled,
          AppRoutes.habits),
      _Tile(Icons.restaurant_outlined, l10n.featureMeals,
          l10n.mealsLogged(s.mealCount), null, AppRoutes.meals),
    ];

    return LayoutBuilder(builder: (context, c) {
      final columns = c.maxWidth >= 720 ? 3 : 2;
      final width = (c.maxWidth - AppSpacing.md * (columns - 1)) / columns;
      return Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: [
          for (final tile in tiles) SizedBox(width: width, child: tile),
        ],
      );
    });
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.label, this.value, this.fraction, this.route);

  final IconData icon;
  final String label;
  final String value;
  final double? fraction;
  final String route;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(route),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(label,
                        style: theme.textTheme.labelMedium,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(value, style: theme.textTheme.titleMedium),
              if (fraction != null) ...[
                const SizedBox(height: AppSpacing.sm),
                LinearProgressIndicator(
                  value: fraction!.isNaN ? 0 : fraction!.clamp(0.0, 1.0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
