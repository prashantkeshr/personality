import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/health.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/clock_format.dart';
import '../health/body_providers.dart';
import '../routines/routine_providers.dart';
import 'goal_reminders.dart';

/// Goal reminders: one card per goal, the user's own goals first.
class GoalRemindersScreen extends ConsumerWidget {
  const GoalRemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final all = ref.watch(goalRemindersProvider);
    final goals = ref.watch(goalsProvider).value ?? const {};
    final allowed = ref.watch(notificationsAllowedProvider).value;

    final kinds = [...GoalReminderKind.values]
      ..sort(
        (a, b) => (goals.contains(b.goal) ? 1 : 0).compareTo(
          goals.contains(a.goal) ? 1 : 0,
        ),
      );

    return Scaffold(
      appBar: AppBar(title: Text(l.featureGoalReminders)),
      body: all == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              children: [
                const _BellHeader(),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l.goalRemindersIntro,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (allowed == false && all.values.any((r) => r.on)) ...[
                  const SizedBox(height: AppSpacing.md),
                  Card(
                    color: theme.colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Text(
                        l.notificationsBlocked,
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                for (final k in kinds)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: GoalReminderCard(
                      reminder: all[k]!,
                      forYourGoal: goals.contains(k.goal),
                    ),
                  ),
              ],
            ),
    );
  }
}

/// A bell with rings that sway once, then rest.
class _BellHeader extends StatefulWidget {
  const _BellHeader();

  @override
  State<_BellHeader> createState() => _BellHeaderState();
}

class _BellHeaderState extends State<_BellHeader>
    with SingleTickerProviderStateMixin {
  late final _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !MediaQuery.disableAnimationsOf(context)) _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: SizedBox(
        height: 120,
        child: AnimatedBuilder(
          animation: _anim,
          builder: (_, _) {
            final t = _anim.value;
            final sway = math.sin(t * math.pi * 6) * (1 - t) * 0.35;
            return Stack(
              alignment: Alignment.center,
              children: [
                for (final (r, a) in [(110.0, 0.10), (80.0, 0.16)])
                  Container(
                    width: r,
                    height: r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: s.primary.withValues(alpha: a),
                    ),
                  ),
                Transform.rotate(
                  angle: sway,
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.notifications_active,
                    size: 52,
                    color: s.primary,
                  ),
                ),
                for (final (icon, dx, dy) in [
                  (Icons.water_drop, -70.0, -24.0),
                  (Icons.bedtime, 70.0, -20.0),
                  (Icons.monitor_weight, -60.0, 34.0),
                  (Icons.directions_walk, 62.0, 34.0),
                ])
                  Transform.translate(
                    offset:
                        Offset(dx, dy) *
                        Curves.easeOutBack.transform(
                          MediaQuery.disableAnimationsOf(context)
                              ? 1
                              : (t * 2).clamp(0.0, 1.0),
                        ),
                    child: Icon(icon, size: 20, color: s.tertiary),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// One goal reminder: switch, and when on, its days and times.
class GoalReminderCard extends ConsumerWidget {
  const GoalReminderCard({
    super.key,
    required this.reminder,
    this.forYourGoal = false,
  });

  final GoalReminder reminder;
  final bool forYourGoal;

  Future<void> _run(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final error = AppLocalizations.of(context).recordSaveError;
    try {
      await action();
    } catch (e, st) {
      AppLogger.error('goalReminder', e, st);
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final r = reminder;
    final actions = ref.read(goalReminderActionsProvider);
    final tag = Localizations.localeOf(context).toLanguageTag();

    return Card(
      key: Key('goal-reminder-${r.kind.name}'),
      clipBehavior: Clip.antiAlias,
      child: _Grow(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              key: Key('goal-reminder-switch-${r.kind.name}'),
              secondary: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: r.on
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                ),
                child: Icon(
                  r.kind.icon,
                  color: r.on
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              title: Row(
                children: [
                  Flexible(child: Text(r.kind.title(l))),
                  if (forYourGoal) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        l.goalRemindForYou,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              subtitle: Text(
                r.on ? _summary(context, l, tag, r) : r.kind.info(l),
              ),
              value: r.on,
              onChanged: (on) => _run(context, () async {
                HapticFeedback.selectionClick();
                if (on) {
                  final allowed = await actions.turnOn(r, l);
                  if (!allowed && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l.notificationsBlocked)),
                    );
                  }
                } else {
                  await actions.turnOff(r);
                }
              }),
            ),
            if (r.on)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.goalRemindDays, style: theme.textTheme.labelLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (var d = 1; d <= 7; d++)
                          FilterChip(
                            key: Key('goal-reminder-day-${r.kind.name}-$d'),
                            showCheckmark: false,
                            label: Text(
                              DateFormat.E(tag).format(DateTime(2024, 1, d)),
                            ),
                            selected: r.days.includes(d),
                            onSelected: (_) {
                              final next = r.days.toggle(d);
                              if (next.isEmpty) return; // keep at least one
                              _run(
                                context,
                                () => actions.reschedule(r, l, days: next),
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(l.goalRemindTimes, style: theme.textTheme.labelLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final t in r.times)
                          InputChip(
                            key: Key('goal-reminder-time-${r.kind.name}-$t'),
                            avatar: const Icon(Icons.schedule, size: 18),
                            label: Text(_time(context, t)),
                            onPressed: () => _run(context, () async {
                              final picked = await _pick(context, t);
                              if (picked == null) return;
                              await actions.reschedule(
                                r,
                                l,
                                times: [
                                  for (final x in r.times)
                                    if (x != t) x,
                                  picked,
                                ],
                              );
                            }),
                            onDeleted: r.times.length < 2
                                ? null
                                : () => _run(
                                    context,
                                    () => actions.reschedule(
                                      r,
                                      l,
                                      times: [
                                        for (final x in r.times)
                                          if (x != t) x,
                                      ],
                                    ),
                                  ),
                            deleteButtonTooltipMessage: l.goalRemindRemoveTime(
                              _time(context, t),
                            ),
                          ),
                        ActionChip(
                          key: Key('goal-reminder-add-${r.kind.name}'),
                          avatar: const Icon(Icons.add, size: 18),
                          label: Text(l.goalRemindAddTime),
                          onPressed: () => _run(context, () async {
                            final picked = await _pick(
                              context,
                              (r.times.last + 60) % (24 * 60),
                            );
                            if (picked == null) return;
                            await actions.reschedule(
                              r,
                              l,
                              times: [...r.times, picked],
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _time(BuildContext context, int minute) =>
      clockFormat(context)
          .format(DateTime(2024, 1, 1, minute ~/ 60, minute % 60));

  static Future<int?> _pick(BuildContext context, int minute) async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: minute ~/ 60, minute: minute % 60),
    );
    return t == null ? null : t.hour * 60 + t.minute;
  }

  static String _summary(
    BuildContext context,
    AppLocalizations l,
    String tag,
    GoalReminder r,
  ) {
    final days = r.days.mask == Weekdays.everyDay.mask
        ? l.everyDay
        : r.days.mask == 0x1F
        ? l.goalRemindWeekdays
        : [
            for (var d = 1; d <= 7; d++)
              if (r.days.includes(d))
                DateFormat.E(tag).format(DateTime(2024, 1, d)),
          ].join(', ');
    final times = r.times.map((t) => _time(context, t)).join(', ');
    return '$days · $times';
  }
}

/// Animates the card's height as it opens; with reduced motion it simply
/// changes (AnimatedSize with a zero duration re-lays itself out mid-layout).
class _Grow extends StatelessWidget {
  const _Grow({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => MediaQuery.disableAnimationsOf(context)
      ? child
      : AnimatedSize(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.topCenter,
          child: child,
        );
}
