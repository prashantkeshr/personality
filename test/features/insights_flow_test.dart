import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/data/repositories/body_record_repository.dart';
import 'package:personality/data/repositories/health_repositories.dart';
import 'package:personality/data/repositories/posture_repository.dart';
import 'package:personality/data/repositories/wellbeing_repository.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/domain/services/posture_engine.dart';
import 'package:personality/features/health/health_providers.dart';
import 'package:personality/features/posture/posture_history_screen.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

MetricResult metric(PostureMetric m, double deg) => MetricResult(
      metric: m,
      degrees: deg,
      direction: MetricDirection.left,
      band: PostureBands.of(m, deg),
      spread: 0.5,
      confidence: Confidence.high,
    );

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);
  final monday = DateTime(2026, 10, 12, 9);

  Future<AppHarness> start(WidgetTester tester) async {
    final app = AppHarness(tester);
    await app.run(() async {
      // Last week (5–11 Oct): water most days, short sleep.
      final water = BodyRecordRepository(app.db, app.db.waterLogs, unit: 'ml');
      final sleep = SleepRepository(app.db);
      for (var i = 1; i <= 7; i++) {
        final day = monday.subtract(Duration(days: i));
        await water.add(Measurement(
            value: 2200, unit: 'ml', source: DataSource.userEntered,
            recordedAt: day.add(const Duration(hours: 3)).toUtc()));
        final wake = DateTime(day.year, day.month, day.day, 6);
        await sleep.add(
            bedAt: wake.subtract(Duration(minutes: i < 3 ? 480 : 330)), wakeAt: wake);
      }
    });
    await app.start(onboarded, overrides: [clockProvider.overrideWithValue(() => monday)]);
    return app;
  }

  testWidgets('Monday review, then insights with sleep score and no-data days',
      (tester) async {
    final app = await start(tester);
    await app.reveal(find.text('Your week'));
    expect(find.text('Your week'), findsOneWidget);
    expect(find.textContaining('7 active days'), findsOneWidget);
    expect(find.textContaining('Water target met on 7 days'), findsOneWidget);
    expect(find.textContaining('regular bedtime'), findsOneWidget); // sleep tip

    await app.tapAndSettle(find.text('See insights'));
    expect(find.text('Sleep score'), findsOneWidget);
    expect(find.textContaining('nights logged'), findsOneWidget);
    // The last 7 days end today, which has nothing logged yet.
    await app.reveal(find.text('Met on 6 of 6 logged days'));
    expect(find.text('Met on 6 of 6 logged days'), findsOneWidget); // water
    await app.reveal(find.text('Mood'));
    expect(find.text('No records in this period yet.'), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await app.reveal(find.text('Close'));
    await app.tapAndSettle(find.text('Close'));
    expect(find.text('Your week'), findsNothing);
    await app.dispose();
  });

  testWidgets('evolution notes from the Journey screen', (tester) async {
    final app = await start(tester);
    await app.run(() => WellbeingRepository(app.db, clock: () => monday)
        .addNote('Started stretching'));
    await app.reveal(find.text('Your journey'));
    await app.tapAndSettle(find.text('Your journey'));
    await app.reveal(find.text('Evolution'));
    expect(find.text('Started stretching'), findsOneWidget);
    expect(find.text('First step: you logged something'), findsOneWidget);
    await app.tapAndSettle(find.text('See all'));
    await app.tapAndSettle(find.byKey(const Key('add-note')));
    await tester.enterText(find.byKey(const Key('note-text')), 'Slept better');
    await app.tapAndSettle(find.text('Save'));
    expect(find.text('Slept better'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('posture compare shows the change per metric', (tester) async {
    final app = AppHarness(tester);
    await app.run(() async {
      for (final (at, deg) in [(DateTime(2026, 9, 1), 4.0), (DateTime(2026, 10, 1), 1.5)]) {
        await PostureRepository(app.db, clock: () => at).save(PostureResult(
            view: PostureView.front,
            metrics: [metric(PostureMetric.shoulderLevel, deg)],
            confidence: Confidence.high,
            framesUsed: 15,
            visibility: 0.9));
      }
    });
    await app.start(onboarded);
    final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
    nav.push(MaterialPageRoute<void>(builder: (_) => const PostureCompareScreen()));
    await app.settle();
    expect(find.text('Compare sessions'), findsOneWidget);
    expect(find.text('4.0°'), findsOneWidget);
    expect(find.text('1.5°'), findsOneWidget);
    expect(find.text('−2.5°'), findsOneWidget);
    await app.dispose();
  });
}
