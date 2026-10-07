/// Posture metrics from pose landmarks (spec §15–16).
///
/// Produces *estimated alignment* for awareness — never a diagnosis. Every
/// metric is an angle measured on the image, aggregated over many frames,
/// with an explicit confidence. When the evidence is insufficient the
/// engine returns no result instead of guessing.
library;

import 'dart:math' as math;

import '../../ml/pose/pose_estimator.dart';
import '../entities/provenance.dart';

enum PostureView { front, side }

enum PostureMetric {
  /// Front: angle of the ear line from horizontal.
  headTilt,

  /// Front: angle of the shoulder line from horizontal.
  shoulderLevel,

  /// Front: angle of the hip line from horizontal.
  hipLevel,

  /// Front: sideways lean of the torso; side: forward/back lean.
  torsoLean,

  /// Front: deviation of the knee from the hip–ankle line.
  kneeAlignment,

  /// Side: how far the ear sits in front of the shoulder.
  headForward,
}

/// Where a deviation points, in the person's own terms.
enum MetricDirection { none, left, right, forward, backward }

enum AlignmentBand { aligned, slight, noticeable }

/// Approximate bands in degrees, used only to choose neutral wording.
abstract final class PostureBands {
  static const Map<PostureMetric, (double, double)> degrees = {
    PostureMetric.headTilt: (3, 7),
    PostureMetric.shoulderLevel: (2, 5),
    PostureMetric.hipLevel: (2, 5),
    PostureMetric.torsoLean: (3, 7),
    PostureMetric.kneeAlignment: (5, 10),
    PostureMetric.headForward: (15, 25),
  };

  static AlignmentBand of(PostureMetric m, double deg) {
    final (slight, noticeable) = degrees[m]!;
    if (deg < slight) return AlignmentBand.aligned;
    if (deg < noticeable) return AlignmentBand.slight;
    return AlignmentBand.noticeable;
  }
}

class MetricSample {
  const MetricSample(this.degrees, this.direction);
  final double degrees;
  final MetricDirection direction;
}

/// What one frame contributes. Unusable frames carry the reasons.
class FrameAssessment {
  const FrameAssessment({
    required this.issues,
    this.view,
    this.samples = const {},
    this.visibility = 0,
  });

  final Set<FrameQualityIssue> issues;
  final PostureView? view;
  final Map<PostureMetric, MetricSample> samples;

  /// Mean confidence of the landmarks the metrics used.
  final double visibility;

  bool get usable => issues.isEmpty && view != null;
}

class _P {
  const _P(this.x, this.y, this.v);
  final double x;
  final double y;
  final double v;
}

abstract final class PostureEngine {
  static const minVisibility = 0.6;
  static const margin = 0.02;

  static double _deg(double rad) => rad * 180 / math.pi;

  /// Assesses one detection. [previous] enables the stillness check.
  static FrameAssessment assess(PoseDetected pose, {PoseDetected? previous}) {
    final w = pose.imageWidth.toDouble();
    final h = pose.imageHeight.toDouble();
    _P? p(PoseJoint j) {
      final l = pose[j];
      return l == null ? null : _P(l.x * w, l.y * h, l.visibility);
    }

    final ls = p(PoseJoint.leftShoulder), rs = p(PoseJoint.rightShoulder);
    final lh = p(PoseJoint.leftHip), rh = p(PoseJoint.rightHip);
    if ([ls, rs, lh, rh].any((x) => x == null)) {
      return const FrameAssessment(issues: {FrameQualityIssue.bodyOutOfFrame});
    }

    final issues = <FrameQualityIssue>{};
    final core = [ls!, rs!, lh!, rh!];

    // Body in frame: shoulders and hips must sit inside the image.
    for (final j in [
      PoseJoint.leftShoulder,
      PoseJoint.rightShoulder,
      PoseJoint.leftHip,
      PoseJoint.rightHip,
      PoseJoint.nose,
    ]) {
      final l = pose[j];
      if (l == null ||
          l.x < margin ||
          l.x > 1 - margin ||
          l.y < margin ||
          l.y > 1 - margin) {
        issues.add(FrameQualityIssue.bodyOutOfFrame);
      }
    }

    final midS = _P((ls.x + rs.x) / 2, (ls.y + rs.y) / 2, 1);
    final midH = _P((lh.x + rh.x) / 2, (lh.y + rh.y) / 2, 1);
    final torso = math.sqrt(
        math.pow(midS.x - midH.x, 2) + math.pow(midS.y - midH.y, 2));
    if (torso < 1) {
      return const FrameAssessment(issues: {FrameQualityIssue.bodyOutOfFrame});
    }

    // Distance: torso length relative to image height.
    final torsoFraction = torso / h;
    if (torsoFraction < 0.12) issues.add(FrameQualityIssue.tooFar);
    if (torsoFraction > 0.6) issues.add(FrameQualityIssue.tooClose);

    // Stillness: mean core-landmark movement relative to torso length.
    if (previous != null) {
      var moved = 0.0;
      var n = 0;
      for (final j in [
        PoseJoint.leftShoulder,
        PoseJoint.rightShoulder,
        PoseJoint.leftHip,
        PoseJoint.rightHip,
      ]) {
        final a = pose[j], b = previous[j];
        if (a == null || b == null) continue;
        moved += math.sqrt(math.pow((a.x - b.x) * w, 2) +
            math.pow((a.y - b.y) * h, 2));
        n++;
      }
      if (n > 0 && moved / n / torso > 0.08) {
        issues.add(FrameQualityIssue.motionBlur);
      }
    }

    // View: shoulder width relative to torso length.
    final ratio = (ls.x - rs.x).abs() / torso;
    final PostureView? view = ratio > 0.45
        ? PostureView.front
        : ratio < 0.25
            ? PostureView.side
            : null;
    if (view == null) issues.add(FrameQualityIssue.unclearView);

    final samples = <PostureMetric, MetricSample>{};
    final used = <_P>[];

    if (view == PostureView.front) {
      if (core.any((x) => x.v < minVisibility)) {
        issues.add(FrameQualityIssue.lowVisibility);
      }
      used.addAll(core);

      // Image direction of the person's left (handles mirroring).
      final leftSign = (ls.x - rs.x).sign;

      MetricSample level(_P left, _P right) {
        final dx = (left.x - right.x).abs();
        final dy = (left.y - right.y).abs();
        final deg = _deg(math.atan2(dy, dx));
        final dir = deg < 1
            ? MetricDirection.none
            : (left.y < right.y ? MetricDirection.left : MetricDirection.right);
        return MetricSample(deg, dir);
      }

      samples[PostureMetric.shoulderLevel] = level(ls, rs);
      samples[PostureMetric.hipLevel] = level(lh, rh);

      // Head tilt: toward the side of the lower ear (fallback: eyes).
      var le = p(PoseJoint.leftEar), re = p(PoseJoint.rightEar);
      if (le == null || re == null || le.v < minVisibility || re.v < minVisibility) {
        le = p(PoseJoint.leftEye);
        re = p(PoseJoint.rightEye);
      }
      if (le != null && re != null &&
          le.v >= minVisibility && re.v >= minVisibility) {
        final s = level(le, re);
        // level() names the higher side; the head tilts toward the lower.
        samples[PostureMetric.headTilt] = MetricSample(
            s.degrees,
            switch (s.direction) {
              MetricDirection.left => MetricDirection.right,
              MetricDirection.right => MetricDirection.left,
              final d => d,
            });
        used.addAll([le, re]);
      }

      // Torso lean: shoulder midpoint relative to hip midpoint.
      final leanDeg =
          _deg(math.atan2((midS.x - midH.x).abs(), (midH.y - midS.y).abs()));
      samples[PostureMetric.torsoLean] = MetricSample(
          leanDeg,
          leanDeg < 1
              ? MetricDirection.none
              : ((midS.x - midH.x) * leftSign > 0
                  ? MetricDirection.left
                  : MetricDirection.right));

      // Knees only when the whole leg is clearly visible.
      double? kneeDev(PoseJoint hip, PoseJoint knee, PoseJoint ankle) {
        final a = p(hip), b = p(knee), c = p(ankle);
        if (a == null || b == null || c == null) return null;
        if ([a, b, c].any((x) => x.v < minVisibility)) return null;
        final v1x = a.x - b.x, v1y = a.y - b.y;
        final v2x = c.x - b.x, v2y = c.y - b.y;
        final cos = (v1x * v2x + v1y * v2y) /
            (math.sqrt(v1x * v1x + v1y * v1y) * math.sqrt(v2x * v2x + v2y * v2y));
        return 180 - _deg(math.acos(cos.clamp(-1.0, 1.0)));
      }

      final lk = kneeDev(PoseJoint.leftHip, PoseJoint.leftKnee, PoseJoint.leftAnkle);
      final rk = kneeDev(PoseJoint.rightHip, PoseJoint.rightKnee, PoseJoint.rightAnkle);
      if (lk != null && rk != null) {
        final worst = math.max(lk, rk);
        samples[PostureMetric.kneeAlignment] = MetricSample(
            worst,
            worst < 1
                ? MetricDirection.none
                : (lk >= rk ? MetricDirection.left : MetricDirection.right));
      }
    } else if (view == PostureView.side) {
      // Use the side facing the camera (higher landmark confidence).
      final leftFacing = ls.v + lh.v >= rs.v + rh.v;
      final sh = leftFacing ? ls : rs;
      final hip = leftFacing ? lh : rh;
      final ear = p(leftFacing ? PoseJoint.leftEar : PoseJoint.rightEar);
      final nose = p(PoseJoint.nose);
      if (sh.v < minVisibility || hip.v < minVisibility) {
        issues.add(FrameQualityIssue.lowVisibility);
      }
      used.addAll([sh, hip]);

      if (ear != null && nose != null && ear.v >= minVisibility) {
        used.add(ear);
        // Facing direction from nose relative to ear.
        final facing = (nose.x - ear.x).sign;
        final dx = (ear.x - sh.x) * facing; // > 0: ear ahead of shoulder
        final deg = _deg(math.atan2(math.max(0.0, dx), (sh.y - ear.y).abs()));
        samples[PostureMetric.headForward] = MetricSample(
            deg, deg < 1 ? MetricDirection.none : MetricDirection.forward);

        final lean = (sh.x - hip.x) * facing;
        final leanDeg = _deg(math.atan2(lean.abs(), (hip.y - sh.y).abs()));
        samples[PostureMetric.torsoLean] = MetricSample(
            leanDeg,
            leanDeg < 1
                ? MetricDirection.none
                : (lean > 0 ? MetricDirection.forward : MetricDirection.backward));
      } else {
        issues.add(FrameQualityIssue.lowVisibility);
      }
    }

    final visibility =
        used.isEmpty ? 0.0 : used.map((x) => x.v).reduce((a, b) => a + b) / used.length;
    return FrameAssessment(
      issues: issues,
      view: view,
      samples: issues.isEmpty ? samples : const {},
      visibility: visibility,
    );
  }
}

class MetricResult {
  const MetricResult({
    required this.metric,
    required this.degrees,
    required this.direction,
    required this.band,
    required this.spread,
    required this.confidence,
  });

  final PostureMetric metric;

  /// Median over frames.
  final double degrees;
  final MetricDirection direction;
  final AlignmentBand band;

  /// Median absolute deviation across frames, degrees.
  final double spread;
  final Confidence confidence;
}

class PostureResult {
  const PostureResult({
    required this.view,
    required this.metrics,
    required this.confidence,
    required this.framesUsed,
    required this.visibility,
  });

  final PostureView view;
  final List<MetricResult> metrics;
  final Confidence confidence;
  final int framesUsed;
  final double visibility;

  DataSource get source => DataSource.cameraDerived;

  MetricResult? operator [](PostureMetric m) {
    for (final r in metrics) {
      if (r.metric == m) return r;
    }
    return null;
  }
}

/// Collects frame assessments for one capture and aggregates them.
class PostureCapture {
  PostureCapture({this.targetFrames = 15});

  static const minFrames = 6;
  final int targetFrames;
  final _frames = <FrameAssessment>[];
  final _lastIssues = <FrameQualityIssue, int>{};

  int get usableFrames => _frames.length;
  bool get complete => _frames.length >= targetFrames;
  double get progress => (_frames.length / targetFrames).clamp(0.0, 1.0);

  /// The most frequent problem so far, for guidance after a failed capture.
  FrameQualityIssue? get mainIssue {
    if (_lastIssues.isEmpty) return null;
    return _lastIssues.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
  }

  void add(FrameAssessment a) {
    if (a.usable) {
      _frames.add(a);
    } else {
      for (final i in a.issues) {
        _lastIssues[i] = (_lastIssues[i] ?? 0) + 1;
      }
    }
  }

  static double _median(List<double> v) {
    final s = [...v]..sort();
    final m = s.length ~/ 2;
    return s.length.isOdd ? s[m] : (s[m - 1] + s[m]) / 2;
  }

  /// The aggregated result, or null when there is not enough evidence.
  PostureResult? result() {
    if (_frames.length < minFrames) return null;

    // Use the dominant view only; mixed captures are not averaged.
    final views = <PostureView, int>{};
    for (final f in _frames) {
      views[f.view!] = (views[f.view!] ?? 0) + 1;
    }
    final view = views.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    final frames = _frames.where((f) => f.view == view).toList();
    if (frames.length < minFrames) return null;

    final visibility =
        frames.map((f) => f.visibility).reduce((a, b) => a + b) / frames.length;

    final metrics = <MetricResult>[];
    for (final m in PostureMetric.values) {
      final samples = [
        for (final f in frames)
          if (f.samples[m] != null) f.samples[m]!,
      ];
      // A metric needs most frames to support it.
      if (samples.length < minFrames || samples.length * 2 < frames.length) {
        continue;
      }
      final values = samples.map((s) => s.degrees).toList();
      final median = _median(values);
      final spread = _median([for (final v in values) (v - median).abs()]);
      final dirs = <MetricDirection, int>{};
      for (final s in samples) {
        dirs[s.direction] = (dirs[s.direction] ?? 0) + 1;
      }
      final direction = median < 1
          ? MetricDirection.none
          : dirs.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

      final Confidence confidence;
      if (samples.length >= 12 && visibility >= 0.8 && spread <= 1.5) {
        confidence = Confidence.high;
      } else if (samples.length >= 8 && visibility >= 0.65 && spread <= 3) {
        confidence = Confidence.medium;
      } else {
        confidence = Confidence.low;
      }
      metrics.add(MetricResult(
        metric: m,
        degrees: median,
        direction: direction,
        band: PostureBands.of(m, median),
        spread: spread,
        confidence: confidence,
      ));
    }
    if (metrics.isEmpty) return null;

    final overall = metrics
        .map((r) => r.confidence)
        .reduce((a, b) => a.index <= b.index ? a : b);
    return PostureResult(
      view: view,
      metrics: metrics,
      confidence: overall,
      framesUsed: frames.length,
      visibility: visibility,
    );
  }
}
