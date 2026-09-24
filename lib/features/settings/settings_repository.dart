import 'package:flutter/material.dart';

import '../../core/database/app_database.dart';
import '../../core/units/units.dart';
import 'app_settings.dart';

/// Persists [AppSettings] in the encrypted `app_settings` table.
class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  static const _onboarding = 'onboarding.completed';
  static const _units = 'units.system';
  static const _theme = 'theme.mode';
  static const _locale = 'locale.code';

  Future<AppSettings> load() async {
    final rows = await _db.select(_db.appSettingsEntries).get();
    final map = {for (final r in rows) r.key: r.value};
    return AppSettings(
      onboardingCompleted: map[_onboarding] == 'true',
      unitSystem: UnitSystem.fromName(map[_units]),
      themeMode: ThemeMode.values.firstWhere(
        (m) => m.name == map[_theme],
        orElse: () => ThemeMode.system,
      ),
      localeCode: map[_locale],
    );
  }

  Future<void> save(AppSettings settings) async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    await _db.transaction(() async {
      Future<void> put(String key, String value) => _db
          .into(_db.appSettingsEntries)
          .insertOnConflictUpdate(AppSettingsEntriesCompanion.insert(
            key: key,
            value: value,
            updatedAt: now,
          ));

      await put(_onboarding, '${settings.onboardingCompleted}');
      await put(_units, settings.unitSystem.name);
      await put(_theme, settings.themeMode.name);
      if (settings.localeCode case final code?) {
        await put(_locale, code);
      } else {
        await (_db.delete(_db.appSettingsEntries)
              ..where((t) => t.key.equals(_locale)))
            .go();
      }
    });
  }
}
