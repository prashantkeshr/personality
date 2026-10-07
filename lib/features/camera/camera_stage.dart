import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../ml/pose/pose_estimator.dart';
import '../posture/skeleton_overlay.dart';
import 'camera_source.dart';

/// Live camera preview with landmark overlay, body guide, an on-device
/// badge, a guidance line and an optional large countdown/counter.
class CameraStage extends StatelessWidget {
  const CameraStage({
    super.key,
    required this.camera,
    required this.state,
    required this.pose,
    required this.guidance,
    this.countdown,
    this.overlay,
    this.painter,
  });

  final CameraSource camera;
  final CameraSourceState state;
  final PoseDetected? pose;
  final String guidance;
  final int? countdown;

  /// Shown at the top-right, e.g. a rep counter or hold timer.
  final Widget? overlay;

  /// Replaces the default body skeleton and guide (e.g. a face outline).
  final CustomPainter? painter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final aspect = state.previewAspectRatio ?? 4 / 3;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: state.running
                ? FittedBox(
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: 300,
                      height: 300 * aspect,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          camera.preview(),
                          CustomPaint(
                            painter: painter ?? SkeletonPainter(
                              pose: pose,
                              guideColor: Colors.white.withValues(alpha: 0.7),
                              boneColor: scheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const ColoredBox(
                    color: Colors.black,
                    child: Center(child: CircularProgressIndicator()),
                  ),
          ),
          PositionedDirectional(
            top: AppSpacing.sm,
            start: AppSpacing.sm,
            child: InfoPill(text: l10n.cameraProcessingOnDevice, icon: Icons.memory),
          ),
          if (overlay != null)
            PositionedDirectional(
              top: AppSpacing.sm,
              end: AppSpacing.sm,
              child: overlay!,
            ),
          if (countdown != null)
            Positioned.fill(
              child: Center(
                child: Semantics(
                  liveRegion: true,
                  label: l10n.postureCountdown(countdown!),
                  child: Text(
                    '$countdown',
                    style: const TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 12)],
                    ),
                  ),
                ),
              ),
            ),
          PositionedDirectional(
            bottom: AppSpacing.sm,
            start: AppSpacing.sm,
            end: AppSpacing.sm,
            child: Semantics(
              liveRegion: true,
              child: InfoPill(text: guidance, icon: Icons.info_outline),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoPill extends StatelessWidget {
  const InfoPill({super.key, required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Flexible(
              child: Text(text,
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ],
        ),
      );
}

class CameraProblemCard extends StatelessWidget {
  const CameraProblemCard(
      {super.key, required this.problem, required this.onRetry});

  final CameraProblem problem;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            const Icon(Icons.no_photography_outlined, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text(
              switch (problem) {
                CameraProblem.permissionDenied => l10n.cameraPermissionDenied,
                CameraProblem.noCamera => l10n.cameraUnavailable,
                CameraProblem.failed => l10n.cameraFailed,
              },
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onRetry, child: Text(l10n.actionRetry)),
          ],
        ),
      ),
    );
  }
}
