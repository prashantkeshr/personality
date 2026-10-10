import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/services/evolution_engine.dart';
import 'package:personality/domain/services/health_stats.dart';
import 'package:personality/domain/services/insights_engine.dart';
import 'package:personality/domain/services/nutrition_engine.dart';
import 'package:personality/domain/services/progress_engine.dart';

int key(DateTime d) => Days.key(d);
int ago(int n) => key(DateTime(2026, 10, 11 - n)); // today = Sun 11 Oct

void main() {
  const t = InsightTargets(waterMl: 2000, sleepMinutes: 480, activeMinutes: 30);
  final today = ago(0);

  group('day marks', () {
    test('no data is never a miss', () {
      final f = DayFacts(dayKey: today);
      for (final m in InsightMetric.values) {
        expect(InsightsEngine.point(m, f, t).mark, DayMark.noData, reason: '$m');
      }
    });

    test('met / partial / missed per metric', () {
      DayMark mark(InsightMetric m, DayFacts f) => InsightsEngine.point(m, f, t).mark;
      expect(mark(InsightMetric.water, DayFacts(dayKey: today, waterMl: 2100)), DayMark.met);
      expect(mark(InsightMetric.water, DayFacts(dayKey: today, waterMl: 900)), DayMark.partial);
      expect(mark(InsightMetric.sleep, DayFacts(dayKey: today, sleepMinutes: 455)), DayMark.met);
      expect(mark(InsightMetric.sleep, DayFacts(dayKey: today, sleepMinutes: 400)), DayMark.partial);
      expect(mark(InsightMetric.sleep, DayFacts(dayKey: today, sleepMinutes: 300)), DayMark.missed);
      // Skipped items leave the plan; 4 of 5 counted = 80 % = met.
      expect(
          mark(InsightMetric.plan,
              DayFacts(dayKey: today, planScheduled: 6, planCompleted: 4, planSkipped: 1)),
          DayMark.met);
      expect(
          mark(InsightMetric.plan,
              DayFacts(dayKey: today, planScheduled: 3, planSkipped: 3)),
          DayMark.noData);
      expect(mark(InsightMetric.habits,
              DayFacts(dayKey: today, habitsScheduled: 2)), DayMark.missed);
      expect(mark(InsightMetric.mood, DayFacts(dayKey: today, mood: 1)), DayMark.met);
    });
  });

  test('week series with trend against the previous week', () {
    final facts = {
      for (var i = 0; i < 14; i++)
        ago(i): DayFacts(dayKey: ago(i), waterMl: i < 7 ? 2000 : (i.isEven ? 1000 : null)),
    };
    final s = InsightsEngine.series(InsightMetric.water, facts, t, today, InsightRange.week);
    expect(s.days.length, 7);
    expect(s.days.first.dayKey, ago(6));
    expect((s.metDays, s.loggedDays, s.average), (7, 7, 2000));
    expect(s.previousAverage, 1000);
    expect(s.change, 1000);
    final m = InsightsEngine.series(InsightMetric.water, facts, t, today, InsightRange.month);
    expect(m.days.length, 30);
    expect(m.loggedDays, 7 + 3); // days 8, 10 and 12 ago
  });

  test('sleep score rewards duration and regular bedtimes', () {
    List<(DateTime, DateTime)> nights(List<int> bedHours, int minutes) => [
          for (final (i, h) in bedHours.indexed)
            (DateTime(2026, 10, 1 + i, h), DateTime(2026, 10, 1 + i, h).add(Duration(minutes: minutes))),
        ];
    final steady = SleepScore.of(nights([23, 23, 23, 23], 480))!;
    expect(steady.score, 100);
    expect(steady.averageMinutes, 480);
    final irregular = SleepScore.of(nights([21, 23, 1 + 24 - 24, 3], 480))!;
    expect(irregular.score, lessThan(steady.score));
    final short = SleepScore.of(nights([23, 23, 23], 300))!;
    expect(short.score, lessThan(80));
    expect(SleepScore.of(const []), isNull);
  });

  test('weekly review: last Monday–Sunday, one gentle suggestion', () {
    final sunday = DateTime(2026, 10, 11);
    // Reviewing on Monday 12 Oct → the week of 5–11 Oct.
    expect(WeeklyReview.weekStartFor(DateTime(2026, 10, 12)), 20261005);
    final facts = {
      for (var i = 0; i < 7; i++)
        key(sunday.subtract(Duration(days: i))): DayFacts(
          dayKey: key(sunday.subtract(Duration(days: i))),
          waterMl: 2200,
          sleepMinutes: i < 2 ? 480 : 300,
        ),
    };
    final r = WeeklyReview.build(facts, t, DateTime(2026, 10, 12))!;
    expect(r.weekStart, 20261005);
    expect(r.activeDays, 7);
    expect(r.water.metDays, 7);
    expect(r.tip, ReviewTip.sleep);
    expect(WeeklyReview.build(const {}, t, DateTime(2026, 10, 12)), isNull);
  });

  test('evolution timeline: firsts, streaks, plans, weight steps, notes', () {
    final history = [
      for (var i = 9; i >= 0; i--)
        DayActivity(
          dayKey: ago(i),
          waterMl: 2000,
          postureChecks: i == 5 ? 1 : 0,
          habitsDone: 4,
        ),
    ];
    final ms = EvolutionEngine.build(
      history: history,
      plans: [(ago(8), PlanKind.loseFat)],
      weights: [(ago(9), 80), (ago(5), 78.5), (ago(1), 77.9), (ago(0), 75.6)],
      notes: [Milestone(ago(3), MilestoneKind.note, text: 'Felt strong')],
    );
    final kinds = {for (final m in ms) m.kind: m};
    expect(kinds[MilestoneKind.firstStep]!.dayKey, ago(9));
    expect(kinds[MilestoneKind.firstPosture]!.dayKey, ago(5));
    expect(kinds[MilestoneKind.streak7]!.dayKey, ago(3));
    expect(kinds.containsKey(MilestoneKind.streak30), isFalse);
    expect(kinds[MilestoneKind.habits30]!.dayKey, ago(2)); // 4 × 8 days
    expect(kinds[MilestoneKind.planStarted]!.plan, PlanKind.loseFat);
    final weight = ms.where((m) => m.kind == MilestoneKind.weightChange).toList();
    expect(weight.map((m) => (m.dayKey, m.value)), [(ago(0), -4.0), (ago(1), -2.0)]);
    expect(ms.first.dayKey, ago(0)); // newest first
  });
}
