import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../health/health_providers.dart';
import '../permissions/app_permissions.dart' show appKvProvider;

/// Weekly backup reminder. The backup itself stays a tap away (it needs the
/// user's password, which is never stored), so this only reminds.
///
/// Device settings (`backup.` keys are never put in backups):
///   backup.last      when this phone last made a backup
///   backup.weekly    '0' when the reminder is off
///   backup.firstSeen when the reminder first checked (counts for "never")
///   backup.snooze    reminder hidden until then
const backupEvery = Duration(days: 7);
const _weeklyKey = 'backup.weekly';
const _firstKey = 'backup.firstSeen';
const _snoozeKey = 'backup.snooze';

class BackupNudge {
  const BackupNudge({required this.weekly, this.since, this.everBackedUp = false, this.due = false});
  final bool weekly;
  final DateTime? since;
  final bool everBackedUp;
  final bool due;

  /// Whole days since the last backup (or since the reminder started).
  int daysSince(DateTime now) => since == null ? 0 : now.difference(since!).inDays;
}

BackupNudge backupNudgeFrom(Map<String, String> m, DateTime now) {
  DateTime? at(String k) => m[k] == null ? null : DateTime.tryParse(m[k]!)?.toLocal();
  final last = at('backup.last');
  final since = last ?? at(_firstKey);
  final snooze = at(_snoozeKey);
  final weekly = m[_weeklyKey] != '0';
  final due = weekly &&
      since != null &&
      now.difference(since) >= backupEvery &&
      (snooze == null || !now.isBefore(snooze));
  return BackupNudge(weekly: weekly, since: since, everBackedUp: last != null, due: due);
}

final backupNudgeProvider = StreamProvider<BackupNudge>((ref) {
  final clock = ref.watch(clockProvider);
  return ref.watch(appKvProvider).watchPrefix('backup.').map((m) => backupNudgeFrom(m, clock()));
});

Future<void> setWeeklyBackupReminder(WidgetRef ref, bool on) =>
    ref.read(appKvProvider).put(_weeklyKey, on ? '1' : '0');

/// Home card shown when a backup is due.
class BackupNudgeCard extends ConsumerStatefulWidget {
  const BackupNudgeCard({super.key});

  @override
  ConsumerState<BackupNudgeCard> createState() => _BackupNudgeCardState();
}

class _BackupNudgeCardState extends ConsumerState<BackupNudgeCard> {
  @override
  void initState() {
    super.initState();
    _startCounting();
  }

  /// Remembers when the reminder first ran, so a phone that never backed up
  /// is reminded a week later rather than at once.
  Future<void> _startCounting() async {
    final kv = ref.read(appKvProvider);
    if (await kv.get(_firstKey) == null) {
      await kv.put(_firstKey, ref.read(clockProvider)().toUtc().toIso8601String());
    }
  }

  Future<void> _later() => ref.read(appKvProvider).put(
        _snoozeKey,
        ref.read(clockProvider)().add(const Duration(days: 3)).toUtc().toIso8601String(),
      );

  @override
  Widget build(BuildContext context) {
    final n = ref.watch(backupNudgeProvider).value;
    if (n == null || !n.due) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final days = n.daysSince(ref.read(clockProvider)());
    return Card(
      key: const Key('backup-nudge'),
      color: scheme.secondaryContainer,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.sm, AppSpacing.xs),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.cloud_off_outlined, color: scheme.onSecondaryContainer),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(l10n.backupNudgeTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: scheme.onSecondaryContainer)),
            ),
          ]),
          const SizedBox(height: AppSpacing.xs),
          Text(
            n.everBackedUp ? l10n.backupNudgeBody(days) : l10n.backupNudgeNever,
            style: TextStyle(color: scheme.onSecondaryContainer),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(
              key: const Key('backup-nudge-later'),
              onPressed: _later,
              child: Text(l10n.backupNudgeLater),
            ),
            FilledButton.tonal(
              key: const Key('backup-nudge-go'),
              onPressed: () => context.push(AppRoutes.backup),
              child: Text(l10n.backupNudgeNow),
            ),
          ]),
        ]),
      ),
    );
  }
}
