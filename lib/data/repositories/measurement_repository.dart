import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../domain/entities/body.dart';
import '../../domain/entities/provenance.dart';
import 'body_record_repository.dart';

class MeasurementRepository {
  MeasurementRepository(this._db, {Clock? clock, Uuid? uuid})
      : _clock = clock ?? DateTime.now,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  /// All measurements, newest first.
  Stream<List<BodyMeasurementRecord>> watchAll() {
    final query = _db.select(_db.bodyMeasurements)
      ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]);
    return query.watch().map((rows) => rows.map(_toRecord).toList());
  }

  Future<String> add(
    BodyMeasurementType type,
    Measurement m, {
    String? customLabel,
    String? notes,
  }) async {
    if (m.unit != CanonicalUnits.length) {
      throw ArgumentError('Measurements are stored in cm');
    }
    if (type == BodyMeasurementType.custom &&
        (customLabel == null || customLabel.trim().isEmpty)) {
      throw ArgumentError('Custom measurements need a label');
    }
    final id = _uuid.v4();
    await _db.into(_db.bodyMeasurements).insert(RawValuesInsertable({
      ...provenanceValues(
        id: id,
        m: m,
        notes: notes,
        now: _clock().toUtc().millisecondsSinceEpoch,
      ),
      'type': Variable(type.name),
      if (type == BodyMeasurementType.custom)
        'custom_label': Variable(customLabel!.trim()),
    }));
    return id;
  }

  Future<void> delete(String id) =>
      (_db.delete(_db.bodyMeasurements)..where((t) => t.id.equals(id))).go();

  BodyMeasurementRecord _toRecord(BodyMeasurementRow row) =>
      BodyMeasurementRecord(
        id: row.id,
        measurement: measurementFromJson(row.toJson()),
        type: BodyMeasurementType.fromName(row.type),
        customLabel: row.customLabel,
        notes: row.notes,
      );
}

/// Latest record for each standard measurement type.
Map<BodyMeasurementType, BodyRecord> latestByType(
    List<BodyMeasurementRecord> newestFirst) {
  final result = <BodyMeasurementType, BodyRecord>{};
  for (final r in newestFirst) {
    if (r.type == BodyMeasurementType.custom) continue;
    result.putIfAbsent(r.type, () => r);
  }
  return result;
}
