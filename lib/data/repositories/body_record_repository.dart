import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../domain/entities/body.dart';
import '../../domain/entities/provenance.dart';

typedef Clock = DateTime Function();

/// Converts the provenance block of any measurement row (via `toJson`).
Measurement measurementFromJson(Map<String, dynamic> j) => Measurement(
      value: (j['value'] as num).toDouble(),
      unit: j['unit'] as String,
      source: DataSource.fromWireName(j['source'] as String),
      method: j['method'] as String?,
      confidence: Confidence.fromWireName(j['confidence'] as String?),
      lowerBound: (j['lowerBound'] as num?)?.toDouble(),
      upperBound: (j['upperBound'] as num?)?.toDouble(),
      recordedAt: DateTime.fromMillisecondsSinceEpoch(j['recordedAt'] as int,
          isUtc: true),
    );

Map<String, Expression<Object>> provenanceValues({
  required String id,
  required Measurement m,
  required String? notes,
  required int now,
}) =>
    {
      'id': Variable(id),
      'value': Variable(m.value),
      'unit': Variable(m.unit),
      'source': Variable(m.source.wireName),
      if (m.method != null) 'method': Variable(m.method!),
      if (m.confidence != null) 'confidence': Variable(m.confidence!.wireName),
      if (m.lowerBound != null) 'lower_bound': Variable(m.lowerBound!),
      if (m.upperBound != null) 'upper_bound': Variable(m.upperBound!),
      'recorded_at': Variable(m.recordedAt.toUtc().millisecondsSinceEpoch),
      if (notes != null && notes.isNotEmpty) 'notes': Variable(notes),
      'created_at': Variable(now),
      'updated_at': Variable(now),
    };

/// Height and weight records share one implementation (identical columns).
class BodyRecordRepository<T extends ProvenanceColumns,
    R extends DataClass> {
  BodyRecordRepository(
    this._db,
    this._table, {
    required this.unit,
    Clock? clock,
    Uuid? uuid,
  })  : _clock = clock ?? DateTime.now,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final TableInfo<T, R> _table;
  final String unit;
  final Clock _clock;
  final Uuid _uuid;

  /// Newest first.
  Stream<List<BodyRecord>> watchAll() {
    final query = _db.select(_table)
      ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]);
    return query.watch().map((rows) => rows.map(_toRecord).toList());
  }

  Future<List<BodyRecord>> all() async {
    final query = _db.select(_table)
      ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]);
    return (await query.get()).map(_toRecord).toList();
  }

  Future<String> add(Measurement m, {String? notes}) async {
    if (m.unit != unit) {
      throw ArgumentError('Expected canonical unit $unit, got ${m.unit}');
    }
    final id = _uuid.v4();
    await _db.into(_table).insert(RawValuesInsertable(provenanceValues(
      id: id,
      m: m,
      notes: notes,
      now: _clock().toUtc().millisecondsSinceEpoch,
    )));
    return id;
  }

  Future<void> delete(String id) =>
      (_db.delete(_table)..where((t) => t.id.equals(id))).go();

  BodyRecord _toRecord(R row) {
    final j = row.toJson();
    return BodyRecord(
      id: j['id'] as String,
      measurement: measurementFromJson(j),
      notes: j['notes'] as String?,
    );
  }
}
