import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/device/device_tier.dart';
import '../../core/providers.dart';
import '../../core/features/feature_registry.dart';
import '../../ml/model_manager/bundled_models.dart';
import '../../ml/pose/mlkit_pose_estimator.dart';
import '../../ml/pose/pose_estimator.dart';
import 'camera_source.dart';

/// Real camera by default; tests override with a fake.
final cameraSourceProvider = Provider<CameraSource>((ref) {
  final source = PluginCameraSource();
  ref.onDispose(source.stop);
  return source;
});

/// The bundled ML Kit model where available; otherwise an estimator that
/// honestly reports "model not installed". High-tier devices get the
/// larger, more accurate model.
final poseEstimatorProvider = Provider<PoseEstimator>((ref) {
  if (!ref.watch(installedModelsProvider).contains(ModelIds.pose)) {
    return const UnavailablePoseEstimator();
  }
  final policy = ProcessingPolicy.forTier(ref.watch(deviceTierProvider));
  final estimator =
      MlKitPoseEstimator(accurate: policy.poseModel == PoseModelVariant.heavy);
  ref.onDispose(estimator.dispose);
  return estimator;
});

class CameraSettingsRepository {
  CameraSettingsRepository(this._db);

  final AppDatabase _db;
  static const _key = 'camera.power_mode';

  Stream<CameraPowerMode?> watchMode() {
    final q = _db.select(_db.appSettingsEntries)
      ..where((t) => t.key.equals(_key));
    return q
        .watchSingleOrNull()
        .map((r) => CameraPowerMode.fromName(r?.value));
  }

  Future<void> setMode(CameraPowerMode mode) =>
      _db.into(_db.appSettingsEntries).insertOnConflictUpdate(
            AppSettingsEntriesCompanion.insert(
              key: _key,
              value: mode.name,
              updatedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
            ),
          );
}

final cameraSettingsRepositoryProvider = Provider(
    (ref) => CameraSettingsRepository(ref.watch(appDatabaseProvider)));

final _savedModeProvider = StreamProvider<CameraPowerMode?>(
    (ref) => ref.watch(cameraSettingsRepositoryProvider).watchMode());

/// The user's choice, or the default for this device's tier.
final cameraPowerModeProvider = Provider<CameraPowerMode>((ref) =>
    ref.watch(_savedModeProvider).value ??
    CameraPowerMode.defaultFor(ref.watch(deviceTierProvider)));
