/// Today as one timeline: plan items, habits, water, planned meals and the
/// day's workout, grouped into morning / afternoon / evening (pure Dart).
///
/// Day modes adapt the day to real life instead of making it a failure:
/// a busy day keeps the essentials and shrinks the workout to five
/// minutes; a low-energy day swaps training for gentle mobility. Skipped
/// items don't count against the day.
library;

import '../entities/routine.dart';
import 'meal_planner.dart';
import 'plan_engine.dart';

enum DayMode { normal, busy, lowEnergy }

enum DayPart { morning, afternoon, evening, anytime }

enum AgendaKind { plan, habit, water, meal, workout }

class AgendaTask {
  const AgendaTask({
    required this.id,
    required this.kind,
    this.title,
    this.minute,
    this.done = false,
    this.skipped = false,
    this.missed = false,
    this.optional = false,
    this.progress = 0,
    this.target = 1,
    this.plan,
    this.habitId,
    this.slot,
    this.workout,
  });

  final String id;
  final AgendaKind kind;

  /// User-written title (plan items, habits); other kinds are labelled by
  /// the UI.
  final String? title;

  /// Minute of day, or null for "any time".
  final int? minute;
  final bool done;
  final bool skipped;

  /// Past its time and not done (plan items only).
  final bool missed;

  /// Moved aside by the day mode; doesn't count toward the day.
  final bool optional;
  final double progress;
  final double target;
  final PlanEntry? plan;
  final String? habitId;
  final MealSlot? slot;
  final TrainingDay? workout;

  DayPart get part => switch (minute) {
        null => DayPart.anytime,
        final m when m < 12 * 60 => DayPart.morning,
        final m when m < 17 * 60 => DayPart.afternoon,
        _ => DayPart.evening,
      };

  double get fraction =>
      done ? 1 : (target <= 0 ? 0 : (progress / target).clamp(0.0, 1.0));

  bool get open => !done && !skipped;
}

/// Habit scheduled for the day and how it went.
class HabitToday {
  const HabitToday(this.id, this.name, {this.done = false, this.skipped = false});
  final String id;
  final String name;
  final bool done;
  final bool skipped;
}

class DayAgenda {
  const DayAgenda(this.tasks, this.mode, {this.nowMinute});

  final List<AgendaTask> tasks;
  final DayMode mode;

  /// Current minute for today's agenda; null when viewing another day.
  final int? nowMinute;

  /// Typical meal times for planned meals.
  static const mealMinutes = {
    MealSlot.breakfast: 8 * 60 + 30,
    MealSlot.lunch: 13 * 60,
    MealSlot.snack: 16 * 60 + 30,
    MealSlot.dinner: 20 * 60,
  };
  static const workoutMinute = 18 * 60;

  /// Short mobility for busy days; gentle mobility for low-energy days.
  static const fiveMinuteMoves = ['neck_stretch', 'shoulder_rolls', 'chin_tuck'];
  static const gentleMoves = ['cat_cow', 'child_pose', 'hamstring_stretch'];

  static const _essentialPlanKinds = {
    RoutineItemKind.wake,
    RoutineItemKind.water,
    RoutineItemKind.meal,
    RoutineItemKind.sleep,
  };

  List<AgendaTask> get _counted =>
      [for (final t in tasks) if (!t.optional && !t.skipped) t];

  /// Share of today's (non-optional, non-skipped) tasks done; water counts
  /// partially.
  double get completion {
    final c = _counted;
    if (c.isEmpty) return 0;
    return c.fold(0.0, (s, t) => s + t.fraction) / c.length;
  }

  int get doneCount => _counted.where((t) => t.done).length;
  int get countedTotal => _counted.length;

  List<AgendaTask> inPart(DayPart p) => [
        for (final t in tasks)
          if (!t.optional && t.part == p) t
      ];

  List<AgendaTask> get optional => [for (final t in tasks) if (t.optional) t];

  /// The next thing to do: the earliest open task that isn't long past
  /// (timed before any-time).
  AgendaTask? get next {
    final from = (nowMinute ?? 0) - PlanEngine.dueWindowMinutes;
    final open = [
      for (final t in tasks)
        if (t.open && !t.optional && !t.missed && (t.minute ?? from) >= from) t
    ]
      ..sort((a, b) => (a.minute ?? 24 * 60).compareTo(b.minute ?? 24 * 60));
    return open.isEmpty ? null : open.first;
  }

  static DayAgenda build({
    required List<PlanEntry> plan,
    required List<HabitToday> habits,
    required double waterMl,
    required int waterTargetMl,
    bool hasMealPlan = false,
    Set<MealSlot> loggedMeals = const {},
    TrainingDay? workout,
    bool workoutDone = false,
    DayMode mode = DayMode.normal,
    int? nowMinute,
  }) {
    final tasks = <AgendaTask>[];
    for (final e in plan) {
      tasks.add(AgendaTask(
        id: 'plan:${e.item.id}',
        kind: AgendaKind.plan,
        title: e.item.title,
        minute: e.minute,
        done: e.state == PlanItemState.completed,
        skipped: e.state == PlanItemState.skipped,
        missed: e.state == PlanItemState.missed,
        optional: switch (mode) {
          DayMode.normal => false,
          DayMode.busy => !_essentialPlanKinds.contains(e.item.kind),
          DayMode.lowEnergy => e.item.kind == RoutineItemKind.exercise,
        },
        plan: e,
      ));
    }
    for (final h in habits) {
      tasks.add(AgendaTask(
        id: 'habit:${h.id}',
        kind: AgendaKind.habit,
        title: h.name,
        done: h.done,
        skipped: h.skipped,
        habitId: h.id,
      ));
    }
    tasks.add(AgendaTask(
      id: 'water',
      kind: AgendaKind.water,
      done: waterMl >= waterTargetMl,
      progress: waterMl,
      target: waterTargetMl.toDouble(),
    ));
    if (hasMealPlan) {
      for (final slot in MealSlot.values) {
        tasks.add(AgendaTask(
          id: 'meal:${slot.name}',
          kind: AgendaKind.meal,
          minute: mealMinutes[slot],
          done: loggedMeals.contains(slot),
          optional: mode == DayMode.busy && slot == MealSlot.snack,
          slot: slot,
        ));
      }
    }
    if (workout != null && workout.type != WorkoutType.rest) {
      final adapted = switch (mode) {
        DayMode.normal => workout,
        DayMode.busy =>
          TrainingDay(workout.weekday, WorkoutType.mobility, fiveMinuteMoves, 5),
        DayMode.lowEnergy =>
          TrainingDay(workout.weekday, WorkoutType.mobility, gentleMoves, 10),
      };
      tasks.add(AgendaTask(
        id: 'workout',
        kind: AgendaKind.workout,
        minute: workoutMinute,
        done: workoutDone,
        workout: adapted,
      ));
    }
    tasks.sort((a, b) => (a.minute ?? 24 * 60).compareTo(b.minute ?? 24 * 60));
    return DayAgenda(tasks, mode, nowMinute: nowMinute);
  }
}

enum FiveMinuteKind { water, habit, mobility, prepareOutfit, posture }

class FiveMinuteIdea {
  const FiveMinuteIdea(this.kind, {this.task});
  final FiveMinuteKind kind;
  final AgendaTask? task;
}

/// One small, doable step for right now — never a list of chores.
abstract final class FiveMinute {
  static FiveMinuteIdea pick(DayAgenda agenda, int nowMinute,
      {bool hasWardrobe = false}) {
    AgendaTask? find(AgendaKind k) {
      for (final t in agenda.tasks) {
        if (t.kind == k && t.open && !t.optional) return t;
      }
      return null;
    }

    // Behind on water for the time of day (less than the share expected).
    final water = find(AgendaKind.water);
    if (water != null) {
      final expected = ((nowMinute - 7 * 60) / (14 * 60)).clamp(0.0, 1.0);
      if (water.fraction + 0.15 < expected) {
        return FiveMinuteIdea(FiveMinuteKind.water, task: water);
      }
    }
    final habit = find(AgendaKind.habit);
    if (habit != null) return FiveMinuteIdea(FiveMinuteKind.habit, task: habit);
    if (find(AgendaKind.workout) != null || agenda.mode != DayMode.normal) {
      return const FiveMinuteIdea(FiveMinuteKind.mobility);
    }
    if (hasWardrobe && nowMinute >= 19 * 60) {
      return const FiveMinuteIdea(FiveMinuteKind.prepareOutfit);
    }
    return const FiveMinuteIdea(FiveMinuteKind.posture);
  }
}
