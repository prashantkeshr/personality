import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/app_settings.dart';
import '../features/settings/settings_repository.dart';
import 'database/app_database.dart';
import 'device/device_tier.dart';
import 'device/platform_device_probe.dart';
import 'features/feature_registry.dart';
import 'features/implemented_features.dart';
import '../ml/model_manager/bundled_models.dart';

/// Opened during bootstrap and injected with an override.
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('appDatabaseProvider must be overridden'),
);

/// Settings loaded during bootstrap, so the first frame has the right theme.
final initialSettingsProvider = Provider<AppSettings>(
  (ref) => throw UnimplementedError('initialSettingsProvider must be overridden'),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(appDatabaseProvider)),
);

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(initialSettingsProvider);

  /// Persists first, then publishes, so the UI never shows unsaved state.
  Future<void> update(AppSettings Function(AppSettings current) change) async {
    final next = change(state);
    await ref.read(settingsRepositoryProvider).save(next);
    state = next;
  }

  /// Re-reads saved settings, e.g. after a restore. Onboarding stays done.
  Future<void> reload() async {
    final loaded = await ref.read(settingsRepositoryProvider).load();
    state = loaded.copyWith(onboardingCompleted: state.onboardingCompleted || loaded.onboardingCompleted);
  }
}

final featureRegistryProvider = Provider<FeatureRegistry>(
  (ref) => const FeatureRegistry(implemented: implementedFeatures),
);

final deviceProbeProvider =
    Provider<DeviceCapabilityProbe>((ref) => const PlatformDeviceProbe());

/// Hardware facts, probed once per launch.
final deviceSpecsProvider = FutureProvider<DeviceSpecs>(
    (ref) => ref.watch(deviceProbeProvider).probe());

final deviceTierProvider = Provider<DeviceTier>((ref) =>
    classifyDevice(ref.watch(deviceSpecsProvider).value ?? const DeviceSpecs()));

/// Until the probe answers, the device is treated as unknown, which the
/// capability rules handle conservatively.
final capabilityContextProvider = Provider<CapabilityContext>((ref) {
  final specs = ref.watch(deviceSpecsProvider).value ?? const DeviceSpecs();
  return CapabilityContext(
    tier: classifyDevice(specs),
    hasCamera: specs.hasCamera,
    installedModels: ref.watch(installedModelsProvider),
  );
});
