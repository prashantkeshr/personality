import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:personality/core/database/app_database.dart';
import 'package:personality/core/device/device_tier.dart';
import 'package:personality/core/providers.dart';
import 'package:personality/data/repositories/snapshot_repository.dart';
import 'package:personality/features/camera/camera_providers.dart';
import 'package:personality/features/settings/app_settings.dart';

import '../helpers/app_harness.dart';
import '../helpers/fakes.dart';

/// A real, EXIF-free JPEG of the given size.
Uint8List jpeg(int w, int h) =>
    Uint8List.fromList(img.encodeJpg(img.Image(width: w, height: h)
      ..clear(img.ColorRgb8(120, 140, 160))));

void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 3200);
  tester.view.devicePixelRatio = 2.5;
  addTearDown(tester.view.reset);
}

Future<void> waitFor(AppHarness app, Finder f) async {
  for (var i = 0; i < 80 && f.evaluate().isEmpty; i++) {
    await app.run(() => Future<void>.delayed(const Duration(milliseconds: 30)));
    await app.tester.pump(const Duration(milliseconds: 100));
  }
  expect(f, findsWidgets);
}

void main() {
  test('photos are downscaled, re-encoded and stored in the database', () async {
    final prepared = preparePhoto(jpeg(3000, 4000))!;
    expect((prepared.width, prepared.height), (810, 1080));
    expect(img.decodeJpg(prepared.jpeg), isNotNull);
    expect(preparePhoto(Uint8List.fromList([1, 2, 3])), isNull);

    final db = AppDatabase(NativeDatabase.memory());
    final repo = SnapshotRepository(db);
    final id = await repo.add(SnapshotKind.bodyFront, jpeg(600, 800));
    final list = await repo.watch(SnapshotKind.bodyFront).first;
    expect(list.single.id, id);
    expect(await repo.watch(SnapshotKind.face).first, isEmpty);
    await repo.deleteAll();
    expect(await repo.watch(SnapshotKind.bodyFront).first, isEmpty);
    await db.close();
  });

  testWidgets('consent, capture with timer, save privately', (tester) async {
    usePhoneScreen(tester);
    final camera = FakeCamera()..photo = jpeg(480, 640);
    final app = AppHarness(tester);
    await app.start(const AppSettings(onboardingCompleted: true), overrides: [
      cameraSourceProvider.overrideWithValue(camera),
      deviceProbeProvider.overrideWithValue(const FixedProbe(
          DeviceSpecs(ramMb: 6144, cpuCores: 8, hasCamera: true))),
    ]);
    await tester.tap(find.text('Analyze'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Progress snapshots'));
    await waitFor(app, find.textContaining('turn on snapshots'));
    expect(find.textContaining('never leave this phone'), findsOneWidget);

    await tester.tap(find.textContaining('turn on snapshots'));
    await waitFor(app, find.text('Take snapshot'));
    expect(find.textContaining('Take your first snapshot'), findsOneWidget);

    await tester.tap(find.text('Take snapshot'));
    await waitFor(app, find.text('Capture (3-second timer)'));
    await tester.ensureVisible(find.text('Capture (3-second timer)'));
    await tester.pump();
    await tester.tap(find.text('Capture (3-second timer)'));
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    await waitFor(app, find.text('Save privately'));
    await tester.ensureVisible(find.text('Save privately'));
    await tester.pump();
    await tester.tap(find.text('Save privately'));
    // Decoding and encoding run in a background isolate (real time).
    await waitFor(app, find.text('Take snapshot'));
    final saved = await app.run(
        () => SnapshotRepository(app.db).watch(SnapshotKind.face).first);
    expect(saved, hasLength(1));
    await app.dispose();
  });
}
