import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../domain/entities/provenance.dart';
import '../../domain/services/posture_engine.dart';
import 'body_record_repository.dart';

T _enum<T extends Enum>(List<T> values, String name, T fallback) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return fallback;
}

class SavedPosture {
  const SavedPosture({
    required this.id,
    required this.recordedAt,
    required this.result,
  });

  final String id;
  final DateTime recordedAt;
  final PostureResult result;
}

/// Saved posture checks. Numbers only — frames are never stored.
class PostureRepository {
  PostureRepository(this._db, {Clock? clock, Uuid? uuid})
      : _clock = clock ?? DateTime.now,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  static const method = 'Pose landmarks (on-device), median of frames';

  Future<String> save(PostureResult r) async {
    final id = _uuid.v4();
    final now = _clock().toUtc().millisecondsSinceEpoch;
    await _db.transaction(() async {
      await _db.into(_db.postureSessions).insert(PostureSessionsCompanion.insert(
            id: id,
            recordedAt: now,
            view: r.view.name,
            framesUsed: r.framesUsed,
            confidence: r.confidence.wireName,
            visibility: r.visibility,
            source: r.source.wireName,
            method: method,
            createdAt: now,
          ));
      for (final m in r.metrics) {
        await _db.into(_db.postureMetrics).insert(PostureMetricsCompanion.insert(
              sessionId: id,
              metric: m.metric.name,
              value: m.degrees,
              unit: 'deg',
              direction: m.direction.name,
              band: m.band.name,
              spread: m.spread,
              confidence: m.confidence.wireName,
            ));
      }
    });
    return id;
  }

  /// Newest first.
  Stream<List<SavedPosture>> watchAll() {
    final q = _db.select(_db.postureSessions)
      ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]);
    return q.watch().asyncMap((sessions) async {
      if (sessions.isEmpty) return const <SavedPosture>[];
      final metrics = await (_db.select(_db.postureMetrics)
            ..where((t) => t.sessionId.isIn(sessions.map((s) => s.id))))
          .get();
      return [
        for (final s in sessions)
          SavedPosture(
            id: s.id,
            recordedAt:
                DateTime.fromMillisecondsSinceEpoch(s.recordedAt, isUtc: true),
            result: PostureResult(
              view: _enum(PostureView.values, s.view, PostureView.front),
              framesUsed: s.framesUsed,
              confidence: Confidence.fromWireName(s.confidence)!,
              visibility: s.visibility,
              metrics: [
                for (final m in metrics)
                  if (m.sessionId == s.id)
                    MetricResult(
                      metric: _enum(
                          PostureMetric.values, m.metric, PostureMetric.headTilt),
                      degrees: m.value,
                      direction: _enum(MetricDirection.values, m.direction,
                          MetricDirection.none),
                      band: _enum(
                          AlignmentBand.values, m.band, AlignmentBand.aligned),
                      spread: m.spread,
                      confidence: Confidence.fromWireName(m.confidence)!,
                    ),
              ],
            ),
          ),
      ];
    });
  }

  /// Deletes a session and its metrics (cascade).
  Future<void> delete(String id) =>
      (_db.delete(_db.postureSessions)..where((t) => t.id.equals(id))).go();
}
