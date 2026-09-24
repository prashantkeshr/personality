import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/data/repositories/body_record_repository.dart';
import 'package:personality/data/repositories/measurement_repository.dart';
import 'package:personality/data/repositories/profile_repository.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/entities/provenance.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  final at = DateTime.utc(2026, 9, 20, 8);

  Measurement cm(double v, {DataSource s = DataSource.userEntered}) =>
      Measurement(
        value: v,
        unit: 'cm',
        source: s,
        recordedAt: at,
        method: MeasurementMethod.selfMeasured.wireName,
        confidence: s.requiresConfidence ? Confidence.medium : null,
        lowerBound: s.requiresConfidence ? v - 1 : null,
        upperBound: s.requiresConfidence ? v + 2 : null,
      );

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('height records round-trip with full provenance', () async {
    final repo =
        BodyRecordRepository(db, db.heightRecords, unit: CanonicalUnits.length);
    await repo.add(cm(172), notes: 'morning');
    await repo.add(cm(173, s: DataSource.cameraDerived));

    final all = await repo.all();
    expect(all, hasLength(2));
    final manual = all.firstWhere((r) => r.source == DataSource.userEntered);
    expect(manual.value, 172);
    expect(manual.notes, 'morning');
    expect(manual.recordedAt, at);
    expect(manual.measurement.method, 'Self-measured');

    final cam = all.firstWhere((r) => r.source == DataSource.cameraDerived);
    expect(cam.measurement.confidence, Confidence.medium);
    expect(cam.measurement.lowerBound, 172);
    expect(cam.measurement.upperBound, 175);
  });

  test('rejects values not in the canonical unit', () {
    final repo =
        BodyRecordRepository(db, db.weightRecords, unit: CanonicalUnits.mass);
    expect(repo.add(cm(70)), throwsArgumentError);
  });

  test('deleting the pinned height clears the pin', () async {
    final heights =
        BodyRecordRepository(db, db.heightRecords, unit: CanonicalUnits.length);
    final profiles = ProfileRepository(db);
    final id = await heights.add(cm(172));
    await profiles.save(const Profile().copyWith(primaryHeightId: () => id));
    expect((await profiles.load()).primaryHeightId, id);

    await profiles.deleteHeight(id);
    expect(await heights.all(), isEmpty);
    expect((await profiles.load()).primaryHeightId, isNull);
  });

  test('profile and goals persist', () async {
    final repo = ProfileRepository(db);
    await repo.save(const Profile(
      displayName: '  Asha ',
      ageRange: AgeRange.from25to34,
      activityLevel: ActivityLevel.moderate,
      goalWeightMinKg: 60,
      goalWeightMaxKg: 65,
    ));
    final p = await repo.load();
    expect(p.displayName, 'Asha');
    expect(p.ageRange, AgeRange.from25to34);
    expect(p.activityLevel, ActivityLevel.moderate);
    expect(p.hasWeightGoal, isTrue);

    await repo.setGoals({GoalType.posture, GoalType.style});
    expect(await repo.watchGoals().first, {GoalType.posture, GoalType.style});
    await repo.setGoals({GoalType.sleep});
    expect(await repo.watchGoals().first, {GoalType.sleep});
  });

  test('measurements keep type and custom label; latestByType', () async {
    final repo = MeasurementRepository(db);
    await repo.add(BodyMeasurementType.waist, cm(84));
    await repo.add(BodyMeasurementType.custom, cm(38), customLabel: 'Calf');
    expect(repo.add(BodyMeasurementType.custom, cm(10)), throwsArgumentError);

    final all = await repo.watchAll().first;
    expect(all, hasLength(2));
    final custom = all.firstWhere((r) => r.type == BodyMeasurementType.custom);
    expect(custom.customLabel, 'Calf');

    final latest = latestByType(all);
    expect(latest.keys, [BodyMeasurementType.waist]);
  });
}
