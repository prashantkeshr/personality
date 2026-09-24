/// Central feature capability system (spec §66).
///
/// All "is this feature usable here?" decisions go through [FeatureRegistry]
/// so feature-state logic is never scattered across screens.
library;

import '../device/device_tier.dart';

enum FeatureState {
  available,
  beta,
  comingSoon,
  deviceRequired,
  modelRequired,
  onlineRequired,
  premium;

  bool get isUsable => this == available || this == beta;
}

enum AppFeature {
  profile,
  height,
  bodyMeasurements,
  bodyProportions,
  weight,
  water,
  meals,
  sleep,
  activity,
  exercise,
  habits,
  routines,
  reminders,
  progress,
  cameraHeightEstimate,
  postureAnalysis,
  exerciseCameraTracking,
  faceAnalysis,
  styleRecommendations,
  wardrobe,
  aiCoach,
  healthIntegration,
  encryptedBackup,
  commerce,
}

/// ML model identifiers referenced by capability rules.
abstract final class ModelIds {
  static const pose = 'pose';
  static const face = 'face';
  static const localLlm = 'local_llm';
}

/// Runtime facts the registry needs to decide a feature's state.
class CapabilityContext {
  const CapabilityContext({
    required this.tier,
    required this.hasCamera,
    required this.installedModels,
    this.isOnline = false,
    this.healthPlatformAvailable = false,
  });

  final DeviceTier tier;
  final bool hasCamera;
  final Set<String> installedModels;
  final bool isOnline;
  final bool healthPlatformAvailable;
}

class FeatureRegistry {
  /// [implemented] lists features whose code has shipped. Anything else is
  /// reported as [FeatureState.comingSoon] instead of pretending to work.
  const FeatureRegistry({required this.implemented, this.beta = const {}});

  final Set<AppFeature> implemented;
  final Set<AppFeature> beta;

  FeatureState stateOf(AppFeature feature, CapabilityContext ctx) {
    if (!implemented.contains(feature)) return FeatureState.comingSoon;

    final blocked = _requirement(feature, ctx);
    if (blocked != null) return blocked;

    return beta.contains(feature) ? FeatureState.beta : FeatureState.available;
  }

  FeatureState? _requirement(AppFeature feature, CapabilityContext ctx) {
    switch (feature) {
      case AppFeature.cameraHeightEstimate:
      case AppFeature.postureAnalysis:
      case AppFeature.exerciseCameraTracking:
        if (!ctx.hasCamera) return FeatureState.deviceRequired;
        if (!ctx.installedModels.contains(ModelIds.pose)) {
          return FeatureState.modelRequired;
        }
      case AppFeature.faceAnalysis:
        if (!ctx.hasCamera) return FeatureState.deviceRequired;
        if (!ctx.installedModels.contains(ModelIds.face)) {
          return FeatureState.modelRequired;
        }
      case AppFeature.aiCoach:
        if (!ProcessingPolicy.forTier(ctx.tier).localAiAllowed) {
          return FeatureState.deviceRequired;
        }
        if (!ctx.installedModels.contains(ModelIds.localLlm)) {
          return FeatureState.modelRequired;
        }
      case AppFeature.healthIntegration:
        if (!ctx.healthPlatformAvailable) return FeatureState.deviceRequired;
      case AppFeature.commerce:
        if (!ctx.isOnline) return FeatureState.onlineRequired;
      default:
        break;
    }
    return null;
  }
}
