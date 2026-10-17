import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/face_engine.dart';
import '../../domain/services/glasses_fit.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/visual/outfit_silhouette.dart' show hexColor;
import '../../shared/visual/style_art.dart';
import '../../shared/widgets/async_view.dart';
import '../face/face_labels.dart';
import 'style_studio_labels.dart';
import 'style_studio_providers.dart';

/// A frame drawn in its own colour and weight.
class FrameArt extends StatelessWidget {
  const FrameArt({super.key, required this.frame});
  final GlassesFrame frame;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _FramePainter(frame),
        size: Size.infinite,
      );
}

class _FramePainter extends CustomPainter {
  _FramePainter(this.frame);
  final GlassesFrame frame;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width * 0.9;
    paintGlasses(canvas, Rect.fromCenter(center: size.center(Offset.zero), width: w, height: w * 0.42),
        GlassesStyle.values.byName(frame.shape), hexColor(frame.colorHex),
        weight: frame.thick ? 1.6 : 1);
  }

  @override
  bool shouldRepaint(_FramePainter old) => old.frame != frame;
}

/// Twenty frames, ranked for the user's face shape, with live try-on.
class GlassesScreen extends ConsumerStatefulWidget {
  const GlassesScreen({super.key});

  @override
  ConsumerState<GlassesScreen> createState() => _GlassesScreenState();
}

class _GlassesScreenState extends ConsumerState<GlassesScreen> {
  bool _bestOnly = false;

  void _details(GlassesFrame f, FaceShape? shape) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final (fit, reason) = GlassesFit.fit(f, shape);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (c) => Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(f.name[lang] ?? f.name['en']!, style: theme.textTheme.titleLarge),
          SizedBox(height: 120, child: FrameArt(frame: f)),
          _FitBadge(fit: fit),
          const SizedBox(height: AppSpacing.sm),
          Text(l.fitReasonText(reason)),
          const SizedBox(height: AppSpacing.sm),
          Text(l.glassesSizeTip, style: theme.textTheme.bodySmall),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              key: const Key('glasses-try-on'),
              onPressed: () {
                Navigator.of(c).pop();
                context.push('${AppRoutes.tryOn}?item=frame:${f.shape}&color=${f.colorHex.substring(1)}');
              },
              icon: const Icon(Icons.face_retouching_natural),
              label: Text(l.glassesTryOn),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final shape = ref.watch(latestFaceShapeProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.featureGlasses)),
      body: AsyncView(
        value: ref.watch(glassesCatalogProvider),
        data: (frames) {
          final ranked = GlassesFit.ranked(frames, shape);
          final shown = _bestOnly && shape != null
              ? ranked.where((f) => GlassesFit.fit(f, shape).$1 == FrameFit.great).toList()
              : ranked;
          return ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
            children: [
              Card(
                color: scheme.primaryContainer,
                child: ListTile(
                  leading: Icon(Icons.face_outlined, color: scheme.onPrimaryContainer),
                  title: Text(shape == null ? l.glassesNoShape : l.glassesForShape(l.faceShapeName(shape)),
                      style: TextStyle(color: scheme.onPrimaryContainer)),
                  subtitle: Text(l.glassesHonest, style: TextStyle(color: scheme.onPrimaryContainer)),
                  trailing: shape == null ? Icon(Icons.chevron_right, color: scheme.onPrimaryContainer) : null,
                  onTap: shape == null ? () => context.push(AppRoutes.face) : null,
                ),
              ),
              if (shape != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Wrap(spacing: AppSpacing.sm, children: [
                    ChoiceChip(label: Text(l.filterAll), selected: !_bestOnly, onSelected: (_) => setState(() => _bestOnly = false)),
                    ChoiceChip(
                        key: const Key('glasses-best'),
                        label: Text(l.fitGreat),
                        selected: _bestOnly,
                        onSelected: (_) => setState(() => _bestOnly = true)),
                  ]),
                ),
              const SizedBox(height: AppSpacing.sm),
              LayoutBuilder(builder: (context, c) {
                final cols = c.maxWidth > 600 ? 3 : 2;
                final w = (c.maxWidth - AppSpacing.sm * (cols - 1)) / cols;
                return Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
                  for (final f in shown)
                    SizedBox(
                      width: w,
                      child: Card(
                        margin: EdgeInsets.zero,
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          key: Key('frame-${f.id}'),
                          onTap: () => _details(f, shape),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              SizedBox(height: 64, child: FrameArt(frame: f)),
                              const SizedBox(height: AppSpacing.xs),
                              Text(f.name[lang] ?? f.name['en']!,
                                  style: theme.textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: AppSpacing.xs),
                              _FitBadge(fit: GlassesFit.fit(f, shape).$1),
                            ]),
                          ),
                        ),
                      ),
                    ),
                ]);
              }),
            ],
          );
        },
      ),
    );
  }
}

class _FitBadge extends StatelessWidget {
  const _FitBadge({required this.fit});
  final FrameFit fit;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg) = switch (fit) {
      FrameFit.great => (scheme.primaryContainer, scheme.onPrimaryContainer),
      FrameFit.good => (scheme.secondaryContainer, scheme.onSecondaryContainer),
      FrameFit.lessBalancing => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(l.frameFitName(fit), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg)),
    );
  }
}
