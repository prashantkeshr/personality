import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/exercise_library.dart';
import '../../domain/entities/health.dart';
import '../permissions/app_permissions.dart' show appKvProvider;

/// Workouts the user builds, kept on the phone in app_settings
/// (`myworkout.<id>` → JSON), so they are backed up with everything else.
const _prefix = 'myworkout.';

bool isMyWorkout(String id) => id.startsWith('my_');

final myWorkoutsProvider = StreamProvider<List<WorkoutProgram>>((ref) => ref
    .watch(appKvProvider)
    .watchPrefix(_prefix)
    .map((m) {
      final out = <WorkoutProgram>[];
      for (final e in m.entries) {
        try {
          out.add(WorkoutProgram.fromJson(jsonDecode(e.value) as Map<String, dynamic>));
        } catch (err, st) {
          AppLogger.error('myworkout.parse', err, st);
        }
      }
      return out..sort((a, b) => a.id.compareTo(b.id));
    }));

/// The most common category among the chosen exercises, so the workout is
/// logged under the right kind of exercise.
ExerciseCategory categoryFor(List<ProgramStep> steps, Map<String, LibraryExercise> byId) {
  final counts = <ExerciseCategory, int>{};
  for (final s in steps) {
    final c = byId[s.exercise]?.category;
    if (c != null) counts[c] = (counts[c] ?? 0) + 1;
  }
  if (counts.isEmpty) return ExerciseCategory.generalFitness;
  return (counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first.key;
}

class MyWorkoutActions {
  MyWorkoutActions(this._ref);
  final Ref _ref;

  /// Saves (or replaces) a workout and returns its id.
  Future<String> save({
    String? id,
    required String name,
    required List<ProgramStep> steps,
    required int rounds,
    required ExerciseCategory category,
    required DateTime now,
  }) async {
    final wid = id ?? 'my_${now.millisecondsSinceEpoch}';
    final p = WorkoutProgram(
      id: wid,
      title: {'en': name},
      summary: const {},
      category: category,
      steps: steps,
      rounds: rounds,
    );
    await _ref.read(appKvProvider).put('$_prefix$wid', jsonEncode(p.toJson()));
    return wid;
  }

  Future<void> delete(String id) => _ref.read(appKvProvider).delete('$_prefix$id');
}

final myWorkoutActionsProvider = Provider((ref) => MyWorkoutActions(ref));
