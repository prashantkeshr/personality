import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/repositories/progress_repository.dart';
import '../../data/repositories/snapshot_repository.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/progress_engine.dart';
import '../face/face_providers.dart';
import '../health/body_providers.dart';
import '../health/health_providers.dart';
import '../routines/routine_providers.dart';
import '../snapshots/snapshot_providers.dart';
import '../style/style_providers.dart';
import 'snapshot_aligner.dart';

final progressRepositoryProvider = Provider((ref) => ProgressRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider)));

final progressHistoryProvider = StreamProvider<List<DayActivity>>(
    (ref) => ref.watch(progressRepositoryProvider).watchHistory());

/// What exists today, so quests are always achievable.
final questContextProvider = Provider<QuestContext>((ref) {
  final now = ref.watch(clockProvider)();
  final today = Days.key(now);
  final habits = ref.watch(habitsProvider).value ?? const [];
  final weekAgo = now.subtract(const Duration(days: 7));
  final faces =
      ref.watch(snapshotsProvider(SnapshotKind.face)).value ?? const [];
  return QuestContext(
    hasPlanToday: ref.watch(todayPlanProvider).isNotEmpty,
    habitsToday: habits
        .where((h) =>
            !h.archived &&
            h.startDayKey <= today &&
            h.schedule.includes(now.weekday))
        .length,
    wardrobeItems: (ref.watch(wardrobeProvider).value ?? const []).length,
    snapshotThisWeek: faces.any((s) => s.takenAt.isAfter(weekAgo)),
    goals: ref.watch(goalsProvider).value ?? const {},
  );
});

final progressSummaryProvider = Provider<ProgressSummary?>((ref) {
  final history = ref.watch(progressHistoryProvider).value;
  if (history == null) return null;
  return ProgressSummary.compute(
    history: history,
    todayKey: Days.key(ref.watch(clockProvider)()),
    context: ref.watch(questContextProvider),
    savedOutfits: (ref.watch(savedOutfitsProvider).value ?? const []).length,
  );
});

/// Whether newly earned badges pop a celebration (off in most widget tests).
final badgeCelebrationsProvider = Provider<bool>((ref) => true);

/// Badges earned but not yet celebrated.
final unseenBadgesProvider = FutureProvider<List<Award>>((ref) async {
  final summary = ref.watch(progressSummaryProvider);
  if (summary == null || !ref.watch(badgeCelebrationsProvider)) return const [];
  final seen = await ref.read(progressRepositoryProvider).seenBadges();
  return [
    for (final b in summary.badges)
      if (b.earned && !seen.contains(b.badge.name)) b.badge,
  ];
});

/// Face snapshots oldest → newest for the time-lapse. Looks for eyes in
/// new photos first (once each) so frames line up.
final faceTimelineProvider = Provider<List<Snapshot>>((ref) {
  final list =
      ref.watch(snapshotsProvider(SnapshotKind.face)).value ?? const [];
  if (list.any((s) => s.eyes == null)) ref.watch(snapshotAlignmentProvider);
  return list.reversed.toList();
});

/// Re-runs whenever a face snapshot is added or removed.
final snapshotAlignmentProvider = FutureProvider<int>((ref) {
  ref.watch(snapshotsProvider(SnapshotKind.face)
      .select((s) => s.value?.length ?? 0));
  return SnapshotAligner(ref.read(snapshotRepositoryProvider),
          ref.read(faceEstimatorProvider))
      .alignPending();
});
