import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:personality/data/repositories/app_kv.dart';
import 'package:personality/domain/entities/discipline.dart';
import 'package:personality/domain/entities/health.dart' show Weekdays;
import 'package:personality/domain/entities/exercise_library.dart';
import 'package:personality/domain/entities/routine.dart';
import 'package:personality/domain/services/day_agenda.dart';
import 'package:personality/domain/services/plan_engine.dart';
import 'package:personality/features/exercise/workout_ranking.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/features/today/today_widgets.dart';

import '../helpers/app_harness.dart';

WorkoutProgram program(String id) => WorkoutProgram.fromJson({
  'id': id,
  'category': 'strength',
  'title': {'en': id},
  'summary': {'en': ''},
  'steps': <Object>[],
});

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  test('popularity orders unused workouts; use moves them up', () {
    final all = [
      program('yoga_evening_calm'),
      program('beginner_full_body'),
      program('pack_thing'),
      program('desk_reset'),
    ];
    expect(
      rankWorkouts(all, const WorkoutUsage()).map((p) => p.id),
      ['beginner_full_body', 'desk_reset', 'yoga_evening_calm', 'pack_thing'],
    );
    // Two finishes (6) beat five opens (5); opens still count.
    final usage = const WorkoutUsage(
      opened: {'desk_reset': 5},
      done: {'yoga_evening_calm': 2},
    );
    expect(
      rankWorkouts(all, usage).map((p) => p.id).take(3),
      ['yoga_evening_calm', 'desk_reset', 'beginner_full_body'],
    );
  });

  test('timeline cards lead to their own screens', () {
    AgendaTask plan(RoutineItemKind kind, String title) => AgendaTask(
      id: title,
      kind: AgendaKind.plan,
      title: title,
      plan: PlanEntry(
        routine: const Routine(id: 'r', name: 'Day', days: Weekdays.everyDay),
        dayKey: 20261025,
        minute: 600,
        state: PlanItemState.values.first,
        item: RoutineItem(
          id: title,
          routineId: 'r',
          minuteOfDay: 600,
          title: title,
          kind: kind,
        ),
      ),
    );
    final exercises = [
      LibraryExercise.fromJson({
        'id': 'reverse_lunge',
        'category': 'strength',
        'name': {'en': 'Reverse lunges'},
        'steps': {'en': <String>[]},
      }),
    ];
    final skills = [
      Discipline.fromJson({
        'id': 'self_defence',
        'family': 'world',
        'hue': 0,
        'motion': 'guard',
        'pack': 'martial-arts',
        'name': {'en': 'Self-defence basics'},
        'region': {'en': ''},
        'about': {'en': ''},
        'trains': {'en': ''},
        'safety': {'en': ''},
        'tips': <Object>[],
      }),
    ];
    String? route(AgendaTask t) => agendaRoute(t, exercises: exercises, skills: skills);

    expect(route(const AgendaTask(id: 'w', kind: AgendaKind.water)), '/health/water');
    expect(route(plan(RoutineItemKind.meal, 'Lunch time')), '/health/meals');
    expect(route(plan(RoutineItemKind.posture, 'Posture check')), '/analyze/posture');
    expect(
      route(plan(RoutineItemKind.exercise, '8 reverse lunges each side')),
      '/health/exercise/library/reverse_lunge',
    );
    expect(
      route(plan(RoutineItemKind.exercise, 'Practise Self-defence basics · 15 min')),
      '/growth/skills/self_defence',
    );
    expect(route(plan(RoutineItemKind.exercise, 'Workout')), '/health/exercise/programs');
    expect(route(plan(RoutineItemKind.sleep, 'Bedtime')), '/health/sleep');
  });

  Future<void> wait(AppHarness app, WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await app.run(() => Future<void>.delayed(const Duration(milliseconds: 30)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
  }

  testWidgets('Home suggests the most popular workout, then the user\'s favourite', (
    tester,
  ) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await wait(app, tester);
    final letsTry = find.byKey(const Key('lets-try'));
    await app.reveal(find.textContaining("Let's try"));
    expect(find.text("Let's try Beginner full body"), findsOneWidget);
    expect(find.textContaining('Most popular'), findsOneWidget);
    await app.reveal(find.byKey(const Key('home-workouts-all')));
    expect(find.byKey(const Key('home-workout-yoga_sun_flow')), findsOneWidget);

    // Doing Desk reset twice makes it the go-to workout.
    await app.run(() async {
      final kv = AppKv(app.db);
      await kv.put('workout.done.desk_reset', '2');
    });
    await wait(app, tester);
    await app.reveal(find.textContaining("Let's try"), step: -250);
    expect(find.text("Let's try Desk reset"), findsOneWidget);
    expect(find.textContaining('Your go-to workout'), findsOneWidget);

    // Tapping it opens the workout (and counts the visit).
    await app.tapAndSettle(letsTry);
    final router = GoRouter.of(tester.element(find.byType(Scaffold).last));
    expect(router.state.uri.path, '/health/exercise/programs/desk_reset');
    await wait(app, tester);
    final opened = await app.run(() => AppKv(app.db).get('workout.opened.desk_reset'));
    expect(opened, '1');
    await app.dispose();
  });
}
