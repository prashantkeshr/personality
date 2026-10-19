import '../entities/body.dart';
import 'insights_engine.dart';

/// Areas of the personal Blueprint. There is deliberately no overall
/// "personality score": each area stands on its own.
enum BlueprintArea { body, fitness, posture, sleep, hydration, habits, style, grooming, skills }

/// Why an area is shown the way it is (drives the "Why am I seeing this?" sheet).
enum BlueprintReason { yourGoal, noRecords, onTrack, partly, fallingBehind }

/// What the user should do next for an area.
enum BlueprintAction {
  setBodyPlan,
  logWeight,
  startWorkout,
  checkPosture,
  logSleep,
  addWater,
  doHabits,
  addClothes,
  buildOutfit,
  takeSnapshot,
  practiseSkill,
}

/// Everything the Blueprint needs, gathered from the user's records.
class BlueprintFacts {
  const BlueprintFacts({
    this.goals = const {},
    this.water,
    this.sleep,
    this.activity,
    this.habits,
    this.hasBodyPlan = false,
    this.weighIns14d = 0,
    this.postureChecks14d = 0,
    this.everCheckedPosture = false,
    this.wardrobeItems = 0,
    this.savedOutfits = 0,
    this.snapshotThisWeek = false,
    this.everSnapshot = false,
    this.skillSessions7d = 0,
    this.everPractisedSkill = false,
  });

  final Set<GoalType> goals;

  /// Week series from the insights engine.
  final MetricSeries? water;
  final MetricSeries? sleep;
  final MetricSeries? activity;
  final MetricSeries? habits;

  final bool hasBodyPlan;
  final int weighIns14d;
  final int postureChecks14d;
  final bool everCheckedPosture;
  final int wardrobeItems;
  final int savedOutfits;
  final bool snapshotThisWeek;
  final bool everSnapshot;
  final int skillSessions7d;
  final bool everPractisedSkill;
}

class AreaStatus {
  const AreaStatus({
    required this.area,
    required this.focus,
    required this.progress,
    required this.reason,
    required this.action,
    this.metDays,
  });

  final BlueprintArea area;

  /// The user picked a goal that belongs to this area.
  final bool focus;

  /// 0–1 for the last week (or two, for less frequent things); null when
  /// there is nothing recorded yet. "No data" is never shown as failure.
  final double? progress;
  final BlueprintReason reason;
  final BlueprintAction action;

  /// Days met out of 7, for daily areas.
  final int? metDays;
}

abstract final class Blueprint {
  static const _goalArea = {
    GoalType.posture: BlueprintArea.posture,
    GoalType.weightManagement: BlueprintArea.body,
    GoalType.fitness: BlueprintArea.fitness,
    GoalType.flexibility: BlueprintArea.fitness,
    GoalType.hydration: BlueprintArea.hydration,
    GoalType.sleep: BlueprintArea.sleep,
    GoalType.habits: BlueprintArea.habits,
    GoalType.style: BlueprintArea.style,
    GoalType.grooming: BlueprintArea.grooming,
    GoalType.strength: BlueprintArea.fitness,
    GoalType.mindfulness: BlueprintArea.sleep,
    GoalType.energy: BlueprintArea.fitness,
    GoalType.nutrition: BlueprintArea.body,
    GoalType.skinCare: BlueprintArea.grooming,
    GoalType.confidence: BlueprintArea.style,
  };

  static BlueprintArea areaOf(GoalType g) => _goalArea[g]!;

  static double _clamp(double v) => v.clamp(0.0, 1.0);

  static BlueprintReason _reason(double? p, bool focus) => switch (p) {
        null => focus ? BlueprintReason.yourGoal : BlueprintReason.noRecords,
        >= 0.7 => BlueprintReason.onTrack,
        >= 0.35 => BlueprintReason.partly,
        _ => BlueprintReason.fallingBehind,
      };

  static (double?, int?) _daily(MetricSeries? s) {
    if (s == null || s.loggedDays == 0) return (null, null);
    return (_clamp(s.metDays / 7), s.metDays);
  }

  /// One status per area: the user's focus areas first (least progress
  /// first, so the next step is obvious), then the rest.
  static List<AreaStatus> compute(BlueprintFacts f) {
    final focus = {for (final g in f.goals) areaOf(g)};
    AreaStatus status(BlueprintArea a, double? p, BlueprintAction action, {int? met}) {
      final isFocus = focus.contains(a);
      return AreaStatus(
          area: a, focus: isFocus, progress: p, reason: _reason(p, isFocus), action: action, metDays: met);
    }

    final (water, waterMet) = _daily(f.water);
    final (sleep, sleepMet) = _daily(f.sleep);
    final (active, activeMet) = _daily(f.activity);
    final (habits, habitsMet) = _daily(f.habits);

    final list = [
      status(BlueprintArea.hydration, water, BlueprintAction.addWater, met: waterMet),
      status(BlueprintArea.sleep, sleep, BlueprintAction.logSleep, met: sleepMet),
      status(BlueprintArea.fitness, active, BlueprintAction.startWorkout, met: activeMet),
      status(BlueprintArea.habits, habits, BlueprintAction.doHabits, met: habitsMet),
      status(
        BlueprintArea.body,
        // Two weigh-ins a week is plenty to see a trend.
        f.weighIns14d == 0 && !f.hasBodyPlan ? null : _clamp(f.weighIns14d / 4),
        f.hasBodyPlan ? BlueprintAction.logWeight : BlueprintAction.setBodyPlan,
      ),
      status(
        BlueprintArea.posture,
        f.everCheckedPosture ? _clamp(f.postureChecks14d / 2) : null,
        BlueprintAction.checkPosture,
      ),
      status(
        BlueprintArea.style,
        f.wardrobeItems == 0 && f.savedOutfits == 0
            ? null
            : _clamp((f.wardrobeItems / 10 + f.savedOutfits / 3) / 2),
        f.wardrobeItems < 6 ? BlueprintAction.addClothes : BlueprintAction.buildOutfit,
      ),
      status(
        BlueprintArea.grooming,
        f.everSnapshot ? (f.snapshotThisWeek ? 1.0 : 0.0) : null,
        BlueprintAction.takeSnapshot,
      ),
      status(
        BlueprintArea.skills,
        f.everPractisedSkill ? _clamp(f.skillSessions7d / 3) : null,
        BlueprintAction.practiseSkill,
      ),
    ];
    int rank(AreaStatus s) => s.focus ? 0 : (s.progress != null ? 1 : 2);
    list.sort((a, b) {
      final r = rank(a).compareTo(rank(b));
      if (r != 0) return r;
      return (a.progress ?? -1).compareTo(b.progress ?? -1);
    });
    return list;
  }

  /// The single most useful next step: the weakest focus area, else any
  /// area with records that is behind, else the first focus area.
  static AreaStatus? nextStep(List<AreaStatus> areas) {
    final focus = areas.where((a) => a.focus).toList();
    final pool = focus.isNotEmpty ? focus : areas.where((a) => a.progress != null).toList();
    if (pool.isEmpty) return null;
    final behind = pool.where((a) => (a.progress ?? 0) < 0.7).toList();
    return (behind.isEmpty ? pool : behind).first;
  }
}
