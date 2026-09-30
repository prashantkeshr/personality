import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/health.dart';
import 'package:personality/domain/entities/routine.dart';
import 'package:personality/domain/services/health_stats.dart';
import 'package:personality/domain/services/plan_engine.dart';

// 2026-09-30 is a Wednesday.
final today = DateTime(2026, 9, 30);
int day(int offset) => Days.key(today.add(Duration(days: offset)));

const daily = Routine(id: 'r', name: 'Daily', days: Weekdays.everyDay);
RoutineItem item(String id, int hour, [int minute = 0, bool reminder = true]) =>
    RoutineItem(
        id: id,
        routineId: 'r',
        minuteOfDay: hour * 60 + minute,
        title: id,
        kind: RoutineItemKind.custom,
        reminder: reminder);

PlanRecord rec(String id, int dayKey, PlanOutcome o,
        {DateTime? at, int? moved}) =>
    PlanRecord(
        itemId: id,
        dayKey: dayKey,
        outcome: o,
        recordedAt: at ?? Days.fromKey(dayKey),
        rescheduledMinute: moved);

void main() {
  group('PlanEngine.forDay', () {
    final items = [item('water', 7), item('posture', 10, 30), item('walk', 18)];

    test('states follow the clock and recorded outcomes', () {
      final now = today.add(const Duration(hours: 10, minutes: 45));
      final plan = PlanEngine.forDay(
        routines: const [daily],
        items: items,
        records: [rec('water', day(0), PlanOutcome.completed)],
        dayKey: day(0),
        now: now,
      );
      expect(plan.map((e) => (e.item.id, e.state)), [
        ('water', PlanItemState.completed),
        ('posture', PlanItemState.due), // within the 60 min window
        ('walk', PlanItemState.upcoming),
      ]);
      expect(PlanEngine.next(plan)!.item.id, 'posture');
    });

    test('open items become missed after the due window and on past days', () {
      final now = today.add(const Duration(hours: 12));
      final plan = PlanEngine.forDay(
          routines: const [daily],
          items: items,
          records: const [],
          dayKey: day(0),
          now: now);
      expect(plan.firstWhere((e) => e.item.id == 'posture').state,
          PlanItemState.missed);
      final yesterday = PlanEngine.forDay(
          routines: const [daily],
          items: items,
          records: const [],
          dayKey: day(-1),
          now: now);
      expect(yesterday.every((e) => e.state == PlanItemState.missed), isTrue);
    });

    test('rescheduling moves the effective time and re-sorts', () {
      final plan = PlanEngine.forDay(
        routines: const [daily],
        items: items,
        records: [
          rec('water', day(0), PlanOutcome.rescheduled, moved: 19 * 60)
        ],
        dayKey: day(0),
        now: today.add(const Duration(hours: 8)),
      );
      expect(plan.last.item.id, 'water');
      expect(plan.last.minute, 19 * 60);
      expect(plan.last.state, PlanItemState.upcoming);
      expect(plan.last.wasRescheduled, isTrue);
    });

    test('occurrences before the item existed are not planned or missed', () {
      final created = RoutineItem(
          id: 'new',
          routineId: 'r',
          minuteOfDay: 7 * 60,
          title: 'new',
          kind: RoutineItemKind.custom,
          createdAt: today.add(const Duration(hours: 9)));
      final noon = today.add(const Duration(hours: 12));
      List<PlanEntry> plan(int dayKey, [List<PlanRecord> r = const []]) =>
          PlanEngine.forDay(
              routines: const [daily],
              items: [created],
              records: r,
              dayKey: dayKey,
              now: noon);
      expect(plan(day(-1)), isEmpty, reason: 'did not exist yesterday');
      expect(plan(day(0)), isEmpty, reason: '07:00 was before 09:00 creation');
      expect(plan(day(1)).single.state, PlanItemState.upcoming);
      // An outcome the user recorded anyway still counts.
      expect(plan(day(0), [rec('new', day(0), PlanOutcome.completed)]).single
          .state, PlanItemState.completed);
    });

    test('a moved item keeps its new time once completed', () {
      final plan = PlanEngine.forDay(
        routines: const [daily],
        items: items,
        records: [
          PlanRecord(
              itemId: 'posture',
              dayKey: day(0),
              outcome: PlanOutcome.completed,
              recordedAt: today,
              rescheduledMinute: 9 * 60 + 35),
        ],
        dayKey: day(0),
        now: today.add(const Duration(hours: 10)),
      );
      final e = plan.firstWhere((e) => e.item.id == 'posture');
      expect((e.minute, e.state, e.wasRescheduled),
          (9 * 60 + 35, PlanItemState.completed, true));
    });

    test('paused routines and unscheduled weekdays are excluded', () {
      const paused =
          Routine(id: 'r', name: 'x', days: Weekdays.everyDay, active: false);
      expect(
          PlanEngine.forDay(
              routines: const [paused],
              items: items,
              records: const [],
              dayKey: day(0),
              now: today),
          isEmpty);
      const weekendOnly = Routine(id: 'r', name: 'x', days: Weekdays(0x60));
      expect(
          PlanEngine.forDay(
              routines: const [weekendOnly],
              items: items,
              records: const [],
              dayKey: day(0), // Wednesday
              now: today),
          isEmpty);
    });

    test('summary keeps skipped, missed, moved and open apart', () {
      final plan = PlanEngine.forDay(
        routines: const [daily],
        items: items,
        records: [
          rec('water', day(0), PlanOutcome.skipped),
          rec('walk', day(0), PlanOutcome.rescheduled, moved: 20 * 60),
        ],
        dayKey: day(0),
        now: today.add(const Duration(hours: 12)),
      );
      final s = PlanSummary.of(plan);
      expect((s.scheduled, s.completed, s.skipped, s.missed, s.rescheduled,
          s.open), (3, 0, 1, 1, 1, 1));
    });
  });

  group('ReminderPlanner', () {
    test('only future, open, reminder-enabled items within the window', () {
      final now = today.add(const Duration(hours: 9));
      final items = [
        item('early', 7), // already past today
        item('done', 10),
        item('quiet', 11, 0, false),
        item('later', 12),
      ];
      final o = ReminderPlanner.upcoming(
        routines: const [daily],
        items: items,
        records: [rec('done', day(0), PlanOutcome.completed)],
        now: now,
      );
      final todayOnes = o.where((x) => x.dayKey == day(0)).map((x) => x.itemId);
      expect(todayOnes, ['later']);
      // Six more days × three reminder-enabled items.
      expect(o.length, 1 + 6 * 3);
      expect(o.map((x) => x.at.isAfter(now)), everyElement(isTrue));
    });

    test('ids are stable, distinct per day and leave the snooze bit free', () {
      final a = ReminderPlanner.notificationId('item', day(0));
      expect(ReminderPlanner.notificationId('item', day(0)), a);
      expect(ReminderPlanner.notificationId('item', day(1)), isNot(a));
      expect(a & 0x40000000, 0);
      expect(a, greaterThanOrEqualTo(0));
    });
  });

  group('AdaptiveReminders', () {
    final now = today.add(const Duration(hours: 8));
    final posture = item('posture', 15);

    test('suggests one hour later when an item is usually missed', () {
      final s = AdaptiveReminders.suggest(
        routines: const [daily],
        items: [posture],
        records: [
          for (var d = -14; d <= -11; d++)
            rec('posture', day(d), PlanOutcome.completed),
        ],
        now: now,
      );
      final only = s.single;
      expect(only.basis, SuggestionBasis.missed);
      expect(only.fromMinute, 15 * 60);
      expect(only.toMinute, 16 * 60);
      expect(only.occurrences, 10);
      expect(only.scheduledDays, 14);
    });

    test('suggests the typical actual time when done late', () {
      final s = AdaptiveReminders.suggest(
        routines: const [daily],
        items: [posture],
        records: [
          for (var d = -5; d <= -1; d++)
            rec('posture', day(d), PlanOutcome.completed,
                at: Days.fromKey(day(d))
                    .add(Duration(hours: 16, minutes: 20 + d))),
          for (var d = -14; d <= -6; d++)
            rec('posture', day(d), PlanOutcome.completed,
                at: Days.fromKey(day(d)).add(const Duration(hours: 15))),
        ],
        now: now,
      );
      expect(s.single.basis, SuggestionBasis.lateCompletion);
      expect(s.single.toMinute, 16 * 60 + 15);
    });

    test('prefers the time the user keeps moving it to', () {
      final s = AdaptiveReminders.suggest(
        routines: const [daily],
        items: [posture],
        records: [
          for (var d = -3; d <= -1; d++)
            rec('posture', day(d), PlanOutcome.rescheduled, moved: 17 * 60),
          for (var d = -14; d <= -4; d++)
            rec('posture', day(d), PlanOutcome.completed),
        ],
        now: now,
      );
      expect(s.single.basis, SuggestionBasis.rescheduled);
      expect(s.single.toMinute, 17 * 60);
    });

    test('no suggestion for consistent items, new items or dismissed ones', () {
      final consistent = AdaptiveReminders.suggest(
        routines: const [daily],
        items: [posture],
        records: [
          for (var d = -14; d <= -1; d++)
            rec('posture', day(d), PlanOutcome.completed),
        ],
        now: now,
      );
      expect(consistent, isEmpty);

      final dismissed = AdaptiveReminders.suggest(
        routines: const [daily],
        items: [posture],
        records: const [],
        now: now,
        dismissedOn: {'posture': day(-2)},
      );
      expect(dismissed, isEmpty);

      final expiredDismissal = AdaptiveReminders.suggest(
        routines: const [daily],
        items: [posture],
        records: const [],
        now: now,
        dismissedOn: {'posture': day(-20)},
      );
      expect(expiredDismissal, hasLength(1));
    });

    test('today, still in progress, is never counted', () {
      final s = AdaptiveReminders.suggest(
        routines: const [daily],
        items: [posture],
        records: [
          for (var d = -14; d <= -1; d++)
            rec('posture', day(d), PlanOutcome.completed),
        ],
        now: today.add(const Duration(hours: 23)), // today's 15:00 missed
      );
      expect(s, isEmpty);
    });
  });
}
