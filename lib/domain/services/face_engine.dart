/// Face shape estimate from the face outline (spec §20–21).
///
/// Measures proportions only — length to width, forehead and jaw relative
/// to the cheekbones — and compares them with six common reference shapes.
/// It is an estimate for style suggestions, never a judgement about
/// appearance. Close calls report two shapes instead of overstating.
library;

import 'dart:math' as math;

import '../../ml/face/face_estimator.dart';
import '../../ml/pose/pose_estimator.dart' show FrameQualityIssue;
import '../entities/provenance.dart';

enum FaceShape { oval, round, square, oblong, heart, diamond }

enum FaceRatio {
  /// Face length / cheekbone width.
  lengthToWidth,

  /// Forehead width / cheekbone width.
  foreheadToCheek,

  /// Jaw width / cheekbone width.
  jawToCheek,
}

/// Width of a closed outline at height [y] (distance between the outermost
/// crossings), or null when the line misses it.
double? _widthAt(List<(double, double)> pts, double y) {
  double? lo, hi;
  for (var i = 0; i < pts.length; i++) {
    final (x1, y1) = pts[i];
    final (x2, y2) = pts[(i + 1) % pts.length];
    if ((y1 <= y && y2 >= y) || (y2 <= y && y1 >= y)) {
      final x = y1 == y2 ? x1 : x1 + (y - y1) / (y2 - y1) * (x2 - x1);
      lo = lo == null ? x : math.min(lo, x);
      hi = hi == null ? x : math.max(hi, x);
    }
  }
  return lo == null ? null : hi! - lo;
}

class FaceFrameAssessment {
  const FaceFrameAssessment({required this.issues, this.ratios = const {}});

  final Set<FrameQualityIssue> issues;
  final Map<FaceRatio, double> ratios;

  bool get usable => issues.isEmpty && ratios.length == FaceRatio.values.length;
}

abstract final class FaceEngine {
  static const maxYaw = 10.0;
  static const maxRoll = 8.0;
  static const maxPitch = 12.0;

  static FaceFrameAssessment assess(FaceDetected f) {
    final issues = <FrameQualityIssue>{};
    if (f.boxHeight < 0.25) issues.add(FrameQualityIssue.tooFar);
    if (f.boxHeight > 0.85) issues.add(FrameQualityIssue.tooClose);
    if (f.yaw.abs() > maxYaw ||
        f.roll.abs() > maxRoll ||
        f.pitch.abs() > maxPitch) {
      issues.add(FrameQualityIssue.unclearView);
    }
    final pts = f.outline;
    if (pts.length < 20) return const FaceFrameAssessment(issues: {FrameQualityIssue.bodyOutOfFrame});
    for (final (x, y) in pts) {
      if (x < 0 || y < 0 || x > f.imageWidth || y > f.imageHeight) {
        issues.add(FrameQualityIssue.bodyOutOfFrame);
        break;
      }
    }
    if (issues.isNotEmpty) return FaceFrameAssessment(issues: issues);

    final top = pts.map((p) => p.$2).reduce(math.min);
    final bottom = pts.map((p) => p.$2).reduce(math.max);
    final length = bottom - top;
    if (length <= 0) return const FaceFrameAssessment(issues: {FrameQualityIssue.lowVisibility});
    double? at(double f) => _widthAt(pts, top + f * length);

    double cheek = 0;
    for (var f = 0.25; f <= 0.55; f += 0.05) {
      cheek = math.max(cheek, at(f) ?? 0);
    }
    final forehead = at(0.12), jaw = at(0.8);
    if (cheek <= 0 || forehead == null || jaw == null) {
      return const FaceFrameAssessment(issues: {FrameQualityIssue.lowVisibility});
    }
    return FaceFrameAssessment(issues: const {}, ratios: {
      FaceRatio.lengthToWidth: length / cheek,
      FaceRatio.foreheadToCheek: forehead / cheek,
      FaceRatio.jawToCheek: jaw / cheek,
    });
  }

  /// Reference proportions, calibrated for the ML Kit outline (whose top
  /// sits on the upper forehead, below the hairline).
  static const prototypes = <FaceShape, (double, double, double)>{
    FaceShape.oblong: (1.45, 0.90, 0.84),
    FaceShape.oval: (1.30, 0.88, 0.78),
    FaceShape.round: (1.08, 0.90, 0.86),
    FaceShape.square: (1.12, 0.95, 0.93),
    FaceShape.heart: (1.27, 0.97, 0.70),
    FaceShape.diamond: (1.27, 0.78, 0.74),
  };

  /// Weighted distance to each reference shape, smallest first.
  static List<(FaceShape, double)> rank(Map<FaceRatio, double> r) {
    final lw = r[FaceRatio.lengthToWidth]!,
        fc = r[FaceRatio.foreheadToCheek]!,
        jc = r[FaceRatio.jawToCheek]!;
    final out = [
      for (final e in prototypes.entries)
        (
          e.key,
          math.sqrt(math.pow((lw - e.value.$1) / 0.10, 2) +
              math.pow((fc - e.value.$2) / 0.05, 2) +
              math.pow((jc - e.value.$3) / 0.05, 2)),
        ),
    ]..sort((a, b) => a.$2.compareTo(b.$2));
    return out;
  }
}

class FaceShapeResult {
  const FaceShapeResult({
    required this.shape,
    required this.ratios,
    required this.confidence,
    required this.framesUsed,
    this.alsoLike,
  });

  final FaceShape shape;

  /// A second shape when the measurements sit between two references.
  final FaceShape? alsoLike;
  final Map<FaceRatio, double> ratios;
  final Confidence confidence;
  final int framesUsed;

  DataSource get source => DataSource.cameraDerived;
}

/// Aggregates frames for one capture (median per ratio).
class FaceCapture {
  FaceCapture({this.targetFrames = 12});

  static const minFrames = 6;
  final int targetFrames;
  final _frames = <Map<FaceRatio, double>>[];
  final _issues = <FrameQualityIssue, int>{};

  int get usableFrames => _frames.length;
  bool get complete => _frames.length >= targetFrames;
  double get progress => (_frames.length / targetFrames).clamp(0.0, 1.0);

  FrameQualityIssue? get mainIssue => _issues.isEmpty
      ? null
      : _issues.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

  void add(FaceFrameAssessment a) {
    if (a.usable) {
      _frames.add(a.ratios);
    } else {
      for (final i in a.issues) {
        _issues[i] = (_issues[i] ?? 0) + 1;
      }
    }
  }

  static double _median(List<double> v) {
    final s = [...v]..sort();
    final m = s.length ~/ 2;
    return s.length.isOdd ? s[m] : (s[m - 1] + s[m]) / 2;
  }

  FaceShapeResult? result() {
    if (_frames.length < minFrames) return null;
    final ratios = {
      for (final r in FaceRatio.values)
        r: _median([for (final f in _frames) f[r]!]),
    };
    final ranked = FaceEngine.rank(ratios);
    final margin = ranked[1].$2 - ranked[0].$2;
    // Stability: how much the length/width ratio moved between frames.
    final lw = [for (final f in _frames) f[FaceRatio.lengthToWidth]!];
    final m = ratios[FaceRatio.lengthToWidth]!;
    final spread = _median([for (final v in lw) (v - m).abs()]);

    final Confidence confidence;
    if (_frames.length >= 10 && margin >= 0.8 && spread <= 0.02) {
      confidence = Confidence.high;
    } else if (_frames.length >= 8 && margin >= 0.3 && spread <= 0.04) {
      confidence = Confidence.medium;
    } else {
      confidence = Confidence.low;
    }
    return FaceShapeResult(
      shape: ranked[0].$1,
      alsoLike: margin < 0.8 ? ranked[1].$1 : null,
      ratios: ratios,
      confidence: confidence,
      framesUsed: _frames.length,
    );
  }
}
