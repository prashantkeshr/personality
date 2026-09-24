/// Body proportion engine (spec §13).
///
/// Produces neutral, descriptive proportions used for garment fit and
/// silhouette suggestions. It never ranks or scores appearance and makes no
/// health claims. All outputs are [DataSource.calculated].
library;

import '../entities/body.dart';
import '../entities/provenance.dart';

enum ProportionMetric {
  /// Inseam ÷ height. Describes the vertical leg line.
  legLine,

  /// Shoulder width ÷ height.
  shoulderBreadth,

  /// Chest − waist circumference (tailoring "drop").
  upperTaper,

  /// Hip − chest circumference.
  hipBalance,
}

/// Neutral descriptors. UI maps these to localized wording.
enum ProportionDescriptor {
  shorterLegLine,
  balancedLegLine,
  longerLegLine,
  narrowerShoulders,
  averageShoulders,
  broaderShoulders,
  straightTaper,
  moderateTaper,
  pronouncedTaper,
  chestFuller,
  balancedChestHip,
  hipsFuller,
}

class ProportionResult {
  const ProportionResult({
    required this.metric,
    required this.value,
    required this.unit,
    required this.descriptor,
    required this.inputs,
    required this.confidence,
  });

  final ProportionMetric metric;

  /// Ratio (unit `ratio`) or difference in centimetres (unit `cm`).
  final double value;
  final String unit;
  final ProportionDescriptor descriptor;

  /// The records this result was calculated from, for "How is this calculated?"
  final Map<String, BodyRecord> inputs;
  final Confidence confidence;

  DataSource get source => DataSource.calculated;
}

class ProportionProfile {
  const ProportionProfile(this.results, this.missing);

  final List<ProportionResult> results;

  /// Inputs that would unlock more results, per metric.
  final Map<ProportionMetric, Set<String>> missing;

  bool get isEmpty => results.isEmpty;
}

/// Band thresholds. Approximate adult ranges used only to choose neutral
/// wording, documented so they can be tuned without touching the engine.
abstract final class ProportionBands {
  static const legLineLow = 0.44;
  static const legLineHigh = 0.47;
  static const shoulderLow = 0.22;
  static const shoulderHigh = 0.25;
  static const taperModerateCm = 8.0;
  static const taperPronouncedCm = 15.0;
  static const hipBalanceCm = 5.0;
}

abstract final class ProportionEngine {
  static const heightKey = 'height';

  static ProportionProfile calculate({
    required BodyRecord? height,
    required Map<BodyMeasurementType, BodyRecord> latest,
  }) {
    final results = <ProportionResult>[];
    final missing = <ProportionMetric, Set<String>>{};

    void need(ProportionMetric metric, Map<String, BodyRecord?> inputs,
        ProportionResult Function(Map<String, BodyRecord>) build) {
      final absent = {
        for (final e in inputs.entries)
          if (e.value == null) e.key,
      };
      if (absent.isNotEmpty) {
        missing[metric] = absent;
        return;
      }
      results.add(build({
        for (final e in inputs.entries) e.key: e.value!,
      }));
    }

    final inseam = latest[BodyMeasurementType.inseam];
    final shoulder = latest[BodyMeasurementType.shoulderWidth];
    final chest = latest[BodyMeasurementType.chest];
    final waist = latest[BodyMeasurementType.waist];
    final hip = latest[BodyMeasurementType.hip];

    need(ProportionMetric.legLine, {
      heightKey: height,
      BodyMeasurementType.inseam.name: inseam,
    }, (i) {
      final ratio = i[BodyMeasurementType.inseam.name]!.value /
          i[heightKey]!.value;
      return _result(
        ProportionMetric.legLine,
        ratio,
        'ratio',
        ratio < ProportionBands.legLineLow
            ? ProportionDescriptor.shorterLegLine
            : ratio > ProportionBands.legLineHigh
                ? ProportionDescriptor.longerLegLine
                : ProportionDescriptor.balancedLegLine,
        i,
      );
    });

    need(ProportionMetric.shoulderBreadth, {
      heightKey: height,
      BodyMeasurementType.shoulderWidth.name: shoulder,
    }, (i) {
      final ratio = i[BodyMeasurementType.shoulderWidth.name]!.value /
          i[heightKey]!.value;
      return _result(
        ProportionMetric.shoulderBreadth,
        ratio,
        'ratio',
        ratio < ProportionBands.shoulderLow
            ? ProportionDescriptor.narrowerShoulders
            : ratio > ProportionBands.shoulderHigh
                ? ProportionDescriptor.broaderShoulders
                : ProportionDescriptor.averageShoulders,
        i,
      );
    });

    need(ProportionMetric.upperTaper, {
      BodyMeasurementType.chest.name: chest,
      BodyMeasurementType.waist.name: waist,
    }, (i) {
      final drop = i[BodyMeasurementType.chest.name]!.value -
          i[BodyMeasurementType.waist.name]!.value;
      return _result(
        ProportionMetric.upperTaper,
        drop,
        CanonicalUnits.length,
        drop < ProportionBands.taperModerateCm
            ? ProportionDescriptor.straightTaper
            : drop < ProportionBands.taperPronouncedCm
                ? ProportionDescriptor.moderateTaper
                : ProportionDescriptor.pronouncedTaper,
        i,
      );
    });

    need(ProportionMetric.hipBalance, {
      BodyMeasurementType.chest.name: chest,
      BodyMeasurementType.hip.name: hip,
    }, (i) {
      final diff = i[BodyMeasurementType.hip.name]!.value -
          i[BodyMeasurementType.chest.name]!.value;
      return _result(
        ProportionMetric.hipBalance,
        diff,
        CanonicalUnits.length,
        diff > ProportionBands.hipBalanceCm
            ? ProportionDescriptor.hipsFuller
            : diff < -ProportionBands.hipBalanceCm
                ? ProportionDescriptor.chestFuller
                : ProportionDescriptor.balancedChestHip,
        i,
      );
    });

    return ProportionProfile(results, missing);
  }

  static ProportionResult _result(
    ProportionMetric metric,
    double value,
    String unit,
    ProportionDescriptor descriptor,
    Map<String, BodyRecord> inputs,
  ) {
    return ProportionResult(
      metric: metric,
      value: value,
      unit: unit,
      descriptor: descriptor,
      inputs: inputs,
      confidence: _combinedConfidence(inputs.values),
    );
  }

  /// A calculation is only as reliable as its weakest input. Manual,
  /// imported and device values count as high; estimates keep their own.
  static Confidence _combinedConfidence(Iterable<BodyRecord> inputs) {
    var result = Confidence.high;
    for (final r in inputs) {
      final c = r.measurement.confidence ??
          (r.source.requiresConfidence ? Confidence.low : Confidence.high);
      if (c.index < result.index) result = c;
    }
    return result;
  }
}
