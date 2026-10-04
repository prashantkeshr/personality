import 'package:flutter/services.dart';

import '../logging/app_logger.dart';
import 'device_tier.dart';

/// Reads hardware facts from the Android side (MainActivity "probe").
///
/// Never throws: if the probe is unavailable the device is reported as
/// unknown, which the capability rules treat conservatively (low tier).
class PlatformDeviceProbe implements DeviceCapabilityProbe {
  const PlatformDeviceProbe();

  static const _channel = MethodChannel('personality/device');

  @override
  Future<DeviceSpecs> probe() async {
    try {
      final m = await _channel.invokeMapMethod<String, Object?>('probe');
      if (m == null) return const DeviceSpecs();
      return DeviceSpecs(
        ramMb: m['ramMb'] as int?,
        cpuCores: m['cpuCores'] as int?,
        osApiLevel: m['osApiLevel'] as int?,
        freeStorageMb: m['freeStorageMb'] as int?,
        lowRamDevice: m['lowRamDevice'] as bool? ?? false,
        hasCamera: m['hasCamera'] as bool? ?? false,
        hasFrontCamera: m['hasFrontCamera'] as bool? ?? false,
      );
    } catch (e, st) {
      AppLogger.error('device.probe', e, st);
      return const DeviceSpecs();
    }
  }
}
