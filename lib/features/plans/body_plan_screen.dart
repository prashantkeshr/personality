import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/units/units.dart';
import '../../data/repositories/body_plan_repository.dart';
import '../../domain/entities/body.dart';
import '../../domain/entities/health.dart';
import '../../domain/entities/routine.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/meal_planner.dart';
import '../../domain/services/nutrition_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/body_format.dart';
import '../../shared/visual/reveal.dart';
import '../exercise/exercise_library_screen.dart' show exerciseCatalogProvider;
import '../health/body_providers.dart';
import '../health/health_providers.dart';
import '../routines/routine_providers.dart';
import 'plan_labels.dart';
import 'plan_providers.dart';

/// Diet & body plan: set up a goal, then follow daily meals and a weekly
/// training schedule.
class BodyPlanScreen extends ConsumerWidget {
  const BodyPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final plan = ref.watch(activeBodyPlanProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.featureBodyPlan)),
      body: switch (plan) {
        AsyncData(value: final p?) => _PlanDashboard(plan: p),
        AsyncData() => const _PlanSetup(),
        AsyncError() => Center(child: Text(l10n.recordSaveError)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Setup

class _PlanSetup extends ConsumerStatefulWidget {
  const _PlanSetup({this.initial, this.onCancel});

  /// When changing an existing plan, start from its choices.
  final BodyPlan? initial;
  final VoidCallback? onCancel;

  @override
  ConsumerState<_PlanSetup> createState() => _PlanSetupState();
}

class _PlanSetupState extends ConsumerState<_PlanSetup> {
  PlanKind? _kind;
  PlanPace _pace = PlanPace.steady;
  DietPreference? _diet;
  final _target = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _target.dispose();
    super.dispose();
  }

  PlanKind _defaultKind(Set<GoalType> goals, NutritionInput i) {
    final preferred = goals.contains(GoalType.weightManagement)
        ? (i.bmi < 18.5 ? PlanKind.gainWeight : PlanKind.loseFat)
        : goals.contains(GoalType.fitness)
            ? PlanKind.buildMuscle
            : PlanKind.maintain;
    return NutritionEngine.blockFor(preferred, i) == null
        ? preferred
        : PlanKind.maintain;
  }

  double? _targetKg(UnitSystem units) {
    final v = double.tryParse(_target.text.trim().replaceAll(',', '.'));
    if (v == null) return null;
    final kg = units == UnitSystem.metric ? v : UnitConversions.poundsToKg(v);
    return kg < BodyLimits.minWeightKg || kg > BodyLimits.maxWeightKg ? null : kg;
  }

  Future<void> _start(NutritionInput input, PlanTargets t, DietPreference diet,
      double? targetKg) async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(bodyPlanRepositoryProvider).start(
          targets: t,
          diet: diet,
          weightKg: input.weightKg,
          targetWeightKg: t.kind == PlanKind.maintain ? null : targetKg);
      // Remember the food preference for next time.
      final profiles = ref.read(profileRepositoryProvider);
      final p = await profiles.load();
      if (p.dietPreference == null) {
        await profiles.save(p.copyWith(dietPreference: () => diet));
      }
      messenger.showSnackBar(SnackBar(content: Text(l10n.bodyPlanStarted)));
    } catch (e, st) {
      AppLogger.error('plan.start', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final input = ref.watch(nutritionInputProvider);
    final profile = ref.watch(profileProvider).value;
    final goals = ref.watch(goalsProvider).value ?? const {};
    final units = ref.watch(settingsControllerProvider).unitSystem;
    final format = BodyFormat.of(context, units);

    final intro = Text(l10n.bodyPlanIntro,
        style: theme.textTheme.bodyMedium
            ?.copyWith(color: theme.colorScheme.onSurfaceVariant));

    if (input == null) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          intro,
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.bodyPlanNeedData, style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
                    FilledButton.tonal(
                      onPressed: () => context.push(AppRoutes.height),
                      child: Text(l10n.heightAdd),
                    ),
                    FilledButton.tonal(
                      onPressed: () => context.push(AppRoutes.weight),
                      child: Text(l10n.weightAdd),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final kind = _kind ??= widget.initial?.kind ?? _defaultKind(goals, input);
    final diet = _diet ??= widget.initial?.diet ??
        profile?.dietPreference ??
        DietPreference.vegetarian;
    final t = NutritionEngine.targets(input, kind, _pace);
    final targetKg = _targetKg(units);
    final weeks = t.weeksTo(input.weightKg, targetKg);
    final (lo, hi) = NutritionEngine.healthyRange(input.heightCm);
    final missing = profile?.gender == null ||
        profile?.region == null ||
        profile?.ageRange == null ||
        profile?.activityLevel == null;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        intro,
        if (missing) ...[
          const SizedBox(height: AppSpacing.md),
          Card(
            color: theme.colorScheme.secondaryContainer,
            child: ListTile(
              leading: const Icon(Icons.tune),
              title: Text(l10n.bodyPlanImprove),
              trailing: TextButton(
                onPressed: () => context.push(AppRoutes.profile),
                child: Text(l10n.bodyPlanOpenProfile),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Text(l10n.bodyPlanGoal, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.05,
          children: [
            for (final k in PlanKind.values)
              _GoalCard(
                kind: k,
                selected: k == kind,
                block: NutritionEngine.blockFor(k, input),
                onTap: () => setState(() => _kind = k),
              ),
          ],
        ),
        if (kind != PlanKind.maintain) ...[
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.bodyPlanPace, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<PlanPace>(
            segments: [
              for (final p in PlanPace.values)
                ButtonSegment(value: p, label: Text(l10n.paceName(p))),
            ],
            selected: {_pace},
            onSelectionChanged: (s) => setState(() => _pace = s.first),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(l10n.bodyPlanRate(format.weightChange(t.weeklyChangeKg)),
              style: theme.textTheme.bodySmall),
        ],
        const SizedBox(height: AppSpacing.xl),
        Text(l10n.profileDiet, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          for (final d in DietPreference.values)
            ChoiceChip(
              label: Text(l10n.dietLabel(d)),
              selected: d == diet,
              onSelected: (_) => setState(() => _diet = d),
            ),
        ]),
        if (kind != PlanKind.maintain) ...[
          const SizedBox(height: AppSpacing.xl),
          TextField(
            key: const Key('plan-target'),
            controller: _target,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: l10n.bodyPlanTarget,
              suffixText: units == UnitSystem.metric ? 'kg' : 'lb',
              helperText: l10n.bodyPlanHealthyRange(
                  '${format.weight(lo)} – ${format.weight(hi)}'),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        _TargetsCard(targets: t, weeks: weeks),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.bodyPlanDisclaimer, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          icon: const Icon(Icons.flag_outlined),
          label: Text(l10n.bodyPlanStart),
          onPressed: _saving || NutritionEngine.blockFor(kind, input) != null
              ? null
              : () => _start(input, t, diet, targetKg),
        ),
        if (widget.onCancel != null)
          TextButton(
            onPressed: widget.onCancel,
            child: Text(l10n.actionCancel),
          ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.kind,
    required this.selected,
    required this.block,
    required this.onTap,
  });

  final PlanKind kind;
  final bool selected;
  final PlanBlock? block;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final reduce = MediaQuery.disableAnimationsOf(context);
    final enabled = block == null;
    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      label: l10n.planKindName(kind),
      excludeSemantics: true,
      child: GestureDetector(
        key: Key('plan-${kind.name}'),
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: reduce ? Duration.zero : const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                width: selected ? 3 : 0,
                color: selected ? scheme.primary : Colors.transparent),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(fit: StackFit.expand, children: [
              ColorFiltered(
                colorFilter: enabled
                    ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                    : const ColorFilter.matrix([
                        0.33, 0.33, 0.33, 0, 0, //
                        0.33, 0.33, 0.33, 0, 0,
                        0.33, 0.33, 0.33, 0, 0,
                        0, 0, 0, 1, 0,
                      ]),
                child: Image.asset(planImage(kind),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        ColoredBox(color: scheme.primaryContainer)),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.25, 1],
                    colors: [Color(0x00000000), Color(0xD9000000)],
                  ),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.planKindName(kind),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                    Text(
                        block == null
                            ? l10n.planKindInfo(kind)
                            : l10n.planBlockReason(block!),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Color(0xE6FFFFFF), fontSize: 11)),
                  ],
                ),
              ),
              if (selected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: scheme.primary,
                    child: Icon(Icons.check, size: 16, color: scheme.onPrimary),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}

/// Calories with a macro split bar, water and the expected timeline.
class _TargetsCard extends StatelessWidget {
  const _TargetsCard({required this.targets, this.weeks, this.eaten});

  final PlanTargets targets;
  final int? weeks;

  /// Calories logged today (dashboard only).
  final int? eaten;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final t = targets;
    final reduce = MediaQuery.disableAnimationsOf(context);
    final parts = [
      (l10n.bodyPlanProtein, t.proteinG, t.proteinG * 4, scheme.primary),
      (l10n.bodyPlanCarbs, t.carbsG, t.carbsG * 4, scheme.tertiary),
      (l10n.bodyPlanFat, t.fatG, t.fatG * 9, scheme.secondary),
    ];
    final total = parts.fold(0, (s, p) => s + p.$3);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox.square(
                dimension: 92,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(
                      begin: 0,
                      end: eaten == null
                          ? 1
                          : (eaten! / t.calories).clamp(0.0, 1.0)),
                  duration: reduce ? Duration.zero : const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (_, v, _) => CustomPaint(
                    painter: _RingPainter(v, scheme),
                    child: Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text('${eaten ?? t.calories}',
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        Text('kcal', style: theme.textTheme.labelSmall),
                      ]),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.bodyPlanCalories, style: theme.textTheme.titleMedium),
                    if (eaten != null)
                      Text(l10n.bodyPlanEaten(eaten!, t.calories),
                          style: theme.textTheme.bodyMedium),
                    if (t.maintenance > 0)
                      Text(l10n.bodyPlanMaintenance(t.maintenance),
                          style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 10,
                child: Row(children: [
                  for (final p in parts)
                    Expanded(
                        flex: math.max(1, (p.$3 * 1000 / total).round()),
                        child: ColoredBox(color: p.$4)),
                ]),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              for (final p in parts)
                Expanded(
                  child: Row(children: [
                    Container(
                        width: 8,
                        height: 8,
                        decoration:
                            BoxDecoration(color: p.$4, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text('${p.$1} ${l10n.bodyPlanGrams(p.$2)}',
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall),
                    ),
                  ]),
                ),
            ]),
            const Divider(height: AppSpacing.xl),
            Row(children: [
              Icon(Icons.water_drop_outlined, size: 18, color: scheme.primary),
              const SizedBox(width: AppSpacing.xs),
              Text('${l10n.bodyPlanWater}: ${(t.waterMl / 1000).toStringAsFixed(1)} L',
                  style: theme.textTheme.bodyMedium),
            ]),
            if (weeks != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(children: [
                Icon(Icons.flag_outlined, size: 18, color: scheme.primary),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                    child: Text(l10n.bodyPlanTimeline(weeks!),
                        style: theme.textTheme.bodyMedium)),
              ]),
            ],
            if (t.limitedByFloor) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.bodyPlanFloorNote,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: scheme.tertiary)),
            ],
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value, this.scheme);
  final double value;
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.09;
    final rect = (Offset.zero & size).deflate(stroke / 2 + 1);
    canvas.drawArc(rect, 0, math.pi * 2, false, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = scheme.surfaceContainerHighest);
    if (value <= 0) return;
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * value, false, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [scheme.tertiary, scheme.primary, scheme.tertiary],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(rect));
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value;
}

// ---------------------------------------------------------------------------
// Dashboard

class _PlanDashboard extends ConsumerStatefulWidget {
  const _PlanDashboard({required this.plan});
  final BodyPlan plan;

  @override
  ConsumerState<_PlanDashboard> createState() => _PlanDashboardState();
}

class _PlanDashboardState extends ConsumerState<_PlanDashboard> {
  final Map<MealSlot, int> _swaps = {};
  bool _changing = false;

  BodyPlan get plan => widget.plan;

  /// The plan's stored targets, with maintenance estimated from today's
  /// data when available (0 hides it).
  PlanTargets _targets(NutritionInput? input) => PlanTargets(
        kind: plan.kind,
        pace: plan.pace,
        bmr: 0,
        maintenance: input == null ? 0 : NutritionEngine.maintenance(input),
        calories: plan.calories,
        proteinG: plan.proteinG,
        carbsG: plan.carbsG,
        fatG: plan.fatG,
        waterMl: plan.waterMl,
        weeklyChangeKg: 0,
      );

  Future<void> _logMeal(PlannedMeal m, String lang) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(mealRepositoryProvider).add(
            type: mealTypeFor(m.meal.slot),
            food: m.meal.nameIn(lang),
            quantity: '${m.meal.portionIn(lang)} × ${_servings(m.servings)}',
            calories: m.kcal.toDouble(),
            eatenAt: ref.read(clockProvider)(),
          );
      messenger.showSnackBar(SnackBar(content: Text(l10n.bodyPlanLogged)));
    } catch (e, st) {
      AppLogger.error('plan.logMeal', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
    }
  }

  Future<void> _addRoutine(List<TrainingDay> week) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      var mask = 0;
      for (final d in week) {
        if (d.type != WorkoutType.rest) mask |= 1 << (d.weekday - 1);
      }
      final repo = ref.read(routineRepositoryProvider);
      final id = await repo.createRoutine(l10n.bodyPlanRoutineName, Weekdays(mask));
      await repo.addItem(id, 18 * 60, l10n.bodyPlanWorkoutItem, RoutineItemKind.exercise);
      messenger.showSnackBar(SnackBar(content: Text(l10n.bodyPlanRoutineAdded)));
    } catch (e, st) {
      AppLogger.error('plan.routine', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
    }
  }

  Future<void> _update(NutritionInput input) async {
    final t = NutritionEngine.targets(input, plan.kind, plan.pace);
    await ref.read(bodyPlanRepositoryProvider).start(
        targets: t,
        diet: plan.diet,
        weightKg: input.weightKg,
        targetWeightKg: plan.targetWeightKg);
  }

  Future<void> _end() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.bodyPlanEndConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.actionCancel)),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.bodyPlanEnd)),
        ],
      ),
    );
    if (ok == true) await ref.read(bodyPlanRepositoryProvider).end();
  }

  static String _servings(double s) =>
      s == s.roundToDouble() ? s.toStringAsFixed(0) : s.toString();

  @override
  Widget build(BuildContext context) {
    if (_changing) {
      return _PlanSetup(
          initial: plan, onCancel: () => setState(() => _changing = false));
    }
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final lang = Localizations.localeOf(context).languageCode;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final now = ref.watch(clockProvider)();
    final units = ref.watch(settingsControllerProvider).unitSystem;
    final format = BodyFormat.of(context, units);
    final input = ref.watch(nutritionInputProvider);
    final region = ref.watch(profileProvider).value?.region;
    final library = ref.watch(mealLibraryProvider).value;
    final exercises = ref.watch(exerciseCatalogProvider).value ?? const [];
    final eaten = ref.watch(todayCaloriesProvider);
    final todayMeals = (ref.watch(mealsProvider).value ?? const [])
        .where((m) => Days.key(m.eatenAt) == Days.key(now))
        .map((m) => m.food)
        .toSet();

    final start = Days.fromKey(plan.startDay);
    final dayNumber = DateTime(now.year, now.month, now.day)
        .difference(DateTime(2020))
        .inDays;
    final menu = library == null
        ? null
        : MealPlanner.day(
            library: library,
            calories: plan.calories,
            proteinG: plan.proteinG,
            diet: plan.diet,
            day: dayNumber,
            region: region,
            swaps: _swaps);
    final week = TrainingPlanner.week(plan.kind, plan.pace, region: region);
    final today = week[now.weekday - 1];
    final current = input?.weightKg ?? plan.startWeightKg;
    final weeksIn = now.difference(start).inDays / 7;
    final expectedRate = input == null
        ? 0.0
        : NutritionEngine.targets(input, plan.kind, plan.pace).weeklyChangeKg;
    final expected = plan.startWeightKg + expectedRate * weeksIn;
    final changed = input != null && (current - plan.startWeightKg).abs() >= 2;
    String exName(String id) {
      for (final e in exercises) {
        if (e.id == id) return e.name[lang] ?? e.name['en']!;
      }
      return id;
    }

    var reveal = 0;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Reveal(
          index: reveal++,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 150,
              child: Stack(fit: StackFit.expand, children: [
                Image.asset(planImage(plan.kind),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        ColoredBox(color: scheme.primaryContainer)),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xE6000000), Color(0x33000000)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(l10n.planKindName(plan.kind),
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(color: Colors.white)),
                      Text(
                          '${l10n.paceName(plan.pace)} · ${l10n.dietLabel(plan.diet)} · '
                          '${l10n.bodyPlanSince(DateFormat.MMMd(locale).format(start))}',
                          style: const TextStyle(color: Color(0xE6FFFFFF))),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
        if (changed) ...[
          const SizedBox(height: AppSpacing.md),
          Card(
            color: scheme.tertiaryContainer,
            child: ListTile(
              leading: const Icon(Icons.update),
              title: Text(l10n.bodyPlanUpdate),
              trailing: FilledButton.tonal(
                onPressed: () => _update(input),
                child: Text(l10n.bodyPlanUpdateAction),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Reveal(
          index: reveal++,
          child: Card(
            child: ListTile(
              leading: const Icon(Icons.monitor_weight_outlined),
              title: Text(l10n.bodyPlanProgress),
              subtitle: Text([
                l10n.bodyPlanWeightNow(
                    format.weight(current), format.weight(plan.startWeightKg)),
                if (plan.kind != PlanKind.maintain && weeksIn >= 1)
                  l10n.bodyPlanExpected(format.weight(expected)),
              ].join('\n')),
              trailing: TextButton(
                onPressed: () => context.push(AppRoutes.weight),
                child: Text(l10n.bodyPlanLogWeight),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.bodyPlanToday, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Reveal(index: reveal++, child: _TargetsCard(targets: _targets(input), eaten: eaten)),
        const SizedBox(height: AppSpacing.xl),
        Text(l10n.bodyPlanMenu, style: theme.textTheme.titleMedium),
        if (region != null)
          Text(l10n.bodyPlanLocalMenu(l10n.regionLabel(region)),
              style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        if (menu == null)
          const Center(child: CircularProgressIndicator())
        else
          for (final m in menu.meals)
            Reveal(
              index: reveal++,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md, AppSpacing.md, AppSpacing.sm, AppSpacing.md),
                    child: Row(children: [
                      CircleAvatar(
                        backgroundColor: scheme.primaryContainer,
                        child: Icon(slotIcon(m.meal.slot),
                            color: scheme.onPrimaryContainer),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                m.extra
                                    ? l10n.bodyPlanProteinBoost
                                    : l10n.slotName(m.meal.slot),
                                style: theme.textTheme.labelMedium
                                    ?.copyWith(color: scheme.primary)),
                            Text(m.meal.nameIn(lang),
                                style: theme.textTheme.titleSmall),
                            Text(
                                '${m.meal.portionIn(lang)} ${m.servings == 1 ? '' : l10n.bodyPlanServings(_servings(m.servings))}'
                                    .trim(),
                                style: theme.textTheme.bodySmall),
                            Text(
                                '${l10n.bodyPlanKcal(m.kcal)} · ${l10n.bodyPlanProtein} ${l10n.bodyPlanGrams(m.protein)}',
                                style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        if (todayMeals.contains(m.meal.nameIn(lang)))
                          Chip(
                              avatar: const Icon(Icons.check, size: 16),
                              label: Text(l10n.bodyPlanLogged))
                        else
                          FilledButton.tonal(
                            key: Key('log-${m.meal.id}'),
                            onPressed: () => _logMeal(m, lang),
                            child: Text(l10n.bodyPlanLog),
                          ),
                        if (!m.extra)
                          TextButton(
                            key: Key('swap-${m.meal.slot.name}'),
                            onPressed: () => setState(() => _swaps.update(
                                m.meal.slot, (v) => v + 1,
                                ifAbsent: () => 1)),
                            child: Text(l10n.bodyPlanSwap),
                          ),
                      ]),
                    ]),
                  ),
                ),
              ),
            ),
        const SizedBox(height: AppSpacing.xl),
        Text(l10n.bodyPlanWeek, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(children: [
          for (final d in week)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: d.weekday == now.weekday
                        ? scheme.primary
                        : d.type == WorkoutType.rest
                            ? scheme.surfaceContainerHigh
                            : scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(children: [
                    Text(
                        DateFormat.E(locale)
                            .format(DateTime(2024, 1, d.weekday))
                            .characters
                            .take(2)
                            .toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: d.weekday == now.weekday
                                ? scheme.onPrimary
                                : null)),
                    const SizedBox(height: 4),
                    Icon(workoutIcon(d.type),
                        size: 18,
                        color: d.weekday == now.weekday
                            ? scheme.onPrimary
                            : scheme.onPrimaryContainer),
                  ]),
                ),
              ),
            ),
        ]),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.bodyPlanTodayWorkout(l10n.workoutName(today.type)),
                    style: theme.textTheme.titleMedium),
                if (today.minutes > 0)
                  Text(l10n.bodyPlanMinutes(today.minutes),
                      style: theme.textTheme.bodySmall),
                for (final id in today.exerciseIds)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: Icon(Icons.play_circle_outline, color: scheme.primary),
                    title: Text(exName(id)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('${AppRoutes.exerciseLibrary}/$id'),
                  ),
                const SizedBox(height: AppSpacing.sm),
                if (region?.hotClimate ?? false) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(Icons.wb_sunny_outlined, size: 18, color: scheme.tertiary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                        child: Text(l10n.bodyPlanHotClimate,
                            style: theme.textTheme.bodySmall)),
                  ]),
                  const SizedBox(height: AppSpacing.sm),
                ],
                OutlinedButton.icon(
                  icon: const Icon(Icons.event_repeat),
                  label: Text(l10n.bodyPlanAddRoutine),
                  onPressed: () => _addRoutine(week),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(l10n.bodyPlanDisclaimer, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.md),
        Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _changing = true),
              child: Text(l10n.bodyPlanChange),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: TextButton(
              onPressed: _end,
              child: Text(l10n.bodyPlanEnd),
            ),
          ),
        ]),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
