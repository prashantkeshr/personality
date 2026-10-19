import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/health.dart';
import '../../domain/entities/routine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/clock_format.dart';
import '../permissions/app_permissions.dart' show appKvProvider;
import '../routines/routine_providers.dart';
import '../today/now_providers.dart';

/// "Add to my day": a daily practice slot for a skill. Every slot lives in
/// one "My practice" routine, so it gets a reminder, shows on the day plan
/// and counts in plan history like any other routine item.
class PracticePlanner {
  PracticePlanner(this._ref);
  final Ref _ref;

  static const _routineKey = 'practice.routine';

  Future<String> _routine(AppLocalizations l) async {
    final kv = _ref.read(appKvProvider);
    final repo = _ref.read(routineRepositoryProvider);
    final id = await kv.get(_routineKey);
    final routines = await repo.watchRoutines().first;
    if (id != null && routines.any((r) => r.id == id)) return id;
    final created = await repo.createRoutine(
      l.practiceRoutine,
      Weekdays.everyDay,
    );
    await kv.put(_routineKey, created);
    return created;
  }

  /// Adds the slot and switches reminders on (asking for notification
  /// permission once). Returns whether notifications can be shown.
  Future<bool> add({
    required String skillId,
    required String skillName,
    required int minute,
    required int minutes,
    required AppLocalizations l,
  }) async {
    final id = await _routine(l);
    await _ref
        .read(routineRepositoryProvider)
        .addItem(
          id,
          minute,
          l.practiceItem(skillName, minutes),
          RoutineItemKind.exercise,
        );
    // Chosen skills also come up in the Home recommendations.
    await _ref.read(nowActionsProvider).setSkill(skillId, true);
    final scheduler = _ref.read(reminderSchedulerProvider);
    final allowed =
        await scheduler.notificationsAllowed() ||
        await scheduler.requestPermission();
    _ref.invalidate(notificationsAllowedProvider);
    await _ref.read(reminderSettingsRepositoryProvider).setEnabled(true);
    return allowed;
  }
}

final practicePlannerProvider = Provider((ref) => PracticePlanner(ref));

/// Asks for a time and a length, then adds the practice to the day.
Future<void> showAddToDaySheet(
  BuildContext context, {
  required String skillId,
  required String skillName,
}) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  showDragHandle: true,
  builder: (_) => _AddToDaySheet(skillId: skillId, skillName: skillName),
);

class _AddToDaySheet extends ConsumerStatefulWidget {
  const _AddToDaySheet({required this.skillId, required this.skillName});
  final String skillId;
  final String skillName;

  @override
  ConsumerState<_AddToDaySheet> createState() => _AddToDaySheetState();
}

class _AddToDaySheetState extends ConsumerState<_AddToDaySheet> {
  int _minute = 18 * 60;
  int _length = 10;
  bool _saving = false;

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _minute ~/ 60, minute: _minute % 60),
    );
    if (t != null) setState(() => _minute = t.hour * 60 + t.minute);
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    try {
      final allowed = await ref
          .read(practicePlannerProvider)
          .add(
            skillId: widget.skillId,
            skillName: widget.skillName,
            minute: _minute,
            minutes: _length,
            l: l,
          );
      HapticFeedback.mediumImpact();
      nav.pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            allowed
                ? l.practiceAdded(widget.skillName)
                : l.notificationsBlocked,
          ),
        ),
      );
    } catch (e, st) {
      AppLogger.error('practice.add', e, st);
      if (mounted) setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(l.recordSaveError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final time = clockFormat(context)
        .format(DateTime(2024, 1, 1, _minute ~/ 60, _minute % 60));
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.practiceAddTitle(widget.skillName),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l.practiceAddInfo,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              key: const Key('practice-time'),
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule),
              title: Text(l.practiceTime),
              trailing: Text(time, style: theme.textTheme.titleMedium),
              onTap: _pickTime,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l.practiceLength, style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            SegmentedButton<int>(
              key: const Key('practice-length'),
              segments: [
                for (final m in const [5, 10, 15, 20])
                  ButtonSegment(value: m, label: Text(l.bodyPlanMinutes(m))),
              ],
              selected: {_length},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() => _length = s.single),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              key: const Key('practice-save'),
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.event_available),
              label: Text(l.practiceAddButton),
            ),
          ],
        ),
      ),
    );
  }
}
