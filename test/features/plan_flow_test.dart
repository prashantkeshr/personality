import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/data/repositories/body_plan_repository.dart';
import 'package:personality/data/repositories/body_record_repository.dart';
import 'package:personality/data/repositories/health_repositories.dart';
import 'package:personality/data/repositories/profile_repository.dart';
import 'package:personality/data/repositories/routine_repository.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/entities/grooming.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/domain/services/face_engine.dart';
import 'package:personality/domain/services/nutrition_engine.dart';
import 'package:personality/data/repositories/style_repository.dart';
import 'package:personality/features/health/health_providers.dart';
import 'package:personality/features/journey/goal_finder_screen.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

Future<void> seedBody(AppDatabase db, DateTime at) async {
  await ProfileRepository(db).save(const Profile(
      displayName: 'Ravi Kumar',
      gender: Gender.male,
      ageRange: AgeRange.from25to34,
      activityLevel: ActivityLevel.moderate));
  await BodyRecordRepository(db, db.heightRecords, unit: 'cm').add(Measurement(
      value: 175,
      unit: 'cm',
      source: DataSource.userEntered,
      method: MeasurementMethod.selfMeasured.wireName,
      recordedAt: at));
  await BodyRecordRepository(db, db.weightRecords, unit: 'kg').add(Measurement(
      value: 70,
      unit: 'kg',
      source: DataSource.userEntered,
      method: MeasurementMethod.scale.wireName,
      recordedAt: at));
}

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);
  final now = DateTime(2026, 10, 9, 9);

  test('repository: one active plan, ended plans kept', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final repo = BodyPlanRepository(db, clock: () => now);
    const input = NutritionInput(weightKg: 70, heightCm: 175, gender: Gender.male);
    await repo.start(
        targets: NutritionEngine.targets(input, PlanKind.loseFat, PlanPace.steady),
        diet: DietPreference.vegetarian,
        weightKg: 70,
        targetWeightKg: 65);
    await repo.start(
        targets: NutritionEngine.targets(input, PlanKind.buildMuscle, PlanPace.gentle),
        diet: DietPreference.vegan,
        weightKg: 70);
    final active = await repo.watchActive().first;
    expect((active!.kind, active.pace, active.diet),
        (PlanKind.buildMuscle, PlanPace.gentle, DietPreference.vegan));
    expect((await db.select(db.bodyPlans).get()).length, 2);
    await repo.end();
    expect(await repo.watchActive().first, isNull);
    await db.close();
  });

  test('profile stores gender, diet and style fit', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final repo = ProfileRepository(db);
    await repo.save(const Profile(
        gender: Gender.female, dietPreference: DietPreference.eggetarian));
    var p = await repo.load();
    expect((p.gender, p.dietPreference, p.styleFit, p.effectiveStyleFit),
        (Gender.female, DietPreference.eggetarian, null, StyleFit.womenswear));
    await repo.save(p.copyWith(styleFit: () => StyleFit.all));
    p = await repo.load();
    expect(p.effectiveStyleFit, StyleFit.all);
    expect(const Profile(gender: Gender.nonBinary).effectiveStyleFit, StyleFit.all);
    await db.close();
  });

  test('style examples follow the chosen fit, with a fallback', () {
    const beard = StyleItem(
        id: 'b', kind: StyleKind.beard, name: {}, desc: {}, fit: StyleFit.menswear);
    const hair = StyleItem(id: 'h', kind: StyleKind.hair, name: {}, desc: {});
    expect(beard.suits(StyleFit.womenswear), isFalse);
    expect(beard.suits(StyleFit.menswear), isTrue);
    expect(beard.suits(StyleFit.all), isTrue);
    expect(hair.suits(StyleFit.womenswear), isTrue);
    // Every style has looks for both fits.
    for (final style in StylePreference.values) {
      for (final fit in [StyleFit.menswear, StyleFit.womenswear]) {
        expect(styleImages[style]!.any((l) => l.$2 == fit), isTrue,
            reason: '$style $fit');
      }
    }
    expect(looksFor(StylePreference.traditional, StyleFit.menswear), hasLength(2));
    expect(looksFor(StylePreference.street, StyleFit.womenswear),
        ['assets/images/looks/street_2.jpg']);
    // Every face shape offers hair ideas for both fits.
    final content = GroomingContent.fromJson(jsonDecode(
            File('assets/content/grooming.json').readAsStringSync())
        as Map<String, dynamic>);
    for (final shape in FaceShape.values) {
      for (final fit in [StyleFit.menswear, StyleFit.womenswear]) {
        expect(content.suggestions(shape, StyleKind.hair, fit: fit), isNotEmpty,
            reason: '$shape $fit');
      }
      expect(content.suggestions(shape, StyleKind.beard, fit: StyleFit.womenswear),
          isEmpty);
    }
  });

  testWidgets('create a plan, log a planned meal, add workouts, end it',
      (tester) async {
    final app = AppHarness(tester);
    await app.run(() => seedBody(app.db, now));
    await app.start(onboarded,
        overrides: [clockProvider.overrideWithValue(() => now)]);
    expect(find.text('Good morning, Ravi'), findsOneWidget);

    await app.tapAndSettle(find.text('Health'));
    await tester.scrollUntilVisible(find.text('Diet & body plan').hitTestable(), 100,
        scrollable: find.byType(Scrollable).last);
    await app.tapAndSettle(find.text('Diet & body plan'));
    expect(find.text('Your goal'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('plan-loseFat')));
    await app.tapAndSettle(find.byKey(const Key('plan-loseFat')));
    // 70 kg, 175 cm, male, 25–34, moderate → 2010 kcal at a steady pace.
    await tester.scrollUntilVisible(find.text('2010').hitTestable(), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Protein 140 g'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('plan-target')), '65');
    await app.settle();
    expect(find.text('About 11 weeks to your target'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Start my plan').hitTestable(), 200,
        scrollable: find.byType(Scrollable).first);
    await app.tapAndSettle(find.text('Start my plan'));

    expect(find.text("Today's menu"), findsOneWidget);
    final logButton = find.byWidgetPredicate(
        (w) => w.key is ValueKey<String> &&
            (w.key! as ValueKey<String>).value.startsWith('log-'));
    await tester.scrollUntilVisible(logButton.first.hitTestable(), 200,
        scrollable: find.byType(Scrollable).first);
    await app.tapAndSettle(logButton.first);
    final meals = await app.run(() => MealRepository(app.db)
        .watchSince(now.subtract(const Duration(days: 1)))
        .first);
    expect(meals!.single.calories, greaterThan(300));
    await app.settle();
    expect(find.text('Logged'), findsWidgets);

    await tester.scrollUntilVisible(
        find.text('Add workouts to my routines').hitTestable(), 200,
        scrollable: find.byType(Scrollable).first);
    await app.tapAndSettle(find.text('Add workouts to my routines'));
    final routines =
        await app.run(() => RoutineRepository(app.db).watchRoutines().first);
    expect(routines!.single.name, 'Training plan');
    expect(routines.single.days.count, 6); // one rest day for steady fat loss

    await tester.scrollUntilVisible(find.text('End plan').hitTestable(), 200,
        scrollable: find.byType(Scrollable).first);
    await app.tapAndSettle(find.text('End plan'));
    await app.tapAndSettle(find.widgetWithText(FilledButton, 'End plan'));
    expect(find.text('Your goal'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('plan asks for height and weight first', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await app.tapAndSettle(find.text('Health'));
    await tester.scrollUntilVisible(find.text('Diet & body plan').hitTestable(), 100,
        scrollable: find.byType(Scrollable).last);
    await app.tapAndSettle(find.text('Diet & body plan'));
    expect(find.text('Add your height and weight to create a plan.'), findsOneWidget);
    expect(find.text('Add height'), findsOneWidget);
    await app.dispose();
  });
}
