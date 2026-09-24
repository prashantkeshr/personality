import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/personality_app.dart';
import 'core/database/app_database.dart';
import 'core/database/encrypted_connection.dart';
import 'core/logging/app_logger.dart';
import 'core/providers.dart';
import 'core/security/database_key_store.dart';
import 'features/settings/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _start();
}

/// Opens the encrypted database and loads settings before the first frame,
/// so theme and language are correct from the start.
Future<void> _start() async {
  AppDatabase? db;
  try {
    final key = await SecureDatabaseKeyStore().obtainKey();
    db = AppDatabase(openEncryptedDatabase(key));
    final settings = await SettingsRepository(db).load();

    runApp(ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        initialSettingsProvider.overrideWithValue(settings),
      ],
      child: const PersonalityApp(),
    ));
  } catch (e, st) {
    AppLogger.error('startup', e, st);
    await db?.close();
    runApp(StartupErrorApp(onRetry: _start));
  }
}
