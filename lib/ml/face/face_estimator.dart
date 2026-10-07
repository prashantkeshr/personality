/// On-device face geometry contract (spec §20–21).
///
/// Produces only geometry (outline points and head angles) — never an
/// image, identity or attribute guess. Frames stay in memory.
library;

import '../pose/pose_estimator.dart' show CameraFrame;

sealed class FaceEstimation {
  const FaceEstimation();
}

final class FaceDetected extends FaceEstimation {
  const FaceDetected({
    required this.outline,
    required this.yaw,
    required this.roll,
    required this.pitch,
    required this.boxHeight,
    required this.imageWidth,
    required this.imageHeight,
    this.frontCamera = false,
    this.leftEye,
    this.rightEye,
    this.noseBottom,
    this.upperLip,
    this.lowerLip,
  });

  /// Feature points in upright-image pixels, used for try-on placement.
  final (double, double)? leftEye;
  final (double, double)? rightEye;
  final (double, double)? noseBottom;
  final List<(double, double)>? upperLip;
  final List<(double, double)>? lowerLip;

  /// Face outline in upright-image pixels (36 points, clockwise from the
  /// top centre of the forehead).
  final List<(double, double)> outline;

  /// Head rotation in degrees: turn left/right, tilt sideways, nod.
  final double yaw;
  final double roll;
  final double pitch;

  /// Face height as a fraction of the image height.
  final double boxHeight;
  final int imageWidth;
  final int imageHeight;
  final bool frontCamera;
}

final class NoFaceDetected extends FaceEstimation {
  const NoFaceDetected();
}

final class MultipleFaces extends FaceEstimation {
  const MultipleFaces();
}

enum FaceUnavailableReason { modelNotInstalled, deviceUnsupported, runtimeError }

final class FaceUnavailable extends FaceEstimation {
  const FaceUnavailable(this.reason);
  final FaceUnavailableReason reason;
}

abstract interface class FaceEstimator {
  Future<FaceEstimation> estimate(CameraFrame frame);
  Future<void> dispose();
}

class UnavailableFaceEstimator implements FaceEstimator {
  const UnavailableFaceEstimator();

  @override
  Future<FaceEstimation> estimate(CameraFrame frame) async =>
      const FaceUnavailable(FaceUnavailableReason.modelNotInstalled);

  @override
  Future<void> dispose() async {}
}
