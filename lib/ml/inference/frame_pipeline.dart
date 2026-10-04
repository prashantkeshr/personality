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
  });

  final Uint8List yPlane;
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
        pose = await estimator.estimate(CameraFrame(
          bytes: frame.yPlane,
          width: frame.width,
          height: frame.height,
          rotationDegrees: frame.rotationDegrees,
          timestamp: frame.timestamp,
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
