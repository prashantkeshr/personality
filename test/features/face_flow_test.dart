import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/core/database/app_database.dart';
import 'package:personality/core/device/device_tier.dart';
import 'package:personality/core/features/feature_registry.dart';
import 'package:personality/core/providers.dart';
import 'package:personality/data/repositories/face_repository.dart';
import 'package:personality/data/repositories/routine_repository.dart';
import 'package:personality/domain/entities/grooming.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/domain/services/face_engine.dart';
import 'package:personality/features/camera/camera_providers.dart';
import 'package:personality/features/face/face_providers.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/ml/face/face_estimator.dart';
import 'package:personality/ml/model_manager/bundled_models.dart';

import '../domain/face_engine_test.dart' show face;
import '../helpers/app_harness.dart';
import '../helpers/fakes.dart';

const midRange =
    DeviceSpecs(ramMb: 6144, cpuCores: 8, osApiLevel: 33, hasCamera: true);

void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 3200);
  tester.view.devicePixelRatio = 2.5;
  addTearDown(tester.view.reset);
}

Future<void> waitFor(AppHarness app, Finder f) async {
  for (var i = 0; i < 60 && f.evaluate().isEmpty; i++) {
    await app.run(() => Future<void>.delayed(const Duration(milliseconds: 30)));
    await app.tester.pump(const Duration(milliseconds: 100));
  }
  expect(f, findsWidgets);
}

void main() {
  const onboarded = AppSettings(onboardingCompleted: true);

  test('grooming content covers every shape and kind, in both languages', () {
    final c = GroomingContent.fromJson(
        jsonDecode(File('assets/content/grooming.json').readAsStringSync())
            as Map<String, dynamic>);
    for (final s in FaceShape.values) {
      expect(c.shapes[s], isNotNull, reason: '$s');
      expect(c.shapes[s]!.why.keys, containsAll(['en', 'hi']));
      for (final k in StyleKind.values) {
        expect(c.suggestions(s, k), isNotEmpty, reason: '$s $k');
      }
    }
    for (final i in c.items.values) {
      expect(i.name.keys, containsAll(['en', 'hi']), reason: i.id);
    }
  });

  test('repository stores proportions with provenance; favourites', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final repo = FaceRepository(db);
    final c = FaceCapture();
    for (var i = 0; i < 12; i++) {
      c.add(FaceEngine.assess(face(1.30, 0.88, 0.78)));
    }
    final id = await repo.save(c.result()!);
    final saved = (await repo.watchAll().first).single;
    expect(saved.id, id);
    expect(saved.result.shape, FaceShape.oval);
    expect(saved.result.source, DataSource.cameraDerived);
    expect(saved.result.ratios[FaceRatio.lengthToWidth], closeTo(1.30, 0.02));
    await repo.setFavorite('side_part', true);
    expect(await repo.watchFavorites().first, {'side_part'});
    await repo.setFavorite('side_part', false);
    await repo.delete(id);
    expect(await repo.watchAll().first, isEmpty);
    expect(await db.select(db.faceMetrics).get(), isEmpty);
    await db.close();
  });

  testWidgets('face check: guidance, estimate, suggestions, save, routine',
      (tester) async {
    usePhoneScreen(tester);
    final camera = FakeCamera();
    final faceEst = ScriptedFaceEstimator([const NoFaceDetected()]);
    final app = AppHarness(tester);
    await app.start(onboarded, overrides: [
      cameraSourceProvider.overrideWithValue(camera),
      faceEstimatorProvider.overrideWithValue(faceEst),
      deviceProbeProvider.overrideWithValue(const FixedProbe(midRange)),
      installedModelsProvider
          .overrideWithValue(const {ModelIds.pose, ModelIds.face}),
    ]);
    await tester.tap(find.text('Analyze'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Face analysis'));
    await waitFor(app, find.text('Start camera'));
    expect(find.textContaining('No photo is taken or stored'), findsOneWidget);
    expect(find.textContaining('says nothing about attractiveness'),
        findsOneWidget);

    await tester.tap(find.text('Start camera'));
    await tester.pump();
    var ms = 0;
    Future<void> frames(int n) async {
      for (var i = 0; i < n; i++) {
        await app.run(() => camera.emit(
            100, 160, DateTime(2026).add(Duration(milliseconds: ms += 200))));
        await tester.pump();
      }
    }

    await frames(1);
    expect(find.text('No face detected. Look at the camera.'), findsOneWidget);
    faceEst.script = [face(1.30, 0.88, 0.78, yaw: 20)];
    await frames(1);
    expect(find.textContaining('Look straight at the camera'), findsOneWidget);
    faceEst.script = [face(1.30, 0.88, 0.78)];
    await frames(1);
    expect(find.textContaining('Face detected'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Analyze'));
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(seconds: 1)); // countdown
    }
    await frames(12);
    await waitFor(app, find.text('Estimated face shape'));
    expect(find.text('Oval'), findsOneWidget);
    expect(find.textContaining('Camera estimate'), findsOneWidget);
    expect(camera.state.value.running, isFalse);

    await tester.scrollUntilVisible(find.text('Hairstyles'), 200,
        scrollable: find.byType(Scrollable).last);
    expect(find.text('Classic side part'), findsOneWidget);
    await tester.tap(find.byTooltip('Add to favourites').first);
    await app.settle();
    await tester.scrollUntilVisible(find.text('Add to my routines'), 200,
        scrollable: find.byType(Scrollable).last);
    await tester.ensureVisible(find.text('Add to my routines'));
    await tester.pump();
    await tester.tap(find.text('Add to my routines'));
    await app.settle();
    final routines =
        await app.run(() => RoutineRepository(app.db).watchRoutines().first);
    expect(routines!.single.name, 'Grooming');

    await tester.scrollUntilVisible(find.text('Save'), -200,
        scrollable: find.byType(Scrollable).last);
    await tester.ensureVisible(find.text('Save'));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await app.settle();
    final saved = await app.run(() => FaceRepository(app.db).watchAll().first);
    expect(saved!.single.result.shape, FaceShape.oval);
    final favs =
        await app.run(() => FaceRepository(app.db).watchFavorites().first);
    expect(favs, isNotEmpty);
    await app.dispose();
  });
}
