/// On-device pose estimation contract (spec §15–16).
///
/// Implementations (MediaPipe / LiteRT / ONNX) plug in behind
/// [PoseEstimator] in Phase 6. Frames are processed in memory and never
/// persisted by this layer.
library;

import 'dart:typed_data';

/// Pixel layout of [CameraFrame.bytes].
enum FrameFormat {
  /// Android NV21: full-resolution Y plane followed by interleaved VU.
  nv21,

  /// Luminance plane only (enough for lighting checks, not for models).
  luma,
}

/// A single camera frame handed to an ML model. Held in memory only.
class CameraFrame {
  const CameraFrame({
    required this.bytes,
    required this.width,
    required this.height,
    required this.rotationDegrees,
    required this.timestamp,
    int? bytesPerRow,
    this.format = FrameFormat.luma,
    this.frontCamera = false,
  }) : bytesPerRow = bytesPerRow ?? width;

  final Uint8List bytes;

  /// Sensor (unrotated) size in pixels.
  final int width;
  final int height;
  final int bytesPerRow;

  /// Clockwise rotation that makes the frame upright.
  final int rotationDegrees;
  final DateTime timestamp;
  final FrameFormat format;
  final bool frontCamera;

  /// Size after applying [rotationDegrees].
  int get uprightWidth => rotationDegrees % 180 == 0 ? width : height;
  int get uprightHeight => rotationDegrees % 180 == 0 ? height : width;
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
  const PoseDetected({
    required this.landmarks,
    required this.score,
    this.imageWidth = 1,
    this.imageHeight = 1,
    this.frontCamera = false,
  });

  /// Normalized to the upright image: x, y in [0, 1].
  final List<PoseLandmark> landmarks;

  /// Overall model confidence in [0, 1].
  final double score;

  /// Upright image size in pixels; angles use real proportions.
  final int imageWidth;
  final int imageHeight;

  /// Preview of a front camera is mirrored; overlays must mirror x.
  final bool frontCamera;

  PoseLandmark? operator [](PoseJoint joint) {
    for (final l in landmarks) {
      if (l.joint == joint) return l;
    }
    return null;
  }
}

final class NoPersonDetected extends PoseEstimation {
  const NoPersonDetected();
}

enum FrameQualityIssue {
  tooDark,
  tooBright,
  lowContrast,
  bodyOutOfFrame,
  tooFar,
  tooClose,
  motionBlur,

  /// Neither clearly facing the camera nor clearly sideways.
  unclearView,

  /// Key landmarks were detected with too little confidence.
  lowVisibility,
}

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
