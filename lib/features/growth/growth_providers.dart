import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/discipline.dart';
import '../../domain/entities/exercise_library.dart';
import '../../domain/entities/health.dart';
import '../../data/repositories/snapshot_repository.dart' show SnapshotKind;
import '../../domain/services/blueprint_engine.dart';
import '../../domain/services/insights_engine.dart';
import '../content/content_providers.dart';
import '../health/body_providers.dart';
import '../health/health_providers.dart';
import '../insights/insights_providers.dart';
import '../plans/plan_providers.dart' show activeBodyPlanProvider;
import '../posture/posture_providers.dart';
import '../snapshots/snapshot_providers.dart';
import '../style/style_providers.dart';

/// Martial arts and skills, each with its own card (built-in overview).
final disciplinesProvider = FutureProvider<List<Discipline>>((ref) async {
  final raw = await rootBundle.loadString('assets/content/disciplines.json', cache: false);
  return [for (final d in jsonDecode(raw) as List) Discipline.fromJson(d as Map<String, dynamic>)];
});

/// Techniques and drills per discipline id, from installed packs.
final techniquesByDisciplineProvider = Provider<Map<String, List<LibraryExercise>>>((ref) {
  final all = ref.watch(exerciseCatalogProvider).value ?? const <LibraryExercise>[];
  final out = <String, List<LibraryExercise>>{};
  for (final e in all) {
    if (e.discipline != null) (out[e.discipline!] ??= []).add(e);
  }
  return out;
});

final blueprintFactsProvider = Provider<BlueprintFacts>((ref) {
  final now = ref.watch(clockProvider)();
  final twoWeeks = now.subtract(const Duration(days: 14));
  final week = now.subtract(const Duration(days: 7));
  MetricSeries series(InsightMetric m) => ref.watch(insightSeriesProvider((m, InsightRange.week)));
  final postures = ref.watch(postureHistoryProvider).value ?? const [];
  final weights = ref.watch(weightRecordsProvider).value ?? const [];
  final faces = ref.watch(snapshotsProvider(SnapshotKind.face)).value ?? const [];
  final exercises = ref.watch(exercisesProvider).value ?? const <ExerciseEntry>[];
  final skills = exercises.where((e) => e.category == ExerciseCategory.martialArts);
  return BlueprintFacts(
    goals: ref.watch(goalsProvider).value ?? const {},
    water: series(InsightMetric.water),
    sleep: series(InsightMetric.sleep),
    activity: series(InsightMetric.activity),
    habits: series(InsightMetric.habits),
    hasBodyPlan: ref.watch(activeBodyPlanProvider).value != null,
    weighIns14d: weights.where((w) => w.measurement.recordedAt.isAfter(twoWeeks)).length,
    postureChecks14d: postures.where((p) => p.recordedAt.isAfter(twoWeeks)).length,
    everCheckedPosture: postures.isNotEmpty,
    wardrobeItems: (ref.watch(wardrobeProvider).value ?? const []).length,
    savedOutfits: (ref.watch(savedOutfitsProvider).value ?? const []).length,
    snapshotThisWeek: faces.any((s) => s.takenAt.isAfter(week)),
    everSnapshot: faces.isNotEmpty,
    skillSessions7d: skills.where((e) => e.performedAt.isAfter(week)).length,
    everPractisedSkill: skills.isNotEmpty,
  );
});

final blueprintProvider = Provider<List<AreaStatus>>((ref) => Blueprint.compute(ref.watch(blueprintFactsProvider)));
