import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/domain/services/face_engine.dart';
import 'package:personality/ml/face/face_estimator.dart';
import 'package:personality/ml/pose/pose_estimator.dart' show FrameQualityIssue;

/// A face outline with exact proportions: length/cheek, forehead/cheek,
/// jaw/cheek. Width varies smoothly between the reference heights.
FaceDetected face(double lw, double fc, double jc,
    {double yaw = 0, double box = 0.45}) {
  const cheek = 300.0, cx = 360.0, top = 300.0;
  final length = lw * cheek;
  double widthAt(double f) {
    // Piecewise-linear profile through the reference points.
    const ks = [0.0, 0.12, 0.40, 0.80, 1.0];
    final ws = [fc * cheek * 0.6, fc * cheek, cheek, jc * cheek, 0.0];
    for (var i = 0; i < ks.length - 1; i++) {
      if (f <= ks[i + 1]) {
        final t = (f - ks[i]) / (ks[i + 1] - ks[i]);
        return ws[i] + (ws[i + 1] - ws[i]) * t;
      }
    }
    return 0;
  }

  final pts = <(double, double)>[];
  for (var i = 0; i <= 40; i++) {
    final f = i / 40;
    pts.add((cx + widthAt(f) / 2, top + f * length));
  }
  for (var i = 40; i >= 0; i--) {
    final f = i / 40;
    pts.add((cx - widthAt(f) / 2, top + f * length));
  }
  return FaceDetected(
      outline: pts,
      yaw: yaw,
      roll: 0,
      pitch: 0,
      boxHeight: box,
      imageWidth: 720,
      imageHeight: 1280);
}

FaceShapeResult capture(FaceDetected Function(int i) f, [int n = 12]) {
  final c = FaceCapture();
  for (var i = 0; i < n; i++) {
    c.add(FaceEngine.assess(f(i)));
  }
  return c.result()!;
}

void main() {
  test('ratios are measured from the outline', () {
    final a = FaceEngine.assess(face(1.30, 0.88, 0.78));
    expect(a.usable, isTrue);
    expect(a.ratios[FaceRatio.lengthToWidth], closeTo(1.30, 0.02));
    expect(a.ratios[FaceRatio.foreheadToCheek], closeTo(0.88, 0.02));
    expect(a.ratios[FaceRatio.jawToCheek], closeTo(0.78, 0.02));
  });

  test('each reference shape is recognised', () {
    for (final e in FaceEngine.prototypes.entries) {
      final (lw, fc, jc) = e.value;
      final r = capture((_) => face(lw, fc, jc));
      expect(r.shape, e.key, reason: '${e.key}');
      expect(r.confidence, Confidence.high, reason: '${e.key}');
      expect(r.source, DataSource.cameraDerived);
    }
  });

  test('in-between proportions report two shapes; steady stays confident',
      () {
    final r = capture((_) => face(1.19, 0.89, 0.82)); // between oval and round
    expect({r.shape, r.alsoLike}, {FaceShape.oval, FaceShape.round});
    expect(r.confidence, Confidence.high);
    // The user's real measurement on the phone: oval / diamond.
    final real = capture((_) => face(1.27, 0.83, 0.78));
    expect({real.shape, real.alsoLike}, {FaceShape.oval, FaceShape.diamond});
    expect(real.confidence, Confidence.high);
  });

  test('unsteady measurements lower confidence', () {
    final r = capture((i) => face(i.isEven ? 1.22 : 1.38, 0.88, 0.78));
    expect(r.confidence, Confidence.low);
  });

  test('turned head, distance and too few frames block the result', () {
    expect(FaceEngine.assess(face(1.3, .88, .78, yaw: 20)).issues,
        contains(FrameQualityIssue.unclearView));
    expect(FaceEngine.assess(face(1.3, .88, .78, box: 0.15)).issues,
        contains(FrameQualityIssue.tooFar));
    final c = FaceCapture();
    for (var i = 0; i < 5; i++) {
      c.add(FaceEngine.assess(face(1.3, .88, .78)));
    }
    c.add(FaceEngine.assess(face(1.3, .88, .78, yaw: 25)));
    expect(c.result(), isNull);
    expect(c.mainIssue, FrameQualityIssue.unclearView);
  });

  test('outline width helper handles a circle', () {
    final circle = [
      for (var i = 0; i < 72; i++)
        (100 + 50 * math.cos(i * math.pi / 36), 100 + 50 * math.sin(i * math.pi / 36)),
    ];
    final r = FaceEngine.assess(FaceDetected(
        outline: circle, yaw: 0, roll: 0, pitch: 0, boxHeight: 0.4,
        imageWidth: 720, imageHeight: 1280));
    expect(r.ratios[FaceRatio.lengthToWidth], closeTo(1.0, 0.03));
  });
}
