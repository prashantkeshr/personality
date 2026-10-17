import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/services/glasses_fit.dart';
import 'package:personality/domain/services/outfit_engine.dart';
import 'package:personality/shared/visual/outfit_silhouette.dart';
import 'package:personality/shared/visual/style_art.dart';

/// Renders the glasses catalogue and sample outfits for review.
/// Run with: flutter test test/tool/render_style_test.dart --dart-define=RENDER_DIR=DIR
void main() {
  const dir = String.fromEnvironment('RENDER_DIR');
  testWidgets('render style sheets', (tester) async {
    Future<void> save(ui.PictureRecorder rec, int w, int h, String name) => tester.runAsync(() async {
          final img = await rec.endRecording().toImage(w, h);
          final png = await img.toByteData(format: ui.ImageByteFormat.png);
          File('$dir/$name.png').writeAsBytesSync(png!.buffer.asUint8List());
        }).then((_) {});

    final frames = [
      for (final f in jsonDecode(File('assets/content/glasses.json').readAsStringSync()) as List)
        GlassesFrame.fromJson(f as Map<String, dynamic>),
    ];
    var rec = ui.PictureRecorder();
    var c = Canvas(rec)..drawRect(const Rect.fromLTWH(0, 0, 800, 1000), Paint()..color = Colors.white);
    for (final (i, f) in frames.indexed) {
      final r = Rect.fromLTWH(20.0 + (i % 4) * 195, 20.0 + (i ~/ 4) * 195, 175, 175);
      c.drawRect(r, Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black12);
      paintGlasses(c, Rect.fromCenter(center: r.center, width: 150, height: 60),
          GlassesStyle.values.byName(f.shape), hexColor(f.colorHex),
          weight: f.thick ? 1.6 : 1);
    }
    await save(rec, 800, 1000, 'glasses');

    WardrobeItem w(String id, GarmentCategory c, String hex, [GarmentPattern p = GarmentPattern.solid]) =>
        WardrobeItem(id: id, name: id, category: c, colorHex: hex, pattern: p);
    final outfits = [
      [w('shirt', GarmentCategory.top, '#FFFFFF'), w('chinos', GarmentCategory.bottom, '#C8B48A'),
        w('loafers', GarmentCategory.footwear, '#5B3A24')],
      [w('tee', GarmentCategory.top, '#2E6B5E', GarmentPattern.stripes), w('jeans', GarmentCategory.bottom, '#2C3E66'),
        w('jacket', GarmentCategory.outerwear, '#222222'), w('sneakers', GarmentCategory.footwear, '#EEEEEE')],
      [w('kurta', GarmentCategory.ethnicTop, '#E8B04A', GarmentPattern.print),
        w('churidar', GarmentCategory.ethnicBottom, '#F5F0E6'), w('mojari', GarmentCategory.footwear, '#7A4A2A')],
      [w('dress', GarmentCategory.onePiece, '#8E2A4F'), w('heels', GarmentCategory.footwear, '#111111'),
        w('watch', GarmentCategory.accessory, '#B8913A')],
      [w('blazer', GarmentCategory.outerwear, '#1F2A44'), w('shirt2', GarmentCategory.top, '#DCE6F2', GarmentPattern.checks),
        w('trousers', GarmentCategory.bottom, '#333333'), w('oxfords', GarmentCategory.footwear, '#3A2418')],
    ];
    rec = ui.PictureRecorder();
    c = Canvas(rec)..drawRect(const Rect.fromLTWH(0, 0, 1000, 440), Paint()..color = Colors.white);
    for (final (i, o) in outfits.indexed) {
      c.save();
      c.translate(20.0 + i * 195, 20);
      OutfitSilhouettePainter(items: o, womenswear: i == 3, body: const Color(0xFFE3E3E3), outline: const Color(0xFFBDBDBD))
          .paint(c, const Size(175, 400));
      c.restore();
    }
    await save(rec, 1000, 440, 'outfits');
  }, skip: dir.isEmpty);
}
