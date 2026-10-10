import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/core/device/sensor_bridge.dart';
import 'package:personality/data/repositories/body_record_repository.dart';
import 'package:personality/data/repositories/health_repositories.dart';
import 'package:personality/domain/entities/health.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/domain/services/health_stats.dart';
import 'package:personality/domain/services/sensor_import.dart';
import 'package:personality/features/connected/data_import.dart';
import 'package:personality/features/health/health_providers.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

class FakeBridge implements SensorBridge {
  FakeBridge({this.state = const SensorStatus(), this.readout = const SensorReadout(),
      this.hc = const HealthConnectData()});
  SensorStatus state;
  SensorReadout readout;
  HealthConnectData hc;
  var permissionAsked = 0;
  ({bool steps, bool activity, bool sleep})? configured;
  DateTime? prunedBefore;

  @override
  Future<SensorStatus> status() async => state;
  @override
  Future<bool> requestActivityPermission() async {
    permissionAsked++;
    state = SensorStatus(
        stepSensor: state.stepSensor, activityPermission: true,
        playServices: state.playServices, healthConnect: state.healthConnect);
    return true;
  }
  @override
  Future<void> configure({required bool steps, required bool activity, required bool sleep}) async =>
      configured = (steps: steps, activity: activity, sleep: sleep);
  @override
  Future<SensorReadout> read() async => readout;
  @override
  Future<void> prune(DateTime before) async => prunedBefore = before;
  @override
  Future<void> clear() async {}
  @override
  Future<Set<String>> requestHealthConnect() async => {'steps'};
  @override
  Future<HealthConnectData> readHealthConnect(DateTime since) async => hc;
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final now = DateTime(2026, 10, 10, 20);
  DateTime at(int h, [int m = 0, int dayOffset = 0]) =>
      DateTime(2026, 10, 10 + dayOffset, h, m);

  group('sensor maths', () {
    test('steps per day survive a reboot and ignore glitches', () {
      final days = SensorImport.stepsPerDay([
        (at(8), 1000),
        (at(9), 2500), // +1500
        (at(10), 300), // reboot: +300
        (at(11), 900), // +600
        (at(12), 900_000), // glitch
        (at(13, 0, 1), 1200), // next day: below 900 000 → reboot: +1200
      ]);
      expect(days[20261010], 1500 + 300 + 600);
      expect(days[20261011], 1200);
    });

    test('sessions are enter→exit pairs of 10 minutes to 6 hours', () {
      final s = SensorImport.sessions([
        (at(7), MotionCodes.running, MotionCodes.enter),
        (at(7, 32), MotionCodes.running, MotionCodes.exit),
        (at(9), MotionCodes.walking, MotionCodes.enter),
        (at(9, 5), MotionCodes.walking, MotionCodes.exit), // too short
        (at(18), MotionCodes.onBicycle, MotionCodes.exit), // no enter
      ]);
      expect(s.map((x) => (x.kind, x.minutes)), [('running', 32)]);
    });

    test('sleep segments merge across short wakes', () {
      final n = SensorImport.sleep([
        (at(23, 0, -1), at(3), 0),
        (at(3, 30), at(6, 45), 0), // 30-min wake → merged
        (at(14), at(15), 0), // nap: too short
        (at(22), at(23), 1), // failed detection
      ]);
      expect(n, [(at(23, 0, -1), at(6, 45))]);
    });

    test('steps: the larger of your total and an imported total, never the sum', () {
      ActivityEntry e(int steps, DataSource s) => ActivityEntry(
          id: '$steps$s', kind: ActivityKind.walking, recordedAt: at(12),
          steps: steps, source: s);
      expect(HealthStats.stepsOn([e(3000, DataSource.userEntered), e(2000, DataSource.userEntered),
          e(4200, DataSource.deviceDerived), e(6100, DataSource.healthPlatform)], 20261010), 6100);
      expect(HealthStats.stepsOn([e(7000, DataSource.userEntered),
          e(4200, DataSource.deviceDerived)], 20261010), 7000);
    });
  });

  test('importer: no duplicates, sources never double count, disconnect', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final bridge = FakeBridge(
      readout: SensorReadout(
        steps: [(at(8).toUtc(), 100), (at(18).toUtc(), 5100)],
        activity: [
          (at(7), MotionCodes.running, MotionCodes.enter),
          (at(7, 40), MotionCodes.running, MotionCodes.exit),
          (at(17), MotionCodes.walking, MotionCodes.enter),
          (at(17, 25), MotionCodes.walking, MotionCodes.exit),
        ],
        sleep: [(at(23, 0, -1), at(6, 30), 0)],
      ),
      hc: HealthConnectData(
        dailySteps: [(DateTime(2026, 10, 10), 6400)],
        exercise: [(id: 'r1', start: at(7, 2), end: at(7, 41), kind: 'running', km: 5.1)],
        weight: [(id: 'w1', time: at(7), value: 71.4)],
      ),
    );
    final activities = ActivityRepository(db);
    final sleep = SleepRepository(db);
    final settings = ConnectedSettingsRepository(db, clock: () => now);
    // Built first so Dart infers each table's row type.
    final weight = BodyRecordRepository(db, db.weightRecords, unit: 'kg');
    final height = BodyRecordRepository(db, db.heightRecords, unit: 'cm');
    final water = BodyRecordRepository(db, db.waterLogs, unit: 'ml');
    final importer = DataImporter(
      bridge: bridge,
      activities: activities,
      sleep: sleep,
      weight: weight,
      height: height,
      water: water,
      settings: settings,
      clock: () => now,
    );
    // The user already logged last night themselves.
    await sleep.add(bedAt: at(23, 30, -1), wakeAt: at(6));
    final all = const ConnectedSettings(
        steps: true, activity: true, sleep: true, healthConnect: true);
    final existing = await sleep.watchSince(now.subtract(const Duration(days: 3))).first;
    await importer.sync(all, existingSleep: existing);
    await importer.sync(all, existingSleep: existing); // again: no duplicates

    final acts = await activities.watchSince(now.subtract(const Duration(days: 3))).first;
    final ids = acts.map((a) => a.id).toSet();
    expect(acts.length, ids.length);
    // The HC run wins over the sensor's run; the sensor's walk is kept.
    expect(ids, containsAll(['ext:hc:r1', 'ext:hc:steps-20261010', 'ext:sensor:steps-20261010']));
    expect(acts.where((a) => a.kind == ActivityKind.running).length, 1);
    expect(acts.where((a) => a.kind == ActivityKind.walking && a.durationMinutes == 25).length, 1);
    expect(HealthStats.stepsOn(acts, 20261010), 6400);
    // The user's own night wins over the phone's estimate.
    final nights = await sleep.watchSince(now.subtract(const Duration(days: 3))).first;
    expect(nights.single.source, DataSource.userEntered);
    expect((await settings.watch().first).lastSync!.isAtSameMomentAs(now), isTrue);
    expect(bridge.prunedBefore, now.subtract(const Duration(days: 3)));

    final removed = await importer.disconnect(healthConnect: true, removeData: true);
    expect(removed, 3); // steps day, run, weight
    final after = await activities.watchSince(now.subtract(const Duration(days: 3))).first;
    expect(after.any((a) => a.id.startsWith('ext:hc:')), isFalse);
    await db.close();
  });

  testWidgets('turning on steps asks permission, configures and syncs',
      (tester) async {
    final bridge = FakeBridge(
      state: const SensorStatus(stepSensor: true, playServices: true),
      readout: SensorReadout(steps: [(at(8).toUtc(), 100), (at(9).toUtc(), 1300)]),
    );
    final app = AppHarness(tester);
    await app.start(const AppSettings(onboardingCompleted: true),
        sensors: bridge, overrides: [clockProvider.overrideWithValue(() => now)]);
    await app.tapAndSettle(find.text('Health'));
    await tester.scrollUntilVisible(find.text('Connected data').hitTestable(), 150,
        scrollable: find.byType(Scrollable).last);
    await app.tapAndSettle(find.text('Connected data'));
    expect(find.textContaining("isn't on this phone"), findsOneWidget);

    await tester.tap(find.byKey(const Key('sensor-steps')));
    // The sync spinner animates while real database work runs, so pump
    // in steps instead of waiting to settle.
    for (var i = 0; i < 20; i++) {
      await app.run(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(bridge.permissionAsked, 1);
    expect(bridge.configured?.steps, isTrue);
    final acts = await app.run(
        () => ActivityRepository(app.db).watchSince(DateTime(2026, 10, 1)).first);
    expect(acts!.single.steps, 1200);
    expect(acts.single.source, DataSource.deviceDerived);
    await app.dispose();
  });
}
