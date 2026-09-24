import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/domain/services/height_policy.dart';
import 'package:personality/domain/services/proportion_engine.dart';
import 'package:personality/domain/services/weight_trends.dart';

BodyRecord rec(
  String id,
  double value,
  DateTime at, {
  DataSource source = DataSource.userEntered,
  Confidence? confidence,
  String unit = 'cm',
}) =>
    BodyRecord(
      id: id,
      measurement: Measurement(
        value: value,
        unit: unit,
        source: source,
        recordedAt: at,
        confidence: confidence ??
            (source.requiresConfidence ? Confidence.medium : null),
      ),
    );

void main() {
  final d = DateTime.utc(2026, 9, 1);

  group('selectPrimaryHeight', () {
    test('latest manual record wins by default', () {
      final r = selectPrimaryHeight([
        rec('a', 171, d),
        rec('b', 172, d.add(const Duration(days: 3))),
        rec('cam', 175, d.add(const Duration(days: 9)),
            source: DataSource.cameraDerived),
      ]);
      expect(r!.id, 'b');
    });

    test('pinned record overrides latest', () {
      final r = selectPrimaryHeight([
        rec('a', 171, d),
        rec('b', 172, d.add(const Duration(days: 3))),
      ], pinnedId: 'a');
      expect(r!.id, 'a');
    });

    test('stale pin falls back to latest manual', () {
      final r = selectPrimaryHeight([rec('a', 171, d)], pinnedId: 'gone');
      expect(r!.id, 'a');
    });

    test('camera estimates are never chosen automatically', () {
      final r = selectPrimaryHeight(
          [rec('cam', 175, d, source: DataSource.cameraDerived)]);
      expect(r, isNull);
    });

    test('imported value is used when no manual value exists', () {
      final r = selectPrimaryHeight([
        rec('imp', 170, d, source: DataSource.imported),
        rec('cam', 175, d, source: DataSource.cameraDerived),
      ]);
      expect(r!.id, 'imp');
    });

    test('normal variation band', () {
      expect(isWithinNormalVariation(172, 173.5), isTrue);
      expect(isWithinNormalVariation(172, 175), isFalse);
    });
  });

  group('WeightTrends', () {
    final records = [
      for (var i = 0; i < 10; i++)
        rec('w$i', 70 - i * 0.1, d.add(Duration(days: i)), unit: 'kg'),
    ];

    test('window filters by period and sorts oldest first', () {
      final w = WeightTrends.window(
          records.reversed.toList(), d.add(const Duration(days: 9)), 3);
      expect(w.map((r) => r.id), ['w6', 'w7', 'w8', 'w9']);
    });

    test('moving average smooths over the trailing 7 days', () {
      final avg = WeightTrends.movingAverage(records);
      expect(avg.first.kg, closeTo(70, 1e-9));
      // Day 9 averages days 2..9: 69.8 .. 69.1
      expect(avg.last.kg, closeTo((69.8 + 69.1) / 2, 1e-9));
    });

    test('change needs at least two records', () {
      expect(WeightTrends.change(records.take(1).toList()), isNull);
      expect(WeightTrends.change(records), lessThan(0));
    });

    test('goal range position', () {
      const p = Profile(goalWeightMinKg: 65, goalWeightMaxKg: 70);
      expect(positionInGoal(64, p), GoalRangePosition.below);
      expect(positionInGoal(68, p), GoalRangePosition.within);
      expect(positionInGoal(71, p), GoalRangePosition.above);
      expect(positionInGoal(68, const Profile()), isNull);
    });
  });

  group('ProportionEngine', () {
    test('nothing but missing inputs without data', () {
      final p = ProportionEngine.calculate(height: null, latest: {});
      expect(p.isEmpty, isTrue);
      expect(p.missing.keys, containsAll(ProportionMetric.values));
      expect(p.missing[ProportionMetric.legLine],
          {'height', BodyMeasurementType.inseam.name});
    });

    test('calculates neutral descriptors from measurements', () {
      final p = ProportionEngine.calculate(
        height: rec('h', 172, d),
        latest: {
          BodyMeasurementType.inseam: rec('i', 82, d),
          BodyMeasurementType.shoulderWidth: rec('s', 44, d),
          BodyMeasurementType.chest: rec('c', 100, d),
          BodyMeasurementType.waist: rec('w', 84, d),
          BodyMeasurementType.hip: rec('hp', 98, d),
        },
      );
      final by = {for (final r in p.results) r.metric: r};
      expect(p.missing, isEmpty);
      expect(by[ProportionMetric.legLine]!.value, closeTo(82 / 172, 1e-9));
      expect(by[ProportionMetric.legLine]!.descriptor,
          ProportionDescriptor.longerLegLine);
      expect(by[ProportionMetric.shoulderBreadth]!.descriptor,
          ProportionDescriptor.broaderShoulders);
      expect(by[ProportionMetric.upperTaper]!.value, 16);
      expect(by[ProportionMetric.upperTaper]!.descriptor,
          ProportionDescriptor.pronouncedTaper);
      expect(by[ProportionMetric.hipBalance]!.descriptor,
          ProportionDescriptor.balancedChestHip);
      for (final r in p.results) {
        expect(r.source, DataSource.calculated);
        expect(r.confidence, Confidence.high);
      }
    });

    test('estimated inputs lower the confidence of the result', () {
      final p = ProportionEngine.calculate(
        height: rec('h', 172, d),
        latest: {
          BodyMeasurementType.inseam: rec('i', 78, d,
              source: DataSource.cameraDerived, confidence: Confidence.low),
        },
      );
      expect(p.results.single.confidence, Confidence.low);
      expect(p.results.single.descriptor,
          ProportionDescriptor.balancedLegLine);
    });
  });
}
