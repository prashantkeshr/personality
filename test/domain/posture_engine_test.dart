import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/domain/services/posture_engine.dart';
import 'package:personality/ml/pose/pose_estimator.dart';

const w = 720, h = 1280;

/// Builds a detection from normalized joint positions.
PoseDetected pose(Map<PoseJoint, (double, double)> joints,
        {double visibility = 0.95, Map<PoseJoint, double> vis = const {}}) =>
    PoseDetected(
      landmarks: [
        for (final e in joints.entries)
          PoseLandmark(
              joint: e.key,
              x: e.value.$1,
              y: e.value.$2,
              z: 0,
              visibility: vis[e.key] ?? visibility),
      ],
      score: visibility,
      imageWidth: w,
      imageHeight: h,
    );

/// Upright person facing a back camera: their left is on the image right.
Map<PoseJoint, (double, double)> front({double shoulderTiltDeg = 0, bool mirrored = false}) {
  // Raise the left shoulder by the y offset that produces the tilt angle.
  final dx = 0.26 * w;
  final dy = math.tan(shoulderTiltDeg * math.pi / 180) * dx / h;
  double x(double v) => mirrored ? 1 - v : v;
  return {
    PoseJoint.nose: (x(0.5), 0.22),
    PoseJoint.leftEye: (x(0.52), 0.2),
    PoseJoint.rightEye: (x(0.48), 0.2),
    PoseJoint.leftEar: (x(0.54), 0.21),
    PoseJoint.rightEar: (x(0.46), 0.21),
    PoseJoint.leftShoulder: (x(0.63), 0.35 - dy),
    PoseJoint.rightShoulder: (x(0.37), 0.35),
    PoseJoint.leftHip: (x(0.57), 0.6),
    PoseJoint.rightHip: (x(0.43), 0.6),
    PoseJoint.leftKnee: (x(0.56), 0.78),
    PoseJoint.rightKnee: (x(0.44), 0.78),
    PoseJoint.leftAnkle: (x(0.56), 0.95),
    PoseJoint.rightAnkle: (x(0.44), 0.95),
  };
}

/// Person standing sideways, left side to the camera, facing image right.
Map<PoseJoint, (double, double)> side({double earX = 0.56}) => {
      PoseJoint.nose: (earX + 0.06, 0.22),
      PoseJoint.leftEar: (earX, 0.2),
      PoseJoint.leftShoulder: (0.51, 0.35),
      PoseJoint.rightShoulder: (0.49, 0.35),
      PoseJoint.leftHip: (0.51, 0.6),
      PoseJoint.rightHip: (0.49, 0.6),
    };

void main() {
  group('frame assessment', () {
    test('upright front view is usable and aligned', () {
      final a = PostureEngine.assess(pose(front()));
      expect(a.usable, isTrue);
      expect(a.view, PostureView.front);
      for (final s in a.samples.entries) {
        expect(PostureBands.of(s.key, s.value.degrees), AlignmentBand.aligned,
            reason: '${s.key}');
      }
      expect(a.samples.keys, containsAll([
        PostureMetric.shoulderLevel,
        PostureMetric.hipLevel,
        PostureMetric.headTilt,
        PostureMetric.torsoLean,
        PostureMetric.kneeAlignment,
      ]));
    });

    test('shoulder tilt is measured in real pixel proportions', () {
      final s = PostureEngine.assess(pose(front(shoulderTiltDeg: 4)))
          .samples[PostureMetric.shoulderLevel]!;
      expect(s.degrees, closeTo(4, 0.05));
      expect(s.direction, MetricDirection.left);
      expect(PostureBands.of(PostureMetric.shoulderLevel, s.degrees),
          AlignmentBand.slight);
    });

    test('mirrored (selfie) images report the same side', () {
      final s = PostureEngine.assess(
              pose(front(shoulderTiltDeg: 4, mirrored: true)))
          .samples[PostureMetric.shoulderLevel]!;
      expect(s.degrees, closeTo(4, 0.05));
      expect(s.direction, MetricDirection.left);
    });

    test('side view measures head-forward', () {
      final aligned = PostureEngine.assess(pose(side(),
          vis: {PoseJoint.rightShoulder: 0.4, PoseJoint.rightHip: 0.4}));
      expect(aligned.view, PostureView.side);
      expect(aligned.samples[PostureMetric.headForward]!.degrees,
          closeTo(10.6, 0.3));

      final forward = PostureEngine.assess(pose(side(earX: 0.60),
          vis: {PoseJoint.rightShoulder: 0.4, PoseJoint.rightHip: 0.4}));
      final s = forward.samples[PostureMetric.headForward]!;
      expect(s.degrees, closeTo(18.6, 0.3));
      expect(s.direction, MetricDirection.forward);
      expect(PostureBands.of(PostureMetric.headForward, s.degrees),
          AlignmentBand.slight);
    });

    test('quality problems block the frame instead of guessing', () {
      final cut = front()..[PoseJoint.nose] = (0.5, 0.01);
      expect(PostureEngine.assess(pose(cut)).issues,
          contains(FrameQualityIssue.bodyOutOfFrame));

      final tiny = {
        for (final e in front().entries)
          e.key: (0.5 + (e.value.$1 - 0.5) * 0.3, 0.5 + (e.value.$2 - 0.5) * 0.3),
      };
      expect(PostureEngine.assess(pose(tiny)).issues,
          contains(FrameQualityIssue.tooFar));

      final faint = PostureEngine.assess(pose(front(), visibility: 0.3));
      expect(faint.issues, contains(FrameQualityIssue.lowVisibility));
      expect(faint.samples, isEmpty);

      final moved = {
        for (final e in front().entries) e.key: (e.value.$1 + 0.05, e.value.$2),
      };
      expect(
          PostureEngine.assess(pose(front()), previous: pose(moved)).issues,
          contains(FrameQualityIssue.motionBlur));

      final half = front()
        ..[PoseJoint.leftShoulder] = (0.57, 0.35)
        ..[PoseJoint.rightShoulder] = (0.43, 0.35);
      expect(PostureEngine.assess(pose(half)).issues,
          contains(FrameQualityIssue.unclearView));
    });
  });

  group('capture aggregation', () {
    test('too few usable frames gives no result', () {
      final c = PostureCapture();
      for (var i = 0; i < PostureCapture.minFrames - 1; i++) {
        c.add(PostureEngine.assess(pose(front())));
      }
      c.add(PostureEngine.assess(pose(front(), visibility: 0.3)));
      expect(c.result(), isNull);
      expect(c.mainIssue, FrameQualityIssue.lowVisibility);
    });

    test('steady frames give a high-confidence, camera-derived result', () {
      final c = PostureCapture();
      for (var i = 0; i < 15; i++) {
        c.add(PostureEngine.assess(pose(front(shoulderTiltDeg: 4))));
      }
      expect(c.complete, isTrue);
      final r = c.result()!;
      expect(r.view, PostureView.front);
      expect(r.source, DataSource.cameraDerived);
      expect(r.confidence, Confidence.high);
      expect(r[PostureMetric.shoulderLevel]!.degrees, closeTo(4, 0.05));
      expect(r[PostureMetric.shoulderLevel]!.band, AlignmentBand.slight);
      expect(r[PostureMetric.shoulderLevel]!.direction, MetricDirection.left);
    });

    test('median resists outliers; jitter lowers confidence', () {
      final c = PostureCapture();
      final tilts = [4.0, 4.2, 3.8, 4.1, 3.9, 4.0, 4.1, 20.0, 3.9, 4.0];
      for (final t in tilts) {
        c.add(PostureEngine.assess(pose(front(shoulderTiltDeg: t))));
      }
      final r = c.result()!;
      expect(r[PostureMetric.shoulderLevel]!.degrees, closeTo(4.0, 0.1));
      expect(r[PostureMetric.shoulderLevel]!.confidence, Confidence.medium);

      final noisy = PostureCapture();
      for (var i = 0; i < 12; i++) {
        noisy.add(PostureEngine.assess(
            pose(front(shoulderTiltDeg: i.isEven ? 0 : 9))));
      }
      expect(noisy.result()![PostureMetric.shoulderLevel]!.confidence,
          Confidence.low);
    });

    test('mixed views are not averaged together', () {
      final c = PostureCapture();
      for (var i = 0; i < 8; i++) {
        c.add(PostureEngine.assess(pose(front())));
      }
      for (var i = 0; i < 3; i++) {
        c.add(PostureEngine.assess(pose(side(),
            vis: {PoseJoint.rightShoulder: 0.4, PoseJoint.rightHip: 0.4})));
      }
      final r = c.result()!;
      expect(r.view, PostureView.front);
      expect(r.framesUsed, 8);
      expect(r[PostureMetric.headForward], isNull);
    });
  });
}
