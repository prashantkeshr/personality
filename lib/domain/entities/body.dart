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

/// Used for energy estimates (BMR formulas differ by sex) and to choose
/// which style examples to show first. Always optional.
enum Gender { male, female, nonBinary, preferNotToSay }

enum DietPreference { vegetarian, eggetarian, nonVegetarian, vegan }

/// Which style examples to show (hair, looks, ethnic wear).
enum StyleFit { menswear, womenswear, all }

/// Where the user lives. Shapes meal ideas (local cuisine), exercise ideas
/// and climate advice. India is split by region because food differs a lot.
enum Region {
  indiaNorth,
  indiaSouth,
  indiaEast,
  indiaWest,
  southAsia,
  eastAsia,
  southeastAsia,
  middleEast,
  africa,
  europe,
  northAmerica,
  latinAmerica,
  oceania;

  bool get isIndia => index <= Region.indiaWest.index;

  /// Mostly warm climates, where hydration and cooler training hours matter.
  bool get hotClimate => switch (this) {
        Region.europe || Region.northAmerica || Region.eastAsia || Region.oceania => false,
        _ => true,
      };
}

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
    this.gender,
    this.dietPreference,
    this.styleFit,
    this.region,
  });

  final String? displayName;
  final Region? region;
  final Gender? gender;
  final DietPreference? dietPreference;

  /// Explicit choice; null follows [gender].
  final StyleFit? styleFit;

  /// What style examples to show: the explicit choice, else by gender.
  StyleFit get effectiveStyleFit =>
      styleFit ??
      switch (gender) {
        Gender.male => StyleFit.menswear,
        Gender.female => StyleFit.womenswear,
        _ => StyleFit.all,
      };
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
    Gender? Function()? gender,
    DietPreference? Function()? dietPreference,
    StyleFit? Function()? styleFit,
    Region? Function()? region,
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
      gender: gender != null ? gender() : this.gender,
      dietPreference:
          dietPreference != null ? dietPreference() : this.dietPreference,
      styleFit: styleFit != null ? styleFit() : this.styleFit,
      region: region != null ? region() : this.region,
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
