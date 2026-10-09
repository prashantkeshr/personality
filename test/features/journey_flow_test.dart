import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:personality/data/repositories/body_record_repository.dart';
import 'package:personality/data/repositories/progress_repository.dart';
import 'package:personality/data/repositories/profile_repository.dart';
import 'package:personality/data/repositories/snapshot_repository.dart';
import 'package:personality/data/repositories/style_repository.dart';
import 'package:personality/domain/entities/body.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/features/health/health_providers.dart';
import 'package:personality/features/journey/snapshot_aligner.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/ml/preprocessing/yuv_convert.dart';

import '../helpers/app_harness.dart';

Uint8List jpeg(int w, int h, {int shade = 128}) => Uint8List.fromList(img
    .encodeJpg(img.Image(width: w, height: h)
      ..clear(img.ColorRgb8(shade, shade, shade))));

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);
  final now = DateTime(2026, 10, 8, 18);

  group('alignment maths', () {
    test('eyes land at the fixed position, level and spaced', () {
      // Tilted eyes in a 1000×1000 photo.
      const eyes = ((0.40, 0.50), (0.60, 0.54));
      const out = Size(300, 400);
      final m = alignTransform(eyes, const Size(1000, 1000), out);
      Offset map(double x, double y) =>
          MatrixUtils.transformPoint(m, Offset(x, y));

      final a = map(400, 500), b = map(600, 540);
      expect((a.dy - b.dy).abs(), lessThan(1e-6)); // level
      expect((b.dx - a.dx), closeTo(alignedEyeDistance * out.width, 1e-6));
      expect((a + b) / 2, offsetMoreOrLessEquals(
          Offset(alignedEyeCentre.dx * out.width, alignedEyeCentre.dy * out.height)));
      // Order of the eyes does not matter.
      final swapped = alignTransform(
          ((0.60, 0.54), (0.40, 0.50)), const Size(1000, 1000), out);
      expect(swapped, m);
    });

    test('RGB to NV21: grey stays neutral, sizes are even', () {
      final rgba = Uint8List.fromList(
          [for (var i = 0; i < 5 * 3; i++) ...[100, 100, 100, 255]]);
      final f = rgbToNv21(rgba, 5, 3);
      expect((f.width, f.height), (4, 2));
      expect(f.bytes.length, 4 * 2 * 3 ~/ 2);
      expect(f.bytes.sublist(0, 8), everyElement(inInclusiveRange(98, 100)));
      expect(f.bytes.sublist(8), everyElement(inInclusiveRange(127, 129)));
    });

    test('stored photo converts to an upright NV21 frame in memory', () {
      final frame = photoToFrame(jpeg(321, 401))!;
      expect((frame.width, frame.height, frame.rotationDegrees), (320, 400, 0));
      expect(photoToFrame(Uint8List.fromList([1, 2, 3])), isNull);
    });
  });

  testWidgets('Home shows journey, quests and celebrates a new badge once',
      (tester) async {
    final app = AppHarness(tester);
    await app.run(() => BodyRecordRepository(app.db, app.db.waterLogs, unit: 'ml')
        .add(Measurement(
            value: 2000,
            unit: 'ml',
            source: DataSource.userEntered,
            recordedAt: now)));
    await app.start(onboarded,
        celebrateBadges: true,
        overrides: [clockProvider.overrideWithValue(() => now)]);
    for (var i = 0; i < 20 && find.text('Badge unlocked').evaluate().isEmpty; i++) {
      await app.settle();
    }
    expect(find.text('Badge unlocked'), findsOneWidget);
    expect(find.text('First steps'), findsOneWidget);
    await app.tapAndSettle(find.text('Continue'));
    await app.settle();
    expect(find.text('Badge unlocked'), findsNothing);
    final seen = await app.run(() => ProgressRepository(app.db).seenBadges());
    expect(seen, contains('firstSteps'));

    expect(find.text('Your journey'), findsOneWidget);
    expect(find.text('Level 1'), findsOneWidget);
    expect(find.text("Today's quests"), findsOneWidget);
    expect(find.text('1-day streak'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('For you today').hitTestable(), 300,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('What do you want?'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Your journey').hitTestable(), -300,
        scrollable: find.byType(Scrollable).first);
    await app.tapAndSettle(find.text('Your journey'));
    expect(find.text('Total XP'), findsOneWidget);
    expect(find.text('Take a face snapshot to start your time-lapse'),
        findsOneWidget);
    await tester.scrollUntilVisible(find.text('Badges').hitTestable(), 300,
        scrollable: find.byType(Scrollable).first);
    expect(find.textContaining('of 12 earned'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('journey time-lapse plays and compares real snapshots',
      (tester) async {
    final app = AppHarness(tester);
    await app.run(() async {
      final repo = SnapshotRepository(app.db,
          clock: () => DateTime(2026, 9, 1));
      await repo.add(SnapshotKind.face, jpeg(300, 400, shade: 90));
      final later = SnapshotRepository(app.db, clock: () => now);
      await later.add(SnapshotKind.face, jpeg(300, 400, shade: 160));
    });
    await app.start(onboarded,
        overrides: [clockProvider.overrideWithValue(() => now)]);
    expect(find.text('2 snapshots'), findsOneWidget);
    await app.tapAndSettle(find.text('Your journey'));
    expect(find.byType(Slider), findsOneWidget);
    await app.tapAndSettle(find.text('Compare side by side'));
    expect(find.textContaining('First ·'), findsOneWidget);
    expect(find.textContaining('Latest ·'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('goal finder: tap images to choose goals and looks',
      (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded,
        overrides: [clockProvider.overrideWithValue(() => now)]);
    await tester.scrollUntilVisible(find.text('What do you want?').hitTestable(), 300,
        scrollable: find.byType(Scrollable).first);
    await app.tapAndSettle(find.text('What do you want?'));
    expect(find.text('What would you like to work on?'), findsOneWidget);

    await app.tapAndSettle(find.byKey(const Key('goal-posture')));
    await app.tapAndSettle(find.byKey(const Key('goal-sleep')));
    await app.tapAndSettle(find.byKey(const Key('goal-sleep'))); // undo
    expect(find.text('1 selected'), findsOneWidget);
    await app.tapAndSettle(find.text('Next'));
    expect(find.text('Which looks feel like you?'), findsOneWidget);
    await app.tapAndSettle(find.byKey(const Key('look-classic-1')));
    // Both classic looks show as selected; one style is chosen.
    expect(find.text('1 selected'), findsOneWidget);
    await app.tapAndSettle(find.text('Save my focus'));
    expect(find.textContaining('Your focus is saved'), findsOneWidget);

    final goals =
        await app.run(() => ProfileRepository(app.db).watchGoals().first);
    final styles =
        await app.run(() => StyleRepository(app.db).watchProfile().first);
    expect(goals, {GoalType.posture});
    expect(styles!.styles, {StylePreference.classic});
    await app.dispose();
  });
}
