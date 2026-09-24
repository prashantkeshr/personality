import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/provenance.dart';

void main() {
  final now = DateTime.utc(2026, 9, 24);

  group('DataSource', () {
    test('wire names round-trip', () {
      for (final s in DataSource.values) {
        expect(DataSource.fromWireName(s.wireName), s);
      }
      expect(DataSource.userEntered.wireName, 'USER_ENTERED');
    });

    test('unknown wire name throws', () {
      expect(() => DataSource.fromWireName('GUESSED'), throwsArgumentError);
    });
  });

  group('Confidence.fromScore', () {
    test('buckets', () {
      expect(Confidence.fromScore(0.95), Confidence.high);
      expect(Confidence.fromScore(0.8), Confidence.high);
      expect(Confidence.fromScore(0.6), Confidence.medium);
      expect(Confidence.fromScore(0.1), Confidence.low);
    });

    test('rejects out-of-range scores', () {
      expect(() => Confidence.fromScore(1.2), throwsArgumentError);
      expect(() => Confidence.fromScore(double.nan), throwsArgumentError);
    });
  });

  group('Measurement', () {
    test('user-entered height needs no confidence', () {
      final m = Measurement(
        value: 172,
        unit: 'cm',
        source: DataSource.userEntered,
        recordedAt: now,
        method: 'Manual measurement',
      );
      expect(m.isRange, isFalse);
    });

    test('camera estimate without confidence is rejected', () {
      expect(
        () => Measurement(
          value: 172,
          unit: 'cm',
          source: DataSource.cameraDerived,
          recordedAt: now,
        ),
        throwsArgumentError,
      );
    });

    test('estimate range must contain value', () {
      final m = Measurement(
        value: 172.5,
        unit: 'cm',
        source: DataSource.cameraDerived,
        recordedAt: now,
        confidence: Confidence.medium,
        lowerBound: 171,
        upperBound: 174,
      );
      expect(m.isRange, isTrue);

      expect(
        () => Measurement(
          value: 180,
          unit: 'cm',
          source: DataSource.cameraDerived,
          recordedAt: now,
          confidence: Confidence.medium,
          lowerBound: 171,
          upperBound: 174,
        ),
        throwsArgumentError,
      );
    });

    test('half-open range is rejected', () {
      expect(
        () => Measurement(
          value: 172,
          unit: 'cm',
          source: DataSource.userEntered,
          recordedAt: now,
          lowerBound: 170,
        ),
        throwsArgumentError,
      );
    });
  });
}
