import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/device/device_tier.dart';
import 'package:personality/core/features/feature_registry.dart';
import 'package:personality/ml/model_manager/model_descriptor.dart';

void main() {
  group('classifyDevice', () {
    test('tiers by RAM and cores', () {
      expect(classifyDevice(const DeviceSpecs(ramMb: 12288, cpuCores: 8)),
          DeviceTier.high);
      expect(classifyDevice(const DeviceSpecs(ramMb: 6144, cpuCores: 8)),
          DeviceTier.medium);
      expect(classifyDevice(const DeviceSpecs(ramMb: 3072, cpuCores: 8)),
          DeviceTier.low);
    });

    test('unknown hardware is treated as low', () {
      expect(classifyDevice(const DeviceSpecs()), DeviceTier.low);
    });

    test('low tier disables local AI and uses lite pose model', () {
      final p = ProcessingPolicy.forTier(DeviceTier.low);
      expect(p.localAiAllowed, isFalse);
      expect(p.poseModel, PoseModelVariant.lite);
    });
  });

  group('FeatureRegistry', () {
    const ctx = CapabilityContext(
      tier: DeviceTier.medium,
      hasCamera: true,
      installedModels: {},
    );

    test('unimplemented features are coming soon', () {
      const registry = FeatureRegistry(implemented: {});
      expect(registry.stateOf(AppFeature.water, ctx), FeatureState.comingSoon);
    });

    test('tracking features are available once implemented', () {
      const registry = FeatureRegistry(implemented: {AppFeature.water});
      expect(registry.stateOf(AppFeature.water, ctx), FeatureState.available);
    });

    test('posture requires camera then model', () {
      const registry =
          FeatureRegistry(implemented: {AppFeature.postureAnalysis});
      expect(
        registry.stateOf(
          AppFeature.postureAnalysis,
          const CapabilityContext(
              tier: DeviceTier.high, hasCamera: false, installedModels: {}),
        ),
        FeatureState.deviceRequired,
      );
      expect(registry.stateOf(AppFeature.postureAnalysis, ctx),
          FeatureState.modelRequired);
      expect(
        registry.stateOf(
          AppFeature.postureAnalysis,
          const CapabilityContext(
              tier: DeviceTier.medium,
              hasCamera: true,
              installedModels: {ModelIds.pose}),
        ),
        FeatureState.available,
      );
    });

    test('AI coach is blocked on low-tier devices even with a model', () {
      const registry = FeatureRegistry(implemented: {AppFeature.aiCoach});
      expect(
        registry.stateOf(
          AppFeature.aiCoach,
          const CapabilityContext(
              tier: DeviceTier.low,
              hasCamera: true,
              installedModels: {ModelIds.localLlm}),
        ),
        FeatureState.deviceRequired,
      );
    });

    test('beta flag is reported for usable features', () {
      const registry = FeatureRegistry(
        implemented: {AppFeature.wardrobe},
        beta: {AppFeature.wardrobe},
      );
      final state = registry.stateOf(AppFeature.wardrobe, ctx);
      expect(state, FeatureState.beta);
      expect(state.isUsable, isTrue);
    });
  });

  test('ModelDescriptor.supports respects minimum tier', () {
    const model = ModelDescriptor(
      id: 'pose-full',
      kind: ModelKind.pose,
      version: '1',
      sizeBytes: 1,
      sha256: 'x',
      minimumTier: DeviceTier.medium,
    );
    expect(model.supports(DeviceTier.high), isTrue);
    expect(model.supports(DeviceTier.medium), isTrue);
    expect(model.supports(DeviceTier.low), isFalse);
  });
}
