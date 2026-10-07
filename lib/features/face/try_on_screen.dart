import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/grooming.dart';
import '../../l10n/app_localizations.dart';
import '../../ml/face/face_estimator.dart';
import '../../ml/inference/frame_pipeline.dart';
import '../../ml/pose/pose_estimator.dart';
import '../../shared/visual/style_art.dart';
import '../camera/camera_providers.dart';
import '../camera/camera_source.dart';
import '../camera/camera_stage.dart';
import '../camera/portrait_lock.dart';
import 'face_providers.dart';
import 'try_on_painter.dart';

/// Live try-on (front camera): glasses and beard previews that follow the
/// face. Nothing is recorded; frames are analyzed in memory and discarded.
class TryOnScreen extends ConsumerStatefulWidget {
  const TryOnScreen({super.key, this.initialItem});

  final String? initialItem;

  @override
  ConsumerState<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends ConsumerState<TryOnScreen> {
  late final CameraSource _camera = ref.read(cameraSourceProvider);
  late final AppLifecycleListener _lifecycle;
  FramePipeline? _pipeline;
  FaceDetected? _face;
  FaceEstimation? _last;
  late GlassesStyle? _glasses = glassesStyleFor(widget.initialItem ?? '');
  late BeardStyle? _beard = beardStyleFor(widget.initialItem ?? '');
  bool _compare = false;

  @override
  void initState() {
    super.initState();
    PortraitLock.enter();
    _lifecycle = AppLifecycleListener(
      onHide: () => _camera.stop(),
      onShow: _start,
    );
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
    final pipeline = FramePipeline(
      // Smooth tracking matters more than battery for a short try-on.
      targetFps: 15,
      estimator: const UnavailablePoseEstimator(),
      faceEstimator: ref.read(faceEstimatorProvider),
      onStatus: (s) {
        if (!mounted) return;
        setState(() {
          _last = s.face;
          if (s.face is FaceDetected) _face = s.face as FaceDetected;
          if (s.face is NoFaceDetected) _face = null;
        });
      },
    );
    _pipeline = pipeline;
    await _camera.start(CameraLens.front, ref.read(cameraPowerModeProvider),
        pipeline.process);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final content = ref.watch(groomingContentProvider).value;
    final glassesItems = content?.items.values
            .where((i) => i.kind == StyleKind.glasses)
            .toList() ??
        const [];
    final beardItems = content?.items.values
            .where((i) => i.kind == StyleKind.beard)
            .toList() ??
        const [];

    final guidance = switch (_last) {
      null => l10n.cameraWaiting,
      NoFaceDetected() => l10n.faceNone,
      MultipleFaces() => l10n.faceMultiple,
      FaceUnavailable() => l10n.poseAnalysisFailed,
      FaceDetected() => _compare ? l10n.tryOnComparing : l10n.tryOnHint,
    };

    Widget chip(String label, bool selected, VoidCallback onTap,
            {Widget? avatar}) =>
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: ChoiceChip(
            avatar: avatar,
            label: Text(label),
            selected: selected,
            onSelected: (_) => onTap(),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tryOn)),
      body: ValueListenableBuilder<CameraSourceState>(
        valueListenable: _camera.state,
        builder: (context, cam, _) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (cam.problem != null)
              CameraProblemCard(problem: cam.problem!, onRetry: _start)
            else
              GestureDetector(
                // Press and hold to compare with and without.
                onLongPressStart: (_) => setState(() => _compare = true),
                onLongPressEnd: (_) => setState(() => _compare = false),
                child: CameraStage(
                  camera: _camera,
                  state: cam,
                  pose: null,
                  guidance: guidance,
                  scanning: _face == null,
                  ovalGuide: true,
                  painter: TryOnPainter(
                    face: _compare ? null : _face,
                    glasses: _glasses,
                    beard: _beard,
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.styleGlasses, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                chip(l10n.tryOnNone, _glasses == null,
                    () => setState(() => _glasses = null)),
                for (final i in glassesItems)
                  if (glassesStyleFor(i.id) != null)
                    chip(
                      GroomingContent.pick(i.name, lang),
                      _glasses == glassesStyleFor(i.id),
                      () => setState(() => _glasses = glassesStyleFor(i.id)),
                      avatar: SizedBox(
                          width: 28,
                          height: 18,
                          child: GlassesArt(style: glassesStyleFor(i.id)!)),
                    ),
              ]),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.styleBeard, style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                chip(l10n.tryOnNone, _beard == null,
                    () => setState(() => _beard = null)),
                for (final i in beardItems)
                  if (beardStyleFor(i.id) != null)
                    chip(
                      GroomingContent.pick(i.name, lang),
                      _beard == beardStyleFor(i.id),
                      () => setState(() => _beard = beardStyleFor(i.id)),
                    ),
              ]),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.tryOnNote, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
