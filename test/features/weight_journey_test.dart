import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:personality/data/repositories/body_record_repository.dart';
import 'package:personality/data/repositories/profile_repository.dart';
import 'package:personality/data/repositories/routine_repository.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  Future<void> seed(
    AppHarness app,
    List<(int daysAgo, double kg)> weights, {
    double? goalMin,
    double? goalMax,
  }) async {
    await app.run(() async {
      final repo = BodyRecordRepository(
        app.db,
        app.db.weightRecords,
        unit: CanonicalUnits.mass,
      );
      final now = DateTime.now();
      for (final (d, kg) in weights) {
        await repo.add(
          Measurement(
            value: kg,
            unit: CanonicalUnits.mass,
            source: DataSource.userEntered,
            recordedAt: now.subtract(Duration(days: d, minutes: 5)),
          ),
        );
      }
      if (goalMin != null) {
        final profiles = ProfileRepository(app.db);
        await profiles.save(
          (await profiles.load()).copyWith(
            goalWeightMinKg: () => goalMin,
            goalWeightMaxKg: () => goalMax,
          ),
        );
      }
    });
  }

  Future<void> openWeight(AppHarness app, WidgetTester tester) async {
    GoRouter.of(tester.element(find.byType(Scaffold).first))
        .push('/health/weight');
    await app.settle();
    await app.settle();
  }

  testWidgets('the trail shows how far along the journey is', (tester) async {
    final app = AppHarness(tester);
    await seed(app, [(60, 80), (1, 75)], goalMin: 65, goalMax: 70);
    await app.start(onboarded);
    await openWeight(app, tester);

    expect(find.text('Your weight journey'), findsOneWidget);
    expect(find.text('50% of the way'), findsOneWidget);
    expect(find.text('To go'), findsOneWidget);
    expect(find.text('5.0 kg'), findsWidgets); // still to go to 70 kg
    expect(
      find.bySemanticsLabel(RegExp('50% of the way from 80')),
      findsOneWidget,
    );
    await app.dispose();
  });

  testWidgets('weigh in on the scale; passing a milestone celebrates', (
    tester,
  ) async {
    final app = AppHarness(tester);
    // 80 → 70 kg; now at 78 (20%). 77.0 passes the 25% mark.
    await seed(app, [(60, 80), (8, 78)], goalMin: 65, goalMax: 70);
    await app.start(onboarded);
    await openWeight(app, tester);

    await app.tapAndSettle(find.byKey(const Key('weight-weigh-in')));
    expect(find.text('Step on the scale'), findsWidgets);
    expect(find.text('78.0 kg'), findsWidgets); // starts at the last weigh-in
    for (var i = 0; i < 10; i++) {
      await tester.tap(find.byKey(const Key('scale-minus')));
      await tester.pump();
    }
    String scale() =>
        tester.widget<Text>(find.byKey(const Key('scale-value'))).data!;
    expect(scale(), '77.0 kg');
    // Dragging the ruler left raises the weight one step per 14 px (after
    // the 18 px touch slop).
    await tester.drag(
      find.byKey(const Key('scale-ruler')),
      const Offset(-50, 0),
    );
    await tester.pump();
    expect(scale(), '77.2 kg');
    await tester.drag(
      find.byKey(const Key('scale-ruler')),
      const Offset(50, 0),
    );
    await tester.pump();
    expect(scale(), '77.0 kg');

    await app.tapAndSettle(find.byKey(const Key('scale-save')));
    expect(find.byKey(const Key('weight-celebration')), findsOneWidget);
    expect(find.text('25% of the way!'), findsOneWidget);
    await app.tapAndSettle(find.text('Keep going'));

    final saved = await app.run(
      () => app.db.select(app.db.weightRecords).get(),
    );
    expect(saved!.map((r) => r.value), contains(77.0));
    await app.dispose();
  });

  testWidgets('no goal: the trail invites setting one', (tester) async {
    final app = AppHarness(tester);
    await seed(app, [(3, 72)]);
    await app.start(onboarded);
    await openWeight(app, tester);
    expect(find.text('Set a goal to map your journey.'), findsOneWidget);
    await app.tapAndSettle(find.byKey(const Key('journey-set-goal')));
    expect(find.byKey(const Key('goal-min')), findsOneWidget);
    await app.dispose();
  });

  testWidgets('weigh-in reminder from the weight screen', (tester) async {
    final app = AppHarness(tester);
    await seed(app, [(3, 72)]);
    await app.start(onboarded);
    await openWeight(app, tester);
    final toggle = find.byKey(const Key('goal-reminder-switch-weighIn'));
    await app.reveal(toggle);
    await app.tapAndSettle(toggle);

    final routines = await app.run(
      () => RoutineRepository(app.db).watchRoutines().first,
    );
    expect(routines!.single.name, 'Weigh-in');
    expect(routines.single.days.mask, 1); // Mondays
    // Summary: Mondays at 7:30.
    expect(find.textContaining('7:30'), findsWidgets);
    await app.dispose();
  });
}
