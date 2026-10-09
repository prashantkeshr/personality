import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/app_database.dart';
import '../../domain/entities/body.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/nutrition_engine.dart';
import 'body_record_repository.dart';

/// The user's diet + training plan. Only one plan is active at a time;
/// earlier plans are kept (ended) as history.
class BodyPlan {
  const BodyPlan({
    required this.id,
    required this.kind,
    required this.pace,
    required this.diet,
    required this.startDay,
    required this.startWeightKg,
    required this.targetWeightKg,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.waterMl,
  });

  final String id;
  final PlanKind kind;
  final PlanPace pace;
  final DietPreference diet;
  final int startDay;
  final double startWeightKg;
  final double? targetWeightKg;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int waterMl;
}

class BodyPlanRepository {
  BodyPlanRepository(this._db, {Clock? clock, Uuid? uuid})
      : _clock = clock ?? DateTime.now,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  static T _enum<T extends Enum>(List<T> values, String name, T fallback) {
    for (final v in values) {
      if (v.name == name) return v;
    }
    return fallback;
  }

  BodyPlan _toPlan(BodyPlanRow r) => BodyPlan(
        id: r.id,
        kind: _enum(PlanKind.values, r.kind, PlanKind.maintain),
        pace: _enum(PlanPace.values, r.pace, PlanPace.steady),
        diet: _enum(DietPreference.values, r.diet, DietPreference.vegetarian),
        startDay: r.startDay,
        startWeightKg: r.startWeightKg,
        targetWeightKg: r.targetWeightKg,
        calories: r.calories,
        proteinG: r.proteinG,
        carbsG: r.carbsG,
        fatG: r.fatG,
        waterMl: r.waterMl,
      );

  Stream<BodyPlan?> watchActive() {
    final q = _db.select(_db.bodyPlans)
      ..where((t) => t.active.equals(true))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(1);
    return q.watchSingleOrNull().map((r) => r == null ? null : _toPlan(r));
  }

  /// Starts a plan from calculated [targets]; any active plan is ended.
  Future<String> start({
    required PlanTargets targets,
    required DietPreference diet,
    required double weightKg,
    double? targetWeightKg,
  }) async {
    final id = _uuid.v4();
    final now = _clock().toUtc().millisecondsSinceEpoch;
    await _db.transaction(() async {
      await _endActive(now);
      await _db.into(_db.bodyPlans).insert(BodyPlansCompanion.insert(
            id: id,
            kind: targets.kind.name,
            pace: targets.pace.name,
            diet: diet.name,
            startDay: Days.key(_clock()),
            startWeightKg: weightKg,
            targetWeightKg: Value(targetWeightKg),
            calories: targets.calories,
            proteinG: targets.proteinG,
            carbsG: targets.carbsG,
            fatG: targets.fatG,
            waterMl: targets.waterMl,
            createdAt: now,
          ));
    });
    return id;
  }

  Future<void> end() =>
      _endActive(_clock().toUtc().millisecondsSinceEpoch);

  Future<void> _endActive(int now) =>
      (_db.update(_db.bodyPlans)..where((t) => t.active.equals(true))).write(
          BodyPlansCompanion(active: const Value(false), endedAt: Value(now)));
}
