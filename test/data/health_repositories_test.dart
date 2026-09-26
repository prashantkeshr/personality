import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/data/repositories/health_repositories.dart';
import 'package:personality/domain/entities/health.dart';
import 'package:personality/domain/entities/provenance.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  final since = DateTime.utc(2026, 1, 1);
  final at = DateTime(2026, 9, 26, 13);

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('meals: food required, calories optional, trimmed fields', () async {
    final repo = MealRepository(db);
    expect(repo.add(type: MealType.lunch, food: '  ', eatenAt: at),
        throwsArgumentError);
    await repo.add(
        type: MealType.lunch, food: ' Dal and rice ', eatenAt: at, quantity: '');
    final meals = await repo.watchSince(since).first;
    expect(meals.single.food, 'Dal and rice');
    expect(meals.single.quantity, isNull);
    expect(meals.single.calories, isNull);
    expect(meals.single.eatenAt, at.toUtc());
  });

  test('sleep: validated and stored with source', () async {
    final repo = SleepRepository(db);
    expect(repo.add(bedAt: at, wakeAt: at), throwsArgumentError);
    await repo.add(
        bedAt: DateTime(2026, 9, 25, 23), wakeAt: DateTime(2026, 9, 26, 7));
    final s = (await repo.watchSince(since).first).single;
    expect(s.duration, const Duration(hours: 8));
    expect(s.source, DataSource.userEntered);
  });

  test('activity: needs at least one value', () async {
    final repo = ActivityRepository(db);
    expect(repo.add(kind: ActivityKind.walking, recordedAt: at),
        throwsArgumentError);
    await repo.add(kind: ActivityKind.walking, recordedAt: at, steps: 4200);
    final a = (await repo.watchSince(since).first).single;
    expect(a.steps, 4200);
    expect(a.durationMinutes, isNull);
  });

  test('exercise: name and positive duration required', () async {
    final repo = ExerciseRepository(db);
    expect(
        repo.add(
            name: 'Plank',
            category: ExerciseCategory.core,
            durationMinutes: 0,
            performedAt: at),
        throwsArgumentError);
    await repo.add(
        name: 'Plank',
        category: ExerciseCategory.core,
        durationMinutes: 5,
        sets: 3,
        reps: 1,
        performedAt: at);
    final e = (await repo.watchSince(since).first).single;
    expect(e.category, ExerciseCategory.core);
    expect(e.sets, 3);
  });

  test('habits: status set, changed, cleared; delete cascades', () async {
    final repo = HabitRepository(db);
    expect(repo.add('Stretch', const Weekdays(0)), throwsArgumentError);
    final id = await repo.add('Stretch', Weekdays.everyDay);

    await repo.setStatus(id, 20260926, HabitStatus.completed);
    await repo.setStatus(id, 20260926, HabitStatus.skipped);
    var c = await repo.watchCompletionsSince(20260901).first;
    expect(c.single.status, HabitStatus.skipped);

    await repo.setStatus(id, 20260926, null);
    expect(await repo.watchCompletionsSince(20260901).first, isEmpty);

    await repo.setStatus(id, 20260926, HabitStatus.completed);
    await repo.delete(id);
    expect(await repo.watchHabits().first, isEmpty);
    c = await repo.watchCompletionsSince(20260901).first;
    expect(c, isEmpty, reason: 'completions are removed with their habit');
  });

  test('habits: archived habits are hidden', () async {
    final repo = HabitRepository(db);
    final id = await repo.add('Floss', Weekdays.everyDay);
    await repo.archive(id);
    expect(await repo.watchHabits().first, isEmpty);
  });

  test('targets: defaults, then saved values', () async {
    final repo = TargetsRepository(db);
    expect(await repo.watch().first, const DailyTargets());
    const custom = DailyTargets(
        waterMl: 2500, sleepMinutes: 450, steps: 10000, activeMinutes: 45);
    await repo.save(custom);
    expect(await repo.watch().first, custom);
  });
}
