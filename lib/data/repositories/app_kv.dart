import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';

/// Small app state that doesn't deserve its own table (dismissed cards,
/// counters, chosen skills), kept in the encrypted app_settings table so it
/// is backed up with everything else.
class AppKv {
  AppKv(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  Stream<Map<String, String>> watchPrefix(String prefix) {
    final q = _db.select(_db.appSettingsEntries)
      ..where((t) => t.key.like('$prefix%'));
    return q.watch().map((rows) => {for (final r in rows) r.key: r.value});
  }

  Future<String?> get(String key) async {
    final q = _db.select(_db.appSettingsEntries)
      ..where((t) => t.key.equals(key));
    return (await q.getSingleOrNull())?.value;
  }

  Future<void> delete(String key) =>
      (_db.delete(_db.appSettingsEntries)..where((t) => t.key.equals(key))).go();

  Future<void> put(String key, String value) => _db
      .into(_db.appSettingsEntries)
      .insertOnConflictUpdate(
        AppSettingsEntriesCompanion.insert(
          key: key,
          value: value,
          updatedAt: _clock().toUtc().millisecondsSinceEpoch,
        ),
      );
}
