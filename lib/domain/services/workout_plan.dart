import '../entities/exercise_library.dart';

enum SegmentKind { ready, work, rest }

/// One screen of the workout player.
class WorkoutSegment {
  const WorkoutSegment({
    required this.kind,
    this.exercise,
    this.seconds,
    this.reps,
    this.side,
    this.round = 1,
  });

  final SegmentKind kind;

  /// Exercise id (the next one, for ready and rest segments).
  final String? exercise;

  /// Timed segment length; null for rep-based work (the user taps Done).
  final int? seconds;
  final int? reps;

  /// 1 or 2 for exercises done on each side.
  final int? side;
  final int round;
}

/// Expands a program into the sequence the player walks through: a short
/// get-ready, then work and rest for every step, side and round. There is no
/// rest after the very last exercise.
List<WorkoutSegment> workoutSegments(WorkoutProgram p, {int readySeconds = 5}) {
  final out = <WorkoutSegment>[];
  if (p.steps.isEmpty) return out;
  out.add(WorkoutSegment(kind: SegmentKind.ready, exercise: p.steps.first.exercise, seconds: readySeconds));
  for (var round = 1; round <= p.rounds; round++) {
    for (final (i, s) in p.steps.indexed) {
      final sides = s.sides ? [1, 2] : [null];
      for (final side in sides) {
        out.add(WorkoutSegment(
          kind: SegmentKind.work,
          exercise: s.exercise,
          seconds: s.seconds,
          reps: s.seconds == null ? (s.reps ?? 10) : null,
          side: side,
          round: round,
        ));
        final last = round == p.rounds && i == p.steps.length - 1 && side != 1;
        if (last) continue;
        // Switching sides gets a short pause; otherwise the step's own rest.
        final rest = side == 1 ? 5 : s.rest;
        if (rest > 0) {
          final next = side == 1 ? s.exercise : p.steps[(i + 1) % p.steps.length].exercise;
          out.add(WorkoutSegment(kind: SegmentKind.rest, exercise: next, seconds: rest, round: round));
        }
      }
    }
  }
  return out;
}
