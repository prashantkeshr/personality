import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personality/domain/services/face_engine.dart';
import 'package:personality/shared/visual/scan_overlay.dart';
import 'package:personality/shared/visual/style_art.dart';
import 'package:personality/shared/visual/style_carousel.dart';

Widget host(Widget child, {bool reduce = false}) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduce),
        child: Scaffold(body: Center(child: SizedBox(width: 300, height: 400, child: child))),
      ),
    );

void main() {
  testWidgets('scan line animates, and stops with reduce motion',
      (tester) async {
    await tester.pumpWidget(host(const ScanOverlay(color: Colors.teal)));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pumpWidget(
        host(const ScanOverlay(color: Colors.teal), reduce: true));
    await tester.pump();
    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('style art paints for every glasses style and face shape',
      (tester) async {
    for (final s in GlassesStyle.values) {
      await tester.pumpWidget(host(GlassesArt(style: s)));
      expect(tester.takeException(), isNull, reason: '$s');
    }
    for (final s in FaceShape.values) {
      await tester.pumpWidget(host(FaceShapeArt(shape: s, ratios: const {
        FaceRatio.lengthToWidth: 1.27,
        FaceRatio.foreheadToCheek: 0.83,
        FaceRatio.jawToCheek: 0.78,
      })));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$s');
    }
  });

  testWidgets('cards flip on tap and favourite toggles', (tester) async {
    var fav = false;
    await tester.pumpWidget(host(StatefulBuilder(
      builder: (context, setState) => StyleCarousel(
        flipHint: 'Tap to see details',
        tryOnLabel: 'Try on',
        favoriteLabel: 'Favourite',
        cards: [
          StyleCardData(
            id: 'a',
            title: 'Round frames',
            subtitle: 'Soft curves',
            art: const GlassesArt(style: GlassesStyle.round),
            details: 'Why this: balance.',
            favorite: fav,
            onFavorite: () => setState(() => fav = !fav),
            onTryOn: () {},
          ),
        ],
      ),
    )));
    expect(find.text('Why this: balance.'), findsNothing);
    await tester.tap(find.text('Round frames'));
    await tester.pumpAndSettle();
    expect(find.text('Why this: balance.'), findsOneWidget);
    expect(find.text('Try on'), findsOneWidget);
    await tester.tap(find.byTooltip('Favourite'));
    await tester.pumpAndSettle();
    expect(fav, isTrue);
  });
}
