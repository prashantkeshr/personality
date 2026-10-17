import 'package:flutter/material.dart';

import '../../domain/services/outfit_engine.dart';

/// `#RRGGBB` to a Flutter colour.
Color hexColor(String hex) => Color(0xFF000000 | int.parse(hex.substring(1), radix: 16));

/// An outfit drawn on a neutral mannequin, front view: each garment in its
/// own colour and pattern, layered the way it's worn.
class OutfitSilhouette extends StatelessWidget {
  const OutfitSilhouette({super.key, required this.items, this.womenswear = false});

  final List<WardrobeItem> items;
  final bool womenswear;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      image: true,
      label: items.map((i) => i.name).join(', '),
      child: CustomPaint(
        painter: OutfitSilhouettePainter(
          items: items,
          womenswear: womenswear,
          body: scheme.surfaceContainerHighest,
          outline: scheme.outlineVariant,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class OutfitSilhouettePainter extends CustomPainter {
  OutfitSilhouettePainter({required this.items, required this.womenswear, required this.body, required this.outline});

  final List<WardrobeItem> items;
  final bool womenswear;
  final Color body;
  final Color outline;

  static const _h = 2.1; // figure height in units of its width

  WardrobeItem? _first(Set<GarmentCategory> cats) => items.where((i) => cats.contains(i.category)).firstOrNull;

  @override
  void paint(Canvas canvas, Size size) {
    final s = (size.height / _h).clamp(0.0, size.width);
    canvas.save();
    canvas.translate((size.width - s) / 2, (size.height - s * _h) / 2);
    canvas.scale(s);

    final waist = womenswear ? 0.13 : 0.15;
    final torso = Path()
      ..moveTo(0.31, 0.36)
      ..lineTo(0.69, 0.36)
      ..quadraticBezierTo(0.5 + waist + 0.02, 0.62, 0.5 + waist + 0.01, 0.98)
      ..lineTo(0.5 - waist - 0.01, 0.98)
      ..quadraticBezierTo(0.5 - waist - 0.02, 0.62, 0.31, 0.36)
      ..close();
    Path arm(double side, double to) => Path()
      ..moveTo(0.5 + side * 0.19, 0.37)
      ..lineTo(0.5 + side * 0.25, 0.37 + (to - 0.37) * 0.15)
      ..lineTo(0.5 + side * 0.29, to)
      ..lineTo(0.5 + side * 0.23, to)
      ..lineTo(0.5 + side * 0.18, 0.5)
      ..close();
    Path leg(double side, double to) => Path()
      ..moveTo(0.5 + side * 0.005, 0.96)
      ..lineTo(0.5 + side * 0.15, 0.96)
      ..lineTo(0.5 + side * 0.12, to)
      ..lineTo(0.5 + side * 0.03, to)
      ..close();

    final base = Paint()..color = body;
    final edge = Paint()
      ..color = outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.006;

    // Mannequin.
    canvas.drawCircle(const Offset(0.5, 0.2), 0.085, base);
    canvas.drawRect(const Rect.fromLTWH(0.465, 0.27, 0.07, 0.1), base);
    for (final p in [torso, arm(-1, 0.98), arm(1, 0.98), leg(-1, 1.98), leg(1, 1.98)]) {
      canvas.drawPath(p, base);
      canvas.drawPath(p, edge);
    }

    void garment(Path p, WardrobeItem item) {
      canvas.drawPath(p, Paint()..color = hexColor(item.colorHex));
      _pattern(canvas, p, item);
      canvas.drawPath(p, Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.006);
    }

    final dress = _first({GarmentCategory.onePiece});
    final bottom = _first({GarmentCategory.bottom});
    final ethnicBottom = _first({GarmentCategory.ethnicBottom});
    final top = _first({GarmentCategory.top});
    final ethnicTop = _first({GarmentCategory.ethnicTop});
    final outer = _first({GarmentCategory.outerwear});
    final shoes = _first({GarmentCategory.footwear});
    final accessory = _first({GarmentCategory.accessory});

    if (ethnicBottom != null) {
      // Loose, gathered at the ankle (salwar, churidar, dhoti-style).
      garment(
          Path()
            ..moveTo(0.33, 0.94)
            ..lineTo(0.67, 0.94)
            ..quadraticBezierTo(0.72, 1.5, 0.63, 1.92)
            ..lineTo(0.37, 1.92)
            ..quadraticBezierTo(0.28, 1.5, 0.33, 0.94)
            ..close(),
          ethnicBottom);
    } else if (bottom != null) {
      final p = Path()
        ..addPath(leg(-1, 1.9), Offset.zero)
        ..addPath(leg(1, 1.9), Offset.zero)
        ..addRect(const Rect.fromLTRB(0.34, 0.94, 0.66, 1.1));
      garment(p, bottom);
    }
    if (dress != null) {
      garment(
          Path()
            ..moveTo(0.31, 0.36)
            ..lineTo(0.69, 0.36)
            ..quadraticBezierTo(0.64, 0.7, 0.64, 0.92)
            ..lineTo(0.78, 1.5)
            ..lineTo(0.22, 1.5)
            ..lineTo(0.36, 0.92)
            ..quadraticBezierTo(0.36, 0.7, 0.31, 0.36)
            ..close(),
          dress);
    }
    if (ethnicTop != null) {
      // Kurta: long body with side slits, full sleeves.
      garment(
          Path()
            ..addPath(arm(-1, 0.92), Offset.zero)
            ..addPath(arm(1, 0.92), Offset.zero)
            ..moveTo(0.31, 0.36)
            ..lineTo(0.69, 0.36)
            ..lineTo(0.7, 1.4)
            ..lineTo(0.3, 1.4)
            ..close(),
          ethnicTop);
    } else if (top != null) {
      garment(
          Path()
            ..addPath(arm(-1, 0.62), Offset.zero)
            ..addPath(arm(1, 0.62), Offset.zero)
            ..addPath(torso, Offset.zero),
          top);
    }
    if (outer != null) {
      // Open jacket: two front panels and long sleeves.
      garment(
          Path()
            ..addPath(arm(-1, 0.94), Offset.zero)
            ..addPath(arm(1, 0.94), Offset.zero)
            ..moveTo(0.3, 0.36)
            ..lineTo(0.45, 0.36)
            ..lineTo(0.43, 1.04)
            ..lineTo(0.3, 1.04)
            ..close()
            ..moveTo(0.55, 0.36)
            ..lineTo(0.7, 0.36)
            ..lineTo(0.7, 1.04)
            ..lineTo(0.57, 1.04)
            ..close(),
          outer);
    }
    if (shoes != null) {
      for (final side in [-1.0, 1.0]) {
        garment(
            Path()
              ..addRRect(RRect.fromRectAndRadius(
                  Rect.fromCenter(center: Offset(0.5 + side * 0.08, 1.98), width: 0.15, height: 0.06),
                  const Radius.circular(0.03))),
            shoes);
      }
    }
    if (accessory != null) {
      canvas.drawCircle(const Offset(0.78, 0.9), 0.025, Paint()..color = hexColor(accessory.colorHex));
    }
    canvas.restore();
  }

  void _pattern(Canvas canvas, Path clip, WardrobeItem item) {
    if (item.pattern == GarmentPattern.solid) return;
    final lum = hexColor(item.colorHex).computeLuminance();
    final ink = Paint()
      ..color = (lum > 0.5 ? Colors.black : Colors.white).withValues(alpha: 0.28)
      ..strokeWidth = 0.008;
    canvas.save();
    canvas.clipPath(clip);
    final b = clip.getBounds();
    switch (item.pattern) {
      case GarmentPattern.stripes:
        for (var y = b.top; y < b.bottom; y += 0.04) {
          canvas.drawLine(Offset(b.left, y), Offset(b.right, y), ink);
        }
      case GarmentPattern.checks:
        for (var y = b.top; y < b.bottom; y += 0.06) {
          canvas.drawLine(Offset(b.left, y), Offset(b.right, y), ink);
        }
        for (var x = b.left; x < b.right; x += 0.06) {
          canvas.drawLine(Offset(x, b.top), Offset(x, b.bottom), ink);
        }
      case GarmentPattern.print:
        for (var y = b.top; y < b.bottom; y += 0.06) {
          for (var x = b.left + ((y * 50).round().isEven ? 0 : 0.03); x < b.right; x += 0.06) {
            canvas.drawCircle(Offset(x, y), 0.01, ink);
          }
        }
      case GarmentPattern.solid:
        break;
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(OutfitSilhouettePainter old) =>
      old.items != items || old.womenswear != womenswear || old.body != body;
}
