import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;

import '../../core/providers.dart';
import '../../data/repositories/style_repository.dart';
import '../../domain/services/color_science.dart';
import '../../domain/services/outfit_engine.dart';
import '../health/health_providers.dart';

final styleRepositoryProvider = Provider((ref) => StyleRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider)));

final styleProfileProvider = StreamProvider<StyleProfile>(
    (ref) => ref.watch(styleRepositoryProvider).watchProfile());

final wardrobeProvider = StreamProvider<List<WardrobeItem>>(
    (ref) => ref.watch(styleRepositoryProvider).watchWardrobe());

final wardrobePhotosProvider = StreamProvider<Map<String, Uint8List>>(
    (ref) => ref.watch(styleRepositoryProvider).watchPhotos());

final savedOutfitsProvider = StreamProvider<List<SavedOutfit>>(
    (ref) => ref.watch(styleRepositoryProvider).watchOutfits());

class NamedColor {
  const NamedColor(this.hex, this.name);
  final String hex;
  final Map<String, String> name;

  String label(String lang) => name[lang] ?? name['en']!;
}

/// Common garment colours with names (assets/content/colors.json).
final garmentColorsProvider = FutureProvider<List<NamedColor>>((ref) async {
  final raw =
      await rootBundle.loadString('assets/content/colors.json', cache: false);
  return [
    for (final e in (jsonDecode(raw) as List).cast<Map<String, dynamic>>())
      NamedColor(
        e['hex'] as String,
        (e['name'] as Map<String, dynamic>).map((k, v) => MapEntry(k, v as String)),
      ),
  ];
});

/// Closest named colour to [hex], for labels and accessibility.
NamedColor? nearestNamed(List<NamedColor> colors, String hex) {
  if (colors.isEmpty) return null;
  final c = Rgb.hex(hex);
  return colors.reduce(
      (a, b) => deltaE(Rgb.hex(a.hex), c) <= deltaE(Rgb.hex(b.hex), c) ? a : b);
}

/// Average colour of the central region of a photo (the garment), off the
/// UI thread. Null if the photo can't be decoded.
String? sampleGarmentColor(Uint8List jpeg) {
  img.Image? im;
  try {
    im = img.decodeImage(jpeg);
  } catch (_) {
    return null;
  }
  if (im == null) return null;
  im = img.bakeOrientation(im);
  final x0 = (im.width * 0.35).round(), x1 = (im.width * 0.65).round();
  final y0 = (im.height * 0.35).round(), y1 = (im.height * 0.65).round();
  var r = 0.0, g = 0.0, b = 0.0, n = 0;
  final step = ((x1 - x0) ~/ 40).clamp(1, 64);
  for (var y = y0; y < y1; y += step) {
    for (var x = x0; x < x1; x += step) {
      final p = im.getPixel(x, y);
      r += p.r;
      g += p.g;
      b += p.b;
      n++;
    }
  }
  if (n == 0) return null;
  return Rgb((r / n).round(), (g / n).round(), (b / n).round()).hex;
}
