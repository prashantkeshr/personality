import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/snapshot_repository.dart';
import '../../domain/entities/health.dart';
import '../../domain/services/day_agenda.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/now_recommendations.dart';
import '../health/body_providers.dart';
import '../health/health_providers.dart';
import '../permissions/app_permissions.dart' show appKvProvider;
import '../posture/posture_providers.dart';
import '../reminders/goal_reminders.dart';
import '../snapshots/snapshot_providers.dart';
import 'today_providers.dart';

/// Keys in app_settings for the Home recommendations.
abstract final class NowKeys {
  static const prefix = 'now.';

  /// "yyyymmdd|key,key": done or set aside today.
  static const handled = 'now.handled';

  /// One-off suggestions turned down for good.
  static const never = 'now.never';

  /// Skills chosen to practise regularly (discipline ids).
  static const skills = 'now.skills';

  /// Sets logged per micro exercise: `now.sets.<id>`.
  static String sets(String id) => 'now.sets.$id';
}

class NowState {
  const NowState({
    this.handledToday = const {},
    this.never = const {},
    this.skills = const [],
    this.setsLogged = const {},
  });

  final Set<String> handledToday;
  final Set<String> never;
  final List<String> skills;
  final Map<String, int> setsLogged;

  static Set<String> _csv(String? v) => {
    for (final x in (v ?? '').split(','))
      if (x.isNotEmpty) x,
  };

  static NowState parse(Map<String, String> m, int today) {
    final handled = (m[NowKeys.handled] ?? '').split('|');
    return NowState(
      handledToday: handled.length == 2 && handled[0] == '$today'
          ? _csv(handled[1])
          : const {},
      never: _csv(m[NowKeys.never]),
      skills: [..._csv(m[NowKeys.skills])],
      setsLogged: {
        for (final e in m.entries)
          if (e.key.startsWith('now.sets.'))
            e.key.substring('now.sets.'.length): int.tryParse(e.value) ?? 0,
      },
    );
  }
}

final nowStateProvider = StreamProvider<NowState>((ref) {
  final today = Days.key(ref.watch(clockProvider)());
  return ref
      .watch(appKvProvider)
      .watchPrefix(NowKeys.prefix)
      .map((m) => NowState.parse(m, today));
});

/// The suggestions for this moment, or null while loading.
final nowRecommendationsProvider = Provider<List<NowRecommendation>?>((ref) {
  final state = ref.watch(nowStateProvider).value;
  if (state == null) return null;
  final now = ref.watch(clockProvider)();
  final today = Days.key(now);
  bool isToday(DateTime t) => Days.key(t.toLocal()) == today;

  final meals = ref.watch(mealsProvider).value ?? const <MealEntry>[];
  final postures = ref.watch(postureHistoryProvider).value ?? const [];
  final weights = ref.watch(weightRecordsProvider).value ?? const [];
  final faces =
      ref.watch(snapshotsProvider(SnapshotKind.face)).value ??
      const <Snapshot>[];
  final agenda = ref.watch(agendaProvider(today));
  final water = agenda?.tasks
      .where((t) => t.kind == AgendaKind.water)
      .firstOrNull;
  final reminders = ref.watch(goalRemindersProvider);

  return NowRecommendations.build(
    NowInput(
      now: now,
      goals: ref.watch(goalsProvider).value ?? const {},
      level: ref.watch(profileProvider).value?.activityLevel,
      mealTimesToday: [
        for (final m in meals)
          if (isToday(m.eatenAt)) m.eatenAt.toLocal(),
      ],
      waterFraction: water?.fraction,
      postureCheckedToday: postures.any((p) => isToday(p.recordedAt)),
      weighedToday: weights.any((w) => isToday(w.recordedAt)),
      lastFaceSnapshot: faces.isEmpty
          ? null
          : faces.map((f) => f.takenAt).reduce((a, b) => a.isAfter(b) ? a : b),
      setsLogged: state.setsLogged,
      mySkills: state.skills,
      handledToday: state.handledToday,
      // Unknown while loading: don't offer them yet.
      mealRemindersOn: reminders?[GoalReminderKind.meals]?.on ?? true,
      neverAgain: state.never,
    ),
  );
});

/// Done, "not now", skills and micro-set counts.
class NowActions {
  NowActions(this._ref);
  final Ref _ref;

  String _today() => '${Days.key(_ref.read(clockProvider)())}';

  Future<void> handle(String key) async {
    final kv = _ref.read(appKvProvider);
    final state = _ref.read(nowStateProvider).value ?? const NowState();
    await kv.put(
      NowKeys.handled,
      '${_today()}|${{...state.handledToday, key}.join(',')}',
    );
  }

  Future<void> never(String key) async {
    final state = _ref.read(nowStateProvider).value ?? const NowState();
    await _ref
        .read(appKvProvider)
        .put(NowKeys.never, {...state.never, key}.join(','));
  }

  /// Counts a finished micro set so the next one can grow.
  Future<void> setDone(String exerciseId) async {
    final state = _ref.read(nowStateProvider).value ?? const NowState();
    await _ref
        .read(appKvProvider)
        .put(
          NowKeys.sets(exerciseId),
          '${(state.setsLogged[exerciseId] ?? 0) + 1}',
        );
  }

  Future<void> setSkill(String id, bool on) async {
    final state = _ref.read(nowStateProvider).value ?? const NowState();
    final skills = [...state.skills]..remove(id);
    if (on) skills.add(id);
    await _ref.read(appKvProvider).put(NowKeys.skills, skills.join(','));
  }
}

final nowActionsProvider = Provider((ref) => NowActions(ref));
