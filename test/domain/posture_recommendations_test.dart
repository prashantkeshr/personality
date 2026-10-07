import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/data/repositories/posture_repository.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/domain/services/posture_engine.dart';
import 'package:personality/domain/services/posture_recommendations.dart';

MetricResult metric(PostureMetric m, double deg,
        {Confidence c = Confidence.high,
        MetricDirection d = MetricDirection.left}) =>
    MetricResult(
      metric: m,
      degrees: deg,
      direction: d,
      band: PostureBands.of(m, deg),
      spread: 0.5,
      confidence: c,
    );

PostureResult result(List<MetricResult> metrics,
        {Confidence c = Confidence.high, PostureView view = PostureView.front}) =>
    PostureResult(
        view: view,
        metrics: metrics,
        confidence: c,
        framesUsed: 15,
        visibility: 0.9);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late List<ExerciseContent> library;

  setUpAll(() {
    final raw = File('assets/content/posture_exercises.json').readAsStringSync();
    library = [
      for (final e in jsonDecode(raw) as List)
        ExerciseContent.fromJson(e as Map<String, dynamic>),
    ];
  });

  test('content has English and Hindi for every exercise', () {
    expect(library, isNotEmpty);
    for (final e in library) {
      for (final field in [e.name, e.summary, e.dose, e.safety]) {
        expect(field.keys, containsAll(['en', 'hi']), reason: e.id);
      }
      expect(e.steps['en']!.length, e.steps['hi']!.length, reason: e.id);
    }
  });

  group('PostureRecommender', () {
    test('most notable observation first, with why and alternative', () {
      final recs = PostureRecommender.recommend(
        latest: result([
          metric(PostureMetric.shoulderLevel, 3), // slight
          metric(PostureMetric.headTilt, 9), // noticeable
          metric(PostureMetric.hipLevel, 1), // aligned
        ]),
        library: library,
        postureGoal: true,
      );
      expect(recs, hasLength(2));
      expect(recs.first.exercise.targets, contains(PostureMetric.headTilt));
      final observed = recs.first.reasons.whereType<ObservedReason>().single;
      expect(observed.metric.metric, PostureMetric.headTilt);
      expect(recs.first.reasons.whereType<GoalReason>(), hasLength(1));
      expect(recs.first.alternative, isNotNull);
      expect(recs.map((r) => r.exercise.id).toSet(), hasLength(2),
          reason: 'no duplicate exercises');
    });

    test('previous check with the same finding adds a repeated reason', () {
      final recs = PostureRecommender.recommend(
        latest: result([metric(PostureMetric.shoulderLevel, 4)]),
        previous: result([metric(PostureMetric.shoulderLevel, 3.5)]),
        library: library,
      );
      expect(recs.single.reasons.whereType<RepeatedReason>(), hasLength(1));
    });

    test('all aligned suggests only a maintenance break', () {
      final recs = PostureRecommender.recommend(
        latest: result([metric(PostureMetric.shoulderLevel, 1)]),
        library: library,
      );
      expect(recs.single.exercise.id, PostureRecommender.generalBreakId);
      expect(recs.single.reasons.first, isA<MaintenanceReason>());
    });

    test('low-confidence results drive no suggestions', () {
      expect(
          PostureRecommender.recommend(
            latest: result([metric(PostureMetric.headTilt, 12)],
                c: Confidence.low),
            library: library,
          ),
          isEmpty);
      // A single low-confidence metric is ignored too.
      final recs = PostureRecommender.recommend(
        latest: result([
          metric(PostureMetric.headTilt, 12, c: Confidence.low),
        ], c: Confidence.medium),
        library: library,
      );
      expect(recs.single.exercise.id, PostureRecommender.generalBreakId);
    });
  });

  test('repository stores numbers with provenance and cascades', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final repo = PostureRepository(db);
    final id = await repo.save(result([
      metric(PostureMetric.shoulderLevel, 4.2),
      metric(PostureMetric.headTilt, 1.5, d: MetricDirection.none),
    ], c: Confidence.medium));
    final saved = (await repo.watchAll().first).single;
    expect(saved.id, id);
    expect(saved.result.source, DataSource.cameraDerived);
    expect(saved.result.confidence, Confidence.medium);
    final s = saved.result[PostureMetric.shoulderLevel]!;
    expect((s.degrees, s.band, s.direction),
        (4.2, AlignmentBand.slight, MetricDirection.left));

    await repo.delete(id);
    expect(await repo.watchAll().first, isEmpty);
    expect(await db.select(db.postureMetrics).get(), isEmpty);
    await db.close();
  });
}
