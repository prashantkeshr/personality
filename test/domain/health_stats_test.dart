import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/entities/health.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/domain/services/health_stats.dart';

SleepEntry sleep(DateTime bed, DateTime wake) =>
    SleepEntry(id: '${bed.millisecondsSinceEpoch}', bedAt: bed, wakeAt: wake);

void main() {
  group('Days', () {
    test('keys use the local calendar day', () {
      expect(Days.key(DateTime(2026, 9, 26, 23, 59)), 20260926);
      expect(Days.fromKey(20260926), DateTime(2026, 9, 26));
    });

    test('lastDays is oldest first and crosses month boundaries', () {
      expect(Days.lastDays(DateTime(2026, 10, 2, 9), 4),
          [20260929, 20260930, 20261001, 20261002]);
    });

    test('range covers exactly one local day', () {
      final (start, end) = Days.range(DateTime(2026, 9, 26, 15));
      expect(start.toLocal(), DateTime(2026, 9, 26));
      expect(end.toLocal(), DateTime(2026, 9, 27));
    });
  });

  test('water totals per local day', () {
    BodyRecord w(DateTime t, double ml) => BodyRecord(
        id: '$t',
        measurement: Measurement(
            value: ml,
            unit: 'ml',
            source: DataSource.userEntered,
            recordedAt: t.toUtc()));
    final totals = HealthStats.waterByDay([
      w(DateTime(2026, 9, 26, 8), 250),
      w(DateTime(2026, 9, 26, 22), 500),
      w(DateTime(2026, 9, 27, 0, 30), 250),
    ]);
    expect(totals, {20260926: 750, 20260927: 250});
  });

  group('sleep', () {
    test('entries validate their times', () {
      final t = DateTime(2026, 9, 26, 7);
      expect(() => sleep(t, t), throwsArgumentError);
      expect(() => sleep(t, t.add(const Duration(hours: 25))),
          throwsArgumentError);
    });

    test('sleep counts towards the day of waking', () {
      final byDay = HealthStats.sleepByDay([
        sleep(DateTime(2026, 9, 25, 23, 15), DateTime(2026, 9, 26, 7)),
      ]);
      expect(byDay, {20260926: const Duration(hours: 7, minutes: 45)});
    });

    test('bedtime variation handles midnight correctly', () {
      final v = HealthStats.bedtimeVariationMinutes([
        sleep(DateTime(2026, 9, 24, 23, 30), DateTime(2026, 9, 25, 7)),
        sleep(DateTime(2026, 9, 26, 0, 30), DateTime(2026, 9, 26, 8)),
      ]);
      // 23:30 and 00:30 are 60 min apart, so each is 30 min from the mean.
      expect(v, closeTo(30, 0.5));
      expect(
          HealthStats.bedtimeVariationMinutes([
            sleep(DateTime(2026, 9, 24, 23), DateTime(2026, 9, 25, 7)),
          ]),
          isNull);
    });
  });

  test('steps and active minutes combine activities and exercise', () {
    final day = DateTime(2026, 9, 26, 10);
    final k = Days.key(day);
    final activities = [
      ActivityEntry(
          id: 'a',
          kind: ActivityKind.walking,
          recordedAt: day,
          steps: 4000,
          durationMinutes: 40),
      ActivityEntry(
          id: 'b', kind: ActivityKind.walking, recordedAt: day, steps: 1500),
      ActivityEntry(
          id: 'c',
          kind: ActivityKind.walking,
          recordedAt: day.subtract(const Duration(days: 1)),
          steps: 9999),
    ];
    final exercises = [
      ExerciseEntry(
          id: 'x',
          name: 'Stretch',
          category: ExerciseCategory.stretching,
          durationMinutes: 15,
          performedAt: day),
    ];
    expect(HealthStats.stepsOn(activities, k), 5500);
    expect(HealthStats.activeMinutesOn(activities, exercises, k), 55);
  });

  group('habits', () {
    test('weekday mask', () {
      var w = const Weekdays(0);
      expect(w.isEmpty, isTrue);
      w = w.toggle(DateTime.monday).toggle(DateTime.friday);
      expect(w.includes(DateTime.monday), isTrue);
      expect(w.includes(DateTime.tuesday), isFalse);
      expect(w.count, 2);
      expect(Weekdays.everyDay.count, 7);
    });

    test('adherence counts only scheduled days', () {
      // 2026-09-21 is a Monday.
      final week = [for (var d = 21; d <= 27; d++) 20260900 + d];
      final weekdaysOnly = Habit(
          id: 'h',
          name: 'Walk',
          schedule: const Weekdays(0x1F)); // Mon–Fri
      final completions = [
        const HabitCompletion(
            habitId: 'h', dayKey: 20260921, status: HabitStatus.completed),
        const HabitCompletion(
            habitId: 'h', dayKey: 20260922, status: HabitStatus.completed),
        const HabitCompletion(
            habitId: 'h', dayKey: 20260923, status: HabitStatus.skipped),
        // Saturday: not scheduled, so not counted.
        const HabitCompletion(
            habitId: 'h', dayKey: 20260926, status: HabitStatus.completed),
        const HabitCompletion(
            habitId: 'other', dayKey: 20260924, status: HabitStatus.completed),
      ];
      final a = HabitAdherence.forHabit(weekdaysOnly, completions, week);
      expect(a.scheduled, 5);
      expect(a.completed, 2);
      expect(a.skipped, 1);
      expect(a.missed, 2);
    });

    test('days before the habit was created are not counted', () {
      final week = [for (var d = 21; d <= 27; d++) 20260900 + d];
      final newHabit = Habit(
          id: 'n',
          name: 'Read',
          schedule: Weekdays.everyDay,
          startDayKey: 20260926);
      final a = HabitAdherence.forHabit(newHabit, const [], week);
      expect(a.scheduled, 2); // 26th and 27th only
      expect(a.missed, 2);
    });
  });
}
