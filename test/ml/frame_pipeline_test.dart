import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/device/device_tier.dart';
import 'package:personality/core/features/feature_registry.dart';
import 'package:personality/ml/inference/frame_pipeline.dart';
import 'package:personality/ml/pose/pose_estimator.dart';
import 'package:personality/ml/preprocessing/frame_quality.dart';
import 'package:personality/ml/preprocessing/frame_sampler.dart';

/// Checkerboard luminance plane with optional row padding.
Uint8List plane(int w, int h, int a, int b, {int padding = 0, int pad = 255}) {
  final bpr = w + padding;
  final out = Uint8List(bpr * h);
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < bpr; x++) {
      out[y * bpr + x] = x >= w ? pad : ((x + y).isEven ? a : b);
    }
  }
  return out;
}

FrameQuality quality(int a, int b, {int padding = 0}) =>
    FrameQualityAnalyzer.analyze(
      yPlane: plane(64, 48, a, b, padding: padding),
      width: 64,
      height: 48,
      bytesPerRow: 64 + padding,
    );

class CountingEstimator implements PoseEstimator {
  int calls = 0;
  @override
  Future<void> load() async {}
  @override
  Future<PoseEstimation> estimate(CameraFrame frame) async {
    calls++;
    return const NoPersonDetected();
  }

  @override
  Future<void> dispose() async {}
}

FrameInput frame(DateTime t, int a, int b) => FrameInput(
      yPlane: plane(64, 48, a, b),
      width: 64,
      height: 48,
      bytesPerRow: 64,
      rotationDegrees: 90,
      timestamp: t,
    );

void main() {
  group('FrameQualityAnalyzer', () {
    test('classifies lighting from real luminance', () {
      expect(quality(10, 30).lighting, LightingLevel.tooDark);
      expect(quality(50, 80).lighting, LightingLevel.dim);
      expect(quality(100, 160).lighting, LightingLevel.good);
      expect(quality(230, 250).lighting, LightingLevel.tooBright);
      expect(quality(120, 120).lighting, LightingLevel.lowContrast);
      expect(quality(100, 160).meanLuma, closeTo(130, 0.5));
    });

    test('ignores row padding beyond the image width', () {
      // Padding bytes are 255; they must not brighten a dark frame.
      expect(quality(10, 30, padding: 32).lighting, LightingLevel.tooDark);
    });

    test('only good and dim frames are usable', () {
      expect(quality(100, 160).usable, isTrue);
      expect(quality(50, 80).usable, isTrue);
      expect(quality(10, 30).usable, isFalse);
    });
  });

  group('FrameSampler', () {
    test('throttles to the target rate', () {
      final s = FrameSampler(targetFps: 10);
      final t0 = DateTime(2026);
      expect(s.accept(t0), isTrue);
      s.done();
      expect(s.accept(t0.add(const Duration(milliseconds: 50))), isFalse);
      expect(s.accept(t0.add(const Duration(milliseconds: 100))), isTrue);
      s.done();
      expect((s.accepted, s.skipped), (2, 1));
    });

    test('drops frames while the previous one is still being analyzed', () {
      final s = FrameSampler(targetFps: 10);
      final t0 = DateTime(2026);
      expect(s.accept(t0), isTrue);
      expect(s.accept(t0.add(const Duration(seconds: 1))), isFalse);
      s.done();
      expect(s.accept(t0.add(const Duration(seconds: 2))), isTrue);
    });
  });

  group('FramePipeline', () {
    test('dark frames never reach the estimator; good ones do', () async {
      final estimator = CountingEstimator();
      final statuses = <PipelineStatus>[];
      final p = FramePipeline(
          targetFps: 10, estimator: estimator, onStatus: statuses.add);
      final t0 = DateTime(2026);

      await p.process(frame(t0, 10, 30));
      expect(estimator.calls, 0);
      expect(statuses.last.pose, isA<LowQualityFrame>());
      expect((statuses.last.pose as LowQualityFrame).issues,
          {FrameQualityIssue.tooDark});

      await p.process(frame(t0.add(const Duration(milliseconds: 200)), 100, 160));
      expect(estimator.calls, 1);
      expect(statuses.last.lighting, LightingLevel.good);
      expect(statuses.last.pose, isA<NoPersonDetected>());
      expect(statuses.last.analyzedFrames, 2);
    });

    test('without a model it reports unavailable, never a result', () async {
      PipelineStatus? last;
      final p = FramePipeline(
          targetFps: 10,
          estimator: const UnavailablePoseEstimator(),
          onStatus: (s) => last = s);
      await p.process(frame(DateTime(2026), 100, 160));
      expect(last!.pose, isA<PoseUnavailable>());
    });

    test('measures the analysis rate over the last second', () async {
      PipelineStatus? last;
      final p = FramePipeline(
          targetFps: 10,
          estimator: CountingEstimator(),
          onStatus: (s) => last = s);
      final t0 = DateTime(2026);
      for (var i = 0; i < 20; i++) {
        await p.process(
            frame(t0.add(Duration(milliseconds: 50 * i)), 100, 160));
      }
      // 20 frames at 20 fps offered, throttled to ~10 per second.
      expect(last!.analysisFps, inInclusiveRange(9, 11));
      expect(last!.skippedFrames, greaterThan(0));
    });

    test('a closed pipeline ignores further frames', () async {
      var count = 0;
      final p = FramePipeline(
          targetFps: 10,
          estimator: CountingEstimator(),
          onStatus: (_) => count++);
      p.close();
      await p.process(frame(DateTime(2026), 100, 160));
      expect(count, 0);
    });
  });

  group('device rules', () {
    test("Android's low-RAM flag always means low tier", () {
      expect(
          classifyDevice(const DeviceSpecs(
              ramMb: 12000, cpuCores: 8, lowRamDevice: true)),
          DeviceTier.low);
    });

    test('power mode defaults follow the tier', () {
      expect(CameraPowerMode.defaultFor(DeviceTier.low),
          CameraPowerMode.lowPower);
      expect(CameraPowerMode.defaultFor(DeviceTier.high),
          CameraPowerMode.standard);
      expect(CameraPowerMode.fromName('highAccuracy'),
          CameraPowerMode.highAccuracy);
      expect(CameraPowerMode.fromName('bogus'), isNull);
    });

    test('camera check needs a camera', () {
      const registry = FeatureRegistry(implemented: {AppFeature.cameraCheck});
      expect(
          registry.stateOf(
              AppFeature.cameraCheck,
              const CapabilityContext(
                  tier: DeviceTier.low, hasCamera: false, installedModels: {})),
          FeatureState.deviceRequired);
      expect(
          registry.stateOf(
              AppFeature.cameraCheck,
              const CapabilityContext(
                  tier: DeviceTier.low, hasCamera: true, installedModels: {})),
          FeatureState.available);
    });
  });
}
