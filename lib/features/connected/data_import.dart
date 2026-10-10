import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/device/sensor_bridge.dart';
import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../data/repositories/body_record_repository.dart';
import '../../data/repositories/health_repositories.dart';
import '../../domain/entities/body.dart';
import '../../domain/entities/health.dart';
import '../../domain/entities/provenance.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/sensor_import.dart';
import '../health/body_providers.dart';
import '../health/health_providers.dart';

/// Which on-device sources the user turned on.
class ConnectedSettings {
  const ConnectedSettings({
    this.steps = false,
    this.activity = false,
    this.sleep = false,
    this.healthConnect = false,
    this.lastSync,
  });

  final bool steps;
  final bool activity;
  final bool sleep;
  final bool healthConnect;
  final DateTime? lastSync;

  bool get anySensor => steps || activity || sleep;
  bool get any => anySensor || healthConnect;
}

class ConnectedSettingsRepository {
  ConnectedSettingsRepository(this._db, {Clock? clock}) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final Clock _clock;
  static const _keys = ['sync.steps', 'sync.activity', 'sync.sleep', 'sync.hc', 'sync.last'];

  Stream<ConnectedSettings> watch() => (_db.select(_db.appSettingsEntries)
        ..where((t) => t.key.isIn(_keys)))
      .watch()
      .map((rows) {
        final m = {for (final r in rows) r.key: r.value};
        final last = int.tryParse(m['sync.last'] ?? '');
        return ConnectedSettings(
          steps: m['sync.steps'] == 'true',
          activity: m['sync.activity'] == 'true',
          sleep: m['sync.sleep'] == 'true',
          healthConnect: m['sync.hc'] == 'true',
          lastSync: last == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(last, isUtc: true),
        );
      });

  Future<void> _put(String k, String v) => _db.into(_db.appSettingsEntries).insertOnConflictUpdate(
      AppSettingsEntriesCompanion.insert(
          key: k, value: v, updatedAt: _clock().toUtc().millisecondsSinceEpoch));

  Future<void> set({bool? steps, bool? activity, bool? sleep, bool? healthConnect}) async {
    if (steps != null) await _put('sync.steps', '$steps');
    if (activity != null) await _put('sync.activity', '$activity');
    if (sleep != null) await _put('sync.sleep', '$sleep');
    if (healthConnect != null) await _put('sync.hc', '$healthConnect');
  }

  Future<void> markSynced(DateTime at) =>
      _put('sync.last', '${at.toUtc().millisecondsSinceEpoch}');
}

class ImportCounts {
  const ImportCounts({this.days = 0, this.sessions = 0, this.nights = 0, this.records = 0});
  final int days;
  final int sessions;
  final int nights;
  final int records;
  int get total => days + sessions + nights + records;
}

/// Imports on-device data into the app's own tables. Every imported row has
/// a stable id (`ext:<source>:<key>`), so syncing again updates it rather
/// than adding a copy, and disconnecting can remove exactly what came in.
class DataImporter {
  DataImporter({
    required this.bridge,
    required this.activities,
    required this.sleep,
    required this.weight,
    required this.height,
    required this.water,
    required this.settings,
    Clock? clock,
  }) : _clock = clock ?? DateTime.now;

  final SensorBridge bridge;
  final ActivityRepository activities;
  final SleepRepository sleep;
  final BodyRecordRepository weight;
  final BodyRecordRepository height;
  final BodyRecordRepository water;
  final ConnectedSettingsRepository settings;
  final Clock _clock;

  static const sensorPrefix = 'ext:sensor:';
  static const hcPrefix = 'ext:hc:';

  static ActivityKind _kind(String k) =>
      ActivityKind.values.asNameMap()[k] ?? ActivityKind.other;

  /// [existingSleep] defaults to the last five weeks from the database.
  Future<ImportCounts> sync(ConnectedSettings s,
      {List<SleepEntry>? existingSleep}) async {
    final now = _clock();
    // Read directly: an unwatched provider's future can stay pending.
    existingSleep ??=
        await sleep.watchSince(now.subtract(const Duration(days: 35))).first;
    var days = 0, sessions = 0, nights = 0, records = 0;
    // Sessions and nights already known from another source, to avoid
    // counting the same run or night twice.
    final hcSessions = <(DateTime, DateTime)>[];
    final otherNights = [
      for (final e in existingSleep)
        if (!e.id.startsWith(sensorPrefix)) (e.bedAt, e.wakeAt)
    ];

    if (s.healthConnect) {
      final since = s.lastSync?.subtract(const Duration(days: 2)) ??
          now.subtract(const Duration(days: 30));
      final hc = await bridge.readHealthConnect(since);
      for (final (dayStart, steps) in hc.dailySteps) {
        if (steps <= 0) continue;
        final d = dayStart.toLocal();
        await activities.upsertImported(
            id: '${hcPrefix}steps-${Days.key(d)}',
            kind: ActivityKind.walking,
            recordedAt: DateTime(d.year, d.month, d.day, 12),
            source: DataSource.healthPlatform,
            steps: steps);
        days++;
      }
      for (final e in hc.exercise) {
        hcSessions.add((e.start, e.end));
        await activities.upsertImported(
            id: '$hcPrefix${e.id}',
            kind: _kind(e.kind),
            recordedAt: e.start,
            source: DataSource.healthPlatform,
            durationMinutes: e.end.difference(e.start).inMinutes,
            distanceKm: e.km);
        sessions++;
      }
      for (final n in hc.sleep) {
        if (otherNights.any((o) => SensorImport.overlaps(o.$1, o.$2, n.start, n.end))) {
          continue; // the user's own entry wins
        }
        await sleep.upsertImported(
            id: '$hcPrefix${n.id}', bedAt: n.start, wakeAt: n.end,
            source: DataSource.healthPlatform);
        otherNights.add((n.start, n.end));
        nights++;
      }
      Measurement m(double v, String unit, DateTime t) => Measurement(
          value: v, unit: unit, source: DataSource.healthPlatform, recordedAt: t);
      for (final r in hc.weight) {
        await weight.upsert('$hcPrefix${r.id}', m(r.value, CanonicalUnits.mass, r.time));
        records++;
      }
      for (final r in hc.height) {
        await height.upsert('$hcPrefix${r.id}', m(r.value, CanonicalUnits.length, r.time));
        records++;
      }
      for (final r in hc.water) {
        await water.upsert('$hcPrefix${r.id}', m(r.value, 'ml', r.time));
        records++;
      }
    }

    if (s.anySensor) {
      final r = await bridge.read();
      if (s.steps) {
        // Days older than two are incomplete once early samples are pruned.
        final oldest = Days.key(now.subtract(const Duration(days: 2)));
        for (final e in SensorImport.stepsPerDay(r.steps).entries) {
          if (e.key < oldest) continue;
          final d = Days.fromKey(e.key);
          await activities.upsertImported(
              id: '${sensorPrefix}steps-${e.key}',
              kind: ActivityKind.walking,
              recordedAt: DateTime(d.year, d.month, d.day, 12),
              source: DataSource.deviceDerived,
              steps: e.value);
          days++;
        }
      }
      if (s.activity) {
        for (final x in SensorImport.sessions(r.activity)) {
          if (hcSessions.any((h) => SensorImport.overlaps(h.$1, h.$2, x.start, x.end))) {
            continue;
          }
          await activities.upsertImported(
              id: '${sensorPrefix}act-${x.start.millisecondsSinceEpoch}',
              kind: _kind(x.kind),
              recordedAt: x.start,
              source: DataSource.deviceDerived,
              durationMinutes: x.minutes);
          sessions++;
        }
      }
      if (s.sleep) {
        for (final (bed, wake) in SensorImport.sleep(r.sleep)) {
          if (otherNights.any((o) => SensorImport.overlaps(o.$1, o.$2, bed, wake))) {
            continue;
          }
          await sleep.upsertImported(
              id: '${sensorPrefix}sleep-${bed.millisecondsSinceEpoch}',
              bedAt: bed, wakeAt: wake, source: DataSource.deviceDerived);
          nights++;
        }
      }
      await bridge.prune(now.subtract(const Duration(days: 3)));
    }

    await settings.markSynced(now);
    return ImportCounts(days: days, sessions: sessions, nights: nights, records: records);
  }

  /// Stops a source; optionally removes what it imported.
  Future<int> disconnect({required bool healthConnect, required bool removeData}) async {
    if (!removeData) return 0;
    final p = healthConnect ? hcPrefix : sensorPrefix;
    return await activities.deleteImported(p) +
        await sleep.deleteImported(p) +
        (healthConnect
            ? await weight.deleteImported(p) +
                await height.deleteImported(p) +
                await water.deleteImported(p)
            : 0);
  }
}

final sensorBridgeProvider = Provider<SensorBridge>((ref) => const PlatformSensorBridge());

final connectedSettingsRepositoryProvider = Provider((ref) =>
    ConnectedSettingsRepository(ref.watch(appDatabaseProvider), clock: ref.watch(clockProvider)));

final connectedSettingsProvider = StreamProvider<ConnectedSettings>(
    (ref) => ref.watch(connectedSettingsRepositoryProvider).watch());

final sensorStatusProvider = FutureProvider<SensorStatus>(
    (ref) => ref.watch(sensorBridgeProvider).status());

final dataImporterProvider = Provider((ref) => DataImporter(
      bridge: ref.watch(sensorBridgeProvider),
      activities: ref.watch(activityRepositoryProvider),
      sleep: ref.watch(sleepRepositoryProvider),
      weight: ref.watch(weightRepositoryProvider),
      height: ref.watch(heightRepositoryProvider),
      water: ref.watch(waterRepositoryProvider),
      settings: ref.watch(connectedSettingsRepositoryProvider),
      clock: ref.watch(clockProvider),
    ));

/// Imports on app start and every time the app comes back to the front.
class DataSyncHost extends ConsumerStatefulWidget {
  const DataSyncHost({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<DataSyncHost> createState() => _DataSyncHostState();
}

class _DataSyncHostState extends ConsumerState<DataSyncHost> {
  late final AppLifecycleListener _lifecycle;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _sync);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _sync() async {
    if (_running || !mounted) return;
    _running = true;
    try {
      final s = await ref
          .read(connectedSettingsRepositoryProvider)
          .watch()
          .first;
      if (!s.any) return;
      await ref.read(dataImporterProvider).sync(s);
    } catch (e, st) {
      AppLogger.error('data.sync', e, st);
    } finally {
      _running = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
