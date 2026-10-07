import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/device/device_tier.dart';
import 'package:personality/core/providers.dart';
import 'package:personality/data/repositories/health_repositories.dart';
import 'package:personality/domain/entities/exercise_library.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/features/camera/camera_providers.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/ml/model_manager/bundled_models.dart';
import 'package:personality/core/features/feature_registry.dart';
import 'package:personality/ml/pose/pose_estimator.dart';

import '../domain/exercise_tracker_test.dart' show squat;
import '../helpers/app_harness.dart';
import '../helpers/fakes.dart';

const midRange =
    DeviceSpecs(ramMb: 6144, cpuCores: 8, osApiLevel: 33, hasCamera: true);

void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 3200);
  tester.view.devicePixelRatio = 2.5;
  addTearDown(tester.view.reset);
}

/// Taps [f], then advances real and fake time until [until] appears.
/// Used where a screen keeps animating, so pumpAndSettle never ends.
Future<void> step(AppHarness app, Finder f, Finder until) async {
  await app.tester.tap(f);
  for (var i = 0; i < 60 && until.evaluate().isEmpty; i++) {
    await app.run(() => Future<void>.delayed(const Duration(milliseconds: 30)));
    await app.tester.pump(const Duration(milliseconds: 100));
  }
  expect(until, findsWidgets);
}

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  test('library content is complete and bilingual', () {
    final list = [
      for (final e in jsonDecode(
              File('assets/content/exercises.json').readAsStringSync()) as List)
        LibraryExercise.fromJson(e as Map<String, dynamic>),
    ];
    expect(list.length, greaterThanOrEqualTo(12));
    expect(list.map((e) => e.id).toSet().length, list.length);
    for (final e in list) {
      for (final m in [e.name, e.summary, e.dose, e.safety]) {
        expect(m.keys, containsAll(['en', 'hi']), reason: e.id);
      }
      if (e.trackable) expect(e.target, isNotNull, reason: e.id);
    }
    expect(list.where((e) => e.trackable).length, 5);
  });

  Future<(AppHarness, FakeCamera, ScriptedEstimator)> start(
      WidgetTester tester) async {
    usePhoneScreen(tester);
    final camera = FakeCamera();
    final estimator = ScriptedEstimator([squat(175)]);
    final app = AppHarness(tester);
    await app.start(onboarded, overrides: [
      cameraSourceProvider.overrideWithValue(camera),
      poseEstimatorProvider.overrideWithValue(estimator),
      deviceProbeProvider.overrideWithValue(const FixedProbe(midRange)),
      installedModelsProvider.overrideWithValue(const {ModelIds.pose}),
    ]);
    return (app, camera, estimator);
  }

  testWidgets('browse the library and log an exercise as done', (tester) async {
    final (app, _, _) = await start(tester);
    await tester.tap(find.text('Health'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Exercise'), 100,
        scrollable: find.byType(Scrollable).last);
    await app.tapAndSettle(find.text('Exercise'));
    await app.tapAndSettle(find.text('Exercise library'));
    expect(find.text('Bodyweight squat'), findsOneWidget);

    await app.tapAndSettle(find.text('Camera-tracked').first);
    expect(find.text('Chin tucks'), findsNothing);
    await app.tapAndSettle(find.text('All'));
    await tester.scrollUntilVisible(find.text('Chin tucks'), 100,
        scrollable: find.byType(Scrollable).last);
    await app.tapAndSettle(find.text('Chin tucks'));
    expect(find.text('How to do it'), findsOneWidget);
    expect(find.text('Track with camera'), findsNothing); // not trackable

    await app.tapAndSettle(find.text('Log as done'));
    await tester.enterText(find.byKey(const Key('done-minutes')), '3');
    await app.tapAndSettle(find.text('Save'));
    final saved = await app.run(() => ExerciseRepository(app.db)
        .watchSince(DateTime.utc(2020)).first);
    expect(saved!.single.name, 'Chin tucks');
    expect(saved.single.durationMinutes, 3);
    await app.dispose();
  });

  testWidgets('camera-tracked squats are counted and saved', (tester) async {
    final (app, camera, estimator) = await start(tester);
    await tester.tap(find.text('Analyze'));
    await tester.pumpAndSettle();
    await step(app, find.text('Exercise tracking'), find.text('Bodyweight squat'));
    expect(find.text('Chin tucks'), findsNothing); // camera filter applied
    await step(app, find.text('Bodyweight squat'), find.text('Track with camera'));
    await step(app, find.text('Track with camera'), find.text('Goal: 10 reps'));
    expect(find.text('Goal: 10 reps'), findsOneWidget);

    await app.tapAndSettle(find.text('Start camera'));
    var ms = 0;
    Future<void> frames(List<PoseDetected> poses) async {
      for (final p in poses) {
        estimator.script = [p];
        await app.run(() => camera.emit(
            100, 160, DateTime(2026).add(Duration(milliseconds: ms += 200))));
        await tester.pump();
      }
      await tester.pumpAndSettle();
    }

    await frames([squat(175)]);
    expect(find.textContaining('tap Start'), findsOneWidget);
    await app.tapAndSettle(find.text('Start'));
    await tester.pump(const Duration(seconds: 5)); // countdown
    await tester.pumpAndSettle();

    for (var i = 0; i < 3; i++) {
      await frames([
        for (final a in <double>[175, 150, 120, 90, 90, 120, 150, 175, 175])
          squat(a),
      ]);
    }
    expect(find.text('3'), findsOneWidget);
    expect(find.text('of 10 reps'), findsOneWidget);

    await app.tapAndSettle(find.text('Finish'));
    expect(find.text('Session summary'), findsOneWidget);
    expect(camera.state.value.running, isFalse);
    await app.tapAndSettle(find.text('Save to log'));
    final saved = await app.run(() => ExerciseRepository(app.db)
        .watchSince(DateTime.utc(2020)).first);
    expect(saved!.single.reps, 3);
    expect(saved.single.source, DataSource.cameraDerived);
    await app.dispose();
  });
}
