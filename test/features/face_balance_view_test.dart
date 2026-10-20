import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:personality/data/repositories/face_repository.dart';
import 'package:personality/domain/entities/provenance.dart';
import 'package:personality/domain/services/face_engine.dart';
import 'package:personality/features/settings/app_settings.dart';
import 'package:personality/shared/visual/hair_art.dart';

import '../helpers/app_harness.dart';

void main() {
  testWidgets('a saved face shows balance, proportions and drawn hairstyles', (
    tester,
  ) async {
    final app = AppHarness(tester);
    await app.run(() => FaceRepository(app.db).save(const FaceShapeResult(
          shape: FaceShape.oval,
          ratios: {
            FaceRatio.lengthToWidth: 1.3,
            FaceRatio.foreheadToCheek: 0.88,
            FaceRatio.jawToCheek: 0.78,
          },
          confidence: Confidence.high,
          framesUsed: 12,
          balance: {
            FaceBalance.eyes: 0.97,
            FaceBalance.cheeks: 0.95,
            FaceBalance.jaw: 0.93,
            FaceBalance.mouth: 0.96,
          },
          proportions: {
            FaceProportion.eyeSpacing: 0.46,
            FaceProportion.mouthToEyes: 0.8,
          },
        )));
    await app.start(const AppSettings(onboardingCompleted: true));
    GoRouter.of(tester.element(find.byType(Scaffold).first))
        .push('/analyze/face/history');
    await app.settle();
    await app.settle();

    await app.tapAndSettle(find.byType(ExpansionTile).first);
    await app.reveal(find.text('97% even'));
    expect(find.byKey(const Key('face-balance')), findsOneWidget);
    expect(find.text('93% even'), findsOneWidget);
    expect(find.textContaining('average'), findsOneWidget); // eye spacing 0.46

    // New hairstyles without photos are drawn.
    await app.reveal(find.text('Hairstyles'));
    final row = find.byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.right,
    );
    await tester.scrollUntilVisible(find.byType(HairArt), 300,
        scrollable: row.first);
    expect(find.byType(HairArt), findsWidgets);

    // Optional screenshot for a visual check (set FACE_OUT to a .png path).
    final out = Platform.environment['FACE_OUT'];
    if (out != null) {
      await tester.pumpAndSettle();
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byType(RepaintBoundary).first,
      );
      await tester.runAsync(() async {
        final image = await boundary.toImage();
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        File(out).writeAsBytesSync(bytes!.buffer.asUint8List());
      });
    }
    await app.dispose();
  });
}
