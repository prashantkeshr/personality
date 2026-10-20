import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/makeup.dart';
import '../../domain/services/face_engine.dart';
import '../../domain/services/palette_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/visual/style_art.dart' show faceSilhouette;
import '../style/style_labels.dart';
import '../style/style_providers.dart';
import 'face_labels.dart';
import 'face_providers.dart';

/// Lookbook ids for makeup shades share the style favourites table.
String makeupFavoriteId(MakeupShade s) => 'makeup:${s.id}';

/// Makeup by face shape (where to place blush, contour and highlight) and by
/// undertone (which shades), with a live try-on. All optional suggestions.
class MakeupGuideScreen extends ConsumerWidget {
  const MakeupGuideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final content = ref.watch(makeupContentProvider).value;
    final faces = ref.watch(faceHistoryProvider).value ?? const [];
    final shape = faces.isEmpty ? null : faces.first.result.shape;
    final style = ref.watch(styleProfileProvider).value;
    final undertone = style?.undertone;
    final favorites = ref.watch(styleFavoritesProvider).value ?? const {};
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    if (content == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.makeupTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final placement = content.shapes[shape ?? FaceShape.oval]!;
    final lips = content.shades(MakeupArea.lips, undertone);
    final blush = content.shades(MakeupArea.blush, undertone);

    Widget shades(MakeupArea area, String title) {
      final list = content.shades(area, undertone);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final s in list)
                _ShadeChip(
                  shade: s,
                  label: MakeupContent.pick(s.name, lang),
                  saved: favorites.contains(makeupFavoriteId(s)),
                  onSave: (on) => ref
                      .read(faceRepositoryProvider)
                      .setFavorite(makeupFavoriteId(s), on),
                  onTry: area == MakeupArea.eyes
                      ? null
                      : () => context.push(
                          '${AppRoutes.tryOn}?${area == MakeupArea.lips ? 'lip' : 'blush'}=${s.hex}',
                        ),
                ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.makeupTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          Text(l.makeupIntro, style: muted),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ActionChip(
                key: const Key('makeup-shape'),
                avatar: const Icon(Icons.face_outlined, size: 18),
                label: Text(shape == null
                    ? l.makeupNoShape
                    : l.faceShapeName(shape)),
                onPressed: () => context.push(AppRoutes.face),
              ),
              ActionChip(
                key: const Key('makeup-undertone'),
                avatar: const Icon(Icons.palette_outlined, size: 18),
                label: Text(undertone == null
                    ? l.makeupNoUndertone
                    : l.undertoneName(undertone)),
                onPressed: () => context.push(AppRoutes.colours),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.makeupPlacementFor(
                      l.faceShapeName(shape ?? FaceShape.oval).toLowerCase(),
                    ),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Center(
                    child: SizedBox(
                      width: 160,
                      height: 190,
                      child: MakeupMapArt(shape: shape ?? FaceShape.oval),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final (colour, title, text) in [
                    (MakeupMapArt.blushColour, l.makeupBlush, placement.blush),
                    (MakeupMapArt.contourColour, l.makeupContour, placement.contour),
                    (MakeupMapArt.highlightColour, l.makeupHighlight, placement.highlight),
                  ])
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: CircleAvatar(radius: 8, backgroundColor: colour),
                      title: Text(title),
                      subtitle: Text(MakeupContent.pick(text, lang)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    undertone == null
                        ? l.makeupShadesAll
                        : l.makeupShadesFor(l.undertoneName(undertone).toLowerCase()),
                    style: theme.textTheme.titleMedium,
                  ),
                  if (style?.depth case final SkinDepth d?) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(MakeupContent.pick(content.depth[d]!, lang), style: muted),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  shades(MakeupArea.lips, l.makeupLips),
                  const SizedBox(height: AppSpacing.md),
                  shades(MakeupArea.blush, l.makeupBlush),
                  const SizedBox(height: AppSpacing.md),
                  shades(MakeupArea.eyes, l.makeupEyes),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    key: const Key('makeup-try'),
                    onPressed: () => context.push(
                      '${AppRoutes.tryOn}?lip=${lips.first.hex}&blush=${blush.first.hex}',
                    ),
                    icon: const Icon(Icons.camera_front_outlined),
                    label: Text(l.makeupTryOn),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l.makeupBasics, style: theme.textTheme.titleMedium),
          for (final b in content.basics)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: const Icon(Icons.check_circle_outline, size: 20),
              title: Text(MakeupContent.pick(b, lang)),
            ),
          Text(l.makeupNote, style: muted),
        ],
      ),
    );
  }
}

class _ShadeChip extends StatelessWidget {
  const _ShadeChip({
    required this.shade,
    required this.label,
    required this.saved,
    required this.onSave,
    this.onTry,
  });

  final MakeupShade shade;
  final String label;
  final bool saved;
  final ValueChanged<bool> onSave;
  final VoidCallback? onTry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return InputChip(
      key: Key('shade-${shade.id}'),
      avatar: CircleAvatar(backgroundColor: Color(shade.argb)),
      label: Text(label),
      onPressed: onTry,
      tooltip: onTry == null ? null : l.makeupTryOn,
      deleteIcon: Icon(saved ? Icons.favorite : Icons.favorite_border, size: 18),
      deleteButtonTooltipMessage: saved ? l.favoriteRemove : l.favoriteAdd,
      onDeleted: () => onSave(!saved),
    );
  }
}

/// A face diagram with blush, contour and highlight zones for a shape.
class MakeupMapArt extends StatelessWidget {
  const MakeupMapArt({super.key, required this.shape});
  final FaceShape shape;

  static const blushColour = Color(0xFFE88A9A);
  static const contourColour = Color(0xFF8A6450);
  static const highlightColour = Color(0xFFF3D98B);

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _MapPainter(shape, Theme.of(context).colorScheme),
    child: const SizedBox.expand(),
  );
}

class _MapPainter extends CustomPainter {
  _MapPainter(this.shape, this.scheme);
  final FaceShape shape;
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    final (lw, fc, jc) = FaceEngine.prototypes[shape]!;
    final face = faceSilhouette(Offset.zero & size, lw, fc, jc);
    final b = face.getBounds();
    canvas.drawPath(face, Paint()..color = scheme.surfaceContainerHighest);
    canvas.drawPath(
      face,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = scheme.outline,
    );
    canvas.save();
    canvas.clipPath(face);
    Offset at(double fx, double fy) =>
        Offset(b.left + fx * b.width, b.top + fy * b.height);
    void zone(Offset c, double w, double h, Color col, {double angle = 0}) {
      // A unit circle scaled to the oval, so the colour fills all of it.
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(angle);
      canvas.scale(w / 2, h / 2);
      final r = Rect.fromCircle(center: Offset.zero, radius: 1);
      canvas.drawCircle(
        Offset.zero,
        1,
        Paint()
          ..shader = RadialGradient(
            colors: [col.withValues(alpha: 0.85), col.withValues(alpha: 0)],
            stops: const [0.35, 1],
          ).createShader(r),
      );
      canvas.restore();
    }

    final w = b.width, h = b.height;
    // Blush position and direction vary with the shape.
    final (by, tilt, spread) = switch (shape) {
      FaceShape.round => (0.50, -0.45, 0.30),
      FaceShape.oblong => (0.55, 0.0, 0.36),
      FaceShape.heart => (0.60, -0.1, 0.28),
      FaceShape.diamond => (0.57, 0.2, 0.26),
      FaceShape.square => (0.55, 0.0, 0.28),
      FaceShape.oval => (0.53, -0.3, 0.30),
    };
    for (final side in [-1.0, 1.0]) {
      zone(at(0.5 + side * spread, by), w * 0.30, h * 0.14,
          MakeupMapArt.blushColour, angle: side * tilt);
      // Contour under the cheekbone, toward the ear.
      zone(at(0.5 + side * 0.40, 0.62), w * 0.30, h * 0.07,
          MakeupMapArt.contourColour, angle: side * -0.5);
      if (shape == FaceShape.square || shape == FaceShape.heart) {
        zone(at(0.5 + side * 0.40, 0.12), w * 0.24, h * 0.1,
            MakeupMapArt.contourColour);
      }
    }
    if (shape == FaceShape.square) {
      for (final side in [-1.0, 1.0]) {
        zone(at(0.5 + side * 0.42, 0.85), w * 0.22, h * 0.1,
            MakeupMapArt.contourColour);
      }
    }
    // Highlight: centre line, cheekbone tops and chin.
    for (final (fx, fy, sw, sh) in [
      (0.5, 0.16, 0.16, 0.08),
      (0.5, 0.45, 0.07, 0.18),
      (0.5, 0.93, 0.16, 0.06),
      (0.27, 0.40, 0.14, 0.05),
      (0.73, 0.40, 0.14, 0.05),
    ]) {
      zone(at(fx, fy), w * sw, h * sh, MakeupMapArt.highlightColour);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_MapPainter o) => o.shape != shape || o.scheme != scheme;
}
