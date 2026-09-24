import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/units/units.dart';
import 'package:personality/data/repositories/body_record_repository.dart';
import 'package:personality/data/repositories/measurement_repository.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  Future<void> openHealthFeature(AppHarness app, String name) async {
    await app.tester.tap(find.text('Health'));
    await app.tester.pumpAndSettle();
    await app.tester.scrollUntilVisible(find.text(name), 100,
        scrollable: find.byType(Scrollable).last);
    await app.tapAndSettle(find.text(name));
  }

  testWidgets('Home prompts for height when none exists', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    expect(
        find.text('Add your height to improve body-proportion and clothing '
            'recommendations.'),
        findsOneWidget);
    await app.dispose();
  });

  testWidgets('adding height from the Health tab updates Home',
      (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await openHealthFeature(app, 'Height');

    await tester.tap(find.text('Add height'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('record-value')), '300');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Enter a value between'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('record-value')), '172');
    await app.tapAndSettle(find.text('Save'));

    expect(find.text('Primary height'), findsOneWidget);
    expect(find.text('172 cm'), findsWidgets);
    expect(find.textContaining('not treated as growth'), findsOneWidget);

    await app.tapAndSettle(find.text('Home'));
    expect(find.text('172 cm'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('imperial height entry is stored in centimetres',
      (tester) async {
    final app = AppHarness(tester);
    await app.start(const AppSettings(
        onboardingCompleted: true, unitSystem: UnitSystem.imperial));
    await openHealthFeature(app, 'Height');
    await tester.tap(find.text('Add height'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('record-value')), '5');
    await tester.enterText(find.byKey(const Key('record-inches')), '8');
    await app.tapAndSettle(find.text('Save'));

    expect(find.text('5 ft 8 in'), findsWidgets);
    final stored = await app.run(() => BodyRecordRepository(
            app.db, app.db.heightRecords,
            unit: CanonicalUnits.length)
        .all());
    expect(stored!.single.value, closeTo(172.72, 1e-9));
    expect(stored.single.source, DataSource.userEntered);
    await app.dispose();
  });

  testWidgets('weight entry and goal range', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await openHealthFeature(app, 'Weight');

    await tester.tap(find.text('Add weight'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('record-value')), '70.5');
    await app.tapAndSettle(find.text('Save'));
    expect(find.text('70.5 kg'), findsWidgets);

    await tester.ensureVisible(find.text('Set'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Set'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('goal-min')), '72');
    await tester.enterText(find.byKey(const Key('goal-max')), '68');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('The second value must be higher than the first.'),
        findsOneWidget);

    await tester.enterText(find.byKey(const Key('goal-min')), '65');
    await tester.enterText(find.byKey(const Key('goal-max')), '70');
    await app.tapAndSettle(find.text('Save'));
    expect(find.text('65.0 kg – 70.0 kg'), findsOneWidget);
    // The latest-weight card sits at the top of the list.
    await tester.scrollUntilVisible(find.text('Above your goal range'), -200,
        scrollable: find.byType(Scrollable).last);
    expect(find.text('Above your goal range'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('proportions show calculated, neutral results', (tester) async {
    final app = AppHarness(tester);
    final at = DateTime.utc(2026, 9, 20);
    Measurement m(double v) => Measurement(
        value: v, unit: 'cm', source: DataSource.userEntered, recordedAt: at);
    await app.run(() async {
      await BodyRecordRepository(app.db, app.db.heightRecords,
              unit: CanonicalUnits.length)
          .add(m(172));
      final mr = MeasurementRepository(app.db);
      await mr.add(BodyMeasurementType.inseam, m(78));
      await mr.add(BodyMeasurementType.chest, m(100));
      await mr.add(BodyMeasurementType.waist, m(90));
    });

    await app.start(onboarded);
    await openHealthFeature(app, 'Body proportions');

    expect(find.text('Balanced leg line'), findsOneWidget);
    expect(find.text('Moderate taper from chest to waist'), findsOneWidget);
    expect(find.textContaining('Calculated'), findsWidgets);
    expect(find.textContaining('no ideal shape'), findsOneWidget);
    // Shoulder width and hip are missing, so those metrics ask for input.
    expect(find.textContaining('Add Shoulder width'), findsOneWidget);
    await app.dispose();
  });
}
