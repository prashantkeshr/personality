import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/health.dart';
import '../../domain/entities/provenance.dart';
import '../../domain/entities/routine.dart';
import '../../domain/services/day_agenda.dart';
import '../../domain/services/health_stats.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/visual/reveal.dart';
import '../health/health_providers.dart';
import '../health/widgets/health_widgets.dart' show HealthFormat;
import '../plans/plan_labels.dart';
import '../plans/plan_providers.dart';
import '../routines/reminder_sync_host.dart' show formatMinute;
import '../routines/routine_providers.dart';
import '../style/style_providers.dart';
import 'today_providers.dart';

/// Small "Daily plan %" ring for the Home header.
class DailyPlanRing extends ConsumerWidget {
  const DailyPlanRing({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final agenda = ref.watch(agendaProvider(ref.watch(selectedDayProvider)));
    if (agenda == null || agenda.countedTotal == 0) {
      return const SizedBox.shrink();
    }
    final pct = (agenda.completion * 100).round();
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: '${l10n.dailyPlan} $pct%',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.dailyPlan,
            textAlign: TextAlign.right,
            style: theme.textTheme.labelMedium,
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox.square(
            dimension: 52,
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: agenda.completion),
              duration: reduce
                  ? Duration.zero
                  : const Duration(milliseconds: 700),
              builder: (_, v, _) => CustomPaint(
                painter: _Ring(v, theme.colorScheme),
                child: Center(
                  child: Text(
                    '$pct%',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Ring extends CustomPainter {
  _Ring(this.value, this.scheme);
  final double value;
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(4);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = scheme.surfaceContainerHighest;
    canvas.drawArc(rect, 0, math.pi * 2, false, base);
    if (value > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        math.pi * 2 * value,
        false,
        base
          ..strokeCap = StrokeCap.round
          ..color = scheme.primary,
      );
    }
  }

  @override
  bool shouldRepaint(_Ring old) => old.value != value;
}

/// The past week plus today; tap a day to look back.
class DayStrip extends ConsumerWidget {
  const DayStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final now = ref.watch(clockProvider)();
    final selected = ref.watch(selectedDayProvider);
    final days = [
      for (var i = 6; i >= 0; i--) DateTime(now.year, now.month, now.day - i),
    ];
    return Row(
      children: [
        for (final d in days)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Semantics(
                button: true,
                selected: Days.key(d) == selected,
                label: DateFormat.MMMEd(locale).format(d),
                excludeSemantics: true,
                child: InkWell(
                  key: Key('day-${Days.key(d)}'),
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => ref
                      .read(selectedDayProvider.notifier)
                      .select(Days.key(d)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Days.key(d) == selected
                          ? scheme.primary
                          : scheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat.E(locale)
                              .format(d)
                              .characters
                              .take(2)
                              .toString(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Days.key(d) == selected
                                ? scheme.onPrimary
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '${d.day}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Days.key(d) == selected
                                ? scheme.onPrimary
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

String dayModeName(AppLocalizations l10n, DayMode m) => switch (m) {
  DayMode.normal => l10n.dayModeNormal,
  DayMode.busy => l10n.dayModeBusy,
  DayMode.lowEnergy => l10n.dayModeLow,
};

/// Normal / Busy / Low energy for today.
class DayModeSelector extends ConsumerWidget {
  const DayModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final mode = ref.watch(todayModeProvider).value ?? DayMode.normal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.dayModeTitle, style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<DayMode>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: DayMode.normal,
                label: Text(l10n.dayModeNormal),
              ),
              ButtonSegment(value: DayMode.busy, label: Text(l10n.dayModeBusy)),
              ButtonSegment(
                value: DayMode.lowEnergy,
                label: Text(l10n.dayModeLow),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (s) =>
                ref.read(wellbeingRepositoryProvider).setTodayMode(s.first),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(switch (mode) {
          DayMode.normal => l10n.dayModeNormalInfo,
          DayMode.busy => l10n.dayModeBusyInfo,
          DayMode.lowEnergy => l10n.dayModeLowInfo,
        }, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

String moodName(AppLocalizations l10n, int v) =>
    [l10n.mood1, l10n.mood2, l10n.mood3, l10n.mood4, l10n.mood5][v - 1];
String energyName(AppLocalizations l10n, int v) => [
  l10n.energy1,
  l10n.energy2,
  l10n.energy3,
  l10n.energy4,
  l10n.energy5,
][v - 1];

const _moodIcons = [
  Icons.sentiment_very_dissatisfied_outlined,
  Icons.sentiment_dissatisfied_outlined,
  Icons.sentiment_neutral_outlined,
  Icons.sentiment_satisfied_outlined,
  Icons.sentiment_very_satisfied_outlined,
];

/// Mood and energy, once a day. Low energy offers a low-energy day.
class MoodCheckInCard extends ConsumerStatefulWidget {
  const MoodCheckInCard({super.key});

  @override
  ConsumerState<MoodCheckInCard> createState() => _MoodCheckInCardState();
}

class _MoodCheckInCardState extends ConsumerState<MoodCheckInCard> {
  int? _mood;
  int? _energy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final today = ref.watch(todayMoodProvider);
    final mode = ref.watch(todayModeProvider).value ?? DayMode.normal;

    if (today != null) {
      final suggestLow = today.energy <= 2 && mode == DayMode.normal;
      return Card(
        child: ListTile(
          leading: Icon(_moodIcons[today.mood - 1], color: scheme.primary),
          title: Text(
            l10n.moodToday(
              moodName(l10n, today.mood),
              energyName(l10n, today.energy),
            ),
          ),
          subtitle: suggestLow ? Text(l10n.moodSuggestLow) : null,
          trailing: suggestLow
              ? FilledButton.tonal(
                  onPressed: () => ref
                      .read(wellbeingRepositoryProvider)
                      .setTodayMode(DayMode.lowEnergy),
                  child: Text(l10n.moodSwitch),
                )
              : null,
        ),
      );
    }

    Future<void> pick({int? mood, int? energy}) async {
      setState(() {
        _mood = mood ?? _mood;
        _energy = energy ?? _energy;
      });
      if (_mood != null && _energy != null) {
        final messenger = ScaffoldMessenger.of(context);
        await ref
            .read(wellbeingRepositoryProvider)
            .checkIn(mood: _mood!, energy: _energy!);
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.moodSaved),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    Widget row(
      String prefix,
      List<IconData> icons,
      String Function(int) name,
      int? value,
      void Function(int) onPick,
    ) => Row(
      children: [
        for (var v = 1; v <= 5; v++)
          Expanded(
            child: Semantics(
              button: true,
              selected: value == v,
              label: name(v),
              excludeSemantics: true,
              child: InkWell(
                key: Key('$prefix-$v'),
                borderRadius: BorderRadius.circular(12),
                onTap: () => onPick(v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: value == v ? scheme.primaryContainer : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        icons[v - 1],
                        color: value == v
                            ? scheme.onPrimaryContainer
                            : scheme.onSurfaceVariant,
                      ),
                      Text(
                        name(v),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.moodQuestion, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            row(
              'mood',
              _moodIcons,
              (v) => moodName(l10n, v),
              _mood,
              (v) => pick(mood: v),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.energyQuestion, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            row(
              'energy',
              _energyIcons,
              (v) => energyName(l10n, v),
              _energy,
              (v) => pick(energy: v),
            ),
          ],
        ),
      ),
    );
  }
}

const _energyIcons = [
  Icons.battery_0_bar,
  Icons.battery_2_bar,
  Icons.battery_4_bar,
  Icons.battery_5_bar,
  Icons.battery_full,
];

/// One small step for right now.
class FiveMinuteCard extends ConsumerWidget {
  const FiveMinuteCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final now = ref.watch(clockProvider)();
    final agenda = ref.watch(agendaProvider(Days.key(now)));
    if (agenda == null) return const SizedBox.shrink();
    final hasWardrobe =
        (ref.watch(wardrobeProvider).value ?? const []).length >= 3;
    final idea = FiveMinute.pick(
      agenda,
      now.hour * 60 + now.minute,
      hasWardrobe: hasWardrobe,
    );
    final (icon, title, info) = switch (idea.kind) {
      FiveMinuteKind.water => (
        Icons.water_drop_outlined,
        l10n.fiveWater,
        l10n.fiveWaterInfo,
      ),
      FiveMinuteKind.habit => (
        Icons.task_alt,
        l10n.fiveHabit(idea.task!.title ?? ''),
        l10n.fiveHabitInfo,
      ),
      FiveMinuteKind.mobility => (
        Icons.self_improvement,
        l10n.fiveMobility,
        l10n.fiveMobilityInfo,
      ),
      FiveMinuteKind.prepareOutfit => (
        Icons.checkroom_outlined,
        l10n.fiveOutfit,
        l10n.fiveOutfitInfo,
      ),
      FiveMinuteKind.posture => (
        Icons.accessibility_new,
        l10n.fivePosture,
        l10n.fivePostureInfo,
      ),
    };

    Future<void> act() async {
      switch (idea.kind) {
        case FiveMinuteKind.water:
          await addWater(context, ref, 250);
        case FiveMinuteKind.habit:
          await ref
              .read(habitRepositoryProvider)
              .setStatus(
                idea.task!.habitId!,
                Days.key(now),
                HabitStatus.completed,
              );
        case FiveMinuteKind.mobility:
          if (context.mounted) {
            context.push(
              '${AppRoutes.exerciseLibrary}/${DayAgenda.fiveMinuteMoves.first}',
            );
          }
        case FiveMinuteKind.prepareOutfit:
          if (context.mounted) context.push(AppRoutes.outfits);
        case FiveMinuteKind.posture:
          if (context.mounted) context.push(AppRoutes.posture);
      }
    }

    return Card(
      color: scheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: scheme.onTertiaryContainer.withValues(
                alpha: 0.1,
              ),
              child: Icon(icon, color: scheme.onTertiaryContainer),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.fiveTitle,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.onTertiaryContainer,
                    ),
                  ),
                  Text(title, style: theme.textTheme.titleSmall),
                  Text(info, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            FilledButton(onPressed: act, child: Text(l10n.fiveDo)),
          ],
        ),
      ),
    );
  }
}

Future<void> addWater(BuildContext context, WidgetRef ref, int ml) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  try {
    await ref
        .read(waterRepositoryProvider)
        .add(
          Measurement(
            value: ml.toDouble(),
            unit: 'ml',
            source: DataSource.userEntered,
            recordedAt: ref.read(clockProvider)().toUtc(),
          ),
        );
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.quickAdded),
        duration: const Duration(seconds: 2),
      ),
    );
  } catch (e, st) {
    AppLogger.error('today.water', e, st);
    messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
  }
}

/// Morning / afternoon / evening / any time, with one-tap actions.
class AgendaTimeline extends ConsumerStatefulWidget {
  const AgendaTimeline({super.key});

  @override
  ConsumerState<AgendaTimeline> createState() => _AgendaTimelineState();
}

class _AgendaTimelineState extends ConsumerState<AgendaTimeline> {
  bool _showOptional = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final day = ref.watch(selectedDayProvider);
    final today = Days.key(ref.watch(clockProvider)());
    final agenda = ref.watch(agendaProvider(day));
    if (agenda == null) return const SizedBox(height: 80);
    final past = day != today;
    final next = past ? null : agenda.next;

    final parts = [
      (DayPart.morning, Icons.wb_twilight, l10n.partMorning),
      (DayPart.afternoon, Icons.wb_sunny_outlined, l10n.partAfternoon),
      (DayPart.evening, Icons.nights_stay_outlined, l10n.partEvening),
      (DayPart.anytime, Icons.all_inclusive, l10n.partAnytime),
    ];
    var reveal = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (past)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              l10n.agendaLookingBack(
                DateFormat.MMMEd(locale).format(Days.fromKey(day)),
              ),
              style: theme.textTheme.titleSmall,
            ),
          ),
        if (next?.plan != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              l10n.planNext(
                next!.title ?? '',
                formatMinute(context, next.minute!),
              ),
              style: theme.textTheme.titleMedium,
            ),
          ),
        Text(
          l10n.agendaProgress(agenda.doneCount, agenda.countedTotal),
          style: theme.textTheme.bodySmall,
        ),
        if (agenda.countedTotal <= 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(l10n.agendaEmpty, style: theme.textTheme.bodyMedium),
          ),
        for (final (part, icon, label) in parts)
          if (agenda.inPart(part).isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(icon, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(label, style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            for (final t in agenda.inPart(part))
              Reveal(
                index: reveal++,
                child: _TaskRow(
                  task: t,
                  day: day,
                  readOnly: past,
                  isNext: t == next,
                ),
              ),
          ],
        if (agenda.optional.isNotEmpty) ...[
          TextButton.icon(
            icon: Icon(_showOptional ? Icons.expand_less : Icons.expand_more),
            label: Text(l10n.agendaOptional(agenda.optional.length)),
            onPressed: () => setState(() => _showOptional = !_showOptional),
          ),
          if (_showOptional)
            for (final t in agenda.optional)
              _TaskRow(task: t, day: day, readOnly: past, isNext: false),
        ],
      ],
    );
  }
}

class _TaskRow extends ConsumerWidget {
  const _TaskRow({
    required this.task,
    required this.day,
    required this.readOnly,
    required this.isNext,
  });

  final AgendaTask task;
  final int day;
  final bool readOnly;
  final bool isNext;

  IconData get _icon => switch (task.kind) {
    AgendaKind.water => Icons.water_drop_outlined,
    AgendaKind.habit => Icons.task_alt,
    AgendaKind.meal => slotIcon(task.slot!),
    AgendaKind.workout => workoutIcon(task.workout!.type),
    AgendaKind.plan => switch (task.plan!.item.kind) {
      RoutineItemKind.wake => Icons.wb_twilight,
      RoutineItemKind.water => Icons.water_drop_outlined,
      RoutineItemKind.meal => Icons.restaurant_outlined,
      RoutineItemKind.exercise => Icons.fitness_center,
      RoutineItemKind.mobility => Icons.self_improvement,
      RoutineItemKind.posture => Icons.accessibility_new,
      RoutineItemKind.habit => Icons.task_alt,
      RoutineItemKind.grooming => Icons.content_cut,
      RoutineItemKind.windDown => Icons.spa_outlined,
      RoutineItemKind.sleep => Icons.bedtime_outlined,
      RoutineItemKind.custom => Icons.event_note_outlined,
    },
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final format = HealthFormat.of(
      context,
      ref.watch(settingsControllerProvider).unitSystem,
    );

    final title = switch (task.kind) {
      AgendaKind.water => l10n.agendaWater(format.water(task.target)),
      AgendaKind.meal => l10n.slotName(task.slot!),
      AgendaKind.workout => l10n.agendaWorkout(
        l10n.workoutName(task.workout!.type),
        task.workout!.minutes,
      ),
      _ => task.title ?? '',
    };
    final lang = Localizations.localeOf(context).languageCode;
    String? dish;
    if (task.kind == AgendaKind.meal) {
      for (final m in ref.watch(dayMenuProvider(day))?.meals ?? const []) {
        if (m.meal.slot == task.slot && !m.extra) dish = m.meal.nameIn(lang);
      }
    }
    final sub = switch (task.kind) {
      AgendaKind.water =>
        '${format.water(task.progress)} / ${format.water(task.target)}',
      _ when task.minute != null => [
        formatMinute(context, task.minute!),
        ?dish,
      ].join(' · '),
      _ => null,
    };

    Future<void> run(Future<void> Function() f) async {
      try {
        await f();
      } catch (e, st) {
        AppLogger.error('today.task', e, st);
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
        }
      }
    }

    final routines = ref.read(routineRepositoryProvider);
    final habits = ref.read(habitRepositoryProvider);

    Future<void> primary() => run(() async {
      switch (task.kind) {
        case AgendaKind.plan:
          await routines.record(
            task.plan!.item.id,
            day,
            task.done ? null : PlanOutcome.completed,
          );
        case AgendaKind.habit:
          await habits.setStatus(
            task.habitId!,
            day,
            task.done ? null : HabitStatus.completed,
          );
        case AgendaKind.water:
          await addWater(context, ref, 250);
        case AgendaKind.meal:
        case AgendaKind.workout:
          if (context.mounted) context.push(AppRoutes.bodyPlan);
      }
    });

    final canTick =
        task.kind == AgendaKind.plan || task.kind == AgendaKind.habit;
    final Widget action = readOnly
        ? Icon(
            task.done ? Icons.check_circle : Icons.circle_outlined,
            color: task.done ? scheme.primary : scheme.outline,
          )
        : IconButton.filledTonal(
            key: Key('task-${task.id}'),
            tooltip: canTick
                ? (task.done ? l10n.agendaUndo : l10n.agendaDone)
                : task.kind == AgendaKind.water
                ? l10n.quickWater(250)
                : null,
            icon: Icon(
              task.done
                  ? Icons.check
                  : canTick
                  ? Icons.check
                  : task.kind == AgendaKind.water
                  ? Icons.add
                  : Icons.play_arrow,
            ),
            style: task.done
                ? IconButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                  )
                : null,
            onPressed: task.done && !canTick ? null : primary,
          );

    final dotColor = task.done
        ? scheme.primary
        : task.missed
        ? scheme.error
        : isNext
        ? scheme.tertiary
        : scheme.outlineVariant;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline rail.
          SizedBox(
            width: 22,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 2,
                  color: scheme.outlineVariant.withValues(alpha: 0.5),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: task.done || isNext ? dotColor : scheme.surface,
                    border: Border.all(color: dotColor, width: 2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Card(
                color: isNext ? scheme.primaryContainer : null,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.xs,
                    AppSpacing.xs,
                    AppSpacing.xs,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(_icon, color: scheme.primary),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    decoration: task.done || task.skipped
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: task.skipped ? scheme.outline : null,
                                  ),
                                ),
                                if (sub != null || task.missed)
                                  Text(
                                    [
                                      ?sub,
                                      if (task.missed) l10n.agendaMissed,
                                    ].join(' · '),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: task.missed ? scheme.error : null,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (task.target > 1 && !task.done)
                            Padding(
                              padding: const EdgeInsets.only(
                                right: AppSpacing.sm,
                              ),
                              child: Text(
                                '${(task.fraction * 100).round()}%',
                                style: theme.textTheme.labelMedium,
                              ),
                            ),
                          action,
                        ],
                      ),
                      if (task.target > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: LinearProgressIndicator(
                            value: task.fraction,
                            minHeight: 3,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      // Missed plan items: move or let go, without blame.
                      if (task.missed && !readOnly)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            spacing: AppSpacing.xs,
                            children: [
                              TextButton(
                                onPressed: () => run(() async {
                                  final t = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                      DateTime.now().add(
                                        const Duration(minutes: 30),
                                      ),
                                    ),
                                  );
                                  if (t == null) return;
                                  await routines.record(
                                    task.plan!.item.id,
                                    day,
                                    PlanOutcome.rescheduled,
                                    rescheduledMinute: t.hour * 60 + t.minute,
                                  );
                                }),
                                child: Text(l10n.agendaReschedule),
                              ),
                              TextButton(
                                onPressed: () => run(
                                  () => routines.record(
                                    task.plan!.item.id,
                                    day,
                                    PlanOutcome.skipped,
                                  ),
                                ),
                                child: Text(l10n.agendaSkip),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "+" sheet: the most common logs in two taps.
Future<void> showQuickAdd(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheet) {
      Widget tile(
        IconData icon,
        String label,
        Future<void> Function() onTap, {
        Key? key,
      }) => ListTile(
        key: key,
        leading: Icon(icon),
        title: Text(label),
        onTap: () async {
          Navigator.of(sheet).pop();
          await onTap();
        },
      );
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                l10n.quickAdd,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            tile(
              Icons.water_drop_outlined,
              l10n.quickWater(250),
              () => addWater(context, ref, 250),
              key: const Key('quick-water-250'),
            ),
            tile(
              Icons.water_drop,
              l10n.quickWater(500),
              () => addWater(context, ref, 500),
            ),
            tile(
              Icons.restaurant_outlined,
              l10n.quickMeal,
              () async => context.push(AppRoutes.meals),
            ),
            tile(
              Icons.monitor_weight_outlined,
              l10n.quickWeight,
              () async => context.push(AppRoutes.weight),
            ),
            tile(
              Icons.bedtime_outlined,
              l10n.quickSleep,
              () async => context.push(AppRoutes.sleep),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      );
    },
  );
}
