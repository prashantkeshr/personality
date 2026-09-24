/// Profile and body entities (spec §10–13).
library;

import 'provenance.dart';

/// Canonical units used for storage.
abstract final class CanonicalUnits {
  static const length = 'cm';
  static const mass = 'kg';
}

/// How a manual measurement was taken. Stored in `method`.
enum MeasurementMethod {
  selfMeasured('Self-measured'),
  measuredByOther('Measured by another person'),
  professional('Professional measurement'),
  scale('Scale'),
  estimated('Estimate');

  const MeasurementMethod(this.wireName);
  final String wireName;

  static MeasurementMethod? fromWireName(String? name) {
    for (final m in values) {
      if (m.wireName == name) return m;
    }
    return null;
  }
}

/// A stored height, weight or body measurement with provenance.
class BodyRecord {
  const BodyRecord({
    required this.id,
    required this.measurement,
    this.notes,
  });

  final String id;
  final Measurement measurement;
  final String? notes;

  double get value => measurement.value;
  DateTime get recordedAt => measurement.recordedAt;
  DataSource get source => measurement.source;
}

/// Body measurement kinds (spec §12). Circumferences and lengths are in cm.
enum BodyMeasurementType {
  shoulderWidth,
  chest,
  waist,
  hip,
  neck,
  armLength,
  legLength,
  torsoLength,
  inseam,
  custom;

  static BodyMeasurementType fromName(String name) =>
      values.firstWhere((t) => t.name == name, orElse: () => custom);
}

class BodyMeasurementRecord extends BodyRecord {
  const BodyMeasurementRecord({
    required super.id,
    required super.measurement,
    required this.type,
    this.customLabel,
    super.notes,
  });

  final BodyMeasurementType type;

  /// Name of a [BodyMeasurementType.custom] measurement.
  final String? customLabel;
}

enum AgeRange { under18, from18to24, from25to34, from35to44, from45to54, from55to64, over65 }

enum ActivityLevel { sedentary, light, moderate, active, veryActive }

enum GoalType {
  posture,
  weightManagement,
  fitness,
  flexibility,
  hydration,
  sleep,
  habits,
  style,
  grooming,
}

/// Profile data. Every field is optional (spec §10: do not require
/// unnecessary information).
class Profile {
  const Profile({
    this.displayName,
    this.ageRange,
    this.activityLevel,
    this.primaryHeightId,
    this.goalWeightMinKg,
    this.goalWeightMaxKg,
  });

  final String? displayName;
  final AgeRange? ageRange;
  final ActivityLevel? activityLevel;

  /// Height record the user chose as primary; null means "latest manual".
  final String? primaryHeightId;
  final double? goalWeightMinKg;
  final double? goalWeightMaxKg;

  bool get hasWeightGoal => goalWeightMinKg != null && goalWeightMaxKg != null;

  Profile copyWith({
    String? Function()? displayName,
    AgeRange? Function()? ageRange,
    ActivityLevel? Function()? activityLevel,
    String? Function()? primaryHeightId,
    double? Function()? goalWeightMinKg,
    double? Function()? goalWeightMaxKg,
  }) {
    return Profile(
      displayName: displayName != null ? displayName() : this.displayName,
      ageRange: ageRange != null ? ageRange() : this.ageRange,
      activityLevel:
          activityLevel != null ? activityLevel() : this.activityLevel,
      primaryHeightId:
          primaryHeightId != null ? primaryHeightId() : this.primaryHeightId,
      goalWeightMinKg:
          goalWeightMinKg != null ? goalWeightMinKg() : this.goalWeightMinKg,
      goalWeightMaxKg:
          goalWeightMaxKg != null ? goalWeightMaxKg() : this.goalWeightMaxKg,
    );
  }
}

/// Plausible input ranges, used to reject typos rather than judge values.
abstract final class BodyLimits {
  static const minHeightCm = 50.0;
  static const maxHeightCm = 272.0;
  static const minWeightKg = 20.0;
  static const maxWeightKg = 400.0;
  static const minMeasurementCm = 5.0;
  static const maxMeasurementCm = 250.0;
}
