import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../ml/face/face_estimator.dart';
import '../../ml/inference/frame_pipeline.dart';
import '../../ml/pose/pose_estimator.dart';
import '../camera/camera_providers.dart';
import '../camera/camera_source.dart';
import '../camera/camera_stage.dart';
import '../camera/portrait_lock.dart';
import '../face/face_providers.dart';
import 'style_providers.dart';
import 'style_widgets.dart';

/// Live colour drape: holds a colour under the face, like a stylist's
/// fabric drape, to see how it looks against your skin. Nothing is
/// recorded.
class DrapeScreen extends ConsumerStatefulWidget {
  const DrapeScreen({super.key, this.initialHex});

  final String? initialHex;

  @override
  ConsumerState<DrapeScreen> createState() => _DrapeScreenState();
}

class _DrapeScreenState extends ConsumerState<DrapeScreen> {
  late final CameraSource _camera = ref.read(cameraSourceProvider);
  late final AppLifecycleListener _lifecycle;
  FramePipeline? _pipeline;
  FaceDetected? _face;
  late String _hex = widget.initialHex ?? '#1F2A44';

  @override
  void initState() {
    super.initState();
    PortraitLock.enter();
    _lifecycle =
        AppLifecycleListener(onHide: () => _camera.stop(), onShow: _start);
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void dispose() {
    PortraitLock.exit();
    _lifecycle.dispose();
    _pipeline?.close();
    _camera.stop();
    super.dispose();
  }

  Future<void> _start() async {
    if (!mounted) return;
    _pipeline?.close();
    final p = FramePipeline(
      targetFps: 12,
      estimator: const UnavailablePoseEstimator(),
      faceEstimator: ref.read(faceEstimatorProvider),
      onStatus: (s) {
        if (!mounted) return;
        final f = s.face;
        if (f is FaceDetected) setState(() => _face = f);
      },
    );
    _pipeline = p;
    await _camera.start(
        CameraLens.front, ref.read(cameraPowerModeProvider), p.process);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final profile = ref.watch(styleProfileProvider).value;
    final names = ref.watch(garmentColorsProvider).value ?? const <NamedColor>[];
    final colors = <String>{
      ...?profile?.palette?.best,
      ...?profile?.palette?.neutrals,
      ...?profile?.palette?.sparingly,
      for (final c in names) c.hex,
    }.toList();
    final current = nearestNamed(names, _hex)?.label(lang);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.drapeTitle)),
      body: ValueListenableBuilder<CameraSourceState>(
        valueListenable: _camera.state,
        builder: (context, cam, _) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (cam.problem != null)
              CameraProblemCard(problem: cam.problem!, onRetry: _start)
            else
              CameraStage(
                camera: _camera,
                state: cam,
                pose: null,
                guidance: current == null ? l10n.drapeHint : '$current · ${l10n.drapeHint}',
                scanning: _face == null,
                ovalGuide: true,
                painter: DrapePainter(face: _face, color: _parse(_hex)),
              ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: colors.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, i) => Center(
                  child: Swatch(
                    hex: colors[i],
                    index: i.clamp(0, 12),
                    size: 48,
                    label: nearestNamed(names, colors[i])?.label(lang),
                    selected: colors[i] == _hex,
                    onTap: () => setState(() => _hex = colors[i]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.drapeNote, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  static Color _parse(String hex) =>
      Color(0xFF000000 | int.parse(hex.substring(1), radix: 16));
}

/// A soft fabric band from just under the chin to the bottom of the frame,
/// shaped like shoulders and following the face.
class DrapePainter extends CustomPainter {
  DrapePainter({required this.face, required this.color});

  final FaceDetected? face;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final f = face;
    double cx = size.width / 2, chin = size.height * 0.68, width = size.width * 0.5;
    if (f != null && f.outline.isNotEmpty) {
      var minX = double.infinity, maxX = -double.infinity, maxY = 0.0;
      for (final (x0, y) in f.outline) {
        final x = (f.frontCamera ? 1 - x0 / f.imageWidth : x0 / f.imageWidth) * size.width;
        minX = math.min(minX, x);
        maxX = math.max(maxX, x);
        maxY = math.max(maxY, y / f.imageHeight * size.height);
      }
      cx = (minX + maxX) / 2;
      chin = maxY;
      width = maxX - minX;
    }
    final top = chin + width * 0.08;
    final shoulder = width * 1.9;
    final path = Path()
      ..moveTo(cx - width * 0.42, top)
      ..quadraticBezierTo(cx, top + width * 0.22, cx + width * 0.42, top)
      ..cubicTo(cx + width * 0.7, top + width * 0.05, cx + shoulder / 2,
          top + width * 0.25, size.width + 20, top + width * 0.55)
      ..lineTo(size.width + 20, size.height + 20)
      ..lineTo(-20, size.height + 20)
      ..lineTo(-20, top + width * 0.55)
      ..cubicTo(cx - shoulder / 2, top + width * 0.25, cx - width * 0.7,
          top + width * 0.05, cx - width * 0.42, top)
      ..close();
    final bounds = path.getBounds();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(color, Colors.white, 0.08)!,
            color,
            Color.lerp(color, Colors.black, 0.25)!,
          ],
        ).createShader(bounds),
    );
    // Gentle folds so it reads as fabric.
    final fold = Paint()
      ..color = Colors.black.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    for (final dx in [-0.35, 0.0, 0.35]) {
      canvas.drawLine(Offset(cx + width * dx, top + width * 0.3),
          Offset(cx + width * dx * 1.6, size.height), fold);
    }
  }

  @override
  bool shouldRepaint(DrapePainter o) => o.face != face || o.color != color;
}
