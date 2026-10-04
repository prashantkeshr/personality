import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/device/device_tier.dart';
import 'package:personality/core/providers.dart';
import 'package:personality/features/camera/camera_providers.dart';
import 'package:personality/features/camera/camera_source.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/ml/inference/frame_pipeline.dart';

import '../helpers/app_harness.dart';

/// A camera that delivers synthetic frames on demand.
class FakeCamera implements CameraSource {
  FakeCamera({this.deny = false});
  final bool deny;
  final _state = ValueNotifier(const CameraSourceState());
  void Function(FrameInput)? _onFrame;
  CameraPowerMode? startedWith;
  int stops = 0;

  @override
  ValueListenable<CameraSourceState> get state => _state;
  @override
  Future<List<CameraLens>> lenses() async => [CameraLens.back, CameraLens.front];
  @override
  Future<void> start(CameraLens lens, CameraPowerMode mode,
      void Function(FrameInput) onFrame) async {
    startedWith = mode;
    if (deny) {
      _state.value =
          const CameraSourceState(problem: CameraProblem.permissionDenied);
      return;
    }
    _onFrame = onFrame;
    _state.value =
        CameraSourceState(running: true, lens: lens, previewAspectRatio: 4 / 3);
  }

  @override
  Future<void> stop() async {
    stops++;
    _onFrame = null;
    _state.value = const CameraSourceState();
  }

  @override
  Widget preview() => const ColoredBox(color: Colors.black);

  /// Sends a frame with the given brightness (checkerboard a/b).
  Future<void> emit(int a, int b, DateTime at) async {
    final y = Uint8List(64 * 48);
    for (var i = 0; i < y.length; i++) {
      y[i] = (i + i ~/ 64).isEven ? a : b;
    }
    _onFrame?.call(FrameInput(
        yPlane: y,
        width: 64,
        height: 48,
        bytesPerRow: 64,
        rotationDegrees: 90,
        timestamp: at));
  }
}

class FixedProbe implements DeviceCapabilityProbe {
  const FixedProbe(this.specs);
  final DeviceSpecs specs;
  @override
  Future<DeviceSpecs> probe() async => specs;
}

/// A tall phone-sized screen so the camera screen fits without scrolling.
void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 3200);
  tester.view.devicePixelRatio = 2.5;
  addTearDown(tester.view.reset);
}

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);
  const midRange =
      DeviceSpecs(ramMb: 6144, cpuCores: 8, osApiLevel: 36, hasCamera: true);

  Future<AppHarness> openCameraCheck(WidgetTester tester, FakeCamera camera,
      {DeviceSpecs specs = midRange}) async {
    usePhoneScreen(tester);
    final app = AppHarness(tester);
    await app.start(onboarded, overrides: [
      cameraSourceProvider.overrideWithValue(camera),
      deviceProbeProvider.overrideWithValue(FixedProbe(specs)),
    ]);
    await tester.tap(find.text('Analyze'));
    await tester.pumpAndSettle();
    await app.tapAndSettle(find.text('Camera check'));
    return app;
  }

  testWidgets('live lighting from real frames; pose honestly unavailable',
      (tester) async {
    final camera = FakeCamera();
    final app = await openCameraCheck(tester, camera);
    expect(find.textContaining('nothing is saved or uploaded'), findsOneWidget);

    await app.tapAndSettle(find.text('Start camera'));
    // Mid-range device → standard mode by default.
    expect(camera.startedWith, CameraPowerMode.standard);
    expect(find.text('Processing on device'), findsOneWidget);

    await app.run(() => camera.emit(10, 30, DateTime(2026)));
    await tester.pumpAndSettle();
    expect(find.text('Too dark'), findsOneWidget);
    expect(find.textContaining('improve the lighting'), findsWidgets);

    await app.run(() => camera.emit(
        100, 160, DateTime(2026).add(const Duration(seconds: 1))));
    await tester.pumpAndSettle();
    expect(find.text('Good light'), findsOneWidget);
    expect(find.textContaining('needs the pose model'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('power mode is saved and restarts the camera', (tester) async {
    final camera = FakeCamera();
    final app = await openCameraCheck(tester, camera);
    await app.tapAndSettle(find.text('Start camera'));
    await app.tapAndSettle(find.text('Low power'));
    expect(camera.startedWith, CameraPowerMode.lowPower);
    expect(find.textContaining('Saves battery'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('denied permission keeps manual tracking available',
      (tester) async {
    final app = await openCameraCheck(tester, FakeCamera(deny: true));
    await app.tapAndSettle(find.text('Start camera'));
    expect(find.textContaining('Camera access was not allowed'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('leaving the screen stops the camera', (tester) async {
    final camera = FakeCamera();
    final app = await openCameraCheck(tester, camera);
    await app.tapAndSettle(find.text('Start camera'));
    final before = camera.stops;
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(camera.stops, greaterThan(before));
    expect(camera.state.value.running, isFalse);
    await app.dispose();
  });

  testWidgets('devices without a camera get an honest state', (tester) async {
    final app = AppHarness(tester);
    await app.start(onboarded, overrides: [
      cameraSourceProvider.overrideWithValue(FakeCamera()),
      deviceProbeProvider.overrideWithValue(
          const FixedProbe(DeviceSpecs(ramMb: 3000, cpuCores: 4))),
    ]);
    await tester.tap(find.text('Analyze'));
    await tester.pumpAndSettle();
    expect(find.text('Not supported on this device'), findsOneWidget);
    await app.dispose();
  });

  testWidgets('This device screen shows detected hardware', (tester) async {
    usePhoneScreen(tester);
    final app = AppHarness(tester);
    await app.start(onboarded, overrides: [
      deviceProbeProvider.overrideWithValue(const FixedProbe(midRange)),
    ]);
    await app.tapAndSettle(find.byTooltip('Settings'));
    await tester.scrollUntilVisible(find.text('Hardware and processing quality'), 100,
        scrollable: find.byType(Scrollable).last);
    await tester.ensureVisible(find.text('Hardware and processing quality'));
    await tester.pumpAndSettle();
    await app.tapAndSettle(find.text('Hardware and processing quality'));
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('6.0 GB'), findsOneWidget);
    expect(find.text('API 36'), findsOneWidget);
    expect(find.text('10 per second'), findsOneWidget);
    await app.dispose();
  });
}
