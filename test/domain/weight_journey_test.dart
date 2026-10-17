import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/domain/services/weight_journey.dart';

BodyRecord w(DateTime at, double kg) => BodyRecord(
      id: '${at.millisecondsSinceEpoch}',
      measurement: Measurement(
        value: kg,
        unit: CanonicalUnits.mass,
        source: DataSource.userEntered,
        recordedAt: at,
      ),
    );

void main() {
  final now = DateTime(2026, 10, 18, 9); // a Sunday
  const goal = Profile(goalWeightMinKg: 65, goalWeightMaxKg: 70);

  test('no weigh-ins, no journey', () {
    expect(WeightJourney.build(const [], goal, now: now), isNull);
  });

  test('heading down to the near edge of the goal range', () {
    final j = WeightJourney.build([
      w(DateTime(2026, 8, 1), 80),
      w(DateTime(2026, 10, 18, 8), 75),
    ], goal, now: now)!;
    expect(j.startKg, 80);
    expect(j.targetKg, 70); // the top of 65–70, not the middle
    expect(j.latestKg, 75);
    expect(j.progress, closeTo(0.5, 0.001));
    expect(j.milestonesReached, 2);
    expect(j.toGoKg, closeTo(5, 0.001));
    expect(j.milestoneKg(0.25), closeTo(77.5, 0.001));
    expect(j.changeSinceStartKg, closeTo(-5, 0.001));
  });

  test('heading up uses the bottom of the range', () {
    final j = WeightJourney.build([w(DateTime(2026, 10, 1), 60)], goal,
        now: now)!;
    expect(j.targetKg, 65);
    expect(j.progress, 0);
  });

  test('starting inside the range: about staying there, no target', () {
    final j = WeightJourney.build([w(DateTime(2026, 10, 1), 68)], goal,
        now: now)!;
    expect(j.targetKg, isNull);
    expect(j.progress, isNull);
    expect(j.toGoKg, isNull);
  });

  test('moving away from the goal shows as the start, never negative', () {
    final j = WeightJourney.build([
      w(DateTime(2026, 9, 1), 80),
      w(DateTime(2026, 10, 18, 8), 84),
    ], goal, now: now)!;
    expect(j.progress, 0);
  });

  test('the trend, not one weigh-in, moves the marker', () {
    // Two weigh-ins the same week: the 7-day average sits between them.
    final j = WeightJourney.build([
      w(DateTime(2026, 9, 1), 80),
      w(DateTime(2026, 10, 15), 76),
      w(DateTime(2026, 10, 18, 8), 74),
    ], goal, now: now)!;
    expect(j.trendKg, closeTo(75, 0.001));
    expect(j.progress, closeTo(0.5, 0.001));
  });

  test('an active body plan sets the start and the target', () {
    final j = WeightJourney.build(
      [w(DateTime(2026, 10, 18, 8), 88)],
      const Profile(),
      now: now,
      planStartKg: 90,
      planStartDate: DateTime(2026, 9, 1),
      planTargetKg: 80,
    )!;
    expect(j.startKg, 90);
    expect(j.targetKg, 80);
    expect(j.progress, closeTo(0.2, 0.001));
  });

  test('weigh-in streak counts whole weeks back from this one', () {
    final records = [
      w(DateTime(2026, 9, 30), 80), // week of 28 Sep
      w(DateTime(2026, 10, 6), 79), // week of 5 Oct
      w(DateTime(2026, 10, 14), 78), // week of 12 Oct
    ];
    // No weigh-in yet this week: the streak still stands from last week.
    expect(WeightJourney.build(records, goal, now: now)!.streakWeeks, 3);
    // A gap breaks it.
    final gap = [w(DateTime(2026, 9, 20), 81), ...records.skip(1)];
    expect(WeightJourney.build(gap, goal, now: now)!.streakWeeks, 2);
    // Two weeks without any: no streak.
    expect(
        WeightJourney.build([w(DateTime(2026, 9, 1), 80)], goal, now: now)!
            .streakWeeks,
        0);
  });

  test('a weigh-in that passes milestones celebrates the highest one', () {
    WeightJourney at(double kg) => WeightJourney.build([
          w(DateTime(2026, 8, 1), 80),
          w(DateTime(2026, 10, 18, 8), kg),
        ], goal, now: now)!;
    expect(WeightJourney.milestoneCrossed(at(78), at(77)), 0.25);
    expect(WeightJourney.milestoneCrossed(at(78), at(74)), 0.5);
    expect(WeightJourney.milestoneCrossed(at(73), at(70)), 1.0);
    expect(WeightJourney.milestoneCrossed(at(77), at(76.5)), isNull);
  });

  test('the ruler snaps to 0.1 kg or 0.2 lb', () {
    expect(snapWeight(72.34, metric: true), 72.3);
    final lb = snapWeight(72.34, metric: false) * 2.20462262185;
    expect((lb / 0.2 - (lb / 0.2).round()).abs(), lessThan(1e-9));
    expect(clampWeight(5), BodyLimits.minWeightKg);
    expect(clampWeight(900), BodyLimits.maxWeightKg);
  });
}
