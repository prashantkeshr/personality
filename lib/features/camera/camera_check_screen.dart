import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/device/device_tier.dart';
import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../ml/inference/frame_pipeline.dart';
import '../../ml/pose/pose_estimator.dart';
import '../../ml/preprocessing/frame_quality.dart';
import '../../shared/widgets/empty_state.dart';
import 'camera_providers.dart';
import 'camera_source.dart';

/// Camera check (spec §17): live preview, lighting indicator, on-device
/// processing status and power modes. Frames are analyzed in memory and
/// discarded; nothing is recorded or uploaded.
class CameraCheckScreen extends ConsumerStatefulWidget {
  const CameraCheckScreen({super.key});

  @override
  ConsumerState<CameraCheckScreen> createState() => _CameraCheckScreenState();
}

class _CameraCheckScreenState extends ConsumerState<CameraCheckScreen> {
  late final CameraSource _camera = ref.read(cameraSourceProvider);
  late final AppLifecycleListener _lifecycle;
  FramePipeline? _pipeline;
  PipelineStatus _status = PipelineStatus.initial;
  CameraLens _lens = CameraLens.back;
  List<CameraLens> _lenses = const [];
  bool _wantRunning = false;

  @override
  void initState() {
    super.initState();
    // Release the camera whenever the app leaves the foreground.
    _lifecycle = AppLifecycleListener(
      onHide: _pause,
      onShow: () {
        if (_wantRunning) _start();
      },
    );
    _camera.lenses().then((l) {
      if (!mounted) return;
      setState(() {
        _lenses = l;
        if (l.isNotEmpty && !l.contains(_lens)) _lens = l.first;
      });
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _pipeline?.close();
    _camera.stop();
    super.dispose();
  }

  /// [mode] overrides the saved preference, used right after changing it
  /// (the saved value reaches the provider asynchronously).
  Future<void> _start({CameraPowerMode? mode}) async {
    _wantRunning = true;
    _pipeline?.close();
    final CameraPowerMode selected = mode ?? ref.read(cameraPowerModeProvider);
    final pipeline = FramePipeline(
      targetFps: selected.analysisFps,
      estimator: ref.read(poseEstimatorProvider),
      onStatus: (s) {
        if (mounted) setState(() => _status = s);
      },
    );
    _pipeline = pipeline;
    setState(() => _status = PipelineStatus.initial);
    await _camera.start(_lens, selected, pipeline.process);
  }

  Future<void> _pause() async {
    _pipeline?.close();
    await _camera.stop();
  }

  Future<void> _stop() async {
    _wantRunning = false;
    await _pause();
  }

  Future<void> _setMode(CameraPowerMode mode) async {
    try {
      await ref.read(cameraSettingsRepositoryProvider).setMode(mode);
      if (_camera.state.value.running) await _start(mode: mode);
    } catch (e, st) {
      AppLogger.error('camera.mode', e, st);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final specs = ref.watch(deviceSpecsProvider);
    final hasCamera = specs.value?.hasCamera ?? true;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.featureCameraCheck),
        actions: [
          if (_lenses.length > 1)
            IconButton(
              tooltip: l10n.cameraSwitch,
              icon: const Icon(Icons.cameraswitch_outlined),
              onPressed: () {
                setState(() => _lens = _lens == CameraLens.back
                    ? CameraLens.front
                    : CameraLens.back);
                if (_camera.state.value.running) _start();
              },
            ),
        ],
      ),
      body: !hasCamera
          ? Center(
              child: EmptyState(
                icon: Icons.no_photography_outlined,
                title: l10n.featureCameraCheck,
                message: l10n.cameraUnavailable,
              ),
            )
          : ValueListenableBuilder<CameraSourceState>(
              valueListenable: _camera.state,
              builder: (context, state, _) => ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  _PreviewArea(
                    camera: _camera,
                    state: state,
                    status: _status,
                    onStart: _start,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (state.running)
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: OutlinedButton.icon(
                        onPressed: _stop,
                        icon: const Icon(Icons.stop_circle_outlined),
                        label: Text(l10n.cameraStop),
                      ),
                    ),
                  if (state.running) ...[
                    const SizedBox(height: AppSpacing.md),
                    _StatusPanel(status: _status),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  _PowerModePicker(onChanged: _setMode),
                  const SizedBox(height: AppSpacing.lg),
                  Text(l10n.cameraPrivacyNote,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
    );
  }
}

class _PreviewArea extends StatelessWidget {
  const _PreviewArea({
    required this.camera,
    required this.state,
    required this.status,
    required this.onStart,
  });

  final CameraSource camera;
  final CameraSourceState state;
  final PipelineStatus status;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (state.running) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 300,
                  height: 300 * (state.previewAspectRatio ?? 4 / 3),
                  child: camera.preview(),
                ),
              ),
            ),
            PositionedDirectional(
              top: AppSpacing.sm,
              start: AppSpacing.sm,
              child: _Badge(
                  icon: Icons.memory, text: l10n.cameraProcessingOnDevice),
            ),
            if (status.lighting != null)
              PositionedDirectional(
                bottom: AppSpacing.sm,
                start: AppSpacing.sm,
                child: _Badge(
                  icon: lightingIcon(status.lighting!),
                  text: lightingLabel(l10n, status.lighting!),
                ),
              ),
          ],
        ),
      );
    }

    final message = switch (state.problem) {
      CameraProblem.permissionDenied => l10n.cameraPermissionDenied,
      CameraProblem.noCamera => l10n.cameraUnavailable,
      CameraProblem.failed => l10n.cameraFailed,
      null => l10n.cameraIntro,
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Icon(
              state.problem == null
                  ? Icons.photo_camera_outlined
                  : Icons.no_photography_outlined,
              size: 40,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: state.starting ? null : onStart,
              icon: const Icon(Icons.videocam_outlined),
              label: Text(state.problem == null
                  ? l10n.cameraStart
                  : l10n.actionRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(text,
                style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      );
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.status});

  final PipelineStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pose = status.pose;
    final poseText = switch (pose) {
      null => l10n.cameraWaiting,
      PoseUnavailable() => l10n.poseModelRequired,
      LowQualityFrame(:final issues) => qualityAdvice(l10n, issues.first),
      NoPersonDetected() => l10n.poseNoPerson,
      PoseDetected() => l10n.posePersonDetected,
    };
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(status.lighting == null
                ? Icons.wb_incandescent_outlined
                : lightingIcon(status.lighting!)),
            title: Text(l10n.cameraLighting),
            subtitle: Text(status.lighting == null
                ? l10n.cameraWaiting
                : lightingAdvice(l10n, status.lighting!)),
          ),
          ListTile(
            leading: const Icon(Icons.accessibility_new),
            title: Text(l10n.featurePosture),
            subtitle: Text(poseText),
          ),
          ListTile(
            leading: const Icon(Icons.speed_outlined),
            title: Text(l10n.cameraAnalysisRate),
            subtitle: Text(l10n.cameraFramesStats(
                status.analysisFps.round(), status.analyzedFrames)),
          ),
        ],
      ),
    );
  }
}

class _PowerModePicker extends ConsumerWidget {
  const _PowerModePicker({required this.onChanged});

  final ValueChanged<CameraPowerMode> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(cameraPowerModeProvider);
    final explanation = switch (mode) {
      CameraPowerMode.lowPower => l10n.powerLowNote,
      CameraPowerMode.standard => l10n.powerStandardNote,
      CameraPowerMode.highAccuracy => l10n.powerHighNote,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.cameraPowerMode,
            style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        SegmentedButton<CameraPowerMode>(
          segments: [
            ButtonSegment(
                value: CameraPowerMode.lowPower, label: Text(l10n.powerLow)),
            ButtonSegment(
                value: CameraPowerMode.standard,
                label: Text(l10n.powerStandard)),
            ButtonSegment(
                value: CameraPowerMode.highAccuracy,
                label: Text(l10n.powerHigh)),
          ],
          selected: {mode},
          showSelectedIcon: false,
          onSelectionChanged: (s) => onChanged(s.single),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(explanation, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

IconData lightingIcon(LightingLevel l) => switch (l) {
      LightingLevel.good => Icons.wb_sunny_outlined,
      LightingLevel.dim => Icons.wb_twilight,
      LightingLevel.tooDark => Icons.nightlight_outlined,
      LightingLevel.tooBright => Icons.flare,
      LightingLevel.lowContrast => Icons.blur_on,
    };

String lightingLabel(AppLocalizations l10n, LightingLevel l) => switch (l) {
      LightingLevel.good => l10n.lightingGood,
      LightingLevel.dim => l10n.lightingDim,
      LightingLevel.tooDark => l10n.lightingTooDark,
      LightingLevel.tooBright => l10n.lightingTooBright,
      LightingLevel.lowContrast => l10n.lightingLowContrast,
    };

String lightingAdvice(AppLocalizations l10n, LightingLevel l) => switch (l) {
      LightingLevel.good => l10n.lightingGoodAdvice,
      LightingLevel.dim => l10n.lightingDimAdvice,
      LightingLevel.tooDark => l10n.lightingTooDarkAdvice,
      LightingLevel.tooBright => l10n.lightingTooBrightAdvice,
      LightingLevel.lowContrast => l10n.lightingLowContrastAdvice,
    };

String qualityAdvice(AppLocalizations l10n, FrameQualityIssue i) => switch (i) {
      FrameQualityIssue.tooDark => l10n.lightingTooDarkAdvice,
      FrameQualityIssue.tooBright => l10n.lightingTooBrightAdvice,
      FrameQualityIssue.lowContrast => l10n.lightingLowContrastAdvice,
      FrameQualityIssue.bodyOutOfFrame ||
      FrameQualityIssue.tooFar ||
      FrameQualityIssue.tooClose =>
        l10n.poseReposition,
      FrameQualityIssue.motionBlur => l10n.poseHoldStill,
    };
