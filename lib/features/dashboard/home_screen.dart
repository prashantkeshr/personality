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
import '../journey/home_journey.dart';
import '../../domain/services/health_stats.dart';
import '../today/today_providers.dart';
import '../today/today_widgets.dart';
import '../health/health_providers.dart';
import '../health/widgets/health_widgets.dart';
import '../routines/plan_screen.dart';
import '../routines/routine_providers.dart';

/// The daily command center: what matters today, in time order, with the
/// next action first. Journey, quests and stats follow.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, this.clock = DateTime.now});

  final DateTime Function() clock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      floatingActionButton: FloatingActionButton(
        key: const Key('quick-add'),
        tooltip: l10n.quickAdd,
        onPressed: () => showQuickAdd(context, ref),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 96),
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Greeting(clock: clock),
                  Semantics(
                    header: true,
                    child: Text(l10n.todayTitle,
                        style: theme.textTheme.headlineSmall),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(date,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            const DailyPlanRing(),
          ]),
          const SizedBox(height: AppSpacing.md),
          const DayStrip(),
          const SizedBox(height: AppSpacing.lg),
          const BadgeCelebrationHost(),
          const _CompleteProfileCard(),
          const _TodayOnly(children: [
            MoodCheckInCard(),
            SizedBox(height: AppSpacing.md),
            DayModeSelector(),
            SizedBox(height: AppSpacing.md),
            FiveMinuteCard(),
            SizedBox(height: AppSpacing.lg),
          ]),
          const AgendaTimeline(),
          const _HomeSuggestions(),
          const SizedBox(height: AppSpacing.xl),
          const JourneyCard(),
          const SizedBox(height: AppSpacing.md),
          const QuestsCard(),
          const SizedBox(height: AppSpacing.lg),
          const _TodaySection(),
          const SizedBox(height: AppSpacing.xl),
          const ForYouFeed(),
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

/// Shown only while today is selected (not when looking back).
class _TodayOnly extends ConsumerWidget {
  const _TodayOnly({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = Days.key(ref.watch(clockProvider)());
    if (ref.watch(selectedDayProvider) != today) return const SizedBox.shrink();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
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

/// Adaptive reminder suggestions; each needs an explicit accept (spec §33).
class _HomeSuggestions extends ConsumerWidget {
  const _HomeSuggestions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // One at a time on Home, the best-supported first; all on the Plan screen.
    final suggestions = [...ref.watch(suggestionsProvider)]
      ..sort((a, b) => b.occurrences.compareTo(a.occurrences));
    return Column(
      children: [
        for (final s in suggestions.take(1)) ...[
          const SizedBox(height: AppSpacing.md),
          SuggestionCard(suggestion: s),
        ],
      ],
    );
  }
}

/// "Good morning, Name" by local time.
class _Greeting extends ConsumerWidget {
  const _Greeting({required this.clock});
  final DateTime Function() clock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final hour = clock().hour;
    final greeting = hour < 12
        ? l10n.greetingMorning
        : hour < 17
            ? l10n.greetingAfternoon
            : l10n.greetingEvening;
    final name = ref.watch(profileProvider).value?.displayName?.split(' ').first;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        name == null || name.isEmpty ? greeting : l10n.greetingNamed(greeting, name),
        style: theme.textTheme.titleMedium
            ?.copyWith(color: theme.colorScheme.primary),
      ),
    );
  }
}

/// Asks for the details that personalise plans and styles, until given.
class _CompleteProfileCard extends ConsumerWidget {
  const _CompleteProfileCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final profile = ref.watch(profileProvider).value;
    final height = ref.watch(heightRecordsProvider).value;
    final weights = ref.watch(weightRecordsProvider).value;
    if (profile == null || height == null || weights == null) {
      return const SizedBox.shrink();
    }
    if (profile.gender != null &&
        profile.region != null &&
        height.isNotEmpty &&
        weights.isNotEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        color: theme.colorScheme.secondaryContainer,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(AppRoutes.profile),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(children: [
              Icon(Icons.person_outline,
                  color: theme.colorScheme.onSecondaryContainer),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.homeCompleteProfile,
                        style: theme.textTheme.titleSmall),
                    Text(l10n.homeCompleteProfileInfo,
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ]),
          ),
        ),
      ),
    );
  }
}
