import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Provides the database encryption key (spec §51).
///
/// A 256-bit key is generated once from a cryptographically secure RNG and
/// kept in platform secure storage (Android Keystore / iOS Keychain). The key
/// never appears in source code or logs.
abstract interface class DatabaseKeyStore {
  /// Returns the key as 64 lowercase hex characters, creating it on first use.
  Future<String> obtainKey();
}

class SecureDatabaseKeyStore implements DatabaseKeyStore {
  SecureDatabaseKeyStore({FlutterSecureStorage? storage, Random? random})
      : _storage = storage ?? const FlutterSecureStorage(),
        _random = random ?? Random.secure();

  static const _keyName = 'personality.db.key.v1';

  final FlutterSecureStorage _storage;
  final Random _random;

  @override
  Future<String> obtainKey() async {
    final existing = await _storage.read(key: _keyName);
    if (existing != null) {
      // Never overwrite a stored key: that would make the database unreadable.
      if (isValidKey(existing)) return existing;
      throw StateError('Stored database key is malformed');
    }

    final key = generateKey(_random);
    await _storage.write(key: _keyName, value: key);
    return key;
  }

  static String generateKey(Random random) => List.generate(
        32,
        (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
      ).join();

  static bool isValidKey(String key) =>
      RegExp(r'^[0-9a-f]{64}$').hasMatch(key);
}
