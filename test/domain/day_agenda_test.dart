import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/data/repositories/wellbeing_repository.dart';
import 'package:personality/domain/entities/health.dart';
import 'package:personality/domain/entities/routine.dart';
import 'package:personality/domain/services/day_agenda.dart';
import 'package:personality/domain/services/meal_planner.dart';
import 'package:personality/domain/services/nutrition_engine.dart';
import 'package:personality/domain/services/plan_engine.dart';

void main() {
  final now = DateTime(2026, 10, 10, 15); // Saturday, 15:00
  const day = 20261010;
  const routine = Routine(id: 'r', name: 'Day', days: Weekdays.everyDay);
  RoutineItem item(String id, int minute, RoutineItemKind kind) => RoutineItem(
      id: id, routineId: 'r', minuteOfDay: minute, title: id, kind: kind,
      createdAt: DateTime(2026, 1, 1));

  List<PlanEntry> plan(List<PlanRecord> records) => PlanEngine.forDay(
        routines: [routine],
        items: [
          item('wake', 6 * 60 + 30, RoutineItemKind.wake),
          item('stretch', 7 * 60, RoutineItemKind.mobility),
          item('posture', 15 * 60 + 30, RoutineItemKind.posture),
          item('run', 19 * 60, RoutineItemKind.exercise),
        ],
        records: records,
        dayKey: day,
        now: now,
      );

  DayAgenda build(DayMode mode, {List<PlanRecord> records = const []}) =>
      DayAgenda.build(
        plan: plan(records),
        habits: const [HabitToday('h1', 'Read'), HabitToday('h2', 'Journal', done: true)],
        waterMl: 1000,
        waterTargetMl: 2000,
        hasMealPlan: true,
        loggedMeals: const {MealSlot.breakfast},
        workout: TrainingPlanner.week(PlanKind.loseFat, PlanPace.steady)[now.weekday - 1],
        mode: mode,
        nowMinute: 15 * 60,
      );

  test('groups the day into parts with a single completion figure', () {
    final a = build(DayMode.normal);
    expect(a.inPart(DayPart.morning).map((t) => t.id),
        ['plan:wake', 'plan:stretch', 'meal:breakfast']);
    expect(a.inPart(DayPart.anytime).map((t) => t.kind),
        [AgendaKind.habit, AgendaKind.habit, AgendaKind.water]);
    // 4 plan + 2 habits + water + 4 meals + workout (Saturday cardio).
    expect(a.countedTotal, 12);
    // Done: journal, breakfast; water half-way.
    expect(a.completion, closeTo((2 + 0.5) / 12, 1e-9));
    // Morning items before 15:00 that weren't done are missed.
    expect(a.tasks.firstWhere((t) => t.id == 'plan:wake').missed, isTrue);
    expect(a.next!.id, 'plan:posture');
  });

  test('skipped items do not count against the day', () {
    final a = build(DayMode.normal, records: [
      PlanRecord(itemId: 'stretch', dayKey: day, outcome: PlanOutcome.skipped,
          recordedAt: now),
    ]);
    expect(a.countedTotal, 11);
  });

  test('busy day keeps essentials and shrinks the workout to 5 minutes', () {
    final a = build(DayMode.busy);
    expect(a.optional.map((t) => t.id),
        containsAll(['plan:stretch', 'plan:posture', 'plan:run', 'meal:snack']));
    expect(a.optional.map((t) => t.id), isNot(contains('plan:wake')));
    final w = a.tasks.firstWhere((t) => t.kind == AgendaKind.workout).workout!;
    expect((w.type, w.minutes, w.exerciseIds),
        (WorkoutType.mobility, 5, DayAgenda.fiveMinuteMoves));
  });

  test('low-energy day swaps training for gentle mobility', () {
    final a = build(DayMode.lowEnergy);
    expect(a.optional.map((t) => t.id), ['plan:run']);
    final w = a.tasks.firstWhere((t) => t.kind == AgendaKind.workout).workout!;
    expect((w.minutes, w.exerciseIds), (10, DayAgenda.gentleMoves));
  });

  test('five-minute idea: water when behind, then habits, then mobility', () {
    final a = build(DayMode.normal);
    expect(FiveMinute.pick(a, 17 * 60).kind, FiveMinuteKind.water); // 50% vs 71%
    expect(FiveMinute.pick(a, 9 * 60).kind, FiveMinuteKind.habit);
    final noHabits = DayAgenda.build(
        plan: const [], habits: const [], waterMl: 2000, waterTargetMl: 2000);
    expect(FiveMinute.pick(noHabits, 20 * 60, hasWardrobe: true).kind,
        FiveMinuteKind.prepareOutfit);
    expect(FiveMinute.pick(noHabits, 10 * 60).kind, FiveMinuteKind.posture);
  });

  test('quiet hours across midnight', () {
    const q = QuietHours(22 * 60, 7 * 60);
    expect(q.contains(23 * 60), isTrue);
    expect(q.contains(6 * 60 + 59), isTrue);
    expect(q.contains(7 * 60), isFalse);
    expect(q.contains(12 * 60), isFalse);
    expect(QuietHours.parse('1320-420')!.start, 1320);
    expect(QuietHours.parse(''), isNull);
    final reminders = ReminderPlanner.upcoming(
      routines: [routine],
      items: [item('late', 23 * 60, RoutineItemKind.windDown),
              item('noon', 12 * 60, RoutineItemKind.water)],
      records: const [],
      now: DateTime(2026, 10, 10, 8),
      days: 1,
      quiet: q,
    );
    expect(reminders.map((r) => r.itemId), ['noon']);
  });

  test('check-ins and today-only day mode', () async {
    final db = AppDatabase(NativeDatabase.memory());
    var clock = now;
    final repo = WellbeingRepository(db, clock: () => clock);
    expect(() => repo.checkIn(mood: 0, energy: 3), throwsArgumentError);
    await repo.checkIn(mood: 4, energy: 2);
    await repo.checkIn(mood: 3, energy: 2); // replaces today's
    final moods = await repo.watchMoods().first;
    expect(moods.single.mood, 3);
    await repo.setTodayMode(DayMode.lowEnergy);
    expect(await repo.watchTodayMode().first, DayMode.lowEnergy);
    clock = now.add(const Duration(days: 1));
    expect(await WellbeingRepository(db, clock: () => clock).watchTodayMode().first,
        DayMode.normal);
    await db.close();
  });
}
