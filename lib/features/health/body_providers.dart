import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/repositories/body_record_repository.dart';
import '../../data/repositories/measurement_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../domain/entities/body.dart';
import '../../domain/services/height_policy.dart';
import '../../domain/services/proportion_engine.dart';

final profileRepositoryProvider = Provider(
    (ref) => ProfileRepository(ref.watch(appDatabaseProvider)));

final heightRepositoryProvider = Provider((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BodyRecordRepository(db, db.heightRecords,
      unit: CanonicalUnits.length);
});

final weightRepositoryProvider = Provider((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BodyRecordRepository(db, db.weightRecords, unit: CanonicalUnits.mass);
});

final measurementRepositoryProvider = Provider(
    (ref) => MeasurementRepository(ref.watch(appDatabaseProvider)));

final profileProvider = StreamProvider<Profile>(
    (ref) => ref.watch(profileRepositoryProvider).watchProfile());

final goalsProvider = StreamProvider<Set<GoalType>>(
    (ref) => ref.watch(profileRepositoryProvider).watchGoals());

final heightRecordsProvider = StreamProvider<List<BodyRecord>>(
    (ref) => ref.watch(heightRepositoryProvider).watchAll());

final weightRecordsProvider = StreamProvider<List<BodyRecord>>(
    (ref) => ref.watch(weightRepositoryProvider).watchAll());

final measurementRecordsProvider = StreamProvider<List<BodyMeasurementRecord>>(
    (ref) => ref.watch(measurementRepositoryProvider).watchAll());

final primaryHeightProvider = FutureProvider<BodyRecord?>((ref) async {
  final heights = await ref.watch(heightRecordsProvider.future);
  final profile = await ref.watch(profileProvider.future);
  return selectPrimaryHeight(heights, pinnedId: profile.primaryHeightId);
});

final proportionProvider = FutureProvider<ProportionProfile>((ref) async {
  final height = await ref.watch(primaryHeightProvider.future);
  final measurements = await ref.watch(measurementRecordsProvider.future);
  return ProportionEngine.calculate(
    height: height,
    latest: latestByType(measurements),
  );
});
