/// Day-by-day training plans with sets and reps, shaped by the user's goals,
/// level, time, equipment, gender and age, and adjusted from how sessions
/// felt. Pure logic; the app stores [TrainingPrefs] and [TrainingProgress].
library;

import 'dart:convert';
import 'dart:math' as math;

import '../entities/body.dart';

enum FitnessLevel { beginner, intermediate, advanced }

enum Equipment {
  /// Floor and wall only.
  none,

  /// A sturdy chair and a loaded backpack.
  homeBasics,
}

/// Which half of the body gets a little more work. Defaults from gender
/// (and can be changed): lower body for women, upper body for men,
/// balanced otherwise.
enum FocusArea { balanced, upper, lower }

enum SessionType { fullBody, upper, lower, core, cardio, mobility, yoga, posture, rest }

/// How a session felt, from the after-workout check.
enum SessionFeel { tooEasy, justRight, tooHard }

class TrainingPrefs {
  const TrainingPrefs({
    this.level = FitnessLevel.beginner,
    this.daysPerWeek = 3,
    this.minutes = 20,
    this.equipment = Equipment.none,
    this.focus = FocusArea.balanced,
  });

  final FitnessLevel level;
  final int daysPerWeek;
  final int minutes;
  final Equipment equipment;
  final FocusArea focus;

  static const dayChoices = [2, 3, 4, 5, 6];
  static const minuteChoices = [10, 20, 30, 45];

  /// The starting focus for a gender; the user can change it.
  static FocusArea focusFor(Gender? g) => switch (g) {
    Gender.female => FocusArea.lower,
    Gender.male => FocusArea.upper,
    _ => FocusArea.balanced,
  };

  TrainingPrefs copyWith({
    FitnessLevel? level,
    int? daysPerWeek,
    int? minutes,
    Equipment? equipment,
    FocusArea? focus,
  }) => TrainingPrefs(
    level: level ?? this.level,
    daysPerWeek: daysPerWeek ?? this.daysPerWeek,
    minutes: minutes ?? this.minutes,
    equipment: equipment ?? this.equipment,
    focus: focus ?? this.focus,
  );

  String encode() => jsonEncode({
    'level': level.name,
    'days': daysPerWeek,
    'minutes': minutes,
    'equipment': equipment.name,
    'focus': focus.name,
  });

  static TrainingPrefs? parse(String? raw) {
    if (raw == null) return null;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      return TrainingPrefs(
        level: FitnessLevel.values.asNameMap()[j['level']] ?? FitnessLevel.beginner,
        daysPerWeek: (j['days'] as int? ?? 3).clamp(2, 6),
        minutes: minuteChoices.contains(j['minutes']) ? j['minutes'] as int : 20,
        equipment: Equipment.values.asNameMap()[j['equipment']] ?? Equipment.none,
        focus: FocusArea.values.asNameMap()[j['focus']] ?? FocusArea.balanced,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is TrainingPrefs &&
      other.level == level &&
      other.daysPerWeek == daysPerWeek &&
      other.minutes == minutes &&
      other.equipment == equipment &&
      other.focus == focus;

  @override
  int get hashCode => Object.hash(level, daysPerWeek, minutes, equipment, focus);
}

/// Per-exercise difficulty steps (+ harder, − easier) and how many
/// "just right" sessions in a row each session type has had.
class TrainingProgress {
  const TrainingProgress({this.steps = const {}, this.justRight = const {}});

  final Map<String, int> steps;
  final Map<SessionType, int> justRight;

  int stepOf(String id) => steps[id] ?? 0;

  String encode() => jsonEncode({
    'steps': steps,
    'justRight': {for (final e in justRight.entries) e.key.name: e.value},
  });

  static TrainingProgress parse(String? raw) {
    if (raw == null) return const TrainingProgress();
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      return TrainingProgress(
        steps: (j['steps'] as Map? ?? const {}).map((k, v) => MapEntry('$k', v as int)),
        justRight: {
          for (final e in (j['justRight'] as Map? ?? const {}).entries)
            ?SessionType.values.asNameMap()[e.key]: e.value as int,
        },
      );
    } catch (_) {
      return const TrainingProgress();
    }
  }
}

enum DoseKind { reps, hold, minutes }

/// What one exercise asks for at a given step.
class Prescription {
  const Prescription({
    required this.exerciseId,
    required this.sets,
    required this.amount,
    required this.kind,
    this.sides = false,
    this.restSeconds = 30,
  });

  final String exerciseId;
  final int sets;

  /// Reps, seconds or minutes per set, depending on [kind].
  final int amount;
  final DoseKind kind;

  /// Done on each side (lunges, side planks).
  final bool sides;
  final int restSeconds;
}

class PlanDay {
  const PlanDay({required this.weekday, required this.type, required this.exercises});

  /// 1 = Monday … 7 = Sunday.
  final int weekday;
  final SessionType type;
  final List<Prescription> exercises;

  bool get isRest => type == SessionType.rest;

  /// Rough length: work plus rest between sets.
  int get minutes {
    var s = 0;
    for (final p in exercises) {
      final work = switch (p.kind) {
        DoseKind.reps => p.amount * 3,
        DoseKind.hold => p.amount,
        DoseKind.minutes => p.amount * 60,
      };
      s += p.sets * (work * (p.sides ? 2 : 1) + p.restSeconds);
    }
    return (s / 60).ceil();
  }
}

class _Base {
  const _Base(this.kind, this.amount, {this.sides = false});
  final DoseKind kind;
  final int amount;
  final bool sides;
}

abstract final class TrainingEngine {
  /// Base dose per exercise for a beginner; levels scale it.
  static const _base = <String, _Base>{
    'squat': _Base(DoseKind.reps, 10),
    'push_up': _Base(DoseKind.reps, 8),
    'incline_push_up': _Base(DoseKind.reps, 8),
    'backpack_row': _Base(DoseKind.reps, 10),
    'chair_dip': _Base(DoseKind.reps, 8),
    'reverse_lunge': _Base(DoseKind.reps, 8, sides: true),
    'glute_bridge': _Base(DoseKind.reps, 12),
    'calf_raise': _Base(DoseKind.reps, 15),
    'wall_sit': _Base(DoseKind.hold, 25),
    'plank': _Base(DoseKind.hold, 20),
    'bird_dog': _Base(DoseKind.reps, 8, sides: true),
    'knee_raise': _Base(DoseKind.hold, 30),
    'arm_raise': _Base(DoseKind.reps, 12),
    'brisk_walk': _Base(DoseKind.minutes, 10),
    'chin_tuck': _Base(DoseKind.reps, 10),
    'wall_angels': _Base(DoseKind.reps, 10),
    'shoulder_rolls': _Base(DoseKind.reps, 10),
    'neck_stretch': _Base(DoseKind.hold, 20, sides: true),
    'cat_cow': _Base(DoseKind.reps, 8),
    'hamstring_stretch': _Base(DoseKind.hold, 25, sides: true),
    'child_pose': _Base(DoseKind.hold, 30),
    'surya_namaskar': _Base(DoseKind.reps, 3),
    'warrior_1': _Base(DoseKind.hold, 20, sides: true),
    'warrior_2': _Base(DoseKind.hold, 20, sides: true),
    'tree_pose': _Base(DoseKind.hold, 20, sides: true),
    'chair_pose': _Base(DoseKind.hold, 20),
    'downward_dog': _Base(DoseKind.hold, 25),
    'low_lunge': _Base(DoseKind.hold, 20, sides: true),
    'cobra': _Base(DoseKind.hold, 15),
    'bridge_pose': _Base(DoseKind.hold, 20),
    'forward_fold': _Base(DoseKind.hold, 25),
    'seated_breath': _Base(DoseKind.minutes, 2),
  };

  /// Exercises per session type, in order of priority. Variants depend on
  /// level, equipment and age; low impact replaces jumping work.
  static List<String> _pool(
    SessionType t, {
    required FitnessLevel level,
    required Equipment equipment,
    required bool lowImpact,
  }) {
    final push = level == FitnessLevel.beginner ? 'incline_push_up' : 'push_up';
    final kit = equipment == Equipment.homeBasics;
    return switch (t) {
      SessionType.fullBody => ['squat', push, if (kit) 'backpack_row', 'reverse_lunge', 'plank', 'glute_bridge', 'bird_dog'],
      SessionType.upper => [push, if (kit) 'backpack_row', if (kit) 'chair_dip', 'plank', 'arm_raise', 'wall_angels', 'shoulder_rolls'],
      SessionType.lower => ['squat', 'reverse_lunge', 'glute_bridge', 'wall_sit', 'calf_raise', 'bridge_pose', 'hamstring_stretch'],
      SessionType.core => ['plank', 'bird_dog', 'glute_bridge', if (!lowImpact) 'knee_raise', 'cat_cow', 'child_pose'],
      SessionType.cardio => ['brisk_walk', if (!lowImpact) 'knee_raise', 'squat', 'calf_raise', 'arm_raise'],
      SessionType.mobility => ['cat_cow', 'hamstring_stretch', 'shoulder_rolls', 'low_lunge', if (lowImpact) 'tree_pose', 'child_pose', 'forward_fold'],
      SessionType.yoga => [if (!lowImpact) 'surya_namaskar', 'warrior_2', 'tree_pose', 'downward_dog', 'cobra', 'child_pose', 'seated_breath'],
      SessionType.posture => ['chin_tuck', 'wall_angels', 'shoulder_rolls', 'cat_cow', 'bird_dog', 'plank', 'neck_stretch'],
      SessionType.rest => const [],
    };
  }

  /// Session types by main goal, most important first; the first
  /// `daysPerWeek` are used. The focus area tilts strength weeks.
  static List<SessionType> _sequence(Set<GoalType> goals, FocusArea focus) {
    bool has(GoalType g) => goals.contains(g);
    if (has(GoalType.strength) || (goals.isEmpty)) {
      return switch (focus) {
        FocusArea.upper => const [SessionType.upper, SessionType.lower, SessionType.core, SessionType.upper, SessionType.fullBody, SessionType.mobility],
        FocusArea.lower => const [SessionType.lower, SessionType.upper, SessionType.core, SessionType.lower, SessionType.fullBody, SessionType.mobility],
        FocusArea.balanced => const [SessionType.fullBody, SessionType.core, SessionType.upper, SessionType.lower, SessionType.fullBody, SessionType.mobility],
      };
    }
    if (has(GoalType.weightManagement) || has(GoalType.energy)) {
      return [
        SessionType.fullBody,
        SessionType.cardio,
        focus == FocusArea.upper ? SessionType.upper : SessionType.lower,
        SessionType.cardio,
        SessionType.core,
        SessionType.mobility,
      ];
    }
    if (has(GoalType.posture)) {
      return const [SessionType.posture, SessionType.core, SessionType.mobility, SessionType.posture, SessionType.upper, SessionType.yoga];
    }
    if (has(GoalType.flexibility) || has(GoalType.mindfulness) || has(GoalType.sleep)) {
      return const [SessionType.yoga, SessionType.mobility, SessionType.core, SessionType.yoga, SessionType.mobility, SessionType.fullBody];
    }
    // General fitness and everything else.
    return const [SessionType.fullBody, SessionType.cardio, SessionType.mobility, SessionType.fullBody, SessionType.yoga, SessionType.cardio];
  }

  /// Training days spread across the week (no more than two in a row).
  static List<int> weekdays(int days) => switch (days.clamp(2, 6)) {
    2 => const [1, 4],
    3 => const [1, 3, 5],
    4 => const [1, 2, 4, 5],
    5 => const [1, 2, 4, 5, 6],
    _ => const [1, 2, 3, 4, 5, 6],
  };

  static int _exerciseCount(int minutes) => switch (minutes) {
    <= 10 => 3,
    <= 20 => 4,
    <= 30 => 5,
    _ => 6,
  };

  /// Base sets for a level; more sets for longer sessions.
  static int _baseSets(FitnessLevel level, int minutes) =>
      (switch (level) {
        FitnessLevel.beginner => 2,
        FitnessLevel.intermediate => 3,
        FitnessLevel.advanced => 4,
      }) -
      (minutes <= 10 ? 1 : 0);

  static double _levelScale(FitnessLevel level) => switch (level) {
    FitnessLevel.beginner => 1.0,
    FitnessLevel.intermediate => 1.4,
    FitnessLevel.advanced => 1.8,
  };

  static bool lowImpactFor(AgeRange? age, FitnessLevel level) =>
      age == AgeRange.from55to64 || age == AgeRange.over65 ||
      (age == AgeRange.under18 && level == FitnessLevel.beginner);

  /// One exercise at its current step: +2 reps / +5 s / +2 min per step,
  /// and one more set every 3 steps (at most 5 sets).
  static Prescription prescribe(
    String id, {
    required FitnessLevel level,
    required int minutes,
    int step = 0,
  }) {
    final b = _base[id] ?? const _Base(DoseKind.reps, 10);
    final scale = _levelScale(level);
    final perStep = switch (b.kind) {
      DoseKind.reps => 2,
      DoseKind.hold => 5,
      DoseKind.minutes => 2,
    };
    final amount = math.max(
      b.kind == DoseKind.minutes ? 2 : (b.kind == DoseKind.hold ? 10 : 4),
      (b.amount * scale).round() + perStep * step,
    );
    final sets = b.kind == DoseKind.minutes
        ? 1
        : (_baseSets(level, minutes) + (step > 0 ? step ~/ 3 : 0)).clamp(1, 5);
    return Prescription(
      exerciseId: id,
      sets: sets,
      amount: amount,
      kind: b.kind,
      sides: b.sides,
      restSeconds: b.kind == DoseKind.minutes ? 0 : (level == FitnessLevel.beginner ? 40 : 30),
    );
  }

  /// The week: training days from the goal's sequence, rest in between.
  /// [available] limits exercises to those in the catalog.
  static List<PlanDay> week({
    required TrainingPrefs prefs,
    Set<GoalType> goals = const {},
    AgeRange? age,
    TrainingProgress progress = const TrainingProgress(),
    Set<String>? available,
  }) {
    final lowImpact = lowImpactFor(age, prefs.level);
    final seq = _sequence(goals, prefs.focus);
    final days = weekdays(prefs.daysPerWeek);
    final count = _exerciseCount(prefs.minutes);
    return [
      for (var wd = 1; wd <= 7; wd++)
        if (days.indexOf(wd) case final i when i >= 0)
          PlanDay(
            weekday: wd,
            type: seq[i % seq.length],
            exercises: [
              for (final id in _pool(
                seq[i % seq.length],
                level: prefs.level,
                equipment: prefs.equipment,
                lowImpact: lowImpact,
              ).where((id) => available == null || available.contains(id)).take(count))
                prescribe(id, level: prefs.level, minutes: prefs.minutes, step: progress.stepOf(id)),
            ],
          )
        else
          PlanDay(weekday: wd, type: SessionType.rest, exercises: const []),
    ];
  }

  /// After a session: too easy raises every exercise one step, too hard
  /// lowers it, and two "just right" in a row for the same kind of day
  /// also raise it. Steps stay between −3 and +12.
  static TrainingProgress adjust(
    TrainingProgress p,
    PlanDay day,
    SessionFeel feel,
  ) {
    final steps = {...p.steps};
    final justRight = {...p.justRight};
    var delta = 0;
    switch (feel) {
      case SessionFeel.tooEasy:
        delta = 1;
        justRight[day.type] = 0;
      case SessionFeel.tooHard:
        delta = -1;
        justRight[day.type] = 0;
      case SessionFeel.justRight:
        final n = (justRight[day.type] ?? 0) + 1;
        if (n >= 2) {
          delta = 1;
          justRight[day.type] = 0;
        } else {
          justRight[day.type] = n;
        }
    }
    if (delta != 0) {
      for (final e in day.exercises) {
        steps[e.exerciseId] = ((steps[e.exerciseId] ?? 0) + delta).clamp(-3, 12);
      }
    }
    return TrainingProgress(steps: steps, justRight: justRight);
  }

  /// Ready for the next level when the plan's exercises are, on average,
  /// 4+ steps up. Returns the new level, or null.
  static FitnessLevel? levelUp(TrainingPrefs prefs, List<PlanDay> week, TrainingProgress p) {
    if (prefs.level == FitnessLevel.advanced) return null;
    final ids = {for (final d in week) for (final e in d.exercises) e.exerciseId};
    if (ids.isEmpty) return null;
    final avg = ids.fold<int>(0, (s, id) => s + p.stepOf(id)) / ids.length;
    return avg >= 4 ? FitnessLevel.values[prefs.level.index + 1] : null;
  }
}
