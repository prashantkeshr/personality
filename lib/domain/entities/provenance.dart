/// Data provenance primitives (spec §9).
///
/// Every meaningful value in the app records where it came from, so that
/// measured, estimated, calculated and AI-generated data are never mixed
/// invisibly.
library;

/// Origin of a piece of data. Persisted using [wireName].
enum DataSource {
  userEntered('USER_ENTERED'),
  cameraDerived('CAMERA_DERIVED'),
  deviceDerived('DEVICE_DERIVED'),
  healthPlatform('HEALTH_PLATFORM'),
  calculated('CALCULATED'),
  imported('IMPORTED'),
  aiGenerated('AI_GENERATED');

  const DataSource(this.wireName);

  /// Stable identifier used in the database and in exports.
  final String wireName;

  /// True for sources whose values are estimates rather than direct readings.
  /// Estimates must carry a [Confidence].
  bool get requiresConfidence =>
      this == DataSource.cameraDerived || this == DataSource.aiGenerated;

  static DataSource fromWireName(String name) => DataSource.values.firstWhere(
        (s) => s.wireName == name,
        orElse: () => throw ArgumentError.value(name, 'name', 'Unknown source'),
      );
}

/// Coarse confidence bucket shown to users.
enum Confidence {
  low,
  medium,
  high;

  /// Maps a model score in [0, 1] to a bucket.
  static Confidence fromScore(double score) {
    if (score.isNaN || score < 0 || score > 1) {
      throw ArgumentError.value(score, 'score', 'Must be within [0, 1]');
    }
    if (score >= 0.8) return Confidence.high;
    if (score >= 0.5) return Confidence.medium;
    return Confidence.low;
  }
}

/// A single numeric observation with full provenance.
///
/// Estimates may carry a [lowerBound]/[upperBound] range so the UI can show
/// "171–174 cm" instead of false precision.
class Measurement {
  Measurement({
    required this.value,
    required this.unit,
    required this.source,
    required this.recordedAt,
    this.confidence,
    this.method,
    this.lowerBound,
    this.upperBound,
  }) {
    if (!value.isFinite) {
      throw ArgumentError.value(value, 'value', 'Must be finite');
    }
    if (source.requiresConfidence && confidence == null) {
      throw ArgumentError('${source.wireName} values must include confidence');
    }
    if ((lowerBound == null) != (upperBound == null)) {
      throw ArgumentError('Range needs both lowerBound and upperBound');
    }
    if (lowerBound != null &&
        !(lowerBound! <= value && value <= upperBound!)) {
      throw ArgumentError('value must lie within [lowerBound, upperBound]');
    }
  }

  final double value;
  final String unit;
  final DataSource source;
  final DateTime recordedAt;
  final Confidence? confidence;
  final String? method;
  final double? lowerBound;
  final double? upperBound;

  bool get isRange => lowerBound != null;
}
