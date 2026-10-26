import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/exercise_library.dart';
import '../content/content_providers.dart';
import '../permissions/app_permissions.dart' show appKvProvider;
import 'my_workouts.dart';

/// How popular each built-in workout is, most popular first. Pack workouts
/// come after these until the user uses them.
const workoutPopularity = [
  'beginner_full_body',
  'yoga_sun_flow',
  'five_minute_energy',
  'desk_reset',
  'morning_mobility',
  'home_strength',
  'wind_down',
  'yoga_balance',
  'yoga_evening_calm',
];

/// How often the user opened and finished each workout (kept on the phone,
/// in app_settings: `workout.opened.<id>`, `workout.done.<id>`).
class WorkoutUsage {
  const WorkoutUsage({this.opened = const {}, this.done = const {}});
  final Map<String, int> opened;
  final Map<String, int> done;

  int score(String id) => (done[id] ?? 0) * 3 + (opened[id] ?? 0);
}

const _openedKey = 'workout.opened.';
const _doneKey = 'workout.done.';

final workoutUsageProvider = StreamProvider<WorkoutUsage>((ref) => ref
    .watch(appKvProvider)
    .watchPrefix('workout.')
    .map((m) {
      Map<String, int> pick(String prefix) => {
        for (final e in m.entries)
          if (e.key.startsWith(prefix))
            e.key.substring(prefix.length): int.tryParse(e.value) ?? 0,
      };
      return WorkoutUsage(opened: pick(_openedKey), done: pick(_doneKey));
    }));

/// Counts an open or a finished session.
class WorkoutUsageRecorder {
  WorkoutUsageRecorder(this._ref);
  final Ref _ref;

  Future<void> _bump(String key) async {
    final kv = _ref.read(appKvProvider);
    final n = int.tryParse(await kv.get(key) ?? '') ?? 0;
    await kv.put(key, '${n + 1}');
  }

  Future<void> opened(String id) => _bump('$_openedKey$id');
  Future<void> finished(String id) => _bump('$_doneKey$id');
}

final workoutUsageRecorderProvider = Provider((ref) => WorkoutUsageRecorder(ref));

/// Workouts in order: the ones the user does and opens most rise to the
/// top; otherwise the popularity order decides.
List<WorkoutProgram> rankWorkouts(List<WorkoutProgram> all, WorkoutUsage usage) {
  int pop(String id) {
    final i = workoutPopularity.indexOf(id);
    return i < 0 ? workoutPopularity.length : i;
  }

  return [...all]..sort((a, b) {
    final s = usage.score(b.id).compareTo(usage.score(a.id));
    if (s != 0) return s;
    final p = pop(a.id).compareTo(pop(b.id));
    return p != 0 ? p : a.id.compareTo(b.id);
  });
}

final rankedWorkoutsProvider = Provider<List<WorkoutProgram>>((ref) {
  final all = [
    ...ref.watch(programCatalogProvider).value ?? const <WorkoutProgram>[],
    ...ref.watch(myWorkoutsProvider).value ?? const <WorkoutProgram>[],
  ];
  final usage = ref.watch(workoutUsageProvider).value ?? const WorkoutUsage();
  return rankWorkouts(all, usage);
});

/// The workout for "Let's try …": the one finished most, else opened most,
/// else the most popular. Null until workouts load.
final letsTryWorkoutProvider = Provider<(WorkoutProgram, bool)?>((ref) {
  final ranked = ref.watch(rankedWorkoutsProvider);
  if (ranked.isEmpty) return null;
  final usage = ref.watch(workoutUsageProvider).value ?? const WorkoutUsage();
  final favourite = ranked.first;
  // True when it comes from the user's own habit, not just popularity.
  return (favourite, usage.score(favourite.id) > 0);
});
