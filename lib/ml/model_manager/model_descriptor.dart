/// Model manager contracts (spec §8). Implementation lands in Phase 11;
/// pose/face models reuse it from Phase 6.
library;

import '../../core/device/device_tier.dart';

enum ModelKind { pose, face, exerciseTracking, languageModel }

class ModelDescriptor {
  const ModelDescriptor({
    required this.id,
    required this.kind,
    required this.version,
    required this.sizeBytes,
    required this.sha256,
    required this.minimumTier,
    this.languages = const {},
  });

  final String id;
  final ModelKind kind;
  final String version;
  final int sizeBytes;

  /// Expected digest; a download is rejected if it does not match.
  final String sha256;
  final DeviceTier minimumTier;
  final Set<String> languages;

  bool supports(DeviceTier tier) => tier.index <= minimumTier.index;
}

enum ModelInstallStatus {
  notInstalled,
  downloading,
  paused,
  verifying,
  installed,
  failed,
}

class ModelInstallProgress {
  const ModelInstallProgress(this.status, {this.receivedBytes = 0, this.error});
  final ModelInstallStatus status;
  final int receivedBytes;
  final String? error;
}

abstract interface class ModelManager {
  Future<List<ModelDescriptor>> installed();
  Stream<ModelInstallProgress> install(ModelDescriptor model);
  Future<void> pause(String modelId);
  Future<void> remove(String modelId);
  Future<bool> verify(String modelId);
}
