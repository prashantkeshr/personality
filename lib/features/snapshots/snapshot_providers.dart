import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/providers.dart';
import '../../data/repositories/snapshot_repository.dart';
import '../health/health_providers.dart';

final snapshotRepositoryProvider = Provider((ref) => SnapshotRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider)));

final snapshotsProvider =
    StreamProvider.family<List<Snapshot>, SnapshotKind>((ref, kind) =>
        ref.watch(snapshotRepositoryProvider).watch(kind));

const _consentKey = 'snapshots.consent';

/// Whether the user agreed to store progress photos on this device.
final snapshotConsentProvider = StreamProvider<bool>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final q = db.select(db.appSettingsEntries)
    ..where((t) => t.key.equals(_consentKey));
  return q.watchSingleOrNull().map((r) => r?.value == 'true');
});

Future<void> setSnapshotConsent(AppDatabase db, bool on) =>
    db.into(db.appSettingsEntries).insertOnConflictUpdate(
          AppSettingsEntriesCompanion.insert(
            key: _consentKey,
            value: '$on',
            updatedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
          ),
        );
