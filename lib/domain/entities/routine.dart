/// Routines, plan items and their outcomes (spec §31–34).
library;

import 'health.dart';

enum RoutineItemKind {
  wake,
  water,
  meal,
  exercise,
  mobility,
  posture,
  habit,
  grooming,
  windDown,
  sleep,
  custom,
}

class Routine {
  const Routine({
    required this.id,
    required this.name,
    required this.days,
    this.active = true,
  });

  final String id;
  final String name;
  final Weekdays days;
  final bool active;
}

class RoutineItem {
  const RoutineItem({
    required this.id,
    required this.routineId,
    required this.minuteOfDay,
    required this.title,
    required this.kind,
    this.reminder = true,
    DateTime? createdAt,
  })  // Named parameters cannot be private, so the formal can't be used.
      // ignore: prefer_initializing_formals
      : _createdAt = createdAt,
        assert(minuteOfDay >= 0 && minuteOfDay < 24 * 60);

  static final _epoch = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  final DateTime? _createdAt;

  final String id;
  final String routineId;

  /// Local time as minutes after midnight (07:30 = 450).
  final int minuteOfDay;
  final String title;
  final RoutineItemKind kind;
  final bool reminder;

  /// Occurrences before this instant are not part of the plan, so a new
  /// item never shows up as "missed" for times before it existed.
  DateTime get createdAt => _createdAt ?? _epoch;
}

/// What the user recorded for an item on a day. Absence means no action.
enum PlanOutcome { completed, skipped, rescheduled }

class PlanRecord {
  const PlanRecord({
    required this.itemId,
    required this.dayKey,
    required this.outcome,
    required this.recordedAt,
    this.rescheduledMinute,
  });

  final String itemId;
  final int dayKey;
  final PlanOutcome outcome;
  final DateTime recordedAt;

  /// New time in minutes after midnight. Set when the item is moved and kept
  /// if the moved item is later completed or skipped.
  final int? rescheduledMinute;
}

/// Minute-of-day helpers.
abstract final class Minutes {
  static const perDay = 24 * 60;

  static int of(DateTime t) {
    final l = t.toLocal();
    return l.hour * 60 + l.minute;
  }

  static DateTime on(int dayKey, int minute) => DateTime(
      dayKey ~/ 10000, dayKey ~/ 100 % 100, dayKey % 100, minute ~/ 60,
      minute % 60);

  static int roundTo(int minute, int step) =>
      ((minute / step).round() * step).clamp(0, perDay - step);
}

/// Steps of the example routine (spec §31). Titles are localized by the UI
/// when the template is applied; after that they are the user's own data.
enum TemplateStep {
  wake,
  water,
  mobility,
  grooming,
  breakfast,
  postureBreak,
  lunch,
  exercise,
  windDown,
  sleep,
}

const exampleRoutineSteps = <(int, TemplateStep, RoutineItemKind)>[
  (7 * 60, TemplateStep.wake, RoutineItemKind.wake),
  (7 * 60 + 10, TemplateStep.water, RoutineItemKind.water),
  (7 * 60 + 20, TemplateStep.mobility, RoutineItemKind.mobility),
  (7 * 60 + 45, TemplateStep.grooming, RoutineItemKind.grooming),
  (8 * 60, TemplateStep.breakfast, RoutineItemKind.meal),
  (10 * 60 + 30, TemplateStep.postureBreak, RoutineItemKind.posture),
  (13 * 60, TemplateStep.lunch, RoutineItemKind.meal),
  (16 * 60, TemplateStep.water, RoutineItemKind.water),
  (18 * 60, TemplateStep.exercise, RoutineItemKind.exercise),
  (21 * 60 + 30, TemplateStep.windDown, RoutineItemKind.windDown),
  (23 * 60, TemplateStep.sleep, RoutineItemKind.sleep),
];
