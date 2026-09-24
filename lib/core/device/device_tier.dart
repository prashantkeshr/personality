/// Device capability contracts (spec §7).
///
/// Detection is platform-specific and arrives in Phase 5; classification and
/// the resulting processing policy are pure functions so they can be tested.
library;

enum DeviceTier { high, medium, low }

/// Hardware facts reported by a [DeviceCapabilityProbe].
/// Unknown values are null and are treated conservatively.
class DeviceSpecs {
  const DeviceSpecs({
    this.ramMb,
    this.cpuCores,
    this.osApiLevel,
    this.freeStorageMb,
    this.hasGpuDelegate = false,
    this.hasNpu = false,
    this.hasCamera = false,
  });

  final int? ramMb;
  final int? cpuCores;
  final int? osApiLevel;
  final int? freeStorageMb;
  final bool hasGpuDelegate;
  final bool hasNpu;
  final bool hasCamera;
}

abstract interface class DeviceCapabilityProbe {
  Future<DeviceSpecs> probe();
}

/// Classifies a device. Missing RAM or core data yields [DeviceTier.low] so an
/// unknown device never gets models it cannot run.
DeviceTier classifyDevice(DeviceSpecs specs) {
  final ram = specs.ramMb;
  final cores = specs.cpuCores;
  if (ram == null || cores == null) return DeviceTier.low;
  if (ram >= 8 * 1024 && cores >= 8) return DeviceTier.high;
  if (ram >= 4 * 1024 && cores >= 6) return DeviceTier.medium;
  return DeviceTier.low;
}

enum PoseModelVariant { lite, full, heavy }

/// Processing settings derived from a tier.
class ProcessingPolicy {
  const ProcessingPolicy({
    required this.poseModel,
    required this.analysisFps,
    required this.maxCameraHeightPx,
    required this.localAiAllowed,
    required this.reducedEffects,
  });

  final PoseModelVariant poseModel;
  final int analysisFps;
  final int maxCameraHeightPx;
  final bool localAiAllowed;
  final bool reducedEffects;

  factory ProcessingPolicy.forTier(DeviceTier tier) => switch (tier) {
        DeviceTier.high => const ProcessingPolicy(
            poseModel: PoseModelVariant.heavy,
            analysisFps: 15,
            maxCameraHeightPx: 1080,
            localAiAllowed: true,
            reducedEffects: false,
          ),
        DeviceTier.medium => const ProcessingPolicy(
            poseModel: PoseModelVariant.full,
            analysisFps: 10,
            maxCameraHeightPx: 720,
            localAiAllowed: true,
            reducedEffects: false,
          ),
        DeviceTier.low => const ProcessingPolicy(
            poseModel: PoseModelVariant.lite,
            analysisFps: 5,
            maxCameraHeightPx: 480,
            localAiAllowed: false,
            reducedEffects: true,
          ),
      };
}
