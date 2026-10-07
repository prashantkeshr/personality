import 'dart:ui' show Size;

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'
    as mlkit;

import '../../core/logging/app_logger.dart';
import '../pose/pose_estimator.dart' show CameraFrame, FrameFormat;
import 'face_estimator.dart';

/// Face outline via Google ML Kit (bundled model, offline). Contours only:
/// no classification (smile/eyes) and no identity features are requested.
class MlKitFaceEstimator implements FaceEstimator {
  mlkit.FaceDetector? _detector;

  static mlkit.InputImageRotation _rotation(int degrees) =>
      switch (degrees % 360) {
        90 => mlkit.InputImageRotation.rotation90deg,
        180 => mlkit.InputImageRotation.rotation180deg,
        270 => mlkit.InputImageRotation.rotation270deg,
        _ => mlkit.InputImageRotation.rotation0deg,
      };

  @override
  Future<FaceEstimation> estimate(CameraFrame frame) async {
    if (frame.format != FrameFormat.nv21) {
      return const FaceUnavailable(FaceUnavailableReason.deviceUnsupported);
    }
    try {
      _detector ??= mlkit.FaceDetector(
        options: mlkit.FaceDetectorOptions(
          enableContours: true,
          performanceMode: mlkit.FaceDetectorMode.accurate,
          minFaceSize: 0.15,
        ),
      );
      final faces = await _detector!.processImage(mlkit.InputImage.fromBytes(
        bytes: frame.bytes,
        metadata: mlkit.InputImageMetadata(
          size: Size(frame.width.toDouble(), frame.height.toDouble()),
          rotation: _rotation(frame.rotationDegrees),
          format: mlkit.InputImageFormat.nv21,
          bytesPerRow: frame.bytesPerRow,
        ),
      ));
      if (faces.isEmpty) return const NoFaceDetected();
      if (faces.length > 1) return const MultipleFaces();
      final f = faces.first;
      final points = f.contours[mlkit.FaceContourType.face]?.points ?? const [];
      if (points.length < 30) return const NoFaceDetected();
      return FaceDetected(
        outline: [for (final p in points) (p.x.toDouble(), p.y.toDouble())],
        yaw: f.headEulerAngleY ?? 0,
        roll: f.headEulerAngleZ ?? 0,
        pitch: f.headEulerAngleX ?? 0,
        boxHeight: f.boundingBox.height / frame.uprightHeight,
        imageWidth: frame.uprightWidth,
        imageHeight: frame.uprightHeight,
        frontCamera: frame.frontCamera,
      );
    } catch (e, st) {
      AppLogger.error('face.estimate', e, st);
      return const FaceUnavailable(FaceUnavailableReason.runtimeError);
    }
  }

  @override
  Future<void> dispose() async {
    await _detector?.close();
    _detector = null;
  }
}
