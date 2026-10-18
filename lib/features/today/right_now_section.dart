import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/health.dart';
import '../../domain/services/now_recommendations.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/clock_format.dart';
import '../exercise/figure/exercise_figure.dart';
import '../growth/growth_providers.dart';
import '../health/health_providers.dart';
import '../reminders/goal_reminders.dart';
import 'now_providers.dart';
import 'today_widgets.dart' show addWater;

/// Home: a few small things that fit this moment, swipeable.
class RightNowSection extends ConsumerWidget {
  const RightNowSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final recs = ref.watch(nowRecommendationsProvider);
    ref.watch(disciplinesProvider); // names for skill cards
    if (recs == null) return const SizedBox.shrink();
    final hour = ref.watch(clockProvider)().hour;
    final part = hour < 5
        ? l.nowNight
        : hour < 12
        ? l.nowMorning
        : hour < 17
        ? l.nowAfternoon
        : hour < 21
        ? l.nowEvening
        : l.nowNight;

    return Column(
      key: const Key('right-now'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(l.nowTitle, style: theme.textTheme.titleMedium),
        ),
        Text(
          part,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (recs.isEmpty)
          Card(
            child: ListTile(
              leading: Icon(
                Icons.check_circle_outline,
                color: theme.colorScheme.primary,
              ),
              title: Text(l.nowAllDone),
            ),
          )
        else
          SizedBox(
            height: 248,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recs.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, i) => _NowCard(rec: recs[i]),
            ),
          ),
      ],
    );
  }
}

class _NowCard extends ConsumerWidget {
  const _NowCard({required this.rec});
  final NowRecommendation rec;

  static String exerciseText(AppLocalizations l, MicroExercise e, int n) =>
      switch (e.id) {
        'push_up' => l.nowPushUps(n),
        'squat' => l.nowSquats(n),
        'plank' => l.nowPlank(n),
        'glute_bridge' => l.nowBridges(n),
        'lunge' => l.nowLunges(n),
        _ => '$n',
      };

  (IconData, String, String, Color) _look(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
  ) {
    final s = Theme.of(context).colorScheme;
    String time(int m) =>
        clockFormat(context).format(DateTime(2024, 1, 1, m ~/ 60, m % 60));
    switch (rec.kind) {
      case NowKind.breakfast:
        return (
          Icons.free_breakfast_outlined,
          l.nowBreakfast,
          l.nowBreakfastInfo,
          s.tertiary,
        );
      case NowKind.lunch:
        return (
          Icons.lunch_dining_outlined,
          l.nowLunch,
          l.nowLunchInfo,
          s.tertiary,
        );
      case NowKind.dinner:
        return (
          Icons.dinner_dining_outlined,
          l.nowDinner,
          l.nowDinnerInfo,
          s.tertiary,
        );
      case NowKind.water:
        return (
          Icons.water_drop_outlined,
          l.fiveWater,
          l.fiveWaterInfo,
          s.primary,
        );
      case NowKind.postureCheck:
        return (
          Icons.accessibility_new,
          l.nowPostureCheck,
          l.nowPostureCheckInfo,
          s.secondary,
        );
      case NowKind.weighIn:
        return (
          Icons.monitor_weight_outlined,
          l.nowWeighIn,
          l.nowWeighInInfo,
          s.secondary,
        );
      case NowKind.wakeStretch:
        return (
          Icons.wb_twilight,
          l.nowWakeStretch,
          l.nowWakeStretchInfo,
          s.primary,
        );
      case NowKind.walkAfterMeal:
        return (Icons.directions_walk, l.nowWalk, l.nowWalkInfo, s.primary);
      case NowKind.microSet:
        return (
          Icons.fitness_center,
          exerciseText(l, rec.exercise!, rec.amount!),
          l.nowMicroInfo(
            ref.watch(nowStateProvider).value?.setsLogged[rec.exercise!.id] ??
                0,
          ),
          s.primary,
        );
      case NowKind.skillPractice:
        final lang = Localizations.localeOf(context).languageCode;
        final d = (ref.watch(disciplinesProvider).value ?? const [])
            .where((d) => d.id == rec.skillId)
            .firstOrNull;
        final name = d == null ? rec.skillId! : (d.name[lang] ?? d.name['en']!);
        return (
          Icons.sports_martial_arts,
          l.nowSkill(name),
          l.nowSkillInfo,
          s.secondary,
        );
      case NowKind.yoga:
        return (Icons.self_improvement, l.nowYoga, l.nowYogaInfo, s.secondary);
      case NowKind.faceSnapshot:
        return (
          Icons.face_retouching_natural,
          l.nowFaceSnapshot,
          l.nowFaceSnapshotInfo,
          s.tertiary,
        );
      case NowKind.windDown:
        return (
          Icons.bedtime_outlined,
          l.nowWindDown,
          l.nowWindDownInfo,
          s.secondary,
        );
      case NowKind.mealReminders:
        final t = GoalReminderKind.meals.defaultTimes;
        return (
          Icons.notifications_active_outlined,
          l.nowMealReminders,
          l.nowMealRemindersInfo(time(t[0]), time(t[1]), time(t[2])),
          s.tertiary,
        );
    }
  }

  /// The motion shown on the card, for movement suggestions.
  String? get _motion => switch (rec.kind) {
    NowKind.microSet => rec.exercise!.id,
    NowKind.yoga => 'tree_pose',
    NowKind.wakeStretch => 'cat_cow',
    NowKind.windDown => 'child_pose',
    _ => null,
  };

  Future<void> _act(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final actions = ref.read(nowActionsProvider);
    final messenger = ScaffoldMessenger.of(context);
    HapticFeedback.selectionClick();
    try {
      switch (rec.kind) {
        case NowKind.breakfast || NowKind.lunch || NowKind.dinner:
          context.push(AppRoutes.meals);
        case NowKind.water:
          await addWater(context, ref, 250);
        case NowKind.postureCheck:
          context.push(AppRoutes.posture);
        case NowKind.weighIn:
          context.push(AppRoutes.weight);
        case NowKind.wakeStretch:
          await actions.handle(rec.key);
          if (context.mounted) {
            context.push('${AppRoutes.programs}/morning_mobility');
          }
        case NowKind.yoga:
          await actions.handle(rec.key);
          if (context.mounted) {
            final evening = ref.read(clockProvider)().hour >= 15;
            context.push(
              '${AppRoutes.programs}/${evening ? 'wind_down' : 'morning_mobility'}',
            );
          }
        case NowKind.windDown:
          await actions.handle(rec.key);
          if (context.mounted) context.push('${AppRoutes.programs}/wind_down');
        case NowKind.walkAfterMeal:
          await actions.handle(rec.key);
          messenger.showSnackBar(SnackBar(content: Text(l.nowWalkStarted)));
        case NowKind.microSet:
          await showMicroSetSheet(context, rec);
        case NowKind.skillPractice:
          await actions.handle(rec.key);
          if (context.mounted) {
            context.push('${AppRoutes.skills}/${rec.skillId}');
          }
        case NowKind.faceSnapshot:
          context.push(AppRoutes.snapshots);
        case NowKind.mealReminders:
          final r = ref.read(goalRemindersProvider)?[GoalReminderKind.meals];
          if (r != null && !r.on) {
            final allowed = await ref
                .read(goalReminderActionsProvider)
                .turnOn(r, l);
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  allowed ? l.nowMealRemindersOn : l.notificationsBlocked,
                ),
              ),
            );
          }
      }
    } catch (e, st) {
      AppLogger.error('now.act', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l.recordSaveError)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final (icon, title, info, accent) = _look(context, ref, l);
    final motion = _motion;
    final oneOff = rec.kind == NowKind.mealReminders;

    return SizedBox(
      width: 250,
      child: Card(
        key: Key('now-${rec.key}'),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Illustration: the moving figure, or a soft icon panel.
            Container(
              height: 96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                  colors: [
                    accent.withValues(alpha: 0.22),
                    accent.withValues(alpha: 0.06),
                  ],
                ),
              ),
              child: motion != null
                  ? ExcludeSemantics(
                      child: ExerciseFigure(
                        motionId: motion,
                        still: MediaQuery.disableAnimationsOf(context),
                      ),
                    )
                  : Center(child: Icon(icon, size: 44, color: accent)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      info,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                0,
                AppSpacing.sm,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  IconButton(
                    key: Key('now-later-${rec.key}'),
                    tooltip: oneOff ? l.nowNoThanks : l.nowNotNow,
                    onPressed: () => oneOff
                        ? ref.read(nowActionsProvider).never(rec.key)
                        : ref.read(nowActionsProvider).handle(rec.key),
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: FilledButton(
                      key: Key('now-do-${rec.key}'),
                      onPressed: () => _act(context, ref),
                      child: Text(l.fiveDo, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A micro set: the moving figure, the target, and "Done" to log it.
Future<void> showMicroSetSheet(BuildContext context, NowRecommendation rec) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (_) => _MicroSetSheet(rec: rec),
    );

class _MicroSetSheet extends ConsumerStatefulWidget {
  const _MicroSetSheet({required this.rec});
  final NowRecommendation rec;

  @override
  ConsumerState<_MicroSetSheet> createState() => _MicroSetSheetState();
}

class _MicroSetSheetState extends ConsumerState<_MicroSetSheet> {
  /// Seconds left on a hold's countdown, or null when not running.
  int? _left;
  Timer? _timer;
  bool _saving = false;

  NowRecommendation get rec => widget.rec;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Holds (plank) count down, buzz at the end and log themselves.
  void _startTimer() {
    HapticFeedback.selectionClick();
    setState(() => _left = rec.amount);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      final left = (_left ?? 1) - 1;
      setState(() => _left = left);
      if (left <= 3 && left > 0) HapticFeedback.selectionClick();
      if (left <= 0) {
        t.cancel();
        HapticFeedback.heavyImpact();
        _done();
      }
    });
  }

  Future<void> _done() async {
    if (_saving) return;
    _saving = true;
    _timer?.cancel();
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final e = rec.exercise!;
    final title = _NowCard.exerciseText(l, e, rec.amount!);
    try {
      HapticFeedback.mediumImpact();
      await ref
          .read(exerciseRepositoryProvider)
          .add(
            name: title,
            category: ExerciseCategory.generalFitness,
            durationMinutes: e.seconds ? 1 : 2,
            sets: 1,
            reps: e.seconds ? null : rec.amount,
            performedAt: ref.read(clockProvider)(),
          );
      await ref.read(nowActionsProvider).setDone(e.id);
      await ref.read(nowActionsProvider).handle(rec.key);
      nav.pop();
      messenger.showSnackBar(SnackBar(content: Text(l.nowSetLogged)));
    } catch (err, st) {
      _saving = false;
      AppLogger.error('now.microSet', err, st);
      messenger.showSnackBar(SnackBar(content: Text(l.recordSaveError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final e = rec.exercise!;
    final running = _left != null;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _NowCard.exerciseText(l, e, rec.amount!),
              key: const Key('micro-title'),
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  ExcludeSemantics(
                    child: ExerciseFigure(
                      motionId: e.id,
                      still: MediaQuery.disableAnimationsOf(context),
                    ),
                  ),
                  if (running)
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        l.holdSecondsValue(_left!),
                        key: const Key('micro-countdown'),
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l.nowMicroHint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    // Close the sheet first: it sits above every page.
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.push('${AppRoutes.exerciseLibrary}/${e.id}');
                    },
                    icon: const Icon(Icons.info_outline),
                    label: Text(l.howTo),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: e.seconds && !running
                      ? FilledButton.icon(
                          key: const Key('micro-timer'),
                          onPressed: _startTimer,
                          icon: const Icon(Icons.timer_outlined),
                          label: Text(l.nowStartTimer),
                        )
                      : FilledButton.icon(
                          key: const Key('micro-done'),
                          onPressed: _done,
                          icon: const Icon(Icons.check),
                          label: Text(l.actionDone),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
