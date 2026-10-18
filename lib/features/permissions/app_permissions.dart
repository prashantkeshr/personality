import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/repositories/app_kv.dart';
import '../connected/data_import.dart' show sensorBridgeProvider;
import '../health/health_providers.dart' show clockProvider;
import '../routines/routine_providers.dart';

/// The permissions the app's features rely on. Each one is optional:
/// without it that feature explains itself and the rest of the app works.
enum AppPermission { notifications, camera, activity }

class PermissionState {
  const PermissionState({this.granted = const {}, this.askable = const {}});

  /// Everything allowed: what tests and unsupported platforms report.
  static const all = PermissionState(granted: {...AppPermission.values});

  final Set<AppPermission> granted;

  /// Missing ones Android will still prompt for. The rest can only be
  /// turned on from the app's settings page.
  final Set<AppPermission> askable;

  bool has(AppPermission p) => granted.contains(p);
  List<AppPermission> get missing => [
    for (final p in AppPermission.values)
      if (!granted.contains(p)) p,
  ];
}

abstract interface class AppPermissions {
  Future<PermissionState> status();

  /// Shows Android's prompt (or opens the app's settings when Android no
  /// longer prompts). Returns whether it is allowed now.
  Future<bool> request(AppPermission p);
  Future<void> openSettings();
}

class PlatformPermissions implements AppPermissions {
  PlatformPermissions(this._ref);
  final Ref _ref;

  static const _ch = MethodChannel('personality/device');

  @override
  Future<PermissionState> status() async {
    try {
      final m = await _ch.invokeMapMethod<String, bool>('permissions') ?? {};
      return PermissionState(
        granted: {
          for (final p in AppPermission.values)
            if (m[p.name] == true) p,
        },
        askable: {
          for (final p in AppPermission.values)
            if (m['${p.name}Askable'] == true) p,
        },
      );
    } on MissingPluginException {
      return PermissionState.all;
    } on PlatformException {
      return PermissionState.all;
    }
  }

  @override
  Future<bool> request(AppPermission p) async {
    final before = await status();
    if (before.has(p)) return true;
    if (!before.askable.contains(p) && p != AppPermission.notifications) {
      await openSettings();
      return false;
    }
    try {
      switch (p) {
        case AppPermission.notifications:
          await _ch.invokeMethod('markAsked', {'permission': 'notifications'});
          final ok = await _ref
              .read(reminderSchedulerProvider)
              .requestPermission();
          if (!ok && !before.askable.contains(p)) await openSettings();
          return ok;
        case AppPermission.camera:
          return await _ch.invokeMethod<bool>('requestCamera') ?? false;
        case AppPermission.activity:
          await _ch.invokeMethod('markAsked', {'permission': 'activity'});
          return await _ref
              .read(sensorBridgeProvider)
              .requestActivityPermission();
      }
    } on MissingPluginException {
      return true;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<void> openSettings() async {
    try {
      await _ch.invokeMethod('openAppSettings');
    } on MissingPluginException {
      // Not on Android: nothing to open.
    }
  }
}

final appPermissionsProvider = Provider<AppPermissions>(
  (ref) => PlatformPermissions(ref),
);

/// Current state; invalidate after a request or when the app resumes.
final permissionStateProvider = FutureProvider<PermissionState>(
  (ref) => ref.watch(appPermissionsProvider).status(),
);

final appKvProvider = Provider((ref) => AppKv(ref.watch(appDatabaseProvider)));

/// How often the Home card may ask again after "Later".
const permissionNudgeEvery = Duration(days: 3);
const permissionNudgeKey = 'perm.nudgeLater';

final _nudgeLaterProvider = StreamProvider<int?>(
  (ref) => ref
      .watch(appKvProvider)
      .watchPrefix(permissionNudgeKey)
      .map((m) => int.tryParse(m[permissionNudgeKey] ?? '')),
);

/// The permissions to ask about on Home now, or empty: only when something
/// is missing and the last "Later" was long enough ago.
final permissionNudgeProvider = Provider<List<AppPermission>>((ref) {
  final state = ref.watch(permissionStateProvider).value;
  final later = ref.watch(_nudgeLaterProvider);
  if (state == null || !later.hasValue) return const [];
  final last = later.value;
  if (last != null) {
    final since = ref.watch(clockProvider)().millisecondsSinceEpoch - last;
    if (since < permissionNudgeEvery.inMilliseconds) return const [];
  }
  return state.missing;
});
