/// Daily health tracking entities (spec §14, §30).
library;

import 'provenance.dart';

enum MealType { breakfast, lunch, snack, dinner, custom }

class MealEntry {
  const MealEntry({
    required this.id,
    required this.type,
    required this.food,
    required this.eatenAt,
    this.customName,
    this.quantity,
    this.calories,
    this.notes,
  });

  final String id;
  final MealType type;
  final String? customName;
  final String food;
  final String? quantity;

  /// Optional. Calorie counting is never required (spec §14).
  final double? calories;
  final DateTime eatenAt;
  final String? notes;
}

class SleepEntry {
  SleepEntry({
    required this.id,
    required this.bedAt,
    required this.wakeAt,
    this.source = DataSource.userEntered,
    this.notes,
  }) {
    if (!wakeAt.isAfter(bedAt)) {
      throw ArgumentError('Wake time must be after bedtime');
    }
    if (wakeAt.difference(bedAt) > SleepLimits.maxDuration) {
      throw ArgumentError('Sleep entries cannot exceed 24 hours');
    }
  }

  final String id;
  final DateTime bedAt;
  final DateTime wakeAt;
  final DataSource source;
  final String? notes;

  Duration get duration => wakeAt.difference(bedAt);
}

abstract final class SleepLimits {
  static const maxDuration = Duration(hours: 24);
}

enum ActivityKind { walking, running, cycling, swimming, sports, other }

class ActivityEntry {
  const ActivityEntry({
    required this.id,
    required this.kind,
    required this.recordedAt,
    this.durationMinutes,
    this.steps,
    this.distanceKm,
    this.source = DataSource.userEntered,
    this.notes,
  });

  final String id;
  final ActivityKind kind;
  final DateTime recordedAt;
  final int? durationMinutes;
  final int? steps;
  final double? distanceKm;
  final DataSource source;
  final String? notes;
}

/// Exercise categories from spec §18. The full library arrives in Phase 7.
enum ExerciseCategory {
  neck,
  shoulder,
  upperBack,
  lowerBack,
  core,
  mobility,
  yoga,
  stretching,
  posture,
  generalFitness,
  strength,
  cardio,
}

class ExerciseEntry {
  const ExerciseEntry({
    required this.id,
    required this.name,
    required this.category,
    required this.durationMinutes,
    required this.performedAt,
    this.sets,
    this.reps,
    this.source = DataSource.userEntered,
    this.notes,
  });

  final String id;
  final String name;
  final ExerciseCategory category;
  final int durationMinutes;
  final int? sets;
  final int? reps;
  final DateTime performedAt;
  final DataSource source;
  final String? notes;
}

/// Days of the week as a bitmask, Monday = bit 0 … Sunday = bit 6.
class Weekdays {
  const Weekdays(this.mask);

  static const everyDay = Weekdays(0x7F);

  final int mask;

  /// [weekday] uses DateTime conventions (1 = Monday … 7 = Sunday).
  bool includes(int weekday) => mask & (1 << (weekday - 1)) != 0;

  Weekdays toggle(int weekday) => Weekdays(mask ^ (1 << (weekday - 1)));

  int get count => [for (var d = 1; d <= 7; d++) if (includes(d)) d].length;

  bool get isEmpty => mask & 0x7F == 0;
}

class Habit {
  const Habit({
    required this.id,
    required this.name,
    required this.schedule,
    this.startDayKey = 0,
    this.archived = false,
  });

  final String id;
  final String name;
  final Weekdays schedule;

  /// First local day (yyyymmdd) the habit applies. Days before it are never
  /// counted as scheduled or missed.
  final int startDayKey;
  final bool archived;
}

enum HabitStatus { completed, skipped }

class HabitCompletion {
  const HabitCompletion({
    required this.habitId,
    required this.dayKey,
    required this.status,
  });

  final String habitId;

  /// Local calendar day as yyyymmdd.
  final int dayKey;
  final HabitStatus status;
}

/// User-adjustable daily targets. Defaults are neutral starting points the
/// user is invited to change; they are not medical recommendations.
class DailyTargets {
  const DailyTargets({
    this.waterMl = 2000,
    this.sleepMinutes = 480,
    this.steps = 8000,
    this.activeMinutes = 30,
  });

  final int waterMl;
  final int sleepMinutes;
  final int steps;
  final int activeMinutes;

  DailyTargets copyWith({
    int? waterMl,
    int? sleepMinutes,
    int? steps,
    int? activeMinutes,
  }) =>
      DailyTargets(
        waterMl: waterMl ?? this.waterMl,
        sleepMinutes: sleepMinutes ?? this.sleepMinutes,
        steps: steps ?? this.steps,
        activeMinutes: activeMinutes ?? this.activeMinutes,
      );

  @override
  bool operator ==(Object other) =>
      other is DailyTargets &&
      other.waterMl == waterMl &&
      other.sleepMinutes == sleepMinutes &&
      other.steps == steps &&
      other.activeMinutes == activeMinutes;

  @override
  int get hashCode => Object.hash(waterMl, sleepMinutes, steps, activeMinutes);
}

abstract final class TargetLimits {
  static const minWaterMl = 250;
  static const maxWaterMl = 8000;
  static const minSleepMinutes = 180;
  static const maxSleepMinutes = 960;
  static const minSteps = 500;
  static const maxSteps = 50000;
  static const minActiveMinutes = 5;
  static const maxActiveMinutes = 600;
}
