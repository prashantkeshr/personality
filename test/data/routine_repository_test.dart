import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/data/repositories/routine_repository.dart';
import 'package:personality/domain/entities/health.dart';
import 'package:personality/domain/entities/routine.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late RoutineRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = RoutineRepository(db);
  });
  tearDown(() => db.close());

  test('validation', () {
    expect(repo.createRoutine(' ', Weekdays.everyDay), throwsArgumentError);
    expect(repo.createRoutine('x', const Weekdays(0)), throwsArgumentError);
    expect(repo.addItem('r', 24 * 60, 'x', RoutineItemKind.custom),
        throwsArgumentError);
    expect(repo.record('i', 20260930, PlanOutcome.rescheduled),
        throwsArgumentError);
  });

  test('template creates a routine with localized titles in order', () async {
    final id = await repo.createFromTemplate('Mine', [
      for (final (m, step, kind) in exampleRoutineSteps) (m, step.name, kind),
    ]);
    final items = await repo.watchItems().first;
    expect(items, hasLength(exampleRoutineSteps.length));
    expect(items.every((i) => i.routineId == id), isTrue);
    expect(items.first.minuteOfDay, 7 * 60);
    expect(items.last.kind, RoutineItemKind.sleep);
  });

  test('duplicate copies items but not history', () async {
    final id = await repo.createRoutine('Morning', Weekdays.everyDay);
    final itemId = await repo.addItem(id, 420, 'Water', RoutineItemKind.water);
    await repo.record(itemId, 20260930, PlanOutcome.completed);

    final copy = await repo.duplicateRoutine(id, 'Morning (copy)');
    final items = await repo.watchItems().first;
    expect(items.where((i) => i.routineId == copy), hasLength(1));
    final records = await repo.watchRecordsSince(0).first;
    expect(records, hasLength(1));
    expect(records.single.itemId, itemId);
  });

  test('outcomes: set, change, reschedule, clear', () async {
    final id = await repo.createRoutine('R', Weekdays.everyDay);
    final itemId = await repo.addItem(id, 600, 'Walk', RoutineItemKind.exercise);

    await repo.record(itemId, 20260930, PlanOutcome.completed);
    await repo.record(itemId, 20260930, PlanOutcome.rescheduled,
        rescheduledMinute: 700);
    var r = (await repo.watchRecordsSince(0).first).single;
    expect(r.outcome, PlanOutcome.rescheduled);
    expect(r.rescheduledMinute, 700);

    // Completing or skipping a moved item keeps the moved time.
    await repo.record(itemId, 20260930, PlanOutcome.skipped);
    r = (await repo.watchRecordsSince(0).first).single;
    expect(r.outcome, PlanOutcome.skipped);
    expect(r.rescheduledMinute, 700);

    await repo.record(itemId, 20260930, null);
    expect(await repo.watchRecordsSince(0).first, isEmpty);
  });

  test('deleting a routine removes its items and their history', () async {
    final id = await repo.createRoutine('R', Weekdays.everyDay);
    final itemId = await repo.addItem(id, 600, 'Walk', RoutineItemKind.exercise);
    await repo.record(itemId, 20260930, PlanOutcome.completed);
    await repo.deleteRoutine(id);
    expect(await repo.watchItems().first, isEmpty);
    expect(await repo.watchRecordsSince(0).first, isEmpty);
  });

  test('reminder settings: off by default, adaptive on, dismissals', () async {
    final settings = ReminderSettingsRepository(db);
    var s = await settings.watch().first;
    expect(s.enabled, isFalse);
    expect(s.adaptive, isTrue);

    await settings.setEnabled(true);
    await settings.setAdaptive(false);
    await settings.dismissSuggestion('item-1', 20260930);
    s = await settings.watch().first;
    expect(s.enabled, isTrue);
    expect(s.adaptive, isFalse);
    expect(s.dismissedOn, {'item-1': 20260930});
  });
}
