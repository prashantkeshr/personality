import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../domain/entities/provenance.dart';
import '../../domain/services/face_engine.dart';
import 'body_record_repository.dart';

class SavedFaceAnalysis {
  const SavedFaceAnalysis({
    required this.id,
    required this.recordedAt,
    required this.result,
  });

  final String id;
  final DateTime recordedAt;
  final FaceShapeResult result;
}

FaceShape? _shape(String? n) {
  for (final s in FaceShape.values) {
    if (s.name == n) return s;
  }
  return null;
}

/// Face-shape estimates and favourite styles. Proportions only.
class FaceRepository {
  FaceRepository(this._db, {Clock? clock, Uuid? uuid})
      : _clock = clock ?? DateTime.now,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  static const method = 'Face outline (on-device), median of frames';

  int get _now => _clock().toUtc().millisecondsSinceEpoch;

  Future<String> save(FaceShapeResult r) async {
    final id = _uuid.v4();
    await _db.transaction(() async {
      await _db.into(_db.faceAnalyses).insert(FaceAnalysesCompanion.insert(
            id: id,
            recordedAt: _now,
            shape: r.shape.name,
            alsoLike: Value(r.alsoLike?.name),
            confidence: r.confidence.wireName,
            framesUsed: r.framesUsed,
            source: r.source.wireName,
            method: method,
            createdAt: _now,
          ));
      for (final e in r.ratios.entries) {
        await _db.into(_db.faceMetrics).insert(FaceMetricsCompanion.insert(
            analysisId: id, metric: e.key.name, value: e.value));
      }
    });
    return id;
  }

  Stream<List<SavedFaceAnalysis>> watchAll() {
    final q = _db.select(_db.faceAnalyses)
      ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]);
    return q.watch().asyncMap((rows) async {
      if (rows.isEmpty) return const <SavedFaceAnalysis>[];
      final metrics = await (_db.select(_db.faceMetrics)
            ..where((t) => t.analysisId.isIn(rows.map((r) => r.id))))
          .get();
      return [
        for (final r in rows)
          if (_shape(r.shape) != null)
            SavedFaceAnalysis(
              id: r.id,
              recordedAt:
                  DateTime.fromMillisecondsSinceEpoch(r.recordedAt, isUtc: true),
              result: FaceShapeResult(
                shape: _shape(r.shape)!,
                alsoLike: _shape(r.alsoLike),
                confidence: Confidence.fromWireName(r.confidence)!,
                framesUsed: r.framesUsed,
                ratios: {
                  for (final m in metrics)
                    if (m.analysisId == r.id)
                      for (final fr in FaceRatio.values)
                        if (fr.name == m.metric) fr: m.value,
                },
              ),
            ),
      ];
    });
  }

  Future<void> delete(String id) =>
      (_db.delete(_db.faceAnalyses)..where((t) => t.id.equals(id))).go();

  Stream<Set<String>> watchFavorites() => _db
      .select(_db.styleFavorites)
      .watch()
      .map((rows) => {for (final r in rows) r.itemId});

  Future<void> setFavorite(String itemId, bool on) async {
    if (on) {
      await _db.into(_db.styleFavorites).insertOnConflictUpdate(
          StyleFavoritesCompanion.insert(itemId: itemId, createdAt: _now));
    } else {
      await (_db.delete(_db.styleFavorites)
            ..where((t) => t.itemId.equals(itemId)))
          .go();
    }
  }
}
