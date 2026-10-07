import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/device/device_tier.dart';
import 'package:personality/core/providers.dart';
import 'package:personality/data/repositories/posture_repository.dart';
import 'package:personality/domain/services/posture_engine.dart';
import 'package:personality/features/camera/camera_providers.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/ml/pose/pose_estimator.dart';

import '../domain/posture_engine_test.dart' show front, pose;
import '../helpers/app_harness.dart';
import '../helpers/fakes.dart';

const midRange =
    DeviceSpecs(ramMb: 6144, cpuCores: 8, osApiLevel: 33, hasCamera: true);

void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 3200);
  tester.view.devicePixelRatio = 2.5;
  addTearDown(tester.view.reset);
}

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  Future<(AppHarness, FakeCamera)> openPosture(
      WidgetTester tester, ScriptedEstimator estimator) async {
    usePhoneScreen(tester);
    final camera = FakeCamera();
    final app = AppHarness(tester);
    await app.start(onboarded, overrides: [
      cameraSourceProvider.overrideWithValue(camera),
      poseEstimatorProvider.overrideWithValue(estimator),
      deviceProbeProvider.overrideWithValue(const FixedProbe(midRange)),
    ]);
    await tester.tap(find.text('Analyze'));
    await tester.pumpAndSettle();
    await app.tapAndSettle(find.text('Posture analysis'));
    return (app, camera);
  }

  /// Sends [n] well-lit frames 200 ms apart (above the 10 fps throttle).
  Future<void> frames(AppHarness app, FakeCamera camera, int n,
      {int startMs = 0}) async {
    for (var i = 0; i < n; i++) {
      await app.run(() => camera.emit(
          100, 160, DateTime(2026).add(Duration(milliseconds: startMs + 200 * i))));
      await app.tester.pump();
    }
    await app.tester.pumpAndSettle();
  }

  testWidgets('guided capture produces an estimated result that can be saved',
      (tester) async {
    final estimator = ScriptedEstimator([pose(front(shoulderTiltDeg: 4))]);
    final (app, camera) = await openPosture(tester, estimator);

    expect(find.textContaining('not a medical or spinal assessment'),
        findsOneWidget);
    await app.tapAndSettle(find.text('Start camera'));

    await frames(app, camera, 1);
    expect(find.textContaining('Front view detected'), findsOneWidget);

    // Analyze starts a countdown so the user can step back into place.
    await app.tapAndSettle(find.widgetWithText(FilledButton, 'Analyze'));
    expect(find.text('5'), findsOneWidget);
    expect(find.textContaining('capture starts at zero'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.textContaining('Hold still'), findsOneWidget);
    await frames(app, camera, PostureCapture().targetFrames, startMs: 1000);

    expect(find.text('Estimated alignment · Front view'), findsOneWidget);
    expect(find.text('Shoulder level'), findsOneWidget);
    expect(find.text('4.0°'), findsOneWidget);
    expect(find.textContaining('Slight · Left side higher'), findsOneWidget);
    expect(find.textContaining('Camera estimate'), findsOneWidget);
    // Camera released once the result is in.
    expect(camera.state.value.running, isFalse);

    // Suggestions explain themselves.
    await tester.scrollUntilVisible(find.text('Why this?').first, 200,
        scrollable: find.byType(Scrollable).last);
    expect(find.textContaining('Shoulder level measured 4.0°'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Save'), -200,
        scrollable: find.byType(Scrollable).last);
    await app.tapAndSettle(find.text('Save'));
    final saved = await app.run(() => PostureRepository(app.db).watchAll().first);
    expect(saved!.single.result[PostureMetric.shoulderLevel]!.degrees,
        closeTo(4, 0.05));

    await app.tapAndSettle(find.byTooltip('Posture history'));
    expect(find.textContaining('Front view'), findsWidgets);
    expect(find.textContaining('1 to look at'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('poor frames during capture give no result, only guidance',
      (tester) async {
    final estimator = ScriptedEstimator([pose(front())]);
    final (app, camera) = await openPosture(tester, estimator);
    await app.tapAndSettle(find.text('Start camera'));
    await frames(app, camera, 1);
    await app.tapAndSettle(find.widgetWithText(FilledButton, 'Analyze'));
    await tester.pump(const Duration(seconds: 5)); // countdown
    await tester.pumpAndSettle();

    // From now on the body is barely visible.
    estimator.script = [pose(front(), visibility: 0.3)];
    await frames(app, camera, 10, startMs: 1000);
    await tester.pump(const Duration(seconds: 16)); // capture timeout
    await tester.pumpAndSettle();

    expect(find.text('Posture could not be reliably measured.'), findsOneWidget);
    expect(find.textContaining("isn't clearly visible"), findsOneWidget);
    expect(find.text('Shoulder level'), findsNothing);
    final saved = await app.run(() => PostureRepository(app.db).watchAll().first);
    expect(saved, isEmpty);
    await app.dispose();
  });

  testWidgets('live guidance explains what to fix', (tester) async {
    final far = {
      for (final e in front().entries)
        e.key: (0.5 + (e.value.$1 - 0.5) * 0.3, 0.5 + (e.value.$2 - 0.5) * 0.3),
    };
    final estimator = ScriptedEstimator([const NoPersonDetected()]);
    final (app, camera) = await openPosture(tester, estimator);
    await app.tapAndSettle(find.text('Start camera'));

    await frames(app, camera, 1);
    expect(find.text('No person detected. Step into the frame.'), findsOneWidget);

    estimator.script = [pose(far)];
    await frames(app, camera, 1, startMs: 1000);
    expect(find.text('Move a little closer to the phone.'), findsOneWidget);
    await app.dispose();
  });
}
