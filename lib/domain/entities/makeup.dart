import '../services/face_engine.dart';
import '../services/palette_engine.dart';

/// A named makeup colour (hex RRGGBB).
class MakeupShade {
  const MakeupShade({required this.id, required this.name, required this.hex});
  final String id;
  final Map<String, String> name;
  final String hex;

  int get argb => 0xFF000000 | int.parse(hex, radix: 16);
}

enum MakeupArea { lips, blush, eyes }

/// Where to place blush, contour and highlight for one face shape.
class MakeupPlacement {
  const MakeupPlacement({
    required this.blush,
    required this.contour,
    required this.highlight,
  });
  final Map<String, String> blush;
  final Map<String, String> contour;
  final Map<String, String> highlight;
}

/// Makeup guidance by face shape and undertone
/// (assets/content/makeup.json). Suggestions only; everything is optional.
class MakeupContent {
  const MakeupContent({
    required this.shapes,
    required this.palettes,
    required this.depth,
    required this.basics,
  });

  final Map<FaceShape, MakeupPlacement> shapes;
  final Map<Undertone, Map<MakeupArea, List<MakeupShade>>> palettes;
  final Map<SkinDepth, Map<String, String>> depth;
  final List<Map<String, String>> basics;

  static String pick(Map<String, String> m, String lang) =>
      m[lang] ?? m['en'] ?? (m.isEmpty ? '' : m.values.first);

  /// Shades for [area]: the user's undertone when known, else every shade.
  List<MakeupShade> shades(MakeupArea area, Undertone? undertone) {
    if (undertone != null) return palettes[undertone]?[area] ?? const [];
    return [
      for (final p in palettes.values) ...(p[area] ?? const <MakeupShade>[]),
    ];
  }

  factory MakeupContent.fromJson(Map<String, dynamic> j) {
    Map<String, String> text(Object? v) =>
        (v as Map<String, dynamic>).map((k, v) => MapEntry(k, v as String));
    return MakeupContent(
      shapes: {
        for (final e in (j['shapes'] as Map<String, dynamic>).entries)
          FaceShape.values.byName(e.key): MakeupPlacement(
            blush: text((e.value as Map)['blush']),
            contour: text((e.value as Map)['contour']),
            highlight: text((e.value as Map)['highlight']),
          ),
      },
      palettes: {
        for (final e in (j['palettes'] as Map<String, dynamic>).entries)
          Undertone.values.byName(e.key): {
            for (final a in MakeupArea.values)
              a: [
                for (final s
                    in ((e.value as Map)[a.name] as List? ?? const [])
                        .cast<Map<String, dynamic>>())
                  MakeupShade(
                    id: s['id'] as String,
                    name: text(s['name']),
                    hex: s['hex'] as String,
                  ),
              ],
          },
      },
      depth: {
        for (final e in (j['depth'] as Map<String, dynamic>).entries)
          SkinDepth.values.byName(e.key): text(e.value),
      },
      basics: [for (final b in j['basics'] as List) text(b)],
    );
  }
}
