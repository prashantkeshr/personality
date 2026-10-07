import 'dart:ui' show Size;

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'
    as mlkit;

import '../../core/logging/app_logger.dart';
import 'pose_estimator.dart';

/// On-device BlazePose via Google ML Kit (bundled model; no download and no
/// network — the release app has no INTERNET permission).
class MlKitPoseEstimator implements PoseEstimator {
  MlKitPoseEstimator({this.accurate = false});

  /// Use the larger "accurate" model (high-tier devices only).
  final bool accurate;
  mlkit.PoseDetector? _detector;

  @override
  Future<void> load() async {
    _detector ??= mlkit.PoseDetector(
      options: mlkit.PoseDetectorOptions(
        mode: mlkit.PoseDetectionMode.stream,
        model: accurate
            ? mlkit.PoseDetectionModel.accurate
            : mlkit.PoseDetectionModel.base,
      ),
    );
  }

  static mlkit.InputImageRotation _rotation(int degrees) =>
      switch (degrees % 360) {
        90 => mlkit.InputImageRotation.rotation90deg,
        180 => mlkit.InputImageRotation.rotation180deg,
        270 => mlkit.InputImageRotation.rotation270deg,
        _ => mlkit.InputImageRotation.rotation0deg,
      };

  @override
  Future<PoseEstimation> estimate(CameraFrame frame) async {
    if (frame.format != FrameFormat.nv21) {
      return const PoseUnavailable(UnavailableReason.deviceUnsupported);
    }
    try {
      await load();
      final input = mlkit.InputImage.fromBytes(
        bytes: frame.bytes,
        metadata: mlkit.InputImageMetadata(
          size: Size(frame.width.toDouble(), frame.height.toDouble()),
          rotation: _rotation(frame.rotationDegrees),
          format: mlkit.InputImageFormat.nv21,
          bytesPerRow: frame.bytesPerRow,
        ),
      );
      final poses = await _detector!.processImage(input);
      if (poses.isEmpty) return const NoPersonDetected();

      // Landmarks come back in upright-image pixels.
      final w = frame.uprightWidth.toDouble();
      final h = frame.uprightHeight.toDouble();
      final pose = poses.first;
      final landmarks = <PoseLandmark>[];
      var sum = 0.0;
      for (final e in pose.landmarks.entries) {
        final joint = PoseJoint.values[e.key.index];
        final l = e.value;
        landmarks.add(PoseLandmark(
          joint: joint,
          x: l.x / w,
          y: l.y / h,
          z: l.z / w,
          visibility: l.likelihood,
        ));
        sum += l.likelihood;
      }
      return PoseDetected(
        landmarks: landmarks,
        score: landmarks.isEmpty ? 0 : sum / landmarks.length,
        imageWidth: frame.uprightWidth,
        imageHeight: frame.uprightHeight,
        frontCamera: frame.frontCamera,
      );
    } catch (e, st) {
      AppLogger.error('pose.estimate', e, st);
      return const PoseUnavailable(UnavailableReason.runtimeError);
    }
  }

  @override
  Future<void> dispose() async {
    await _detector?.close();
    _detector = null;
  }
}
