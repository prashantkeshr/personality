import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/entities/motion.dart';

/// Segment lengths as fractions of standing height.
abstract final class _Body {
  static const head = 0.062;
  static const neck = 0.035;
  static const torso = 0.30;
  static const upperArm = 0.155;
  static const forearm = 0.15;
  static const thigh = 0.235;
  static const shin = 0.235;
  static const foot = 0.065;
  static const shoulderHalf = 0.095; // front view
  static const hipHalf = 0.06;
  static const limb = 0.05; // stroke widths
  static const lowerLimb = 0.042;
  static const torsoWidth = 0.1;
}

/// Joint positions in world units (y up, floor at y = 0).
class BodySkeleton {
  BodySkeleton({
    required this.hip,
    required this.hips,
    required this.shoulders,
    required this.neckBase,
    required this.headCenter,
    required this.headDir,
    required this.elbows,
    required this.hands,
    required this.knees,
    required this.ankles,
    required this.toes,
  });

  final Offset hip;
  final (Offset, Offset) hips;
  final (Offset, Offset) shoulders;
  final Offset neckBase;
  final Offset headCenter;
  final Offset headDir;
  final (Offset, Offset) elbows;
  final (Offset, Offset) hands;
  final (Offset, Offset) knees;
  final (Offset, Offset) ankles;
  final (Offset, Offset)? toes;

  Iterable<Offset> get points sync* {
    yield hip;
    yield neckBase;
    yield headCenter + const Offset(0, _Body.head);
    yield headCenter - const Offset(0, _Body.head);
    yield headCenter + const Offset(_Body.head, 0);
    yield headCenter - const Offset(_Body.head, 0);
    for (final p in [shoulders, hips, elbows, hands, knees, ankles, ?toes]) {
      yield p.$1;
      yield p.$2;
    }
  }

  BodySkeleton shift(Offset d) => BodySkeleton(
        hip: hip + d,
        hips: (hips.$1 + d, hips.$2 + d),
        shoulders: (shoulders.$1 + d, shoulders.$2 + d),
        neckBase: neckBase + d,
        headCenter: headCenter + d,
        headDir: headDir,
        elbows: (elbows.$1 + d, elbows.$2 + d),
        hands: (hands.$1 + d, hands.$2 + d),
        knees: (knees.$1 + d, knees.$2 + d),
        ankles: (ankles.$1 + d, ankles.$2 + d),
        toes: toes == null ? null : (toes!.$1 + d, toes!.$2 + d),
      );

  static double _r(double deg) => deg * math.pi / 180;

  /// Limb direction: 0 = down, +90 = forward (or outward on [side] -1/+1).
  static Offset _limb(double deg, [double side = 1]) =>
      Offset(side * math.sin(_r(deg)), -math.cos(_r(deg)));

  /// Trunk direction: 0 = up, + = forward.
  static Offset _up(double deg) => Offset(math.sin(_r(deg)), math.cos(_r(deg)));

  /// Forward kinematics, then sits the lowest point on the floor.
  factory BodySkeleton.of(BodyPose p, MotionView view) {
    final front = view == MotionView.front;
    const hip = Offset.zero;
    final up = _up(p.torso);
    final neckBase = hip + up * _Body.torso;
    final across = Offset(up.dy, -up.dx); // perpendicular, towards +x when upright
    final shoulders = front
        ? (neckBase + across * _Body.shoulderHalf, neckBase - across * _Body.shoulderHalf)
        : (neckBase, neckBase);
    final hips = front
        ? (hip + across * _Body.hipHalf, hip - across * _Body.hipHalf)
        : (hip, hip);
    final headDir = _up(p.torso + p.head);
    final headCenter = neckBase + headDir * (_Body.neck + _Body.head);
    // Front view: index 0 is the figure's left (viewer's right, +x).
    final s0 = front ? 1.0 : 1.0, s1 = front ? -1.0 : 1.0;
    final elbows = (
      shoulders.$1 + _limb(p.upperArm.$1, s0) * _Body.upperArm,
      shoulders.$2 + _limb(p.upperArm.$2, s1) * _Body.upperArm,
    );
    final hands = (
      elbows.$1 + _limb(p.forearm.$1, s0) * _Body.forearm,
      elbows.$2 + _limb(p.forearm.$2, s1) * _Body.forearm,
    );
    final knees = (
      hips.$1 + _limb(p.thigh.$1, s0) * _Body.thigh,
      hips.$2 + _limb(p.thigh.$2, s1) * _Body.thigh,
    );
    final ankles = (
      knees.$1 + _limb(p.shin.$1, s0) * _Body.shin,
      knees.$2 + _limb(p.shin.$2, s1) * _Body.shin,
    );
    final toes = front
        ? null
        : (
            ankles.$1 + _limb(p.shin.$1 + 90) * _Body.foot,
            ankles.$2 + _limb(p.shin.$2 + 90) * _Body.foot,
          );
    final raw = BodySkeleton(
      hip: hip,
      hips: hips,
      shoulders: shoulders,
      neckBase: neckBase,
      headCenter: headCenter,
      headDir: headDir,
      elbows: elbows,
      hands: hands,
      knees: knees,
      ankles: ankles,
      toes: toes,
    );
    final lowest = raw.points.map((o) => o.dy).reduce(math.min);
    return raw.shift(Offset(p.x, -lowest + _Body.limb / 2 + p.lift));
  }
}

/// The support a motion leans on (bench, box), placed from its first frame.
Rect? propRect(Motion m) {
  if (m.prop == null || m.isFace) return null;
  final s = BodySkeleton.of(m.frames.first.pose as BodyPose, m.view);
  const half = _Body.limb / 2;
  return switch (m.prop) {
    'box_hands' => Rect.fromLTRB(s.hands.$1.dx - 0.09, 0, s.hands.$1.dx + 0.07, s.hands.$1.dy - half),
    'box_feet' => Rect.fromLTRB(s.ankles.$1.dx - 0.06, 0, s.ankles.$1.dx + 0.12, s.ankles.$1.dy - half),
    'bench' => Rect.fromLTRB(math.min(s.hip.dx, s.neckBase.dx) - 0.04, 0,
        math.max(s.hip.dx, s.neckBase.dx) + 0.02, math.min(s.hip.dy, s.neckBase.dy) - _Body.torsoWidth / 2),
    _ => null,
  };
}

/// World-space box that holds every frame of a motion, so the figure
/// doesn't jump around while it moves.
Rect motionBounds(Motion m) {
  if (m.isFace) return const Rect.fromLTWH(0, 0, 1, 1.15);
  var r = Rect.zero;
  var first = true;
  final n = math.max(12, m.frames.length * 8);
  for (var i = 0; i < n; i++) {
    final pose = m.poseAt((m.cycleMs * i / n).round()) as BodyPose;
    for (final p in BodySkeleton.of(pose, m.view).points) {
      final box = Rect.fromCenter(center: p, width: _Body.limb, height: _Body.limb);
      r = first ? box : r.expandToInclude(box);
      first = false;
    }
  }
  final prop = propRect(m);
  if (prop != null) r = r.expandToInclude(prop);
  // Always include the floor and a minimum width so small moves stay small.
  r = r.expandToInclude(Rect.fromLTRB(r.center.dx - 0.25, 0, r.center.dx + 0.25, 0.6));
  return r;
}

class FigureColors {
  const FigureColors({required this.body, required this.far, required this.floor, required this.accent,
      required this.skin, required this.ink});

  factory FigureColors.of(ColorScheme s) => FigureColors(
        body: s.primary,
        far: Color.lerp(s.primary, s.surface, 0.45)!,
        floor: s.outlineVariant,
        accent: s.tertiary,
        skin: Color.lerp(s.primaryContainer, s.surface, 0.2)!,
        ink: s.onPrimaryContainer,
      );

  final Color body;
  final Color far;
  final Color floor;
  final Color accent;
  final Color skin;
  final Color ink;
}

/// Paints one pose of a motion, fitted into the canvas.
class FigurePainter extends CustomPainter {
  FigurePainter(
      {required this.pose, required this.view, required this.bounds, required this.colors, this.prop});

  final Object pose;
  final MotionView view;
  final Rect bounds;
  final FigureColors colors;

  /// World-space support to draw behind the figure.
  final Rect? prop;

  @override
  void paint(Canvas canvas, Size size) {
    switch (pose) {
      case final BodyPose p:
        _paintBody(canvas, size, BodySkeleton.of(p, view), p.lift);
      case final FacePose f:
        view == MotionView.profile ? _paintProfile(canvas, size, f) : _paintFace(canvas, size, f);
    }
  }

  // ------------------------------------------------------------------ body

  void _paintBody(Canvas canvas, Size size, BodySkeleton s, double lift) {
    const pad = 0.08;
    final b = bounds.inflate(bounds.longestSide * pad);
    final scale = math.min(size.width / b.width, size.height / b.height);
    final dx = (size.width - b.width * scale) / 2;
    final dy = (size.height - b.height * scale) / 2;
    Offset map(Offset w) => Offset(dx + (w.dx - b.left) * scale, size.height - dy - (w.dy - b.top) * scale);

    // Floor and a soft shadow that shrinks as the figure lifts.
    final floorY = map(Offset.zero).dy;
    canvas.drawLine(Offset(dx, floorY), Offset(size.width - dx, floorY),
        Paint()
          ..color = colors.floor
          ..strokeWidth = math.max(1, scale * 0.006));
    if (prop != null && prop!.height > 0.01) {
      final a = map(prop!.topLeft), b = map(prop!.bottomRight);
      canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromPoints(a, b), Radius.circular(scale * 0.012)),
          Paint()..color = colors.floor.withValues(alpha: 0.7));
    }
    final shadowW = scale * 0.3 * (1 - (lift * 2).clamp(0, 0.6));
    canvas.drawOval(
        Rect.fromCenter(center: Offset(map(s.hip).dx, floorY), width: shadowW, height: scale * 0.025),
        Paint()..color = colors.body.withValues(alpha: 0.12));

    Paint stroke(Color c, double w) => Paint()
      ..color = c
      ..strokeWidth = w * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    void limb(Offset a, Offset b, Offset c, Color col, {Offset? d}) {
      canvas.drawLine(map(a), map(b), stroke(col, _Body.limb));
      canvas.drawLine(map(b), map(c), stroke(col, _Body.lowerLimb));
      if (d != null) canvas.drawLine(map(c), map(d), stroke(col, _Body.lowerLimb * 0.8));
    }

    void hand(Offset h, Color col) =>
        canvas.drawCircle(map(h), _Body.lowerLimb * 0.62 * scale, Paint()..color = col);

    void head() {
      final c = map(s.headCenter);
      canvas.drawCircle(c, _Body.head * scale, Paint()..color = colors.body);
      if (view == MotionView.side) {
        // A small nose shows which way the figure faces.
        final fwd = Offset(s.headDir.dy, -s.headDir.dx); // perpendicular, forward
        final screenFwd = Offset(fwd.dx, -fwd.dy);
        final tip = c + screenFwd * (_Body.head * 1.28 * scale);
        final up = Offset(-screenFwd.dy, screenFwd.dx) * (_Body.head * 0.32 * scale);
        canvas.drawPath(
            Path()
              ..moveTo(c.dx + screenFwd.dx * _Body.head * 0.8 * scale + up.dx,
                  c.dy + screenFwd.dy * _Body.head * 0.8 * scale + up.dy)
              ..lineTo(tip.dx, tip.dy)
              ..lineTo(c.dx + screenFwd.dx * _Body.head * 0.8 * scale - up.dx,
                  c.dy + screenFwd.dy * _Body.head * 0.8 * scale - up.dy)
              ..close(),
            Paint()..color = colors.body);
      }
    }

    void torso() {
      if (view == MotionView.front) {
        final path = Path()
          ..moveTo(map(s.shoulders.$1).dx, map(s.shoulders.$1).dy)
          ..lineTo(map(s.shoulders.$2).dx, map(s.shoulders.$2).dy)
          ..lineTo(map(s.hips.$2).dx, map(s.hips.$2).dy)
          ..lineTo(map(s.hips.$1).dx, map(s.hips.$1).dy)
          ..close();
        canvas.drawPath(path, stroke(colors.body, _Body.limb));
        canvas.drawPath(path, Paint()..color = colors.body);
      } else {
        canvas.drawLine(map(s.hip), map(s.neckBase), stroke(colors.body, _Body.torsoWidth));
      }
      canvas.drawLine(map(s.neckBase), map(s.headCenter), stroke(colors.body, _Body.lowerLimb));
    }

    final t = s.toes;
    if (view == MotionView.side) {
      limb(s.shoulders.$2, s.elbows.$2, s.hands.$2, colors.far);
      hand(s.hands.$2, colors.far);
      limb(s.hips.$2, s.knees.$2, s.ankles.$2, colors.far, d: t?.$2);
      torso();
      head();
      limb(s.hips.$1, s.knees.$1, s.ankles.$1, colors.body, d: t?.$1);
      limb(s.shoulders.$1, s.elbows.$1, s.hands.$1, colors.body);
      hand(s.hands.$1, colors.body);
    } else {
      limb(s.hips.$1, s.knees.$1, s.ankles.$1, colors.body);
      limb(s.hips.$2, s.knees.$2, s.ankles.$2, colors.body);
      torso();
      limb(s.shoulders.$1, s.elbows.$1, s.hands.$1, colors.body);
      limb(s.shoulders.$2, s.elbows.$2, s.hands.$2, colors.body);
      hand(s.hands.$1, colors.body);
      hand(s.hands.$2, colors.body);
      head();
    }
  }

  // ------------------------------------------------------------------ face

  /// Head-and-shoulders, facing the viewer.
  void _paintFace(Canvas canvas, Size size, FacePose f) {
    final scale = math.min(size.width, size.height / 1.15);
    canvas.save();
    canvas.translate((size.width - scale) / 2, (size.height - scale * 1.15) / 2);
    canvas.scale(scale);

    final fill = Paint()..color = colors.skin;
    final line = Paint()
      ..color = colors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.012
      ..strokeCap = StrokeCap.round;

    // Shoulders.
    canvas.drawPath(
        Path()
          ..moveTo(0.08, 1.15)
          ..quadraticBezierTo(0.1, 0.9, 0.38, 0.86)
          ..lineTo(0.62, 0.86)
          ..quadraticBezierTo(0.9, 0.9, 0.92, 1.15)
          ..close(),
        Paint()..color = colors.body);

    // Everything above the neck base turns with the head.
    canvas.translate(0.5, 0.88);
    canvas.rotate(-f.tilt * math.pi / 180);
    canvas.translate(-0.5, -0.88);
    canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(0.42, 0.6, 0.16, 0.3), const Radius.circular(0.06)),
        fill);

    final nodY = f.nod / 30 * 0.04;
    final shiftX = f.turn * 0.07;
    final cx = 0.5, cy = 0.42 + nodY * 0.5;
    final cheekW = f.cheeks * 0.035;
    final jawDrop = f.jaw * 0.07;
    final chinX = cx + f.jawSide * 0.035 + shiftX * 0.4;
    final head = Path()
      ..moveTo(cx, cy - 0.3)
      ..cubicTo(cx + 0.2, cy - 0.3, cx + 0.25 + cheekW, cy - 0.12, cx + 0.23 + cheekW, cy + 0.04)
      ..cubicTo(cx + 0.21 + cheekW, cy + 0.2, chinX + 0.1, cy + 0.27 + jawDrop, chinX, cy + 0.28 + jawDrop)
      ..cubicTo(chinX - 0.1, cy + 0.27 + jawDrop, cx - 0.21 - cheekW, cy + 0.2, cx - 0.23 - cheekW, cy + 0.04)
      ..cubicTo(cx - 0.25 - cheekW, cy - 0.12, cx - 0.2, cy - 0.3, cx, cy - 0.3)
      ..close();
    canvas.drawPath(head, fill);
    canvas.drawPath(head, line..color = colors.ink.withValues(alpha: 0.35));
    line.color = colors.ink;

    // Hair cap keeps it from looking like a mask.
    canvas.save();
    canvas.clipPath(head);
    canvas.drawRect(Rect.fromLTWH(0, cy - 0.32, 1, 0.1 - f.nod / 30 * 0.02),
        Paint()..color = colors.body.withValues(alpha: 0.85));
    canvas.restore();

    final fx = cx + shiftX;
    final eyeY = cy - 0.02 + nodY;
    for (final side in [-1.0, 1.0]) {
      final near = 1 - (f.turn * side).clamp(0, 1) * 0.35;
      final ex = fx + side * 0.09 * near;
      final h = 0.036 * f.eyes.clamp(0, 1);
      if (h > 0.006) {
        canvas.drawOval(Rect.fromCenter(center: Offset(ex, eyeY), width: 0.055 * near, height: h),
            Paint()..color = colors.ink);
      } else {
        canvas.drawLine(Offset(ex - 0.028 * near, eyeY), Offset(ex + 0.028 * near, eyeY), line);
      }
      final by = eyeY - 0.065 - f.brows * 0.025;
      canvas.drawPath(
          Path()
            ..moveTo(ex - 0.04 * near, by + 0.008)
            ..quadraticBezierTo(ex, by - 0.012 - f.brows * 0.01, ex + 0.04 * near, by + 0.008),
          line);
      if (f.cheeks > 0.05 || f.smile > 0.3) {
        canvas.drawOval(
            Rect.fromCenter(center: Offset(fx + side * 0.13, cy + 0.1), width: 0.08, height: 0.045),
            Paint()..color = colors.accent.withValues(alpha: 0.18 * math.max(f.cheeks, f.smile)));
      }
    }
    // Nose.
    canvas.drawPath(
        Path()
          ..moveTo(fx, eyeY + 0.03)
          ..quadraticBezierTo(fx + 0.025 + f.turn * 0.02, eyeY + 0.09, fx, eyeY + 0.1),
        line..color = colors.ink.withValues(alpha: 0.6));
    line.color = colors.ink;

    // Mouth.
    final mx = fx + f.jawSide * 0.03;
    final my = cy + 0.15 + nodY + jawDrop * 0.45;
    final w = 0.075 * (1 - f.lips * 0.5) + f.smile.clamp(0, 1) * 0.02;
    final open = f.jaw * 0.09 + f.lips * 0.012;
    final curve = f.smile * 0.03;
    if (open > 0.01) {
      final mouth = Path()
        ..moveTo(mx - w, my)
        ..quadraticBezierTo(mx, my - open * 0.35 + curve * 0.3, mx + w, my)
        ..quadraticBezierTo(mx, my + open + curve, mx - w, my)
        ..close();
      canvas.drawPath(mouth, Paint()..color = colors.ink);
      if (f.tongue > 0.3 && f.jaw > 0.2) {
        canvas.save();
        canvas.clipPath(mouth);
        canvas.drawOval(
            Rect.fromCenter(center: Offset(mx, my - open * 0.1 + (1 - f.tongue) * open * 0.6),
                width: w * 1.3, height: open * 0.7),
            Paint()..color = colors.accent);
        canvas.restore();
      }
    } else {
      canvas.drawPath(
          Path()
            ..moveTo(mx - w, my - curve * 0.5)
            ..quadraticBezierTo(mx, my + curve, mx + w, my - curve * 0.5),
          line);
    }
    canvas.restore();
  }

  /// Side profile for chin tucks, nods and tongue posture.
  void _paintProfile(Canvas canvas, Size size, FacePose f) {
    final scale = math.min(size.width, size.height / 1.15);
    canvas.save();
    canvas.translate((size.width - scale) / 2, (size.height - scale * 1.15) / 2);
    canvas.scale(scale);
    final fill = Paint()..color = colors.skin;
    final ink = Paint()
      ..color = colors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.012
      ..strokeCap = StrokeCap.round;

    // Shoulders and upper back.
    canvas.drawPath(
        Path()
          ..moveTo(0.18, 1.15)
          ..quadraticBezierTo(0.2, 0.9, 0.4, 0.86)
          ..lineTo(0.62, 0.88)
          ..quadraticBezierTo(0.78, 0.95, 0.8, 1.15)
          ..close(),
        Paint()..color = colors.body);

    // Neck pivots at its base; a chin tuck glides the head straight back.
    final glide = -f.chin * 0.07;
    canvas.translate(0.5, 0.9);
    canvas.rotate((f.nod + f.chin * 6) * math.pi / 180);
    canvas.translate(-0.5 + glide, -0.9);
    canvas.drawPath(
        Path()
          ..moveTo(0.4 - glide, 0.92)
          ..lineTo(0.43, 0.62)
          ..lineTo(0.6, 0.62)
          ..lineTo(0.62 - glide * 0.5, 0.92)
          ..close(),
        fill);

    final jaw = f.jaw * 0.06;
    final lips = f.lips * 0.025;
    final head = Path()
      ..moveTo(0.36, 0.62)
      ..cubicTo(0.2, 0.5, 0.22, 0.14, 0.48, 0.12)
      ..cubicTo(0.66, 0.11, 0.73, 0.22, 0.73, 0.32)
      ..lineTo(0.79, 0.42) // nose tip
      ..lineTo(0.73, 0.45)
      ..lineTo(0.745 + lips, 0.5) // upper lip
      ..lineTo(0.725, 0.52 + jaw * 0.5)
      ..lineTo(0.74 + lips - jaw * 0.2, 0.54 + jaw) // lower lip
      ..cubicTo(0.73 - jaw * 0.2, 0.6 + jaw, 0.7 - jaw * 0.2, 0.63 + jaw, 0.6, 0.63 + jaw * 0.6)
      ..lineTo(0.5, 0.64)
      ..close();
    canvas.drawPath(head, fill);
    canvas.drawPath(head, ink..color = colors.ink.withValues(alpha: 0.35));
    ink.color = colors.ink;
    canvas.save();
    canvas.clipPath(head);
    canvas.drawPath(
        Path()
          ..moveTo(0.2, 0.42)
          ..cubicTo(0.2, 0.05, 0.75, 0.0, 0.74, 0.25)
          ..lineTo(0.5, 0.2)
          ..cubicTo(0.4, 0.22, 0.36, 0.34, 0.38, 0.5)
          ..close(),
        Paint()..color = colors.body.withValues(alpha: 0.85));
    canvas.restore();
    // Eye and ear.
    canvas.drawCircle(const Offset(0.66, 0.31), 0.016 * f.eyes.clamp(0.3, 1), Paint()..color = colors.ink);
    canvas.drawOval(Rect.fromCenter(center: const Offset(0.47, 0.36), width: 0.05, height: 0.08),
        ink..color = colors.ink.withValues(alpha: 0.5));
    ink.color = colors.ink;
    // Tongue posture: a see-through outline inside the mouth.
    if (f.tongue > 0.05) {
      final rise = f.tongue * 0.045;
      canvas.drawPath(
          Path()
            ..moveTo(0.56, 0.55)
            ..quadraticBezierTo(0.63, 0.52 - rise, 0.72, 0.5 - rise * 0.2),
          Paint()
            ..color = colors.accent
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.022
            ..strokeCap = StrokeCap.round);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(FigurePainter old) =>
      old.pose != pose || old.view != view || old.bounds != bounds || old.colors != colors;
}
