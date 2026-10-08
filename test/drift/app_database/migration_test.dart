// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;
import 'generated/schema_v4.dart' as v4;
import 'generated/schema_v5.dart' as v5;
import 'generated/schema_v6.dart' as v6;
import 'generated/schema_v7.dart' as v7;
import 'generated/schema_v8.dart' as v8;
import 'generated/schema_v9.dart' as v9;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  // User settings written by v1 must survive the upgrade unchanged.
  test('migration from v1 to v2 does not corrupt data', () async {
    // Add data to insert into the old database, and the expected rows after the
    // migration.
    final oldAppSettingsData = <v1.AppSettingsData>[
      const v1.AppSettingsData(
          key: 'onboarding.completed', value: 'true', updatedAt: 1),
      const v1.AppSettingsData(key: 'units.system', value: 'imperial', updatedAt: 2),
    ];
    final expectedNewAppSettingsData = <v2.AppSettingsData>[
      const v2.AppSettingsData(
          key: 'onboarding.completed', value: 'true', updatedAt: 1),
      const v2.AppSettingsData(key: 'units.system', value: 'imperial', updatedAt: 2),
    ];

    final oldFeatureFlagData = <v1.FeatureFlagData>[
      const v1.FeatureFlagData(id: 'demo', enabled: 1, updatedAt: 3),
    ];
    final expectedNewFeatureFlagData = <v2.FeatureFlagData>[
      const v2.FeatureFlagData(id: 'demo', enabled: 1, updatedAt: 3),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.appSettings, oldAppSettingsData);
        batch.insertAll(oldDb.featureFlag, oldFeatureFlagData);
      },
      validateItems: (newDb) async {
        expect(
          expectedNewAppSettingsData,
          await newDb.select(newDb.appSettings).get(),
        );
        expect(
          expectedNewFeatureFlagData,
          await newDb.select(newDb.featureFlag).get(),
        );
      },
    );
  });

  // Body data written by v2 (Phase 2) must survive the v3 upgrade unchanged.
  test('migration from v2 to v3 keeps profile and height data', () async {
    const height = (
      id: 'h1',
      value: 172.0,
      unit: 'cm',
      source: 'USER_ENTERED',
      method: 'Self-measured',
      recordedAt: 1790000000000,
    );

    await verifier.testWithDataIntegrity(
      oldVersion: 2,
      newVersion: 3,
      createOld: v2.DatabaseAtV2.new,
      createNew: v3.DatabaseAtV3.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
            oldDb.userProfile,
            const v2.UserProfileData(
                id: 'me',
                displayName: 'Asha',
                primaryHeightId: 'h1',
                createdAt: 1,
                updatedAt: 1));
        batch.insert(
            oldDb.heightRecord,
            v2.HeightRecordData(
                id: height.id,
                value: height.value,
                unit: height.unit,
                source: height.source,
                method: height.method,
                recordedAt: height.recordedAt,
                createdAt: 1,
                updatedAt: 1));
      },
      validateItems: (newDb) async {
        final profile = await newDb.select(newDb.userProfile).getSingle();
        expect(profile.displayName, 'Asha');
        expect(profile.primaryHeightId, 'h1');
        final h = await newDb.select(newDb.heightRecord).getSingle();
        expect(h.value, height.value);
        expect(h.source, height.source);
        expect(h.method, height.method);
        expect(h.recordedAt, height.recordedAt);
      },
    );
  });

  // Habits and their history from v3 (Phase 3) must survive the v4 upgrade.
  test('migration from v3 to v4 keeps habits and completions', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 3,
      newVersion: 4,
      createOld: v3.DatabaseAtV3.new,
      createNew: v4.DatabaseAtV4.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
            oldDb.habit,
            const v3.HabitData(
                id: 'h1',
                name: 'Stretch',
                weekdays: 0x7F,
                archived: 0,
                createdAt: 1,
                updatedAt: 1));
        batch.insert(
            oldDb.habitCompletion,
            const v3.HabitCompletionData(
                habitId: 'h1',
                day: 20260926,
                status: 'completed',
                recordedAt: 2));
      },
      validateItems: (newDb) async {
        final h = await newDb.select(newDb.habit).getSingle();
        expect((h.id, h.name, h.weekdays), ('h1', 'Stretch', 0x7F));
        final c = await newDb.select(newDb.habitCompletion).getSingle();
        expect((c.habitId, c.day, c.status), ('h1', 20260926, 'completed'));
        expect(await newDb.select(newDb.routine).get(), isEmpty);
      },
    );
  });

  // Routines from v4 (Phase 4) must survive the v5 upgrade.
  test('migration from v4 to v5 keeps routines', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 4,
      newVersion: 5,
      createOld: v4.DatabaseAtV4.new,
      createNew: v5.DatabaseAtV5.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
            oldDb.routine,
            const v4.RoutineData(
                id: 'r1',
                name: 'Morning',
                weekdays: 0x7F,
                active: 1,
                createdAt: 1,
                updatedAt: 1));
      },
      validateItems: (newDb) async {
        final r = await newDb.select(newDb.routine).getSingle();
        expect((r.id, r.name, r.weekdays), ('r1', 'Morning', 0x7F));
        expect(await newDb.select(newDb.postureSession).get(), isEmpty);
      },
    );
  });

  // Posture checks from v5 (Phase 6) must survive the v6 upgrade.
  test('migration from v5 to v6 keeps posture history', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 5,
      newVersion: 6,
      createOld: v5.DatabaseAtV5.new,
      createNew: v6.DatabaseAtV6.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
            oldDb.postureSession,
            const v5.PostureSessionData(
                id: 'p1',
                recordedAt: 5,
                view: 'front',
                framesUsed: 15,
                confidence: 'HIGH',
                visibility: 0.9,
                source: 'CAMERA_DERIVED',
                method: 'm',
                createdAt: 5));
      },
      validateItems: (newDb) async {
        final p = await newDb.select(newDb.postureSession).getSingle();
        expect((p.id, p.framesUsed, p.confidence), ('p1', 15, 'HIGH'));
        expect(await newDb.select(newDb.faceAnalysis).get(), isEmpty);
      },
    );
  });

  // Face estimates from v6 (Phase 8) must survive the v7 upgrade.
  test('migration from v6 to v7 keeps face analyses', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 6,
      newVersion: 7,
      createOld: v6.DatabaseAtV6.new,
      createNew: v7.DatabaseAtV7.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
            oldDb.faceAnalysis,
            const v6.FaceAnalysisData(
                id: 'f1',
                recordedAt: 7,
                shape: 'oval',
                alsoLike: 'diamond',
                confidence: 'HIGH',
                framesUsed: 12,
                source: 'CAMERA_DERIVED',
                method: 'm',
                createdAt: 7));
      },
      validateItems: (newDb) async {
        final f = await newDb.select(newDb.faceAnalysis).getSingle();
        expect((f.id, f.shape, f.alsoLike), ('f1', 'oval', 'diamond'));
        expect(await newDb.select(newDb.progressSnapshot).get(), isEmpty);
      },
    );
  });

  // Progress snapshots from v7 (Phase 9) must survive the v8 upgrade.
  test('migration from v7 to v8 keeps snapshots', () async {
    final jpeg = Uint8List.fromList([0xff, 0xd8, 1, 2, 3, 0xff, 0xd9]);
    await verifier.testWithDataIntegrity(
      oldVersion: 7,
      newVersion: 8,
      createOld: v7.DatabaseAtV7.new,
      createNew: v8.DatabaseAtV8.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
            oldDb.progressSnapshot,
            v7.ProgressSnapshotData(
                id: 's1',
                kind: 'face',
                takenAt: 9,
                jpeg: jpeg,
                width: 720,
                height: 960,
                createdAt: 9));
      },
      validateItems: (newDb) async {
        final s = await newDb.select(newDb.progressSnapshot).getSingle();
        expect((s.id, s.kind), ('s1', 'face'));
        expect(s.jpeg, jpeg);
        expect(await newDb.select(newDb.wardrobeItem).get(), isEmpty);
      },
    );
  });

  // Snapshots from v8 gain empty eye-alignment columns in v9.
  test('migration from v8 to v9 keeps snapshots, not yet aligned', () async {
    final jpeg = Uint8List.fromList([0xff, 0xd8, 1, 2, 3, 0xff, 0xd9]);
    await verifier.testWithDataIntegrity(
      oldVersion: 8,
      newVersion: 9,
      createOld: v8.DatabaseAtV8.new,
      createNew: v9.DatabaseAtV9.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
            oldDb.progressSnapshot,
            v8.ProgressSnapshotData(
                id: 's1',
                kind: 'face',
                takenAt: 9,
                jpeg: jpeg,
                width: 720,
                height: 960,
                createdAt: 9));
      },
      validateItems: (newDb) async {
        final s = await newDb.select(newDb.progressSnapshot).getSingle();
        expect((s.id, s.kind, s.leftEyeX, s.alignChecked),
            ('s1', 'face', null, 0));
        expect(s.jpeg, jpeg);
      },
    );
  });
}
