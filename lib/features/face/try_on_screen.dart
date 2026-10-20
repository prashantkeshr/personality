import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/body.dart' show StyleFit;
import '../../domain/entities/grooming.dart';
import '../../domain/entities/makeup.dart';
import '../../l10n/app_localizations.dart';
import '../../ml/face/face_estimator.dart';
import '../../ml/inference/frame_pipeline.dart';
import '../../ml/pose/pose_estimator.dart';
import '../../shared/visual/hair_art.dart';
import '../../shared/visual/style_art.dart';
import '../camera/camera_providers.dart';
import '../camera/camera_source.dart';
import '../camera/camera_stage.dart';
import '../camera/portrait_lock.dart';
import '../health/body_providers.dart' show profileProvider;
import '../style/style_providers.dart' show styleProfileProvider;
import 'face_providers.dart';
import 'try_on_painter.dart';

/// Live try-on (front camera): hair, glasses, beard, lip and blush previews
/// that follow the face. Nothing is recorded; frames are analyzed in memory
/// and discarded.
class TryOnScreen extends ConsumerStatefulWidget {
  const TryOnScreen({
    super.key,
    this.initialItem,
    this.initialColor,
    this.initialLip,
    this.initialBlush,
  });

  final String? initialItem;

  /// Frame colour as `RRGGBB` (from the glasses finder).
  final String? initialColor;

  /// Lip and blush shades as `RRGGBB` (from the makeup guide).
  final String? initialLip;
  final String? initialBlush;

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
  HairShape? _hair;
  Color _hairColour = hairColours[1];
  late Color? _lip = _hex(widget.initialLip);
  late Color? _blush = _hex(widget.initialBlush);
  bool _hairFromItem = false;

  static Color? _hex(String? v) => switch (int.tryParse(v ?? '', radix: 16)) {
    final c? when v!.length == 6 => Color(0xFF000000 | c),
    _ => null,
  };
  bool _compare = false;
  late final Color _frameColor = switch (int.tryParse(widget.initialColor ?? '', radix: 16)) {
    final v? when (widget.initialColor?.length ?? 0) == 6 => Color(0xFF000000 | v),
    _ => const Color(0xFF1C1C1E),
  };

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
    final fit = ref.watch(profileProvider).value?.effectiveStyleFit ??
        StyleFit.all;
    final beardItems = content?.items.values
            .where((i) => i.kind == StyleKind.beard && i.suits(fit))
            .toList() ??
        const [];
    final hairItems = content?.items.values
            .where((i) =>
                i.kind == StyleKind.hair &&
                i.suits(fit) &&
                HairShape.fromName(i.hair) != null)
            .toList() ??
        const [];
    // A hairstyle opened from its card starts on.
    if (!_hairFromItem && content != null) {
      _hairFromItem = true;
      _hair = HairShape.fromName(content.items[widget.initialItem]?.hair);
    }
    final makeup = ref.watch(makeupContentProvider).value;
    final undertone = ref.watch(styleProfileProvider).value?.undertone;
    final lips = makeup?.shades(MakeupArea.lips, undertone) ?? const [];
    final blushes = makeup?.shades(MakeupArea.blush, undertone) ?? const [];

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
          padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
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
                    hair: _hair,
                    hairColor: _hairColour,
                    lipColor: _lip,
                    blushColor: _blush,
                    frameColor: _frameColor,
                  ),
                ),
              ),
            if (hairItems.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.styleHair, style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              SingleChildScrollView(
                key: const Key('try-on-hair'),
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  chip(l10n.tryOnNone, _hair == null,
                      () => setState(() => _hair = null)),
                  for (final i in hairItems)
                    chip(
                      GroomingContent.pick(i.name, lang),
                      _hair == HairShape.fromName(i.hair),
                      () => setState(() => _hair = HairShape.fromName(i.hair)),
                      avatar: SizedBox(
                        width: 24,
                        height: 24,
                        child: HairArt(
                          shape: HairShape.fromName(i.hair)!,
                          colour: _hairColour,
                        ),
                      ),
                    ),
                ]),
              ),
              if (_hair != null) ...[
                const SizedBox(height: AppSpacing.xs),
                _Swatches(
                  colours: hairColours,
                  selected: _hairColour,
                  onPick: (c) => setState(() => _hairColour = c!),
                ),
              ],
            ],
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
            if (beardItems.isNotEmpty) ...[
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
            ],
            if (lips.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(l10n.makeupLips, style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              _Swatches(
                key: const Key('try-on-lips'),
                colours: [for (final s in lips) Color(s.argb)],
                selected: _lip,
                allowNone: true,
                onPick: (c) => setState(() => _lip = c),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.makeupBlush, style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              _Swatches(
                key: const Key('try-on-blush'),
                colours: [for (final s in blushes) Color(s.argb)],
                selected: _blush,
                allowNone: true,
                onPick: (c) => setState(() => _blush = c),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.tryOnNote, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// A row of colour dots; [allowNone] adds a "none" dot first.
class _Swatches extends StatelessWidget {
  const _Swatches({
    super.key,
    required this.colours,
    required this.selected,
    required this.onPick,
    this.allowNone = false,
  });

  final List<Color> colours;
  final Color? selected;
  final ValueChanged<Color?> onPick;
  final bool allowNone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget dot(Color? c) {
      final on = c == selected;
      return Padding(
        padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
        child: InkResponse(
          onTap: () => onPick(c),
          radius: 24,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: c ?? scheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(
                color: on ? scheme.primary : scheme.outlineVariant,
                width: on ? 3 : 1,
              ),
            ),
            child: c == null
                ? Icon(Icons.block, size: 18, color: scheme.onSurfaceVariant)
                : on
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : null,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        if (allowNone) dot(null),
        for (final c in colours) dot(c),
      ]),
    );
  }
}
