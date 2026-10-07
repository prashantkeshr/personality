import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../domain/services/face_engine.dart';

/// Frame styles drawn as precise vector art (no bitmap assets).
enum GlassesStyle { rectangular, round, browline, deep, classic }

GlassesStyle? glassesStyleFor(String itemId) => switch (itemId) {
      'rect_frames' => GlassesStyle.rectangular,
      'round_frames' => GlassesStyle.round,
      'browline_frames' => GlassesStyle.browline,
      'deep_frames' => GlassesStyle.deep,
      'oversized_any' => GlassesStyle.classic,
      _ => null,
    };

/// Draws a pair of glasses centred in [rect]. Used both for suggestion cards
/// and, scaled and rotated, for live try-on.
void paintGlasses(Canvas canvas, Rect rect, GlassesStyle style, Color frame,
    {bool lensTint = true}) {
  final w = rect.width;
  final lensW = w * 0.38;
  final lensH = switch (style) {
    GlassesStyle.deep => lensW * 0.85,
    GlassesStyle.round => lensW * 0.92,
    GlassesStyle.browline => lensW * 0.62,
    _ => lensW * 0.66,
  };
  final cy = rect.center.dy;
  final gap = w * 0.10;
  final left = Rect.fromCenter(
      center: Offset(rect.center.dx - gap / 2 - lensW / 2, cy),
      width: lensW,
      height: lensH);
  final right = left.shift(Offset(lensW + gap, 0));

  Path lens(Rect r) => switch (style) {
        GlassesStyle.round => Path()..addOval(r),
        GlassesStyle.rectangular => Path()
          ..addRRect(RRect.fromRectAndRadius(r, Radius.circular(r.height * 0.18))),
        GlassesStyle.deep => Path()
          ..addRRect(RRect.fromRectAndRadius(r, Radius.circular(r.height * 0.32))),
        GlassesStyle.classic => Path()
          ..addRRect(RRect.fromRectAndCorners(r,
              topLeft: Radius.circular(r.height * 0.14),
              topRight: Radius.circular(r.height * 0.14),
              bottomLeft: Radius.circular(r.height * 0.5),
              bottomRight: Radius.circular(r.height * 0.5))),
        GlassesStyle.browline => Path()
          ..addRRect(RRect.fromRectAndCorners(r,
              topLeft: Radius.circular(r.height * 0.1),
              topRight: Radius.circular(r.height * 0.1),
              bottomLeft: Radius.circular(r.height * 0.55),
              bottomRight: Radius.circular(r.height * 0.55))),
      };

  final stroke = Paint()
    ..color = frame
    ..style = PaintingStyle.stroke
    ..strokeWidth = math.max(2, w * 0.022)
    ..strokeJoin = StrokeJoin.round;
  for (final r in [left, right]) {
    final p = lens(r);
    if (lensTint) {
      canvas.drawPath(
        p,
        Paint()
          ..shader = ui.Gradient.linear(r.topLeft, r.bottomRight, [
            Colors.white.withValues(alpha: 0.22),
            Colors.white.withValues(alpha: 0.02),
          ]),
      );
      // A thin diagonal sheen reads as glass without looking cartoonish.
      canvas.save();
      canvas.clipPath(p);
      canvas.drawLine(
          Offset(r.left + r.width * 0.15, r.bottom),
          Offset(r.left + r.width * 0.55, r.top),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.35)
            ..strokeWidth = r.width * 0.06);
      canvas.restore();
    }
    canvas.drawPath(p, stroke);
  }
  // Browline: a heavier top bar over each lens.
  if (style == GlassesStyle.browline) {
    final bar = Paint()
      ..color = frame
      ..strokeWidth = math.max(4, w * 0.05)
      ..strokeCap = StrokeCap.round;
    for (final r in [left, right]) {
      canvas.drawLine(r.topLeft.translate(r.width * 0.04, 0),
          r.topRight.translate(-r.width * 0.04, 0), bar);
    }
  }
  // Bridge and temple stubs.
  final bridgeY = cy - lensH * 0.18;
  canvas.drawPath(
      Path()
        ..moveTo(left.right, bridgeY)
        ..quadraticBezierTo(rect.center.dx, bridgeY - lensH * 0.16, right.left, bridgeY),
      stroke);
  canvas.drawLine(Offset(left.left, cy - lensH * 0.3),
      Offset(left.left - w * 0.07, cy - lensH * 0.36), stroke);
  canvas.drawLine(Offset(right.right, cy - lensH * 0.3),
      Offset(right.right + w * 0.07, cy - lensH * 0.36), stroke);
}

class GlassesArt extends StatelessWidget {
  const GlassesArt({super.key, required this.style, this.color});

  final GlassesStyle style;
  final Color? color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _GlassesPainter(
            style, color ?? Theme.of(context).colorScheme.onSurface),
        size: Size.infinite,
      );
}

class _GlassesPainter extends CustomPainter {
  _GlassesPainter(this.style, this.color);
  final GlassesStyle style;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = math.min(size.width, size.height * 2.4) * 0.86;
    paintGlasses(
        canvas,
        Rect.fromCenter(center: size.center(Offset.zero), width: w, height: w * 0.42),
        style,
        color);
  }

  @override
  bool shouldRepaint(_GlassesPainter o) => o.style != style || o.color != color;
}

/// A smooth face silhouette with the given proportions (length/cheek,
/// forehead/cheek, jaw/cheek), fitted into [box].
Path faceSilhouette(Rect box, double lw, double fc, double jc) {
  final h = box.height * 0.92;
  final cheek = math.min(box.width * 0.9, h / lw);
  final length = cheek * lw;
  final top = box.center.dy - length / 2;
  final cx = box.center.dx;
  // Half-widths at relative heights down the face.
  final profile = <(double, double)>[
    (0.0, 0.0),
    (0.04, fc * 0.55),
    (0.12, fc),
    (0.40, 1.0),
    (0.62, (1 + jc) / 2),
    (0.80, jc),
    (0.93, jc * 0.55),
    (1.0, 0.0),
  ];
  final right = [
    for (final (f, wr) in profile) Offset(cx + wr * cheek / 2, top + f * length),
  ];
  final left = [
    for (final (f, wr) in profile.reversed) Offset(cx - wr * cheek / 2, top + f * length),
  ];
  return _smooth([...right, ...left.skip(1)]);
}

/// Closed Catmull-Rom spline through [p] (first == last point allowed).
Path _smooth(List<Offset> p) {
  final path = Path()..moveTo(p.first.dx, p.first.dy);
  final n = p.length;
  for (var i = 0; i < n - 1; i++) {
    final p0 = p[(i - 1 + n) % n], p1 = p[i], p2 = p[i + 1], p3 = p[(i + 2) % n];
    final c1 = p1 + (p2 - p0) / 6;
    final c2 = p2 - (p3 - p1) / 6;
    path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
  }
  return path..close();
}

/// Reference face shape with the user's measured proportions drawn over it.
/// The user's outline animates in, stroke by stroke.
class FaceShapeArt extends StatelessWidget {
  const FaceShapeArt({super.key, required this.shape, this.ratios});

  final FaceShape shape;
  final Map<FaceRatio, double>? ratios;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reduce = MediaQuery.disableAnimationsOf(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: reduce ? Duration.zero : const Duration(milliseconds: 1400),
      curve: Curves.easeInOutCubic,
      builder: (_, t, _) => CustomPaint(
        painter: _FaceShapePainter(
          shape: shape,
          ratios: ratios,
          t: t,
          reference: scheme.outline,
          mine: scheme.primary,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _FaceShapePainter extends CustomPainter {
  _FaceShapePainter({
    required this.shape,
    required this.ratios,
    required this.t,
    required this.reference,
    required this.mine,
  });

  final FaceShape shape;
  final Map<FaceRatio, double>? ratios;
  final double t;
  final Color reference;
  final Color mine;

  @override
  void paint(Canvas canvas, Size size) {
    final box = Offset.zero & size;
    final (lw, fc, jc) = FaceEngine.prototypes[shape]!;
    canvas.drawPath(
        faceSilhouette(box, lw, fc, jc),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = reference.withValues(alpha: 0.7));
    final r = ratios;
    if (r == null) return;
    final path = faceSilhouette(box, r[FaceRatio.lengthToWidth]!,
        r[FaceRatio.foreheadToCheek]!, r[FaceRatio.jawToCheek]!);
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..color = mine.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = mine;
    for (final m in path.computeMetrics()) {
      final part = m.extractPath(0, m.length * t);
      canvas.drawPath(part, glow);
      canvas.drawPath(part, line);
    }
  }

  @override
  bool shouldRepaint(_FaceShapePainter o) =>
      o.t != t || o.shape != shape || o.ratios != ratios;
}
