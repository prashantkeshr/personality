/// On-device frame pipeline (spec §16, §69).
///
///   camera frame (memory) → frame selection → quality filter
///   → pose estimator → structured status → frame discarded
///
/// The pipeline never stores, copies or uploads frame bytes. It only emits a
/// [PipelineStatus] made of numbers and enums.
library;

import 'dart:typed_data';

import '../pose/pose_estimator.dart';
import '../preprocessing/frame_quality.dart';
import '../preprocessing/frame_sampler.dart';

/// A camera frame's luminance plane, valid only during [FramePipeline.process].
class FrameInput {
  const FrameInput({
    required this.yPlane,
    required this.width,
    required this.height,
    required this.bytesPerRow,
    required this.rotationDegrees,
    required this.timestamp,
    this.format = FrameFormat.luma,
    this.frontCamera = false,
    this.toNv21,
  });

  /// Builds NV21 bytes on demand for devices that deliver 3-plane YUV; only
  /// called for frames that actually reach the model.
  final Uint8List Function()? toNv21;

  /// Starts with the luminance plane; for [FrameFormat.nv21] the chroma
  /// follows it in the same buffer.
  final Uint8List yPlane;
  final FrameFormat format;
  final bool frontCamera;
  final int width;
  final int height;
  final int bytesPerRow;
  final int rotationDegrees;
  final DateTime timestamp;
}

/// Everything the UI learns from the camera. Contains no image data.
class PipelineStatus {
  const PipelineStatus({
    required this.lighting,
    required this.meanLuma,
    required this.analyzedFrames,
    required this.skippedFrames,
    required this.analysisFps,
    required this.pose,
  });

  static const initial = PipelineStatus(
    lighting: null,
    meanLuma: null,
    analyzedFrames: 0,
    skippedFrames: 0,
    analysisFps: 0,
    pose: null,
  );

  final LightingLevel? lighting;
  final double? meanLuma;
  final int analyzedFrames;
  final int skippedFrames;

  /// Measured analysis rate over the last second.
  final double analysisFps;

  /// Last pose outcome. Never a fabricated result: when no model is
  /// installed this is [PoseUnavailable].
  final PoseEstimation? pose;
}

class FramePipeline {
  FramePipeline({
    required int targetFps,
    required this.estimator,
    required this.onStatus,
  }) : _sampler = FrameSampler(targetFps: targetFps);

  final PoseEstimator estimator;
  final void Function(PipelineStatus) onStatus;
  final FrameSampler _sampler;
  final _recent = <DateTime>[];
  bool _closed = false;

  int get analyzedFrames => _sampler.accepted;
  int get skippedFrames => _sampler.skipped;

  /// Analyzes [frame] if the sampler accepts it. The caller may reuse or
  /// release the frame buffer as soon as this returns.
  Future<void> process(FrameInput frame) async {
    if (_closed || !_sampler.accept(frame.timestamp)) return;
    try {
      final quality = FrameQualityAnalyzer.analyze(
        yPlane: frame.yPlane,
        width: frame.width,
        height: frame.height,
        bytesPerRow: frame.bytesPerRow,
      );

      // Only usable frames reach the (comparatively expensive) estimator.
      PoseEstimation? pose;
      if (quality.usable) {
        final converted = frame.toNv21?.call();
        pose = await estimator.estimate(CameraFrame(
          bytes: converted ?? frame.yPlane,
          width: frame.width,
          height: frame.height,
          bytesPerRow: converted != null ? frame.width : frame.bytesPerRow,
          rotationDegrees: frame.rotationDegrees,
          timestamp: frame.timestamp,
          format: converted != null ? FrameFormat.nv21 : frame.format,
          frontCamera: frame.frontCamera,
        ));
      } else {
        pose = LowQualityFrame({
          switch (quality.lighting) {
            LightingLevel.tooBright => FrameQualityIssue.tooBright,
            LightingLevel.lowContrast => FrameQualityIssue.lowContrast,
            _ => FrameQualityIssue.tooDark,
          },
        });
      }

      _recent
        ..add(frame.timestamp)
        ..removeWhere((t) =>
            frame.timestamp.difference(t) > const Duration(seconds: 1));
      if (_closed) return;
      onStatus(PipelineStatus(
        lighting: quality.lighting,
        meanLuma: quality.meanLuma,
        analyzedFrames: _sampler.accepted,
        skippedFrames: _sampler.skipped,
        analysisFps: _recent.length.toDouble(),
        pose: pose,
      ));
    } finally {
      _sampler.done();
    }
  }

  void close() => _closed = true;
}
