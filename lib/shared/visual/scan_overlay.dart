import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Viewfinder corners, a sweeping scan line and an optional capture-progress
/// ring, drawn over a live camera preview. With the OS "reduce motion"
/// setting on, only the static corners and progress are shown.
class ScanOverlay extends StatefulWidget {
  const ScanOverlay({
    super.key,
    required this.color,
    this.scanning = true,
    this.progress,
    this.oval = false,
  });

  final Color color;

  /// Animate the sweeping scan line.
  final bool scanning;

  /// Capture progress 0–1, drawn as a ring around the guide; null hides it.
  final double? progress;

  /// Face mode: an oval guide instead of a full-frame viewfinder.
  final bool oval;

  @override
  State<ScanOverlay> createState() => _ScanOverlayState();
}

class _ScanOverlayState extends State<ScanOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2200));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(ScanOverlay old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    final animate =
        widget.scanning && !MediaQuery.disableAnimationsOf(context);
    if (animate && !_c.isAnimating) {
      _c.repeat();
    } else if (!animate && _c.isAnimating) {
      _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _c,
            builder: (_, _) => CustomPaint(
              painter: _ScanPainter(
                t: _c.value,
                animate: _c.isAnimating,
                color: widget.color,
                progress: widget.progress,
                oval: widget.oval,
              ),
              size: Size.infinite,
            ),
          ),
        ),
      );
}

class _ScanPainter extends CustomPainter {
  _ScanPainter({
    required this.t,
    required this.animate,
    required this.color,
    required this.progress,
    required this.oval,
  });

  final double t;
  final bool animate;
  final Color color;
  final double? progress;
  final bool oval;

  Rect _guide(Size s) => oval
      ? Rect.fromCenter(
          center: Offset(s.width / 2, s.height * 0.45),
          width: s.width * 0.62,
          height: s.height * 0.62)
      : Rect.fromLTWH(s.width * 0.06, s.height * 0.04, s.width * 0.88,
          s.height * 0.92);

  @override
  void paint(Canvas canvas, Size size) {
    final r = _guide(size);

    // Viewfinder corners.
    final corner = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final l = math.min(r.width, r.height) * 0.12;
    for (final (o, dx, dy) in [
      (r.topLeft, 1.0, 1.0),
      (r.topRight, -1.0, 1.0),
      (r.bottomLeft, 1.0, -1.0),
      (r.bottomRight, -1.0, -1.0),
    ]) {
      canvas.drawLine(o, o + Offset(l * dx, 0), corner);
      canvas.drawLine(o, o + Offset(0, l * dy), corner);
    }

    // Sweeping scan line with a soft trailing glow, clipped to the guide.
    if (animate) {
      canvas.save();
      canvas.clipPath(oval
          ? (Path()..addOval(r))
          : (Path()..addRRect(RRect.fromRectAndRadius(r, const Radius.circular(16)))));
      // Ease in and out so the line lingers at the ends.
      final p = 0.5 - 0.5 * math.cos(t * 2 * math.pi);
      final y = r.top + r.height * p;
      final down = t < 0.5;
      final trail = r.height * 0.18;
      final band = Rect.fromLTRB(
          r.left, down ? y - trail : y, r.right, down ? y : y + trail);
      canvas.drawRect(
        band,
        Paint()
          ..shader = LinearGradient(
            begin: down ? Alignment.topCenter : Alignment.bottomCenter,
            end: down ? Alignment.bottomCenter : Alignment.topCenter,
            colors: [color.withValues(alpha: 0), color.withValues(alpha: 0.28)],
          ).createShader(band),
      );
      canvas.drawLine(
        Offset(r.left, y),
        Offset(r.right, y),
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 3),
      );
      canvas.restore();
    }

    // Capture progress ring.
    final pr = progress;
    if (pr != null) {
      final ring = r.inflate(6);
      final bg = Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke;
      final fg = Paint()
        ..color = color
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      if (oval) {
        canvas.drawOval(ring, bg);
        canvas.drawArc(ring, -math.pi / 2, 2 * math.pi * pr, false, fg);
      } else {
        final rr = RRect.fromRectAndRadius(ring, const Radius.circular(18));
        canvas.drawRRect(rr, bg);
        final path = Path()..addRRect(rr);
        for (final m in path.computeMetrics()) {
          canvas.drawPath(m.extractPath(0, m.length * pr), fg);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_ScanPainter o) =>
      o.t != t || o.progress != progress || o.animate != animate;
}
