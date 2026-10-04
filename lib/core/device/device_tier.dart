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
    this.hasFrontCamera = false,
    this.lowRamDevice = false,
  });

  final int? ramMb;
  final int? cpuCores;
  final int? osApiLevel;
  final int? freeStorageMb;
  final bool hasGpuDelegate;
  final bool hasNpu;
  final bool hasCamera;
  final bool hasFrontCamera;

  /// Android's own "low RAM device" flag; always treated as low tier.
  final bool lowRamDevice;

  /// True when no probe result is available.
  bool get isUnknown => ramMb == null && cpuCores == null;
}

abstract interface class DeviceCapabilityProbe {
  Future<DeviceSpecs> probe();
}

/// Classifies a device. Missing RAM or core data yields [DeviceTier.low] so an
/// unknown device never gets models it cannot run.
DeviceTier classifyDevice(DeviceSpecs specs) {
  final ram = specs.ramMb;
  final cores = specs.cpuCores;
  if (ram == null || cores == null || specs.lowRamDevice) return DeviceTier.low;
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

/// User-selectable camera power modes (spec §68).
enum CameraPowerMode {
  lowPower(analysisFps: 5, maxHeightPx: 480),
  standard(analysisFps: 10, maxHeightPx: 720),
  highAccuracy(analysisFps: 15, maxHeightPx: 1080);

  const CameraPowerMode({required this.analysisFps, required this.maxHeightPx});

  /// Frames analyzed per second; the preview itself is not throttled.
  final int analysisFps;
  final int maxHeightPx;

  /// Default for a device tier. High-end devices still default to standard
  /// to save battery; the user can opt in to high accuracy.
  static CameraPowerMode defaultFor(DeviceTier tier) => switch (tier) {
        DeviceTier.low => CameraPowerMode.lowPower,
        DeviceTier.medium || DeviceTier.high => CameraPowerMode.standard,
      };

  static CameraPowerMode? fromName(String? name) {
    for (final m in values) {
      if (m.name == name) return m;
    }
    return null;
  }
}
