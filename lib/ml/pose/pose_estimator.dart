/// On-device pose estimation contract (spec §15–16).
///
/// Implementations (MediaPipe / LiteRT / ONNX) plug in behind
/// [PoseEstimator] in Phase 6. Frames are processed in memory and never
/// persisted by this layer.
library;

import 'dart:typed_data';

/// A single camera frame handed to an ML model. Held in memory only.
class CameraFrame {
  const CameraFrame({
    required this.bytes,
    required this.width,
    required this.height,
    required this.rotationDegrees,
    required this.timestamp,
  });

  final Uint8List bytes;
  final int width;
  final int height;
  final int rotationDegrees;
  final DateTime timestamp;
}

/// Landmark indices follow the 33-point MediaPipe Pose topology.
enum PoseJoint {
  nose,
  leftEyeInner,
  leftEye,
  leftEyeOuter,
  rightEyeInner,
  rightEye,
  rightEyeOuter,
  leftEar,
  rightEar,
  mouthLeft,
  mouthRight,
  leftShoulder,
  rightShoulder,
  leftElbow,
  rightElbow,
  leftWrist,
  rightWrist,
  leftPinky,
  rightPinky,
  leftIndex,
  rightIndex,
  leftThumb,
  rightThumb,
  leftHip,
  rightHip,
  leftKnee,
  rightKnee,
  leftAnkle,
  rightAnkle,
  leftHeel,
  rightHeel,
  leftFootIndex,
  rightFootIndex,
}

/// Normalised landmark: x/y in [0, 1] of frame size, z relative depth.
class PoseLandmark {
  const PoseLandmark({
    required this.joint,
    required this.x,
    required this.y,
    required this.z,
    required this.visibility,
  });

  final PoseJoint joint;
  final double x;
  final double y;
  final double z;
  final double visibility;
}

/// Outcome of analysing one frame. Every failure mode is explicit so callers
/// can show guidance instead of fabricating results.
sealed class PoseEstimation {
  const PoseEstimation();
}

final class PoseDetected extends PoseEstimation {
  const PoseDetected({required this.landmarks, required this.score});
  final List<PoseLandmark> landmarks;

  /// Overall model confidence in [0, 1].
  final double score;
}

final class NoPersonDetected extends PoseEstimation {
  const NoPersonDetected();
}

enum FrameQualityIssue { tooDark, bodyOutOfFrame, tooFar, tooClose, motionBlur }

final class LowQualityFrame extends PoseEstimation {
  const LowQualityFrame(this.issues);
  final Set<FrameQualityIssue> issues;
}

enum UnavailableReason { modelNotInstalled, deviceUnsupported, runtimeError }

final class PoseUnavailable extends PoseEstimation {
  const PoseUnavailable(this.reason);
  final UnavailableReason reason;
}

abstract interface class PoseEstimator {
  Future<void> load();
  Future<PoseEstimation> estimate(CameraFrame frame);
  Future<void> dispose();
}

/// Used whenever no pose model is installed. Never returns landmarks.
class UnavailablePoseEstimator implements PoseEstimator {
  const UnavailablePoseEstimator([
    this.reason = UnavailableReason.modelNotInstalled,
  ]);

  final UnavailableReason reason;

  @override
  Future<void> load() async {}

  @override
  Future<PoseEstimation> estimate(CameraFrame frame) async =>
      PoseUnavailable(reason);

  @override
  Future<void> dispose() async {}
}
