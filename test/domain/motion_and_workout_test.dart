import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/exercise_library.dart';
import 'package:personality/domain/entities/health.dart';
import 'package:personality/domain/entities/motion.dart';
import 'package:personality/domain/services/workout_plan.dart';

void main() {
  final motions = parseMotions(
      jsonDecode(File('assets/content/motions.json').readAsStringSync()) as Map<String, dynamic>);
  final exercises = [
    for (final e in jsonDecode(File('assets/content/exercises.json').readAsStringSync()) as List)
      LibraryExercise.fromJson(e as Map<String, dynamic>),
  ];
  final programs = [
    for (final p in jsonDecode(File('assets/content/programs.json').readAsStringSync()) as List)
      WorkoutProgram.fromJson(p as Map<String, dynamic>),
  ];

  test('every motion parses, loops and has poses of the right kind', () {
    expect(motions.length, greaterThan(70));
    for (final m in motions.values) {
      expect(m.frames, isNotEmpty, reason: m.id);
      expect(m.cycleMs, greaterThan(0), reason: m.id);
      for (final f in m.frames) {
        expect(f.pose, m.isFace ? isA<FacePose>() : isA<BodyPose>(), reason: m.id);
      }
      // The loop starts and ends on the first frame.
      expect(identical(m.poseAt(0), m.frames.first.pose) || m.frames.first.hold == 0, isTrue);
    }
  });

  test('interpolation eases between keyframes', () {
    final squat = motions['squat']!;
    final start = squat.poseAt(0) as BodyPose;
    final mid = squat.poseAt(500) as BodyPose; // half way down
    final bottom = squat.poseAt(1000) as BodyPose;
    expect(start.thigh.$1, closeTo(0, 0.01));
    expect(bottom.thigh.$1, closeTo(88, 0.01));
    expect(mid.thigh.$1, closeTo(44, 0.5)); // ease-in-out is symmetric
    expect((squat.poseAt(2000) as BodyPose).thigh.$1, closeTo(0, 0.01)); // looped
  });

  test('built-in exercises and programs only use what exists', () {
    final ids = {for (final e in exercises) e.id};
    for (final e in exercises) {
      expect(motions.containsKey(e.motion), isTrue, reason: '${e.id} -> ${e.motion}');
    }
    for (final p in programs) {
      expect(p.title.keys, containsAll(['en', 'hi']), reason: p.id);
      for (final s in p.steps) {
        expect(ids, contains(s.exercise), reason: '${p.id}: ${s.exercise}');
      }
    }
  });

  test('a program expands into ready, work and rest with sides and rounds', () {
    const p = WorkoutProgram(
      id: 'x',
      title: {'en': 'X'},
      summary: {},
      category: ExerciseCategory.strength,
      rounds: 2,
      steps: [
        ProgramStep(exercise: 'a', seconds: 30, rest: 10),
        ProgramStep(exercise: 'b', reps: 8, rest: 20, sides: true),
      ],
    );
    final s = workoutSegments(p);
    expect(s.first.kind, SegmentKind.ready);
    expect(s.first.exercise, 'a');
    final work = s.where((x) => x.kind == SegmentKind.work).toList();
    expect(work.map((x) => (x.exercise, x.side, x.round)), [
      ('a', null, 1), ('b', 1, 1), ('b', 2, 1),
      ('a', null, 2), ('b', 1, 2), ('b', 2, 2),
    ]);
    expect(work[1].reps, 8);
    expect(work[1].seconds, isNull);
    // A short pause to switch sides, then the step's own rest, and none at the end.
    final rests = s.where((x) => x.kind == SegmentKind.rest).map((x) => x.seconds).toList();
    expect(rests, [10, 5, 20, 10, 5]);
    expect(s.last.kind, SegmentKind.work);
    expect(p.totalSeconds, 2 * (30 + 10 + (8 * 3) * 2 + 20 * 2));
  });
}

