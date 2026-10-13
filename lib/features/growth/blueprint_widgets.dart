import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/blueprint_engine.dart';
import '../../l10n/app_localizations.dart';
import 'growth_providers.dart';

String areaLabel(AppLocalizations l, BlueprintArea a) => switch (a) {
      BlueprintArea.body => l.areaBody,
      BlueprintArea.fitness => l.areaFitness,
      BlueprintArea.posture => l.areaPosture,
      BlueprintArea.sleep => l.areaSleep,
      BlueprintArea.hydration => l.areaHydration,
      BlueprintArea.habits => l.areaHabits,
      BlueprintArea.style => l.areaStyle,
      BlueprintArea.grooming => l.areaGrooming,
      BlueprintArea.skills => l.areaSkills,
    };

IconData areaIcon(BlueprintArea a) => switch (a) {
      BlueprintArea.body => Icons.monitor_weight_outlined,
      BlueprintArea.fitness => Icons.directions_run,
      BlueprintArea.posture => Icons.accessibility_new,
      BlueprintArea.sleep => Icons.bedtime_outlined,
      BlueprintArea.hydration => Icons.water_drop_outlined,
      BlueprintArea.habits => Icons.check_circle_outline,
      BlueprintArea.style => Icons.checkroom_outlined,
      BlueprintArea.grooming => Icons.face_retouching_natural,
      BlueprintArea.skills => Icons.sports_martial_arts,
    };

String _benefit(AppLocalizations l, BlueprintArea a) => switch (a) {
      BlueprintArea.body => l.benefitBody,
      BlueprintArea.fitness => l.benefitFitness,
      BlueprintArea.posture => l.benefitPosture,
      BlueprintArea.sleep => l.benefitSleep,
      BlueprintArea.hydration => l.benefitHydration,
      BlueprintArea.habits => l.benefitHabits,
      BlueprintArea.style => l.benefitStyle,
      BlueprintArea.grooming => l.benefitGrooming,
      BlueprintArea.skills => l.benefitSkills,
    };

String _alternatives(AppLocalizations l, BlueprintArea a) => switch (a) {
      BlueprintArea.body => l.altBody,
      BlueprintArea.fitness => l.altFitness,
      BlueprintArea.posture => l.altPosture,
      BlueprintArea.sleep => l.altSleep,
      BlueprintArea.hydration => l.altHydration,
      BlueprintArea.habits => l.altHabits,
      BlueprintArea.style => l.altStyle,
      BlueprintArea.grooming => l.altGrooming,
      BlueprintArea.skills => l.altSkills,
    };

String reasonText(AppLocalizations l, BlueprintReason r) => switch (r) {
      BlueprintReason.yourGoal => l.whyYourGoal,
      BlueprintReason.noRecords => l.whyNoRecords,
      BlueprintReason.onTrack => l.whyOnTrack,
      BlueprintReason.partly => l.whyPartly,
      BlueprintReason.fallingBehind => l.whyBehind,
    };

(String, String) actionOf(AppLocalizations l, BlueprintAction a) => switch (a) {
      BlueprintAction.setBodyPlan => (l.actSetBodyPlan, AppRoutes.bodyPlan),
      BlueprintAction.logWeight => (l.actLogWeight, AppRoutes.weight),
      BlueprintAction.startWorkout => (l.actStartWorkout, AppRoutes.programs),
      BlueprintAction.checkPosture => (l.actCheckPosture, AppRoutes.posture),
      BlueprintAction.logSleep => (l.actLogSleep, AppRoutes.sleep),
      BlueprintAction.addWater => (l.actAddWater, AppRoutes.water),
      BlueprintAction.doHabits => (l.actDoHabits, AppRoutes.habits),
      BlueprintAction.addClothes => (l.actAddClothes, AppRoutes.wardrobe),
      BlueprintAction.buildOutfit => (l.actBuildOutfit, AppRoutes.outfits),
      BlueprintAction.takeSnapshot => (l.actTakeSnapshot, AppRoutes.snapshots),
      BlueprintAction.practiseSkill => (l.actPractiseSkill, AppRoutes.skills),
    };

/// Explainable recommendation: why this, what it helps with, other ways.
Future<void> showWhySheet(BuildContext context, AreaStatus s) {
  final l = AppLocalizations.of(context);
  final theme = Theme.of(context);
  final (label, route) = actionOf(l, s.action);
  Widget section(IconData icon, String title, String body) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: theme.textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(body, style: theme.textTheme.bodyMedium),
            ]),
          ),
        ]),
      );
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (c) => SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(areaIcon(s.area), color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(areaLabel(l, s.area), style: theme.textTheme.titleLarge)),
        ]),
        const SizedBox(height: AppSpacing.lg),
        section(Icons.help_outline, l.whyTitle, reasonText(l, s.reason)),
        section(Icons.favorite_outline, l.whyBenefit, _benefit(l, s.area)),
        section(Icons.alt_route, l.whyAlternatives, _alternatives(l, s.area)),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            key: const Key('why-action'),
            onPressed: () {
              Navigator.of(c).pop();
              context.push(route);
            },
            icon: const Icon(Icons.arrow_forward),
            label: Text(label),
          ),
        ),
      ]),
    ),
  );
}

/// The Blueprint: each area with its own progress, no overall score.
class BlueprintSection extends ConsumerWidget {
  const BlueprintSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final areas = ref.watch(blueprintProvider);
    final next = Blueprint.nextStep(areas);
    final focus = areas.where((a) => a.focus).toList();
    final rest = areas.where((a) => !a.focus).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Semantics(header: true, child: Text(l.blueprintTitle, style: theme.textTheme.titleLarge)),
      const SizedBox(height: AppSpacing.xs),
      Text(l.blueprintIntro, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      const SizedBox(height: AppSpacing.md),
      if (next != null) _NextStepCard(status: next),
      if (focus.isEmpty)
        Card(
          child: ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: Text(l.blueprintPickGoals),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.goalFinder),
          ),
        ),
      if (focus.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.sm),
        Text(l.blueprintFocus, style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        _AreaGrid(areas: focus),
      ],
      const SizedBox(height: AppSpacing.sm),
      Text(l.blueprintExplore, style: theme.textTheme.titleSmall),
      const SizedBox(height: AppSpacing.xs),
      _AreaGrid(areas: rest),
    ]);
  }
}

class _NextStepCard extends StatelessWidget {
  const _NextStepCard({required this.status});
  final AreaStatus status;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (label, route) = actionOf(l, status.action);
    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.blueprintNextStep,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: scheme.onPrimaryContainer)),
          const SizedBox(height: AppSpacing.xs),
          Row(children: [
            Icon(areaIcon(status.area), color: scheme.onPrimaryContainer),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(label,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: scheme.onPrimaryContainer, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: AppSpacing.sm),
          Wrap(spacing: AppSpacing.sm, children: [
            FilledButton(
              key: const Key('next-step-go'),
              onPressed: () => context.push(route),
              child: Text(l.blueprintGo),
            ),
            TextButton(
              key: const Key('next-step-why'),
              onPressed: () => showWhySheet(context, status),
              child: Text(l.whyTitle),
            ),
          ]),
        ]),
      ),
    );
  }
}

class _AreaGrid extends StatelessWidget {
  const _AreaGrid({required this.areas});
  final List<AreaStatus> areas;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth > 600 ? 3 : 2;
      final w = (c.maxWidth - AppSpacing.sm * (cols - 1)) / cols;
      return Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
        for (final a in areas)
          SizedBox(
            width: w,
            child: Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                key: Key('area-${a.area.name}'),
                onTap: () => showWhySheet(context, a),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Icon(areaIcon(a.area), size: 20, color: scheme.primary),
                      const Spacer(),
                      if (a.focus) Icon(Icons.flag, size: 16, color: scheme.tertiary),
                    ]),
                    const SizedBox(height: AppSpacing.sm),
                    Text(areaLabel(l, a.area),
                        style: theme.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: AppSpacing.xs),
                    if (a.progress == null)
                      Text(l.blueprintNoData,
                          style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant))
                    else ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(value: a.progress, minHeight: 6),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                          a.metDays != null
                              ? l.blueprintDaysMet(a.metDays!)
                              : l.blueprintPercent((a.progress! * 100).round()),
                          style: theme.textTheme.bodySmall),
                    ],
                  ]),
                ),
              ),
            ),
          ),
      ]);
    });
  }
}
