import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import '../../domain/services/day_agenda.dart';
import '../../domain/services/health_stats.dart';
import 'body_record_repository.dart';

class MoodCheckIn {
  const MoodCheckIn(this.day, this.mood, this.energy);

  final int day;

  /// 1 (low) – 5 (great).
  final int mood;
  final int energy;
}

/// Daily mood/energy check-ins and the chosen day mode. Private, on-device.
class WellbeingRepository {
  WellbeingRepository(this._db, {Clock? clock}) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final Clock _clock;

  static const _mode = 'day.mode';

  Stream<List<MoodCheckIn>> watchMoods({int days = 60}) {
    final since = Days.key(_clock().subtract(Duration(days: days)));
    final q = _db.select(_db.moodLogs)
      ..where((t) => t.day.isBiggerOrEqualValue(since))
      ..orderBy([(t) => OrderingTerm.asc(t.day)]);
    return q.watch().map(
        (rows) => [for (final r in rows) MoodCheckIn(r.day, r.mood, r.energy)]);
  }

  Future<void> checkIn({required int mood, required int energy}) {
    if (mood < 1 || mood > 5 || energy < 1 || energy > 5) {
      throw ArgumentError('mood and energy are 1–5');
    }
    return _db.into(_db.moodLogs).insertOnConflictUpdate(MoodLogsCompanion.insert(
        day: Value(Days.key(_clock())),
        mood: mood,
        energy: energy,
        recordedAt: _clock().toUtc().millisecondsSinceEpoch));
  }

  /// The mode chosen for today; it resets to normal the next day.
  Stream<DayMode> watchTodayMode() {
    final q = _db.select(_db.appSettingsEntries)
      ..where((t) => t.key.equals(_mode));
    return q.watchSingleOrNull().map((r) {
      final parts = (r?.value ?? '').split(':');
      if (parts.length != 2 || parts[0] != '${Days.key(_clock())}') {
        return DayMode.normal;
      }
      return DayMode.values.asNameMap()[parts[1]] ?? DayMode.normal;
    });
  }

  Future<void> setTodayMode(DayMode mode) =>
      _db.into(_db.appSettingsEntries).insertOnConflictUpdate(
          AppSettingsEntriesCompanion.insert(
              key: _mode,
              value: '${Days.key(_clock())}:${mode.name}',
              updatedAt: _clock().toUtc().millisecondsSinceEpoch));
}
