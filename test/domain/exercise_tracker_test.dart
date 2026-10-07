import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/services/exercise_tracker.dart';
import 'package:personality/ml/pose/pose_estimator.dart';

const w = 720, h = 1280;

PoseDetected figure(Map<PoseJoint, (double, double)> px, {double vis = 0.9}) =>
    PoseDetected(
      landmarks: [
        for (final e in px.entries)
          PoseLandmark(
              joint: e.key,
              x: e.value.$1 / w,
              y: e.value.$2 / h,
              z: 0,
              visibility: vis),
      ],
      score: vis,
      imageWidth: w,
      imageHeight: h,
    );

/// Front-facing body whose knees bend to [knee] degrees.
PoseDetected squat(double knee, {double kneeInset = 0}) {
  const thigh = 200.0, shin = 200.0;
  final bend = (180 - knee) * math.pi / 180;
  // Thigh tilts forward (toward camera = shorter on screen); for a simple
  // 2D model rotate the shin outward in x so the angle at the knee is exact.
  final Map<PoseJoint, (double, double)> m = {};
  for (final (side, x0, dir) in [('L', 420.0, 1.0), ('R', 300.0, -1.0)]) {
    final hip = (x0, 600.0);
    final knee0 = (x0 - dir * kneeInset, 600.0 + thigh);
    final ankle = (knee0.$1 + dir * math.sin(bend) * shin,
        knee0.$2 + math.cos(bend) * shin);
    if (side == 'L') {
      m[PoseJoint.leftHip] = hip;
      m[PoseJoint.leftKnee] = knee0;
      m[PoseJoint.leftAnkle] = ankle;
      m[PoseJoint.leftShoulder] = (x0, 300);
    } else {
      m[PoseJoint.rightHip] = hip;
      m[PoseJoint.rightKnee] = knee0;
      m[PoseJoint.rightAnkle] = ankle;
      m[PoseJoint.rightShoulder] = (x0, 300);
    }
  }
  return figure(m);
}

/// Front-facing body with both arms raised [deg] from the sides.
PoseDetected arms(double left, [double? right]) {
  (double, double) wrist(double x, double dir, double deg) {
    final r = deg * math.pi / 180;
    return (x + dir * math.sin(r) * 250, 300 + math.cos(r) * 250);
  }

  return figure({
    PoseJoint.leftShoulder: (420, 300),
    PoseJoint.rightShoulder: (300, 300),
    PoseJoint.leftHip: (400, 600),
    PoseJoint.rightHip: (320, 600),
    PoseJoint.leftWrist: wrist(420, 1, left),
    PoseJoint.rightWrist: wrist(300, -1, right ?? left),
  });
}

/// Feeds angles 200 ms apart and returns the final state.
TrackerState run(ExerciseTracker t, List<PoseDetected?> frames,
    {DateTime? start}) {
  var s = TrackerState.initial;
  var at = start ?? DateTime(2026);
  for (final f in frames) {
    s = t.update(f, at);
    at = at.add(const Duration(milliseconds: 200));
  }
  return s;
}

List<PoseDetected> squatReps(int n, {double depth = 90}) => [
      for (var i = 0; i < n; i++) ...[
        for (final a in <double>[175.0, 150, 120, depth, depth, 120, 150, 175, 175])
          squat(a),
      ],
    ];

void main() {
  group('squat', () {
    test('counts full reps', () {
      final s = run(ExerciseTracker(TrackingPattern.squat), squatReps(3));
      expect(s.reps, 3);
      expect(s.tracking, isTrue);
    });

    test('shallow reps are not counted and prompt to go lower', () {
      final t = ExerciseTracker(TrackingPattern.squat);
      final s = run(t, [
        for (final a in <double>[175.0, 150, 130, 125, 130, 150, 170, 175]) squat(a),
      ]);
      expect(s.reps, 0);
      expect(s.cue, FormCue.goLower);
    });

    test('jitter around one threshold does not add reps', () {
      final t = ExerciseTracker(TrackingPattern.squat);
      final s = run(t, [
        for (final a in <double>[175.0, 100, 96, 104, 99, 106, 98, 103, 175, 175]) squat(a),
      ]);
      expect(s.reps, 1);
    });

    test('knees drifting inward produces a cue', () {
      final t = ExerciseTracker(TrackingPattern.squat);
      run(t, [squat(175), squat(150)]);
      final s = run(t, [squat(100, kneeInset: 50)],
          start: DateTime(2026).add(const Duration(seconds: 1)));
      expect(s.cue, FormCue.kneesOverToes);
    });

    test('missing legs pause tracking instead of counting', () {
      final t = ExerciseTracker(TrackingPattern.squat);
      final s = run(t, [null, null]);
      expect(s.tracking, isFalse);
      expect(s.cue, FormCue.stepIntoView);
      expect(s.reps, 0);
    });
  });

  group('arm raise', () {
    test('counts raises and flags uneven arms', () {
      final t = ExerciseTracker(TrackingPattern.armRaise);
      final s = run(t, [
        for (var i = 0; i < 2; i++)
          for (final a in <double>[10.0, 60, 110, 165, 165, 110, 60, 10, 10]) arms(a),
      ]);
      expect(s.reps, 2);

      final uneven = run(ExerciseTracker(TrackingPattern.armRaise),
          [arms(10), arms(160, 100), arms(160, 100)]);
      expect(uneven.cue, FormCue.raiseEvenly);
    });

    test('half raises prompt to raise higher', () {
      final s = run(ExerciseTracker(TrackingPattern.armRaise), [
        for (final a in <double>[10.0, 60, 110, 115, 60, 20, 10]) arms(a),
      ]);
      expect(s.reps, 0);
      expect(s.cue, FormCue.raiseHigher);
    });
  });

  group('holds', () {
    PoseDetected plank(double sag) => figure({
          PoseJoint.leftShoulder: (150, 700),
          PoseJoint.leftHip: (350, 700 + sag),
          PoseJoint.leftAnkle: (600, 700),
        });

    test('plank time accumulates only while the body is straight', () {
      final t = ExerciseTracker(TrackingPattern.plank);
      var s = run(t, [for (var i = 0; i < 11; i++) plank(0)]);
      expect(s.holdSeconds, closeTo(2.0, 0.01));
      expect(s.inPosition, isTrue);
      s = run(t, [for (var i = 0; i < 6; i++) plank(80)],
          start: DateTime(2026).add(const Duration(milliseconds: 2200)));
      expect(s.holdSeconds, lessThan(2.5));
      expect(s.cue, FormCue.keepBodyStraight);
    });

    test('long gaps between frames are not counted as hold time', () {
      final t = ExerciseTracker(TrackingPattern.plank);
      t.update(plank(0), DateTime(2026));
      final s = t.update(plank(0), DateTime(2026).add(const Duration(seconds: 30)));
      expect(s.holdSeconds, lessThanOrEqualTo(1.0));
    });
  });
}
