import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Where the lock's secrets live: Android Keystore-backed secure storage.
/// Only a salted hash of the PIN is kept, never the PIN itself.
abstract interface class LockStore {
  Future<String?> read(String key);
  Future<void> write(String key, String? value);
}

class SecureLockStore implements LockStore {
  const SecureLockStore();
  static const _s = FlutterSecureStorage();

  @override
  Future<String?> read(String key) => _s.read(key: key);

  @override
  Future<void> write(String key, String? value) =>
      value == null ? _s.delete(key: key) : _s.write(key: key, value: value);
}

class MemoryLockStore implements LockStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String? value) async =>
      value == null ? values.remove(key) : values[key] = value;
}

/// Fingerprint / face unlock through the system prompt.
abstract interface class Biometrics {
  Future<bool> available();
  Future<bool> authenticate(String reason);
}

class PlatformBiometrics implements Biometrics {
  const PlatformBiometrics();
  static final _auth = LocalAuthentication();

  @override
  Future<bool> available() async {
    try {
      return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );
    } catch (_) {
      return false; // cancelled, locked out or unavailable: fall back to the PIN
    }
  }
}

class NoBiometrics implements Biometrics {
  const NoBiometrics();
  @override
  Future<bool> available() async => false;
  @override
  Future<bool> authenticate(String reason) async => false;
}

/// PIN hashing and checking. PBKDF2-HMAC-SHA256 with a random salt.
class PinVault {
  PinVault(this._store, {this.iterations = 60000});

  final LockStore _store;
  final int iterations;

  static const _kHash = 'lock.pin';
  static const _kBio = 'lock.biometric';

  static bool validPin(String pin) => RegExp(r'^\d{4,8}$').hasMatch(pin);

  // Off the UI thread so the keypad stays responsive. Static, so the
  // isolate closure captures only plain data.
  static Future<List<int>> _hash(String pin, List<int> salt, int rounds) =>
      Isolate.run(
        () async => (await Pbkdf2(
          macAlgorithm: Hmac.sha256(),
          iterations: rounds,
          bits: 256,
        ).deriveKeyFromPassword(password: pin, nonce: salt)).extractBytes(),
      );

  Future<bool> enabled() async => await _store.read(_kHash) != null;

  Future<void> setPin(String pin) async {
    if (!validPin(pin)) throw ArgumentError('PIN must be 4–8 digits');
    final r = Random.secure();
    final salt = List<int>.generate(16, (_) => r.nextInt(256));
    final hash = await _hash(pin, salt, iterations);
    await _store.write(
      _kHash,
      jsonEncode({
        's': base64Encode(salt),
        'h': base64Encode(hash),
        'i': iterations,
      }),
    );
  }

  Future<bool> verify(String pin) async {
    final raw = await _store.read(_kHash);
    if (raw == null) return true;
    final j = jsonDecode(raw) as Map<String, dynamic>;
    final expected = base64Decode(j['h'] as String);
    final got = await _hash(pin, base64Decode(j['s'] as String), j['i'] as int);
    // Constant-time comparison.
    var diff = expected.length ^ got.length;
    for (var i = 0; i < min(expected.length, got.length); i++) {
      diff |= expected[i] ^ got[i];
    }
    return diff == 0;
  }

  Future<void> disable() async {
    await _store.write(_kHash, null);
    await _store.write(_kBio, null);
  }

  Future<bool> biometricEnabled() async => await _store.read(_kBio) == 'true';
  Future<void> setBiometric(bool on) => _store.write(_kBio, on ? 'true' : null);
}

class AppLockState {
  const AppLockState({
    this.ready = false,
    this.enabled = false,
    this.locked = false,
    this.biometric = false,
    this.failures = 0,
    this.lockedUntil,
  });

  final bool ready;
  final bool enabled;
  final bool locked;
  final bool biometric;
  final int failures;

  /// After repeated wrong PINs, entry pauses until then.
  final DateTime? lockedUntil;

  AppLockState copyWith({
    bool? ready,
    bool? enabled,
    bool? locked,
    bool? biometric,
    int? failures,
    DateTime? Function()? lockedUntil,
  }) => AppLockState(
    ready: ready ?? this.ready,
    enabled: enabled ?? this.enabled,
    locked: locked ?? this.locked,
    biometric: biometric ?? this.biometric,
    failures: failures ?? this.failures,
    lockedUntil: lockedUntil != null ? lockedUntil() : this.lockedUntil,
  );
}

final lockStoreProvider = Provider<LockStore>((ref) => const SecureLockStore());
final biometricsProvider = Provider<Biometrics>(
  (ref) => const PlatformBiometrics(),
);
final pinVaultProvider = Provider(
  (ref) => PinVault(ref.watch(lockStoreProvider)),
);
final lockClockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Lock state for the whole app. Locked on start when a PIN is set.
class AppLockController extends Notifier<AppLockState> {
  @override
  AppLockState build() {
    _load();
    return const AppLockState();
  }

  PinVault get _vault => ref.read(pinVaultProvider);

  Future<void> _load() async {
    final enabled = await _vault.enabled();
    final bio = await _vault.biometricEnabled();
    state = state.copyWith(
      ready: true,
      enabled: enabled,
      locked: enabled,
      biometric: bio,
    );
  }

  /// Called when the app comes back after [away].
  void onResume(Duration away) {
    if (state.enabled && away >= const Duration(seconds: 30)) {
      state = state.copyWith(locked: true);
    }
  }

  /// Seconds to wait before another try (0 = can try now).
  int waitSeconds() {
    final until = state.lockedUntil;
    if (until == null) return 0;
    final s = until.difference(ref.read(lockClockProvider)()).inSeconds;
    return s > 0 ? s + 1 : 0;
  }

  /// True when unlocked. Five wrong PINs pause entry, longer each time.
  Future<bool> unlockWithPin(String pin) async {
    if (waitSeconds() > 0) return false;
    if (await _vault.verify(pin)) {
      state = state.copyWith(
        locked: false,
        failures: 0,
        lockedUntil: () => null,
      );
      return true;
    }
    final failures = state.failures + 1;
    DateTime? until;
    if (failures % 5 == 0) {
      until = ref
          .read(lockClockProvider)()
          .add(Duration(seconds: 30 * (failures ~/ 5)));
    }
    state = state.copyWith(
      failures: failures,
      lockedUntil: () => until ?? state.lockedUntil,
    );
    return false;
  }

  Future<bool> unlockWithBiometrics(String reason) async {
    if (!state.biometric) return false;
    final ok = await ref.read(biometricsProvider).authenticate(reason);
    if (ok) {
      state = state.copyWith(
        locked: false,
        failures: 0,
        lockedUntil: () => null,
      );
    }
    return ok;
  }

  Future<void> enable(String pin) async {
    await _vault.setPin(pin);
    state = state.copyWith(enabled: true, locked: false);
  }

  Future<void> disable() async {
    await _vault.disable();
    state = state.copyWith(enabled: false, locked: false, biometric: false);
  }

  Future<void> setBiometric(bool on) async {
    await _vault.setBiometric(on);
    state = state.copyWith(biometric: on);
  }
}

final appLockProvider = NotifierProvider<AppLockController, AppLockState>(
  AppLockController.new,
);
