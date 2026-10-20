import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/services/face_engine.dart' show FaceShape;
import 'style_art.dart' show faceSilhouette;

/// Hair silhouettes for previews and live try-on. Stylised shapes, not
/// photo-real renders: enough to compare length, height and fringe.
enum HairShape {
  buzz,
  fade,
  crew,
  crop,
  frenchCrop,
  sidePart,
  quiff,
  pompadour,
  slickBack,
  curlyTop,
  longTop,
  texturedFringe,
  manBun,
  afro,
  pixie,
  bob,
  lob,
  wavyLob,
  shoulder,
  longStraight,
  longLayers,
  waves,
  curlyLong,
  sideFringe,
  curtain,
  bluntBangs,
  shag,
  wolfCut,
  ponytail,
  bun,
  braid;

  static HairShape? fromName(String? n) => values.asNameMap()[n];
}

enum HairTexture { smooth, textured, wavy, curly, coily }

enum HairExtra { none, bun, manBun, ponytail, braid }

/// Proportions of a hair shape, relative to the face: [crown] above the
/// top of the face outline and [sides] down from it, both in face lengths;
/// [volume] widens past the face; [fringe] covers the forehead; [sweep]
/// tilts the fringe (negative to the viewer's left).
class HairSpec {
  const HairSpec({
    required this.crown,
    required this.volume,
    required this.sides,
    this.fringe = 0.03,
    this.sweep = 0,
    this.flare = 0,
    this.texture = HairTexture.smooth,
    this.extra = HairExtra.none,
    this.centrePart = false,
  });

  final double crown;
  final double volume;
  final double sides;
  final double fringe;
  final double sweep;

  /// Extra width at the ends, for waves and curls.
  final double flare;
  final HairTexture texture;
  final HairExtra extra;

  /// Fringe parted in the middle (curtain bangs).
  final bool centrePart;
}

HairSpec hairSpec(HairShape s) => switch (s) {
  HairShape.buzz => const HairSpec(crown: .03, volume: .02, sides: .30, fringe: .02),
  HairShape.fade => const HairSpec(crown: .06, volume: .0, sides: .26, fringe: .03),
  HairShape.crew => const HairSpec(crown: .08, volume: .04, sides: .30, fringe: .04, texture: HairTexture.textured),
  HairShape.crop => const HairSpec(crown: .10, volume: .05, sides: .30, fringe: .09, texture: HairTexture.textured),
  HairShape.frenchCrop => const HairSpec(crown: .09, volume: .05, sides: .30, fringe: .15, texture: HairTexture.textured),
  HairShape.sidePart => const HairSpec(crown: .12, volume: .07, sides: .34, fringe: .05, sweep: .06),
  HairShape.quiff => const HairSpec(crown: .24, volume: .06, sides: .32, fringe: .0, texture: HairTexture.textured),
  HairShape.pompadour => const HairSpec(crown: .31, volume: .07, sides: .32, fringe: .0),
  HairShape.slickBack => const HairSpec(crown: .14, volume: .04, sides: .34, fringe: .0),
  HairShape.curlyTop => const HairSpec(crown: .20, volume: .13, sides: .32, fringe: .07, texture: HairTexture.curly),
  HairShape.longTop => const HairSpec(crown: .16, volume: .06, sides: .30, fringe: .14, sweep: .10),
  HairShape.texturedFringe => const HairSpec(crown: .13, volume: .07, sides: .32, fringe: .13, sweep: .04, texture: HairTexture.textured),
  HairShape.manBun => const HairSpec(crown: .09, volume: .04, sides: .33, fringe: .02, extra: HairExtra.manBun),
  HairShape.afro => const HairSpec(crown: .42, volume: .55, sides: .78, fringe: .05, texture: HairTexture.coily),
  HairShape.pixie => const HairSpec(crown: .11, volume: .07, sides: .42, fringe: .14, sweep: .10, texture: HairTexture.textured),
  HairShape.bob => const HairSpec(crown: .12, volume: .18, sides: .98, fringe: .06, flare: .04),
  HairShape.lob => const HairSpec(crown: .12, volume: .16, sides: 1.25, fringe: .04, sweep: .03),
  HairShape.wavyLob => const HairSpec(crown: .14, volume: .22, sides: 1.22, fringe: .04, flare: .14, texture: HairTexture.wavy),
  HairShape.shoulder => const HairSpec(crown: .12, volume: .15, sides: 1.45, fringe: .04),
  HairShape.longStraight => const HairSpec(crown: .10, volume: .12, sides: 1.90, fringe: .03, centrePart: true),
  HairShape.longLayers => const HairSpec(crown: .14, volume: .20, sides: 1.80, fringe: .05, flare: .08, texture: HairTexture.textured),
  HairShape.waves => const HairSpec(crown: .14, volume: .25, sides: 1.60, fringe: .04, flare: .16, texture: HairTexture.wavy),
  HairShape.curlyLong => const HairSpec(crown: .22, volume: .40, sides: 1.60, fringe: .05, flare: .22, texture: HairTexture.curly),
  HairShape.sideFringe => const HairSpec(crown: .12, volume: .14, sides: 1.50, fringe: .17, sweep: .10),
  HairShape.curtain => const HairSpec(crown: .12, volume: .16, sides: 1.50, fringe: .13, centrePart: true),
  HairShape.bluntBangs => const HairSpec(crown: .12, volume: .15, sides: 1.60, fringe: .21),
  HairShape.shag => const HairSpec(crown: .17, volume: .26, sides: 1.30, fringe: .12, flare: .12, texture: HairTexture.textured),
  HairShape.wolfCut => const HairSpec(crown: .18, volume: .24, sides: 1.15, fringe: .11, flare: .06, texture: HairTexture.textured),
  HairShape.ponytail => const HairSpec(crown: .10, volume: .03, sides: .38, fringe: .02, extra: HairExtra.ponytail),
  HairShape.bun => const HairSpec(crown: .09, volume: .03, sides: .36, fringe: .02, extra: HairExtra.bun),
  HairShape.braid => const HairSpec(crown: .10, volume: .06, sides: .40, fringe: .03, extra: HairExtra.braid),
};

/// Where the face is: centre x, top of the face outline, cheek width and
/// face length, all in canvas units.
class HairFrame {
  const HairFrame({
    required this.centreX,
    required this.top,
    required this.width,
    required this.length,
  });
  final double centreX;
  final double top;
  final double width;
  final double length;

  double get bottom => top + length;
}

/// Natural hair colours offered in the try-on.
const hairColours = <Color>[
  Color(0xFF16110E), // black
  Color(0xFF3B2416), // dark brown
  Color(0xFF6A4128), // brown
  Color(0xFF8E3B1F), // auburn
  Color(0xFFC9A066), // blonde
  Color(0xFF9A9A9E), // grey
];

/// Closed Catmull-Rom spline through [p].
Path _smooth(List<Offset> p) {
  final path = Path()..moveTo(p.first.dx, p.first.dy);
  final n = p.length;
  for (var i = 0; i < n; i++) {
    final p0 = p[(i - 1 + n) % n], p1 = p[i], p2 = p[(i + 1) % n], p3 = p[(i + 2) % n];
    final c1 = p1 + (p2 - p0) / 6;
    final c2 = p2 - (p3 - p1) / 6;
    path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
  }
  return path..close();
}

/// The hair's outer silhouette (before the face is cut out).
Path _outer(HairFrame f, HairSpec s) {
  final half = f.width / 2;
  final w = half * (1 + s.volume);
  final crownY = f.top - s.crown * f.length;
  final sideY = f.top + s.sides * f.length;
  final long = s.sides > 1.0;
  final bottomW = w * (1 + s.flare);
  // Right half, from the crown down; mirrored for the left.
  final right = <Offset>[
    Offset(f.centreX, crownY),
    Offset(f.centreX + w * 0.5, crownY + (f.top - crownY) * 0.12 + f.length * 0.015),
    Offset(f.centreX + w * 0.86, crownY + (f.top - crownY) * 0.45 + f.length * 0.03),
    Offset(f.centreX + w * 1.0, f.top + 0.1 * f.length),
    if (long)
      Offset(f.centreX + w * 1.0, f.top + 0.45 * f.length)
    else
      Offset(f.centreX + w * 1.0, f.top + (s.sides - 0.08) * f.length),
    if (long) ...[
      Offset(f.centreX + (w + bottomW) / 2, f.top + (0.45 + s.sides) / 2 * f.length),
      Offset(f.centreX + bottomW, sideY - 0.05 * f.length),
      Offset(f.centreX + bottomW * 0.8, sideY),
      // Inner edge: hair falls behind the neck, leaving it visible.
      Offset(f.centreX + half * 0.42, sideY),
      Offset(f.centreX + half * 0.36, f.bottom + 0.08 * f.length),
    ] else
      Offset(f.centreX + half * 0.97, sideY + 0.02 * f.length),
  ];
  // The left half mirrors the right, walked back up to the crown.
  final left = [
    for (final p in right.skip(1).toList().reversed)
      Offset(2 * f.centreX - p.dx, p.dy),
  ];
  final pts = [...right, ...left];
  return _smooth(_textured(pts, f, s));
}

/// Bumpy edges for curls and waves.
List<Offset> _textured(List<Offset> pts, HairFrame f, HairSpec s) {
  final amp = switch (s.texture) {
    HairTexture.coily => 0.035,
    HairTexture.curly => 0.025,
    HairTexture.wavy => 0.014,
    HairTexture.textured => 0.008,
    HairTexture.smooth => 0.0,
  } * f.length;
  if (amp == 0) return pts;
  final out = <Offset>[];
  final c = Offset(f.centreX, f.top + f.length * 0.3);
  for (var i = 0; i < pts.length; i++) {
    final a = pts[i], b = pts[(i + 1) % pts.length];
    out.add(a);
    for (final t in [0.33, 0.66]) {
      final m = Offset.lerp(a, b, t)!;
      final dir = m - c;
      final n = dir.distance == 0 ? Offset.zero : dir / dir.distance;
      out.add(m + n * amp * (t == 0.33 ? 1 : -0.4));
    }
  }
  return out;
}

/// The part of the face hair must not cover: the face below the hairline.
Path _faceMask(HairFrame f, HairSpec s, Path face) {
  final y = f.top + s.fringe * f.length;
  final dy = s.sweep * f.length;
  final x0 = f.centreX - f.width, x1 = f.centreX + f.width;
  final below = Path();
  if (s.centrePart) {
    // A curtain fringe: longer at the temples, open in the middle.
    below
      ..moveTo(x0, y + f.length * 0.06)
      ..quadraticBezierTo(f.centreX, y - f.length * 0.1, x1, y + f.length * 0.06);
  } else {
    below
      ..moveTo(x0, y + dy)
      ..lineTo(x1, y - dy);
  }
  below
    ..lineTo(x1, f.bottom + f.length)
    ..lineTo(x0, f.bottom + f.length)
    ..close();
  return Path.combine(PathOperation.intersect, face, below);
}

/// Draws [shape] in [colour] around [face] (the face outline path).
void paintHair(
  Canvas canvas,
  HairFrame f,
  HairShape shape,
  Color colour,
  Path face, {
  double opacity = 0.94,
}) {
  final s = hairSpec(shape);
  var hair = _outer(f, s);
  final extras = _extras(f, s);
  if (extras != null) hair = Path.combine(PathOperation.union, hair, extras);
  hair = Path.combine(PathOperation.difference, hair, _faceMask(f, s, face));

  final bounds = hair.getBounds();
  final lighter = Color.lerp(colour, Colors.white, 0.22)!;
  canvas.drawPath(
    hair,
    Paint()
      ..isAntiAlias = true
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lighter.withValues(alpha: opacity),
          colour.withValues(alpha: opacity),
        ],
      ).createShader(bounds),
  );

  // Strands for texture, clipped to the hair.
  canvas.save();
  canvas.clipPath(hair);
  final strand = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = math.max(1, f.width * 0.012)
    ..color = Color.lerp(colour, Colors.white, 0.35)!.withValues(alpha: 0.35);
  final rnd = math.Random(shape.index);
  if (s.texture == HairTexture.curly || s.texture == HairTexture.coily) {
    for (var i = 0; i < 70; i++) {
      final p = Offset(
        bounds.left + rnd.nextDouble() * bounds.width,
        bounds.top + rnd.nextDouble() * bounds.height,
      );
      canvas.drawCircle(p, f.width * (0.02 + rnd.nextDouble() * 0.025), strand);
    }
  } else {
    final crown = Offset(f.centreX + s.sweep * f.width, bounds.top);
    for (var i = 0; i < 26; i++) {
      final end = Offset(
        bounds.left + rnd.nextDouble() * bounds.width,
        bounds.top + bounds.height * (0.25 + rnd.nextDouble() * 0.75),
      );
      final mid = Offset.lerp(crown, end, 0.5)! +
          Offset((rnd.nextDouble() - 0.5) * f.width * 0.2, 0);
      canvas.drawPath(
        Path()
          ..moveTo(crown.dx, crown.dy)
          ..quadraticBezierTo(mid.dx, mid.dy, end.dx, end.dy),
        strand,
      );
    }
  }
  canvas.restore();
}

Path? _extras(HairFrame f, HairSpec s) {
  final crownY = f.top - s.crown * f.length;
  switch (s.extra) {
    case HairExtra.none:
      return null;
    case HairExtra.bun:
      final r = f.length * 0.17;
      return Path()..addOval(Rect.fromCircle(center: Offset(f.centreX, crownY - r * 0.55), radius: r));
    case HairExtra.manBun:
      final r = f.length * 0.11;
      return Path()..addOval(Rect.fromCircle(center: Offset(f.centreX, crownY - r * 0.5), radius: r));
    case HairExtra.ponytail:
      final r = f.length * 0.13;
      final c = Offset(f.centreX + f.width * 0.52, f.top - f.length * 0.02);
      return Path()
        ..addOval(Rect.fromCircle(center: c, radius: r))
        ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(c.dx - r * 0.2, c.dy, r * 1.3, f.length * 1.1),
          Radius.circular(r),
        ));
    case HairExtra.braid:
      final path = Path();
      final r = f.width * 0.11;
      final x = f.centreX + f.width * 0.58;
      for (var i = 0; i < 9; i++) {
        final y = f.top + f.length * (0.15 + i * 0.13);
        path.addOval(Rect.fromCenter(center: Offset(x + (i.isEven ? r * .2 : -r * .2), y), width: r * 2, height: r * 1.7));
      }
      return path;
  }
}

/// A small illustration of a hairstyle on a neutral face, for style cards.
class HairArt extends StatelessWidget {
  const HairArt({
    super.key,
    required this.shape,
    this.faceShape = FaceShape.oval,
    this.colour = const Color(0xFF3B2416),
  });

  final HairShape shape;
  final FaceShape faceShape;
  final Color colour;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _HairArtPainter(
      shape,
      faceShape,
      colour,
      Theme.of(context).colorScheme.surface,
    ),
    child: const SizedBox.expand(),
  );
}

class _HairArtPainter extends CustomPainter {
  _HairArtPainter(this.shape, this.faceShape, this.colour, this.skin);
  final HairShape shape;
  final FaceShape faceShape;
  final Color colour;
  final Color skin;

  static const _ratios = <FaceShape, (double, double, double)>{
    FaceShape.oval: (1.30, 0.88, 0.78),
    FaceShape.round: (1.08, 0.90, 0.86),
    FaceShape.square: (1.12, 0.95, 0.93),
    FaceShape.oblong: (1.45, 0.90, 0.84),
    FaceShape.heart: (1.27, 0.97, 0.70),
    FaceShape.diamond: (1.27, 0.78, 0.74),
  };

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    final s = hairSpec(shape);
    // Leave room for tall and long styles.
    final faceH = size.height / (1.15 + s.crown + math.max(0, s.sides - 1) * 0.6);
    final (lw, fc, jc) = _ratios[faceShape]!;
    final top = size.height * 0.08 + s.crown * faceH +
        (s.extra == HairExtra.bun || s.extra == HairExtra.manBun ? faceH * 0.18 : 0);
    final box = Rect.fromCenter(
      center: Offset(size.width / 2, top + faceH / 2),
      width: size.width,
      height: faceH / 0.92,
    );
    final face = faceSilhouette(box, lw, fc, jc);
    final b = face.getBounds();
    final frame = HairFrame(centreX: b.center.dx, top: b.top, width: b.width, length: b.height);
    // Neck and shoulders, then the face, then hair.
    final body = Paint()..color = Color.lerp(skin, colour, 0.12)!;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(frame.centreX, frame.bottom + frame.length * 0.2), width: frame.width * 0.42, height: frame.length * 0.4),
      body,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(frame.centreX, frame.bottom + frame.length * 0.62), width: frame.width * 2.2, height: frame.length * 0.6),
      body,
    );
    canvas.drawPath(face, Paint()..color = Color.lerp(skin, colour, 0.06)!);
    paintHair(canvas, frame, shape, colour, face, opacity: 1);
  }

  @override
  bool shouldRepaint(_HairArtPainter o) =>
      o.shape != shape || o.faceShape != faceShape || o.colour != colour || o.skin != skin;
}
