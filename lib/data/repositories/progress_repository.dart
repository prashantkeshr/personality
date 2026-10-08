import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/progress_engine.dart';
import 'body_record_repository.dart' show Clock;

/// Builds one [DayActivity] per local day from the records the user already
/// keeps. Read-only: progress is derived, never stored.
class ProgressRepository {
  ProgressRepository(this._db, {Clock? clock}) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final Clock _clock;

  static const historyDays = 400;
  static const _seenBadges = 'progress.badges_seen';

  /// Timestamped events (UTC ms) grouped by local day in Dart, so day
  /// boundaries follow the phone's time zone.
  static const _events = '''
SELECT 'water' AS k, recorded_at AS t, CAST(value AS REAL) AS v FROM water_log WHERE recorded_at >= ?1
UNION ALL SELECT 'meal', eaten_at, 1 FROM meal WHERE eaten_at >= ?1
UNION ALL SELECT 'sleep', wake_at, 1 FROM sleep_log WHERE wake_at >= ?1
UNION ALL SELECT 'workout', recorded_at, 1 FROM activity_log WHERE recorded_at >= ?1
UNION ALL SELECT 'workout', performed_at, 1 FROM exercise_session WHERE performed_at >= ?1
UNION ALL SELECT 'posture', recorded_at, 1 FROM posture_session WHERE recorded_at >= ?1
UNION ALL SELECT 'face', recorded_at, 1 FROM face_analysis WHERE recorded_at >= ?1
UNION ALL SELECT 'snapshot', taken_at, 1 FROM progress_snapshot WHERE taken_at >= ?1
UNION ALL SELECT 'outfit', created_at, 1 FROM outfit WHERE created_at >= ?1
UNION ALL SELECT 'weight', recorded_at, 1 FROM weight_record WHERE recorded_at >= ?1
''';

  /// Day-keyed records.
  static const _dayEvents = '''
SELECT 'habit' AS k, day AS d FROM habit_completion WHERE status = 'completed' AND day >= ?1
UNION ALL SELECT 'plan', day FROM routine_completion WHERE outcome = 'completed' AND day >= ?1
UNION ALL SELECT 'worn', day FROM outfit_wear WHERE day >= ?1
''';

  Set<ResultSetImplementation> get _tables => {
        _db.waterLogs,
        _db.meals,
        _db.sleepLogs,
        _db.activityLogs,
        _db.exerciseSessions,
        _db.postureSessions,
        _db.faceAnalyses,
        _db.snapshots,
        _db.outfits,
        _db.weightRecords,
        _db.habitCompletions,
        _db.planRecords,
        _db.outfitWears,
        _db.appSettingsEntries,
      };

  Stream<List<DayActivity>> watchHistory() {
    final trigger = _db
        .customSelect('SELECT 1', readsFrom: _tables)
        .watch();
    return trigger.asyncMap((_) => history());
  }

  Future<List<DayActivity>> history() async {
    final now = _clock();
    final since = now.subtract(const Duration(days: historyDays));
    final sinceMs = since.toUtc().millisecondsSinceEpoch;
    final sinceDay = Days.key(since);

    final target = int.tryParse((await (_db.select(_db.appSettingsEntries)
                  ..where((t) => t.key.equals('target.water_ml')))
                .getSingleOrNull())
            ?.value ??
        '') ??
        2000;

    final b = <int, _Builder>{};
    _Builder at(int day) => b.putIfAbsent(day, _Builder.new);

    final events = await _db.customSelect(_events,
        variables: [Variable.withInt(sinceMs)]).get();
    for (final r in events) {
      final day = Days.key(
          DateTime.fromMillisecondsSinceEpoch(r.read<int>('t'), isUtc: true)
              .toLocal());
      final d = at(day);
      switch (r.read<String>('k')) {
        case 'water':
          d.water += r.read<double>('v');
        case 'meal':
          d.meals++;
        case 'sleep':
          d.sleep = true;
        case 'workout':
          d.workouts++;
        case 'posture':
          d.posture++;
        case 'face':
          d.face++;
        case 'snapshot':
          d.snapshots++;
        case 'outfit':
          d.outfits++;
        case 'weight':
          d.weight = true;
      }
    }
    final dayEvents = await _db.customSelect(_dayEvents,
        variables: [Variable.withInt(sinceDay)]).get();
    for (final r in dayEvents) {
      final d = at(r.read<int>('d'));
      switch (r.read<String>('k')) {
        case 'habit':
          d.habits++;
        case 'plan':
          d.plan++;
        case 'worn':
          d.worn++;
      }
    }
    final keys = b.keys.toList()..sort();
    return [for (final k in keys) b[k]!.build(k, target)];
  }

  // ---------- badge celebrations ----------

  Future<Set<String>> seenBadges() async {
    final row = await (_db.select(_db.appSettingsEntries)
          ..where((t) => t.key.equals(_seenBadges)))
        .getSingleOrNull();
    return {
      for (final n in (row?.value ?? '').split(','))
        if (n.isNotEmpty) n
    };
  }

  /// Remembers that the unlock animation for these badges was shown.
  Future<void> markBadgesSeen(Iterable<Award> badges) async {
    final seen = await seenBadges()..addAll(badges.map((b) => b.name));
    await _db.into(_db.appSettingsEntries).insertOnConflictUpdate(
        AppSettingsEntriesCompanion.insert(
            key: _seenBadges,
            value: (seen.toList()..sort()).join(','),
            updatedAt: _clock().toUtc().millisecondsSinceEpoch));
  }
}

class _Builder {
  double water = 0;
  int meals = 0, workouts = 0, posture = 0, face = 0, snapshots = 0;
  int outfits = 0, habits = 0, plan = 0, worn = 0;
  bool sleep = false, weight = false;

  DayActivity build(int day, int target) => DayActivity(
        dayKey: day,
        waterMl: water,
        waterTargetMl: target,
        meals: meals,
        sleepLogged: sleep,
        workouts: workouts,
        habitsDone: habits,
        planDone: plan,
        postureChecks: posture,
        faceChecks: face,
        snapshots: snapshots,
        outfitsSaved: outfits,
        outfitsWorn: worn,
        weightLogged: weight,
      );
}
