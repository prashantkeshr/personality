import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/services/outfit_engine.dart';

/// A garment shown as its photo, or as a colour swatch with a subtle
/// pattern texture (stripes, checks, print) — never a cartoon icon.
class GarmentTile extends StatelessWidget {
  const GarmentTile({
    super.key,
    required this.item,
    this.photo,
    this.radius = AppRadius.card,
    this.showName = true,
  });

  final WardrobeItem item;
  final Uint8List? photo;
  final double radius;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    final color = Color(item.color.argb);
    final onColor = ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black87;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(fit: StackFit.expand, children: [
        if (photo != null)
          Image.memory(photo!, fit: BoxFit.cover, gaplessPlayback: true)
        else
          CustomPaint(painter: _FabricPainter(color, item.pattern)),
        if (showName)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    (photo != null ? Colors.black : color).withValues(alpha: 0.75),
                  ],
                ),
              ),
              child: Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: photo != null ? Colors.white : onColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        if (item.favorite)
          const Positioned(
            top: 6,
            right: 6,
            child: Icon(Icons.favorite, size: 16, color: Colors.white,
                shadows: [Shadow(blurRadius: 6)]),
          ),
      ]),
    );
  }
}

class _FabricPainter extends CustomPainter {
  _FabricPainter(this.color, this.pattern);
  final Color color;
  final GarmentPattern pattern;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // Soft fabric shading so a flat swatch reads as cloth.
    canvas.drawRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(color, Colors.white, 0.10)!,
              color,
              Color.lerp(color, Colors.black, 0.18)!,
            ],
          ).createShader(rect));
    final light = ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
    final line = Paint()
      ..color = (light ? Colors.white : Colors.black).withValues(alpha: 0.18)
      ..strokeWidth = math.max(1.5, size.width / 40);
    switch (pattern) {
      case GarmentPattern.solid:
        break;
      case GarmentPattern.stripes:
        for (var x = -size.height; x < size.width; x += size.width / 7) {
          canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), line);
        }
      case GarmentPattern.checks:
        for (var x = 0.0; x < size.width; x += size.width / 6) {
          canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
        }
        for (var y = 0.0; y < size.height; y += size.width / 6) {
          canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
        }
      case GarmentPattern.print:
        final rnd = math.Random(3);
        final dot = Paint()..color = line.color;
        for (var i = 0; i < 40; i++) {
          canvas.drawCircle(
              Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
              size.width / 30 + rnd.nextDouble() * size.width / 30,
              dot);
        }
    }
  }

  @override
  bool shouldRepaint(_FabricPainter o) => o.color != color || o.pattern != pattern;
}

/// An outfit as an editorial collage: the main piece large, the rest
/// stacked beside it, sliding in when shown.
class OutfitCollage extends StatelessWidget {
  const OutfitCollage({
    super.key,
    required this.items,
    required this.photos,
    this.height = 220,
  });

  final List<WardrobeItem> items;
  final Map<String, Uint8List> photos;
  final double height;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    final main = items.first;
    final rest = items.skip(1).toList();
    Widget tile(WardrobeItem i, int index) => TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: reduce
              ? Duration.zero
              : Duration(milliseconds: 360 + 110 * index),
          curve: Curves.easeOutCubic,
          builder: (_, t, child) => Opacity(
            opacity: t,
            child: Transform.translate(offset: Offset(18 * (1 - t), 0), child: child),
          ),
          child: GarmentTile(item: i, photo: photos[i.id], radius: 14),
        );
    return SizedBox(
      height: height,
      child: Row(children: [
        Expanded(flex: 3, child: tile(main, 0)),
        if (rest.isNotEmpty) ...[
          const SizedBox(width: 6),
          Expanded(
            flex: 2,
            child: Column(children: [
              for (final (i, r) in rest.indexed) ...[
                if (i > 0) const SizedBox(height: 6),
                Expanded(child: tile(r, i + 1)),
              ],
            ]),
          ),
        ],
      ]),
    );
  }
}

/// A palette swatch that pops in with a slight delay per index.
class Swatch extends StatelessWidget {
  const Swatch({
    super.key,
    required this.hex,
    required this.index,
    this.label,
    this.selected = false,
    this.onTap,
    this.size = 56,
  });

  final String hex;
  final int index;
  final String? label;
  final bool selected;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    final color = Color(0xFF000000 | int.parse(hex.substring(1), radix: 16));
    return Semantics(
      button: onTap != null,
      selected: selected,
      label: label ?? hex,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: reduce ? Duration.zero : Duration(milliseconds: 300 + 45 * index),
        curve: Curves.easeOutBack,
        builder: (_, t, child) => Transform.scale(scale: 0.6 + 0.4 * t, child: Opacity(opacity: t.clamp(0, 1), child: child)),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: reduce ? Duration.zero : const Duration(milliseconds: 200),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outlineVariant,
                width: selected ? 4 : 1,
              ),
              boxShadow: [
                BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: selected ? 14 : 6,
                    offset: const Offset(0, 3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
