import 'package:flutter/services.dart';

/// What the phone can provide for on-device health tracking.
class SensorStatus {
  const SensorStatus({
    this.stepSensor = false,
    this.activityPermission = false,
    this.playServices = false,
    this.healthConnect = false,
    this.healthConnectGranted = const {},
  });

  /// Hardware step counter present.
  final bool stepSensor;

  /// "Physical activity" permission granted.
  final bool activityPermission;

  /// Google Play services (on-device activity and sleep recognition).
  final bool playServices;

  /// Health Connect is already on the phone (never installed by us).
  final bool healthConnect;
  final Set<String> healthConnectGranted;

  bool get canTrackMotion => activityPermission && playServices;
}

/// Raw on-device sensor rows waiting to be imported.
class SensorReadout {
  const SensorReadout({
    this.steps = const [],
    this.activity = const [],
    this.sleep = const [],
  });

  /// (time, cumulative steps since reboot).
  final List<(DateTime, int)> steps;

  /// (time, activity type, transition) — Play services codes.
  final List<(DateTime, int, int)> activity;

  /// (start, end, status) — status 0 = successful detection.
  final List<(DateTime, DateTime, int)> sleep;
}

/// Records read from Health Connect.
class HealthConnectData {
  const HealthConnectData({
    this.dailySteps = const [],
    this.exercise = const [],
    this.sleep = const [],
    this.weight = const [],
    this.height = const [],
    this.water = const [],
  });

  final List<(DateTime dayStart, int steps)> dailySteps;
  final List<({String id, DateTime start, DateTime end, String kind, double? km})>
      exercise;
  final List<({String id, DateTime start, DateTime end})> sleep;
  final List<({String id, DateTime time, double value})> weight;
  final List<({String id, DateTime time, double value})> height;
  final List<({String id, DateTime time, double value})> water;
}

abstract interface class SensorBridge {
  Future<SensorStatus> status();
  Future<bool> requestActivityPermission();
  Future<void> configure({required bool steps, required bool activity, required bool sleep});
  Future<SensorReadout> read();
  Future<void> prune(DateTime before);
  Future<void> clear();
  Future<Set<String>> requestHealthConnect();
  Future<HealthConnectData> readHealthConnect(DateTime since);
}

class PlatformSensorBridge implements SensorBridge {
  const PlatformSensorBridge();

  static const _ch = MethodChannel('personality/sensors');

  static DateTime _t(Object? ms) =>
      DateTime.fromMillisecondsSinceEpoch((ms as num).toInt(), isUtc: true);

  @override
  Future<SensorStatus> status() async {
    final m = await _ch.invokeMapMethod<String, Object?>('status') ?? const {};
    return SensorStatus(
      stepSensor: m['stepSensor'] == true,
      activityPermission: m['activityPermission'] == true,
      playServices: m['playServices'] == true,
      healthConnect: m['healthConnect'] == 'available',
      healthConnectGranted: {...(m['hcGranted'] as List? ?? const []).cast<String>()},
    );
  }

  @override
  Future<bool> requestActivityPermission() async =>
      await _ch.invokeMethod<bool>('requestActivityPermission') ?? false;

  @override
  Future<void> configure(
          {required bool steps, required bool activity, required bool sleep}) =>
      _ch.invokeMethod('configure', {'steps': steps, 'activity': activity, 'sleep': sleep});

  @override
  Future<SensorReadout> read() async {
    final m = await _ch.invokeMapMethod<String, Object?>('read') ?? const {};
    List<List<num>> rows(String k) => [
          for (final r in (m[k] as List? ?? const [])) (r as List).cast<num>(),
        ];
    return SensorReadout(
      steps: [for (final r in rows('steps')) (_t(r[0]), r[1].toInt())],
      activity: [for (final r in rows('activity')) (_t(r[0]), r[1].toInt(), r[2].toInt())],
      sleep: [for (final r in rows('sleep')) (_t(r[0]), _t(r[1]), r[2].toInt())],
    );
  }

  @override
  Future<void> prune(DateTime before) =>
      _ch.invokeMethod('prune', before.millisecondsSinceEpoch);

  @override
  Future<void> clear() => _ch.invokeMethod('clear');

  @override
  Future<Set<String>> requestHealthConnect() async =>
      {...(await _ch.invokeListMethod<String>('hcRequest') ?? const [])};

  @override
  Future<HealthConnectData> readHealthConnect(DateTime since) async {
    final m = await _ch.invokeMapMethod<String, Object?>(
            'hcRead', since.millisecondsSinceEpoch) ??
        const {};
    List<Map<Object?, Object?>> list(String k) =>
        (m[k] as List? ?? const []).cast<Map<Object?, Object?>>();
    ({String id, DateTime time, double value}) point(Map<Object?, Object?> r) =>
        (id: r['id'] as String, time: _t(r['time']), value: (r['value'] as num).toDouble());
    return HealthConnectData(
      dailySteps: [
        for (final r in (m['steps'] as List? ?? const []))
          (_t((r as List)[0]), (r[1] as num).toInt()),
      ],
      exercise: [
        for (final r in list('exercise'))
          (
            id: r['id'] as String,
            start: _t(r['start']),
            end: _t(r['end']),
            kind: r['kind'] as String,
            km: (r['km'] as num?)?.toDouble(),
          ),
      ],
      sleep: [
        for (final r in list('sleep'))
          (id: r['id'] as String, start: _t(r['start']), end: _t(r['end'])),
      ],
      weight: [for (final r in list('weight')) point(r)],
      height: [for (final r in list('height')) point(r)],
      water: [for (final r in list('water')) point(r)],
    );
  }
}

/// No sensors (tests, unsupported platforms).
class NoSensorBridge implements SensorBridge {
  const NoSensorBridge();
  @override
  Future<SensorStatus> status() async => const SensorStatus();
  @override
  Future<bool> requestActivityPermission() async => false;
  @override
  Future<void> configure(
      {required bool steps, required bool activity, required bool sleep}) async {}
  @override
  Future<SensorReadout> read() async => const SensorReadout();
  @override
  Future<void> prune(DateTime before) async {}
  @override
  Future<void> clear() async {}
  @override
  Future<Set<String>> requestHealthConnect() async => const {};
  @override
  Future<HealthConnectData> readHealthConnect(DateTime since) async =>
      const HealthConnectData();
}
