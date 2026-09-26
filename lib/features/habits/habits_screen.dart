import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/health.dart';
import '../../domain/services/health_stats.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/empty_state.dart';
import '../health/health_providers.dart';
import '../health/widgets/add_record_sheet.dart' show confirmDelete;

/// Habits (spec §30). Reports observable behaviour as counts — never
/// judgements about the person.
class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  static Future<void> edit(BuildContext context, [Habit? habit]) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        builder: (_) => _HabitSheet(habit: habit),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final now = ref.watch(clockProvider)();
    final today = Days.key(now);
    final week = Days.lastDays(now, 7);
    final completions = ref.watch(habitCompletionsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.featureHabits)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => edit(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.habitAdd),
      ),
      body: AsyncView(
        value: ref.watch(habitsProvider),
        data: (habits) {
          if (habits.isEmpty) {
            return Center(
              child: EmptyState(
                icon: Icons.check_circle_outline,
                title: l10n.featureHabits,
                message: l10n.habitsEmpty,
              ),
            );
          }
          final todays = habits
              .where((h) => h.schedule.includes(Days.fromKey(today).weekday))
              .toList();
          final others = habits.where((h) => !todays.contains(h)).toList();
          final summary = HabitAdherence.today(habits, completions, today);

          return ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
            children: [
              Text(
                l10n.habitsTodaySummary(summary.completed, summary.scheduled),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              for (final h in todays)
                _HabitTile(
                    habit: h,
                    today: today,
                    week: week,
                    completions: completions),
              if (others.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.habitsNotToday,
                    style: Theme.of(context).textTheme.labelLarge),
                for (final h in others)
                  _HabitTile(
                      habit: h,
                      today: today,
                      week: week,
                      completions: completions,
                      scheduledToday: false),
              ],
            ],
          );
        },
      ),
    );
  }
}

enum _HabitMenu { edit, archive, delete }

class _HabitTile extends ConsumerWidget {
  const _HabitTile({
    required this.habit,
    required this.today,
    required this.week,
    required this.completions,
    this.scheduledToday = true,
  });

  final Habit habit;
  final int today;
  final List<int> week;
  final List<HabitCompletion> completions;
  final bool scheduledToday;

  Future<void> _set(BuildContext context, WidgetRef ref, HabitStatus? s) async {
    final messenger = ScaffoldMessenger.of(context);
    final error = AppLocalizations.of(context).recordSaveError;
    try {
      await ref.read(habitRepositoryProvider).setStatus(habit.id, today, s);
    } catch (e, st) {
      AppLogger.error('habit.status', e, st);
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    HabitStatus? status;
    for (final c in completions) {
      if (c.habitId == habit.id && c.dayKey == today) status = c.status;
    }
    final week7 = HabitAdherence.forHabit(habit, completions, week);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        child: Row(
          children: [
            if (scheduledToday)
              Checkbox(
                value: status == HabitStatus.completed,
                semanticLabel: habit.name,
                onChanged: (v) => _set(
                    context, ref, v == true ? HabitStatus.completed : null),
              )
            else
              const SizedBox(width: 48),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // The checkbox already announces the name to screen readers.
                  ExcludeSemantics(
                    excluding: scheduledToday,
                    child: Text(habit.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            decoration: status == HabitStatus.skipped
                                ? TextDecoration.lineThrough
                                : null)),
                  ),
                  Text(
                    [
                      l10n.habitWeekAdherence(week7.completed, week7.scheduled),
                      if (status == HabitStatus.skipped) l10n.habitSkippedToday,
                    ].join(' · '),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (scheduledToday && status == null)
              TextButton(
                onPressed: () => _set(context, ref, HabitStatus.skipped),
                child: Text(l10n.habitSkip),
              ),
            if (status == HabitStatus.skipped)
              TextButton(
                onPressed: () => _set(context, ref, null),
                child: Text(l10n.habitUndo),
              ),
            PopupMenuButton<_HabitMenu>(
              onSelected: (m) async {
                final repo = ref.read(habitRepositoryProvider);
                switch (m) {
                  case _HabitMenu.edit:
                    await HabitsScreen.edit(context, habit);
                  case _HabitMenu.archive:
                    await repo.archive(habit.id);
                  case _HabitMenu.delete:
                    if (await confirmDelete(context)) {
                      await repo.delete(habit.id);
                    }
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: _HabitMenu.edit, child: Text(l10n.actionEdit)),
                PopupMenuItem(
                    value: _HabitMenu.archive, child: Text(l10n.habitArchive)),
                PopupMenuItem(
                    value: _HabitMenu.delete, child: Text(l10n.actionDelete)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitSheet extends ConsumerStatefulWidget {
  const _HabitSheet({this.habit});

  final Habit? habit;

  @override
  ConsumerState<_HabitSheet> createState() => _HabitSheetState();
}

class _HabitSheetState extends ConsumerState<_HabitSheet> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.habit?.name);
  late Weekdays _days = widget.habit?.schedule ?? Weekdays.everyDay;
  bool _saving = false;
  bool _daysError = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final valid = _form.currentState!.validate();
    setState(() => _daysError = _days.isEmpty);
    if (!valid || _days.isEmpty) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(habitRepositoryProvider);
    try {
      if (widget.habit == null) {
        await repo.add(_name.text, _days);
      } else {
        await repo.update(widget.habit!.id, _name.text, _days);
      }
      navigator.pop();
    } catch (e, st) {
      AppLogger.error('habit.save', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tag = Localizations.localeOf(context).toLanguageTag();
    // 2024-01-01 was a Monday; used only to get localized weekday names.
    String dayName(int weekday) =>
        DateFormat.E(tag).format(DateTime(2024, 1, weekday));

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.habit == null ? l10n.habitAdd : l10n.habitEdit,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              key: const Key('habit-name'),
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l10n.habitName),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? l10n.validationRequired
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.habitDays, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (var d = 1; d <= 7; d++)
                  FilterChip(
                    label: Text(dayName(d)),
                    selected: _days.includes(d),
                    onSelected: (_) => setState(() => _days = _days.toggle(d)),
                  ),
              ],
            ),
            if (_daysError)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(l10n.habitDaysRequired,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(l10n.actionSave),
            ),
          ],
        ),
      ),
    );
  }
}
