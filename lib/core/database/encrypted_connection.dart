import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:sqlite3/common.dart';

import '../security/database_key_store.dart';

const databaseName = 'personality';

/// Applies the encryption key and verifies the database is really encrypted.
///
/// Throws if the linked SQLite library has no cipher support, so the app can
/// never silently fall back to a plaintext database.
void applyEncryptionKey(CommonDatabase db, String hexKey) {
  if (!SecureDatabaseKeyStore.isValidKey(hexKey)) {
    throw ArgumentError('Invalid database key');
  }
  db.execute("PRAGMA hexkey = '$hexKey';");

  final cipher = db.select('PRAGMA cipher;');
  if (cipher.isEmpty || '${cipher.first.values.first}'.isEmpty) {
    throw StateError('SQLite build does not support encryption');
  }

  // Fails with "file is not a database" when the key is wrong.
  db.select('SELECT count(*) FROM sqlite_master;');
}

/// Opens the app database in a background isolate with encryption applied.
QueryExecutor openEncryptedDatabase(String hexKey) {
  return driftDatabase(
    name: databaseName,
    native: DriftNativeOptions(
      setup: (db) => applyEncryptionKey(db, hexKey),
    ),
  );
}
