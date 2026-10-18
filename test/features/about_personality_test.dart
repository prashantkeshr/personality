import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/data/repositories/body_record_repository.dart';
import 'package:personality/data/repositories/profile_repository.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  Future<void> open(AppHarness app) async {
    final card = find.byKey(const Key('about-card'));
    await app.reveal(card);
    await app.tapAndSettle(card);
  }

  testWidgets('a fresh start explains each part and links to it', (
    tester,
  ) async {
    final app = AppHarness(tester);
    await app.start(onboarded);
    await open(app);
    expect(find.text('About Your Personality'), findsWidgets);
    expect(find.textContaining('No face analysis yet'), findsOneWidget);
    expect(find.textContaining('Add your height and weight'), findsOneWidget);
    await app.reveal(find.textContaining('No posture check yet'));
    expect(find.text('Check now'), findsWidgets);
    await app.dispose();
  });

  testWidgets('body facts, BMI with its caveat, name and goals', (
    tester,
  ) async {
    final app = AppHarness(tester);
    await app.run(() async {
      final now = DateTime.now();
      Measurement m(double v, String unit, int daysAgo) => Measurement(
        value: v,
        unit: unit,
        source: DataSource.userEntered,
        recordedAt: now.subtract(Duration(days: daysAgo)),
      );
      await BodyRecordRepository(
        app.db,
        app.db.heightRecords,
        unit: CanonicalUnits.length,
      ).add(m(170, CanonicalUnits.length, 30));
      final w = BodyRecordRepository(
        app.db,
        app.db.weightRecords,
        unit: CanonicalUnits.mass,
      );
      await w.add(m(75, CanonicalUnits.mass, 30));
      await w.add(m(72.25, CanonicalUnits.mass, 1));
      final profiles = ProfileRepository(app.db);
      await profiles.save(const Profile(displayName: 'Asha'));
      await profiles.setGoals({GoalType.posture});
    });
    await app.start(onboarded);
    await open(app);

    expect(find.text('Asha'), findsOneWidget);
    expect(find.text('Posture'), findsWidgets); // goal chip + section
    final body = find.byKey(const Key('about-body'));
    await tester.ensureVisible(body);
    await tester.pumpAndSettle();
    expect(find.text('170 cm'), findsOneWidget);
    expect(find.text('72.3 kg'), findsOneWidget);
    expect(find.text('25.0'), findsOneWidget); // 72.25 / 1.7²
    expect(find.textContaining('rough guide'), findsOneWidget);
    expect(find.text('-2.8 kg'), findsOneWidget); // since the first weigh-in
    await app.dispose();
  });
}
