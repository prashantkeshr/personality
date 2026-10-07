import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/grooming.dart';
import '../../domain/entities/provenance.dart';
import '../../domain/entities/routine.dart';
import '../../domain/services/face_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../ml/face/face_estimator.dart';
import '../../ml/inference/frame_pipeline.dart';
import '../../ml/pose/pose_estimator.dart';
import '../../ml/preprocessing/frame_quality.dart';
import '../../shared/widgets/provenance_chip.dart';
import '../camera/camera_check_screen.dart' show lightingLabel;
import '../camera/camera_providers.dart';
import '../camera/camera_source.dart';
import '../camera/camera_stage.dart';
import '../camera/portrait_lock.dart';
import '../../shared/visual/reveal.dart';
import '../../shared/visual/style_art.dart';
import '../../shared/visual/style_carousel.dart';
import '../posture/posture_labels.dart';
import '../routines/reminder_sync_host.dart' show formatMinute;
import '../routines/routine_providers.dart';
import 'face_labels.dart';
import 'face_providers.dart';

enum _Phase { setup, live, countdown, capturing, result, failed }

/// Face shape and grooming suggestions (spec §20–21). The face outline is
/// measured on this phone; frames are discarded and only proportions are
/// saved, and only when the user taps Save.
class FaceScreen extends ConsumerStatefulWidget {
  const FaceScreen({super.key});

  static const captureTimeout = Duration(seconds: 12);
  static const countdownSeconds = 3;

  @override
  ConsumerState<FaceScreen> createState() => _FaceScreenState();
}

class _FaceScreenState extends ConsumerState<FaceScreen> {
  late final CameraSource _camera = ref.read(cameraSourceProvider);
  late final AppLifecycleListener _lifecycle;
  FramePipeline? _pipeline;
  _Phase _phase = _Phase.setup;
  FaceEstimation? _last;
  FaceFrameAssessment? _assessment;
  LightingLevel? _lighting;
  FaceCapture? _capture;
  Timer? _timeout;
  Timer? _countdownTimer;
  int _countdown = 0;
  FaceShapeResult? _result;
  FrameQualityIssue? _failure;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    PortraitLock.enter();
    _lifecycle = AppLifecycleListener(onHide: _stopCamera);
  }

  @override
  void dispose() {
    PortraitLock.exit();
    _timeout?.cancel();
    _countdownTimer?.cancel();
    _lifecycle.dispose();
    _pipeline?.close();
    _camera.stop();
    super.dispose();
  }

  Future<void> _startCamera() async {
    _pipeline?.close();
    final mode = ref.read(cameraPowerModeProvider);
    final pipeline = FramePipeline(
      targetFps: mode.analysisFps,
      estimator: const UnavailablePoseEstimator(),
      faceEstimator: ref.read(faceEstimatorProvider),
      onStatus: _onStatus,
    );
    _pipeline = pipeline;
    setState(() {
      _phase = _Phase.live;
      _last = null;
      _assessment = null;
      _result = null;
      _failure = null;
      _saved = false;
    });
    await _camera.start(CameraLens.front, mode, pipeline.process);
  }

  Future<void> _stopCamera() async {
    _pipeline?.close();
    await _camera.stop();
  }

  void _onStatus(PipelineStatus s) {
    if (!mounted) return;
    final face = s.face;
    FaceFrameAssessment? a;
    if (face is FaceDetected) a = FaceEngine.assess(face);
    final capture = _capture;
    if (_phase == _Phase.capturing && capture != null) {
      capture.add(a ??
          FaceFrameAssessment(issues: {
            s.pose is LowQualityFrame
                ? (s.pose as LowQualityFrame).issues.first
                : FrameQualityIssue.bodyOutOfFrame,
          }));
      if (capture.complete) {
        _finish();
        return;
      }
    }
    setState(() {
      _lighting = s.lighting;
      _last = face;
      _assessment = a;
    });
  }

  void _analyze() {
    _countdownTimer?.cancel();
    setState(() {
      _phase = _Phase.countdown;
      _countdown = FaceScreen.countdownSeconds;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      if (_countdown <= 1) {
        t.cancel();
        _capture = FaceCapture();
        _timeout = Timer(FaceScreen.captureTimeout, _finish);
        setState(() => _phase = _Phase.capturing);
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _finish() {
    _timeout?.cancel();
    final capture = _capture;
    if (capture == null || _phase != _Phase.capturing) return;
    _capture = null;
    final result = capture.result();
    _stopCamera();
    setState(() {
      _result = result;
      _failure = result == null ? capture.mainIssue : null;
      _phase = result == null ? _Phase.failed : _Phase.result;
    });
  }

  Future<void> _save() async {
    final r = _result;
    if (r == null) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(faceRepositoryProvider).save(r);
      setState(() => _saved = true);
      messenger.showSnackBar(SnackBar(content: Text(l10n.faceSaved)));
    } catch (e, st) {
      AppLogger.error('face.save', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
    }
  }

  String _guidance(AppLocalizations l10n) {
    if (_lighting != null &&
        _lighting != LightingLevel.good &&
        _lighting != LightingLevel.dim) {
      return lightingLabel(l10n, _lighting!);
    }
    return switch (_last) {
      null => l10n.cameraWaiting,
      NoFaceDetected() => l10n.faceNone,
      MultipleFaces() => l10n.faceMultiple,
      FaceUnavailable(:final reason) =>
        reason == FaceUnavailableReason.modelNotInstalled
            ? l10n.faceModelRequired
            : l10n.poseAnalysisFailed,
      FaceDetected() => _assessment == null || _assessment!.usable
          ? (_phase == _Phase.live ? l10n.faceReady : l10n.poseHoldStill)
          : faceGuidance(l10n, firstIssue(_assessment!.issues)),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final face = _last is FaceDetected ? _last as FaceDetected : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.featureFace),
        actions: [
          IconButton(
            tooltip: l10n.faceHistory,
            icon: const Icon(Icons.history),
            onPressed: () => context.push(AppRoutes.faceHistory),
          ),
        ],
      ),
      body: ValueListenableBuilder<CameraSourceState>(
        valueListenable: _camera.state,
        builder: (context, cam, _) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: switch (_phase) {
            _Phase.setup => [
                Text(l10n.faceIntro, style: theme.textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.md),
                for (final (icon, text) in [
                  (Icons.lock_outline, l10n.facePrivacy),
                  (Icons.wb_sunny_outlined, l10n.faceTipLight),
                  (Icons.face_retouching_natural, l10n.faceTipHair),
                  (Icons.center_focus_strong, l10n.faceTipStraight),
                ])
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(icon),
                    title: Text(text),
                  ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  onPressed: _startCamera,
                  icon: const Icon(Icons.videocam_outlined),
                  label: Text(l10n.cameraStart),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.tryOn),
                  icon: const Icon(Icons.face_retouching_natural),
                  label: Text(l10n.tryOnOpen),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.faceDisclaimer, style: theme.textTheme.bodySmall),
              ],
            _Phase.live || _Phase.countdown || _Phase.capturing => [
                if (cam.problem != null)
                  CameraProblemCard(problem: cam.problem!, onRetry: _startCamera)
                else ...[
                  CameraStage(
                    camera: _camera,
                    state: cam,
                    pose: null,
                    guidance: _guidance(l10n),
                    countdown: _phase == _Phase.countdown ? _countdown : null,
                    ovalGuide: true,
                    scanning: _phase != _Phase.countdown,
                    progress: _phase == _Phase.capturing
                        ? _capture?.progress ?? 0
                        : null,
                    painter: FaceOutlinePainter(
                      face: face,
                      guideColor: Colors.white.withValues(alpha: 0.7),
                      lineColor: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_phase == _Phase.capturing) ...[
                    LinearProgressIndicator(value: _capture?.progress ?? 0),
                    const SizedBox(height: AppSpacing.sm),
                    Text(l10n.faceCapturing),
                  ] else if (_phase == _Phase.live)
                    FilledButton.icon(
                      onPressed: cam.running ? _analyze : null,
                      icon: const Icon(Icons.face),
                      label: Text(l10n.postureAnalyze),
                    ),
                ],
              ],
            _Phase.failed => [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(children: [
                      Icon(Icons.replay, size: 40, color: theme.colorScheme.primary),
                      const SizedBox(height: AppSpacing.md),
                      Text(l10n.faceNotReliable,
                          style: theme.textTheme.titleMedium,
                          textAlign: TextAlign.center),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                          _failure == null
                              ? l10n.faceTipStraight
                              : faceGuidance(l10n, _failure!),
                          textAlign: TextAlign.center),
                      const SizedBox(height: AppSpacing.lg),
                      FilledButton(
                          onPressed: _startCamera, child: Text(l10n.actionRetry)),
                    ]),
                  ),
                ),
              ],
            _Phase.result => [
                FaceResultView(
                  result: _result!,
                  saved: _saved,
                  onSave: _save,
                  onRetake: _startCamera,
                ),
              ],
          },
        ),
      ),
    );
  }
}

/// Estimated shape, proportions and style suggestions for a result.
class FaceResultView extends ConsumerWidget {
  const FaceResultView({
    super.key,
    required this.result,
    this.saved = true,
    this.onSave,
    this.onRetake,
  });

  final FaceShapeResult result;
  final bool saved;
  final VoidCallback? onSave;
  final VoidCallback? onRetake;

  Future<void> _addRoutine(BuildContext context, WidgetRef ref,
      GroomingContent content) async {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(routineRepositoryProvider).createFromTemplate(
        l10n.groomingRoutineName,
        [
          for (final s in content.routine)
            (s.minuteOfDay, GroomingContent.pick(s.name, lang),
                RoutineItemKind.grooming),
        ],
      );
      messenger.showSnackBar(SnackBar(content: Text(l10n.groomingRoutineAdded)));
    } catch (e, st) {
      AppLogger.error('grooming.routine', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
    }
  }

  /// Photo when bundled; vector art for glasses; otherwise a quiet
  /// gradient with the face silhouette (never a cartoon icon).
  Widget _art(BuildContext context, StyleItem item) {
    final scheme = Theme.of(context).colorScheme;
    if (item.image != null) {
      return Image.asset(item.image!, fit: BoxFit.cover);
    }
    final glasses = glassesStyleFor(item.id);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primaryContainer, scheme.surfaceContainerHighest],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 70),
        child: glasses != null
            ? GlassesArt(style: glasses, color: scheme.onPrimaryContainer)
            : FaceShapeArt(shape: result.shape),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final content = ref.watch(groomingContentProvider).value;
    final favorites = ref.watch(styleFavoritesProvider).value ?? const {};
    final shapeText = result.alsoLike == null
        ? l10n.faceShapeName(result.shape)
        : l10n.faceShapeBetween(
            l10n.faceShapeName(result.shape), l10n.faceShapeName(result.alsoLike!));
    var reveal = 0;

    List<Widget> section(String title, StyleKind kind, {String? note}) {
      final seen = <String>{};
      final items = [
        for (final s in [result.shape, ?result.alsoLike])
          for (final i in content?.suggestions(s, kind) ?? const <StyleItem>[])
            if (seen.add(i.id)) i,
      ].take(4).toList();
      if (items.isEmpty || content == null) return const [];
      final why = GroomingContent.pick(content.shapes[result.shape]!.why, lang);
      return [
        const SizedBox(height: AppSpacing.xl),
        Reveal(
          index: reveal++,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              if (note != null) Text(note, style: theme.textTheme.bodySmall),
              const SizedBox(height: AppSpacing.sm),
              StyleCarousel(
                flipHint: l10n.cardFlipHint,
                tryOnLabel: l10n.tryOn,
                favoriteLabel: l10n.favoriteAdd,
                cards: [
                  for (final item in items)
                    StyleCardData(
                      id: item.id,
                      title: GroomingContent.pick(item.name, lang),
                      subtitle: GroomingContent.pick(item.desc, lang),
                      art: _art(context, item),
                      credit: item.credit,
                      details: [
                        GroomingContent.pick(item.desc, lang),
                        '',
                        l10n.whyThis,
                        why,
                      ].join('\n'),
                      favorite: favorites.contains(item.id),
                      onFavorite: () => ref
                          .read(faceRepositoryProvider)
                          .setFavorite(item.id, !favorites.contains(item.id)),
                      onTryOn: kind == StyleKind.hair
                          ? null
                          : () => context.push(
                              '${AppRoutes.tryOn}?item=${item.id}'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ];
    }

    final lw = result.ratios[FaceRatio.lengthToWidth];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Reveal(
          index: reveal++,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 160,
                    child: FaceShapeArt(
                        shape: result.shape, ratios: result.ratios),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.faceResultTitle,
                            style: theme.textTheme.labelLarge),
                        const SizedBox(height: AppSpacing.xs),
                        Text(shapeText, style: theme.textTheme.headlineSmall),
                        const SizedBox(height: AppSpacing.sm),
                        ProvenanceChip(
                            source: result.source,
                            confidence: result.confidence),
                        const SizedBox(height: AppSpacing.xs),
                        Text(l10n.faceArtLegend,
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Reveal(
          index: reveal++,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(children: [
                if (lw != null)
                  AnimatedValueBar(
                    label: l10n.faceRatioName(FaceRatio.lengthToWidth),
                    valueText: lw.toStringAsFixed(2),
                    value: (lw - 0.9) / 0.8,
                  ),
                for (final r in [FaceRatio.foreheadToCheek, FaceRatio.jawToCheek])
                  if (result.ratios[r] != null)
                    AnimatedValueBar(
                      label: l10n.faceRatioName(r),
                      valueText: result.ratios[r]!.toStringAsFixed(2),
                      value: result.ratios[r]!,
                    ),
              ]),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.faceDisclaimer, style: theme.textTheme.bodySmall),
        if (onSave != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Row(children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: saved ? null : onSave,
                icon: Icon(saved ? Icons.check : Icons.save_outlined),
                label: Text(saved ? l10n.postureSavedShort : l10n.actionSave),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onRetake,
                icon: const Icon(Icons.replay),
                label: Text(l10n.postureRetake),
              ),
            ),
          ]),
        ],
        if (result.confidence == Confidence.low)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: Text(l10n.faceLowConfidenceNote),
          )
        else if (content != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Reveal(
            index: reveal++,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.whyThis, style: theme.textTheme.labelLarge),
                Text(GroomingContent.pick(
                    content.shapes[result.shape]!.why, lang)),
                if (result.alsoLike != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(l10n.faceBetweenNote(
                      l10n.faceShapeName(result.alsoLike!))),
                  Text(GroomingContent.pick(
                      content.shapes[result.alsoLike!]!.why, lang)),
                ],
              ],
            ),
          ),
          ...section(l10n.styleHair, StyleKind.hair),
          ...section(l10n.styleBeard, StyleKind.beard, note: l10n.styleBeardNote),
          ...section(l10n.styleGlasses, StyleKind.glasses),
          const SizedBox(height: AppSpacing.xl),
          Reveal(
            index: reveal++,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.groomingTitle, style: theme.textTheme.titleMedium),
                    for (final s in content.routine)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Text(
                          formatMinute(context, s.minuteOfDay),
                          style: theme.textTheme.labelLarge,
                        ),
                        title: Text(GroomingContent.pick(s.name, lang)),
                      ),
                    OutlinedButton.icon(
                      onPressed: () => _addRoutine(context, ref, content),
                      icon: const Icon(Icons.playlist_add),
                      label: Text(l10n.groomingAddRoutine),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ],
    );
  }
}

/// Face outline (front camera, mirrored like the preview) and an oval guide.
class FaceOutlinePainter extends CustomPainter {
  FaceOutlinePainter({
    required this.face,
    required this.guideColor,
    required this.lineColor,
  });

  final FaceDetected? face;
  final Color guideColor;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(size.width / 2, size.height * 0.45),
          width: size.width * 0.62,
          height: size.height * 0.62),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = guideColor,
    );
    final f = face;
    if (f == null || f.outline.isEmpty) return;
    Offset at((double, double) p) {
      final x = p.$1 / f.imageWidth;
      return Offset((f.frontCamera ? 1 - x : x) * size.width,
          p.$2 / f.imageHeight * size.height);
    }

    final pts = [for (final p in f.outline) at(p)];
    final centre = pts.reduce((a, b) => a + b) / pts.length.toDouble();

    // Light mesh: spokes from the outline toward the centre and a ring at
    // mid-depth, then the outline with a soft glow and point markers.
    final mesh = Paint()
      ..color = lineColor.withValues(alpha: 0.28)
      ..strokeWidth = 1;
    final inner = [for (final p in pts) Offset.lerp(p, centre, 0.45)!];
    for (var i = 0; i < pts.length; i += 2) {
      canvas.drawLine(pts[i], inner[i], mesh);
    }
    canvas.drawPath(Path()..addPolygon(inner, true), mesh);

    final outline = Path()..addPolygon(pts, true);
    canvas.drawPath(
        outline,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9
          ..color = lineColor.withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    canvas.drawPath(
        outline,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = lineColor);
    final dot = Paint()..color = Colors.white;
    for (var i = 0; i < pts.length; i += 3) {
      canvas.drawCircle(pts[i], 2.2, dot);
    }
  }

  @override
  bool shouldRepaint(FaceOutlinePainter old) => old.face != face;
}
