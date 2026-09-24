// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

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
}
