import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/data/repositories/body_record_repository.dart';
import 'package:personality/data/repositories/health_repositories.dart';
import 'package:personality/data/repositories/progress_repository.dart';
import 'package:personality/data/repositories/style_repository.dart';
import 'package:personality/domain/entities/health.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/domain/services/outfit_engine.dart';
import 'package:personality/domain/services/progress_engine.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  final now = DateTime(2026, 10, 8, 20);
  final yesterday = DateTime(2026, 10, 7, 23, 30);

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Measurement ml(double v, DateTime at) => Measurement(
      value: v, unit: 'ml', source: DataSource.userEntered, recordedAt: at);

  test('digests each local day from existing records', () async {
    final water = BodyRecordRepository(db, db.waterLogs, unit: 'ml');
    await water.add(ml(1500, now));
    await water.add(ml(600, now.subtract(const Duration(hours: 2))));
    await water.add(ml(300, yesterday));
    final meals = MealRepository(db);
    await meals.add(type: MealType.lunch, food: 'Dal', eatenAt: now);
    await ActivityRepository(db)
        .add(kind: ActivityKind.walking, recordedAt: now, steps: 3000);
    final habits = HabitRepository(db);
    final h = await habits.add('Stretch', Weekdays.everyDay);
    await habits.setStatus(h, 20261008, HabitStatus.completed);
    await habits.setStatus(h, 20261007, HabitStatus.skipped); // not counted
    final style = StyleRepository(db, clock: () => now);
    final a = await style.addItem(
        name: 'Shirt', category: GarmentCategory.top, colorHex: '#FFFFFF');
    final b = await style.addItem(
        name: 'Chinos', category: GarmentCategory.bottom, colorHex: '#1F2A44');
    await style.markWorn(await style.saveOutfit(Occasion.work, [a, b]));

    final repo = ProgressRepository(db, clock: () => now);
    final days = await repo.history();
    expect(days.map((d) => d.dayKey), [20261007, 20261008]);
    final today = days.last;
    expect(today.waterMl, 2100);
    expect(today.waterTargetMet, isTrue);
    expect((today.meals, today.workouts, today.habitsDone), (1, 1, 1));
    expect((today.outfitsSaved, today.outfitsWorn), (1, 1));
    expect(days.first.waterMl, 300);
    expect(days.first.habitsDone, 0);
  });

  test('history stream refreshes on new records; badges seen persist',
      () async {
    final repo = ProgressRepository(db, clock: () => now);
    final stream = repo.watchHistory();
    expect(await stream.first, isEmpty);
    await MealRepository(db).add(type: MealType.lunch, food: 'Dal', eatenAt: now);
    expect((await repo.watchHistory().first).single.meals, 1);

    expect(await repo.seenBadges(), isEmpty);
    await repo.markBadgesSeen([Award.firstSteps]);
    await repo.markBadgesSeen([Award.streak7, Award.firstSteps]);
    expect(await repo.seenBadges(), {'firstSteps', 'streak7'});
  });
}
