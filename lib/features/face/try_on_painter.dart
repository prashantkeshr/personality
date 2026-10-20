import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../ml/face/face_estimator.dart';
import '../../shared/visual/hair_art.dart';
import '../../shared/visual/style_art.dart';

/// Beard styles that can be previewed live.
enum BeardStyle { stubble, short, chin, fullSides }

BeardStyle? beardStyleFor(String itemId) => switch (itemId) {
      'stubble' => BeardStyle.stubble,
      'short_beard' => BeardStyle.short,
      'chin_beard' => BeardStyle.chin,
      'full_sides' => BeardStyle.fullSides,
      _ => null,
    };

/// Draws glasses on the eyes and/or a beard along the jaw, following the
/// live face. The beard is a shaded preview, not a photo-real render.
class TryOnPainter extends CustomPainter {
  TryOnPainter({
    required this.face,
    this.glasses,
    this.beard,
    this.hair,
    this.hairColor = const Color(0xFF3B2416),
    this.lipColor,
    this.blushColor,
    this.frameColor = const Color(0xFF1C1C1E),
    this.beardColor = const Color(0xFF2A1F17),
  });

  final HairShape? hair;
  final Color hairColor;

  /// Sheer tints, so the lips and skin show through.
  final Color? lipColor;
  final Color? blushColor;

  final FaceDetected? face;
  final GlassesStyle? glasses;
  final BeardStyle? beard;
  final Color frameColor;
  final Color beardColor;

  @override
  void paint(Canvas canvas, Size size) {
    final f = face;
    if (f == null) return;
    Offset at((double, double) p) {
      final x = p.$1 / f.imageWidth;
      return Offset((f.frontCamera ? 1 - x : x) * size.width,
          p.$2 / f.imageHeight * size.height);
    }

    if (blushColor != null &&
        f.leftEye != null &&
        f.rightEye != null &&
        f.noseBottom != null) {
      final a = at(f.leftEye!), b = at(f.rightEye!), nose = at(f.noseBottom!);
      final mid = (a + b) / 2;
      final d = (b - a).distance;
      for (final eye in [a, b]) {
        final out = eye + (eye - mid) * 0.32;
        final c = Offset(out.dx, (eye.dy + nose.dy) / 2 + d * 0.12);
        final r = d * 0.42;
        canvas.drawOval(
          Rect.fromCenter(center: c, width: r * 2.1, height: r * 1.5),
          Paint()
            ..shader = RadialGradient(colors: [
              blushColor!.withValues(alpha: 0.38),
              blushColor!.withValues(alpha: 0),
            ]).createShader(Rect.fromCircle(center: c, radius: r * 1.05)),
        );
      }
    }
    if (lipColor != null &&
        (f.upperLip?.length ?? 0) >= 3 &&
        (f.lowerLip?.length ?? 0) >= 3) {
      final pts = [
        for (final p in f.upperLip!) at(p),
        for (final p in f.lowerLip!.reversed) at(p),
      ];
      canvas.drawPath(
        Path()..addPolygon(pts, true),
        Paint()
          ..isAntiAlias = true
          ..color = lipColor!.withValues(alpha: 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
      );
    }
    if (hair != null && f.outline.length >= 20) {
      final pts = [for (final p in f.outline) at(p)];
      final face = Path()..addPolygon(pts, true);
      final b = face.getBounds();
      paintHair(
        canvas,
        HairFrame(centreX: b.center.dx, top: b.top, width: b.width, length: b.height),
        hair!,
        hairColor,
        face,
        opacity: 0.9,
      );
    }
    if (beard != null && f.upperLip != null && f.noseBottom != null) {
      _paintBeard(canvas, f, at);
    }
    if (glasses != null && f.leftEye != null && f.rightEye != null) {
      final a = at(f.leftEye!), b = at(f.rightEye!);
      final mid = (a + b) / 2;
      final d = (b - a).distance;
      var angle = math.atan2(b.dy - a.dy, b.dx - a.dx);
      // Keep the frame upright whichever eye is on the left on screen.
      if (angle.abs() > math.pi / 2) angle += math.pi;
      final w = d * 2.08;
      canvas.save();
      canvas.translate(mid.dx, mid.dy);
      canvas.rotate(angle);
      paintGlasses(canvas, Rect.fromCenter(center: Offset.zero, width: w, height: w * 0.42),
          glasses!, frameColor);
      canvas.restore();
    }
  }

  void _paintBeard(Canvas canvas, FaceDetected f, Offset Function((double, double)) at) {
    final outline = [for (final p in f.outline) at(p)];
    final lip = [for (final p in f.upperLip!) at(p)];
    final nose = at(f.noseBottom!);
    final lipTop = lip.map((p) => p.dy).reduce(math.min);
    final lowerLipY = f.lowerLip == null
        ? lipTop
        : f.lowerLip!.map((p) => at(p).dy).reduce(math.max);

    // Region below a cut line: under the nose for full styles, under the
    // lower lip for a chin beard.
    final cutY = switch (beard!) {
      BeardStyle.chin => lowerLipY + (lowerLipY - lipTop) * 0.2,
      BeardStyle.fullSides => nose.dy - (lipTop - nose.dy) * 0.6,
      _ => (nose.dy + lipTop) / 2,
    };
    final below = outline.where((p) => p.dy > cutY).toList();
    if (below.length < 3) return;
    // Order points around the jaw from one side to the other.
    final cx = outline.map((p) => p.dx).reduce((a, b) => a + b) / outline.length;
    below.sort((p, q) => math
        .atan2(p.dy - cutY, p.dx - cx)
        .compareTo(math.atan2(q.dy - cutY, q.dx - cx)));
    var region = Path()..addPolygon(below, true);

    if (beard == BeardStyle.chin) {
      final width = (lip.last.dx - lip.first.dx).abs() * 1.5;
      region = Path.combine(
          PathOperation.intersect,
          region,
          Path()
            ..addRect(Rect.fromCenter(
                center: Offset(cx, cutY + 400), width: width, height: 800)));
    }
    // Leave the mouth clear.
    if (f.lowerLip != null) {
      final mouth = [...lip, ...[for (final p in f.lowerLip!) at(p)].reversed];
      region = Path.combine(
          PathOperation.difference, region, Path()..addPolygon(mouth, true));
    }

    final density = switch (beard!) {
      BeardStyle.stubble => 0.22,
      BeardStyle.short => 0.5,
      BeardStyle.chin => 0.55,
      BeardStyle.fullSides => 0.58,
    };
    canvas.save();
    canvas.clipPath(region);
    final bounds = region.getBounds();
    // Soft base tone, then short hair strokes for texture.
    canvas.drawRect(
        bounds,
        Paint()
          ..color = beardColor.withValues(alpha: density * 0.55)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    final rnd = math.Random(7);
    final hair = Paint()
      ..color = beardColor.withValues(alpha: density)
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round;
    final count = (bounds.width * bounds.height / 28 * density).clamp(0, 1800).toInt();
    for (var i = 0; i < count; i++) {
      final p = Offset(bounds.left + rnd.nextDouble() * bounds.width,
          bounds.top + rnd.nextDouble() * bounds.height);
      final len = 2 + rnd.nextDouble() * (beard == BeardStyle.stubble ? 1.5 : 4);
      final ang = math.pi / 2 + (p.dx - cx) / bounds.width * 0.9 + (rnd.nextDouble() - 0.5) * 0.6;
      canvas.drawLine(p, p + Offset(math.cos(ang), math.sin(ang)) * len, hair);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(TryOnPainter o) =>
      o.face != face ||
      o.glasses != glasses ||
      o.beard != beard ||
      o.hair != hair ||
      o.hairColor != hairColor ||
      o.lipColor != lipColor ||
      o.blushColor != blushColor;
}
