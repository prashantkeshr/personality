import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/entities/motion.dart';
import 'package:personality/features/exercise/figure/figure_painter.dart';

/// Renders every motion's keyframes to PNG contact sheets for review.
/// Run with: flutter test test/tool/render_motions_test.dart --dart-define=RENDER_DIR=DIR
void main() {
  const dir = String.fromEnvironment('RENDER_DIR');
  testWidgets('render motion sheets', (tester) async {
    final motions = parseMotions(
        jsonDecode(File('assets/content/motions.json').readAsStringSync()) as Map<String, dynamic>);
    final colors = FigureColors.of(ColorScheme.fromSeed(seedColor: const Color(0xFF3F6E5E)));
    const cell = 150.0;
    final ids = motions.keys.toList();
    const perSheet = 12;
    for (var sheet = 0; sheet * perSheet < ids.length; sheet++) {
      final chunk = ids.skip(sheet * perSheet).take(perSheet).toList();
      final cols = chunk.map((id) => motions[id]!.frames.length).reduce((a, b) => a > b ? a : b);
      final w = cell * (cols + 1), h = cell * chunk.length;
      final rec = ui.PictureRecorder();
      final canvas = Canvas(rec)..drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = Colors.white);
      for (final (row, id) in chunk.indexed) {
        final m = motions[id]!;
        final tp = TextPainter(
            text: TextSpan(text: id, style: const TextStyle(color: Colors.black, fontSize: 14)),
            textDirection: TextDirection.ltr)
          ..layout(maxWidth: cell - 8);
        tp.paint(canvas, Offset(6, row * cell + 6));
        final bounds = motionBounds(m);
        for (final (col, f) in m.frames.indexed) {
          canvas.save();
          canvas.translate(cell * (col + 1), row * cell);
          canvas.drawRect(const Rect.fromLTWH(0, 0, cell, cell),
              Paint()
                ..style = PaintingStyle.stroke
                ..color = Colors.black12);
          FigurePainter(
                  pose: f.pose, view: m.view, bounds: bounds, colors: colors, prop: propRect(m), held: m.held)
              .paint(canvas, const Size(cell, cell));
          canvas.restore();
        }
      }
      await tester.runAsync(() async {
        final img = await rec.endRecording().toImage(w.ceil(), h.ceil());
        final png = await img.toByteData(format: ui.ImageByteFormat.png);
        File('$dir/motions_$sheet.png').writeAsBytesSync(png!.buffer.asUint8List());
      });
    }
  }, skip: dir.isEmpty);
}
