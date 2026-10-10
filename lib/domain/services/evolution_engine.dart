/// Personal evolution timeline: meaningful moments derived from what the
/// user did, plus their own notes (pure Dart). Progress stays visible even
/// when physical change is slow. Wording is neutral — no judgement.
library;

import 'nutrition_engine.dart';
import 'progress_engine.dart';

enum MilestoneKind {
  firstStep,
  firstPosture,
  firstFace,
  firstSnapshot,
  firstOutfit,
  planStarted,
  streak7,
  streak30,
  habits30,
  weightChange,
  note,
}

class Milestone {
  const Milestone(this.dayKey, this.kind,
      {this.text, this.value, this.plan, this.noteId});

  final int dayKey;
  final MilestoneKind kind;

  /// The user's words (notes).
  final String? text;

  /// Signed kg change since the first weight (weightChange).
  final double? value;
  final PlanKind? plan;
  final String? noteId;
}

abstract final class EvolutionEngine {
  /// [weights] oldest first as (dayKey, kg). Result is newest first.
  static List<Milestone> build({
    required List<DayActivity> history,
    List<(int, PlanKind)> plans = const [],
    List<(int, double)> weights = const [],
    List<Milestone> notes = const [],
    double weightStepKg = 2,
  }) {
    final out = <Milestone>[...notes];
    final days = [...history]..sort((a, b) => a.dayKey.compareTo(b.dayKey));

    void first(MilestoneKind kind, bool Function(DayActivity) test) {
      for (final d in days) {
        if (test(d)) {
          out.add(Milestone(d.dayKey, kind));
          return;
        }
      }
    }

    first(MilestoneKind.firstStep, (d) => XpRules.forDay(d) > 0);
    first(MilestoneKind.firstPosture, (d) => d.postureChecks > 0);
    first(MilestoneKind.firstFace, (d) => d.faceChecks > 0);
    first(MilestoneKind.firstSnapshot, (d) => d.snapshots > 0);
    first(MilestoneKind.firstOutfit, (d) => d.outfitsSaved > 0);

    // Streaks: the day a run first reached 7 and 30 (rest days included).
    if (days.isNotEmpty) {
      final xp = <int, int>{};
      var hit7 = false, hit30 = false;
      for (final d in days) {
        xp[d.dayKey] = XpRules.forDay(d);
        final run = StreakRules.compute(xp, d.dayKey).current;
        if (!hit7 && run >= 7) {
          hit7 = true;
          out.add(Milestone(d.dayKey, MilestoneKind.streak7));
        }
        if (!hit30 && run >= 30) {
          hit30 = true;
          out.add(Milestone(d.dayKey, MilestoneKind.streak30));
        }
      }
    }

    var habits = 0;
    for (final d in days) {
      final before = habits;
      habits += d.habitsDone;
      if (before < 30 && habits >= 30) {
        out.add(Milestone(d.dayKey, MilestoneKind.habits30));
      }
    }

    for (final (day, kind) in plans) {
      out.add(Milestone(day, MilestoneKind.planStarted, plan: kind));
    }

    // Each time the change from the first weight crosses another step.
    if (weights.length > 1) {
      final start = weights.first.$2;
      var reached = 0;
      for (final (day, kg) in weights.skip(1)) {
        final steps = ((kg - start).abs() / weightStepKg).floor();
        if (steps > reached) {
          reached = steps;
          out.add(Milestone(day, MilestoneKind.weightChange,
              value: (kg - start).sign * steps * weightStepKg));
        }
      }
    }

    out.sort((a, b) => b.dayKey.compareTo(a.dayKey));
    return out;
  }
}
