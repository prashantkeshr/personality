import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/grooming.dart';
import 'package:personality/domain/entities/makeup.dart';
import 'package:personality/domain/services/face_engine.dart';
import 'package:personality/domain/services/palette_engine.dart';
import 'package:personality/ml/face/face_estimator.dart';
import 'package:personality/shared/visual/hair_art.dart';

/// An oval face 300 wide and 400 tall centred at (500, 500), with eyes,
/// nose and lips. [shift] moves the nose and mouth sideways.
FaceDetected face({double shift = 0, double yaw = 0}) {
  final outline = [
    for (var i = 0; i < 36; i++)
      () {
        final a = -math.pi / 2 + i * 2 * math.pi / 36;
        return (500 + 150 * math.cos(a), 500 + 200 * math.sin(a));
      }(),
  ];
  return FaceDetected(
    outline: outline,
    yaw: yaw,
    roll: 0,
    pitch: 0,
    boxHeight: 0.4,
    imageWidth: 1000,
    imageHeight: 1000,
    leftEye: (440, 440),
    rightEye: (560, 440),
    noseBottom: (500 + shift, 540),
    upperLip: [(455 + shift, 590), (500 + shift, 585), (545 + shift, 590)],
    lowerLip: [(455 + shift, 592), (500 + shift, 610), (545 + shift, 592)],
  );
}

void main() {
  test('a symmetric face measures fully even', () {
    final a = FaceEngine.assess(face());
    expect(a.usable, isTrue);
    for (final b in FaceBalance.values) {
      expect(a.balance[b], closeTo(1.0, 0.01), reason: b.name);
    }
    expect(a.proportions[FaceProportion.eyeSpacing], closeTo(120 / 300, 0.02));
    expect(a.proportions[FaceProportion.mouthToEyes], closeTo(90 / 120, 0.02));
  });

  test('an off-centre nose and mouth lower the balance', () {
    final a = FaceEngine.assess(face(shift: 20));
    expect(a.balance[FaceBalance.jaw]!, lessThan(0.97));
    expect(a.balance[FaceBalance.eyes]!, lessThan(0.97));
  });

  test('a turned head gives no balance reading', () {
    final a = FaceEngine.assess(face(yaw: 8));
    expect(a.usable, isTrue); // the shape is still measured
    expect(a.balance, isEmpty);
  });

  test('capture keeps the median balance from straight-on frames', () {
    final c = FaceCapture();
    for (var i = 0; i < 8; i++) {
      c.add(FaceEngine.assess(face(shift: i.isEven ? 4 : 6)));
    }
    final r = c.result()!;
    expect(r.balance.keys, containsAll(FaceBalance.values));
    expect(r.balance[FaceBalance.eyes]!, inInclusiveRange(0.9, 1.0));
  });

  test('31+ hairstyles, each with a try-on shape and suggested somewhere', () {
    final g = GroomingContent.fromJson(
      jsonDecode(File('assets/content/grooming.json').readAsStringSync())
          as Map<String, dynamic>,
    );
    final hair = g.items.values.where((i) => i.kind == StyleKind.hair).toList();
    expect(hair.length, greaterThanOrEqualTo(30));
    for (final h in hair) {
      expect(HairShape.fromName(h.hair), isNotNull, reason: h.id);
    }
    final suggested = {
      for (final s in g.shapes.values) ...?s.items[StyleKind.hair],
    };
    expect(suggested, containsAll(hair.map((h) => h.id)));
    for (final s in g.shapes.values) {
      for (final ids in s.items.values) {
        for (final id in ids) {
          expect(g.items, contains(id));
        }
      }
    }
  });

  test('makeup content covers every shape and undertone', () {
    final m = MakeupContent.fromJson(
      jsonDecode(File('assets/content/makeup.json').readAsStringSync())
          as Map<String, dynamic>,
    );
    expect(m.shapes.keys, containsAll(FaceShape.values));
    for (final u in Undertone.values) {
      for (final a in MakeupArea.values) {
        expect(m.shades(a, u), isNotEmpty, reason: '$u $a');
      }
    }
    // Without a known undertone, every shade is offered.
    expect(
      m.shades(MakeupArea.lips, null).length,
      Undertone.values.fold<int>(0, (n, u) => n + m.shades(MakeupArea.lips, u).length),
    );
    expect(m.basics, isNotEmpty);
  });
}
