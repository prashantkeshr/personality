import '../services/face_engine.dart';
import 'body.dart' show StyleFit;

enum StyleKind { hair, beard, glasses }

class StyleItem {
  const StyleItem({
    required this.id,
    required this.kind,
    required this.name,
    required this.desc,
    this.image,
    this.credit,
    this.fit = StyleFit.all,
  });

  final String id;
  final StyleKind kind;

  /// Who the example is styled for; [StyleFit.all] suits everyone.
  final StyleFit fit;

  bool suits(StyleFit wanted) =>
      wanted == StyleFit.all || fit == StyleFit.all || fit == wanted;
  final Map<String, String> name;
  final Map<String, String> desc;

  /// Bundled photo (asset path), when one is available.
  final String? image;

  /// Photo credit, e.g. "Photo: Name / Unsplash".
  final String? credit;
}

class ShapeGuide {
  const ShapeGuide({required this.why, required this.items});

  /// Why these styles suit the shape (shown as "Why this?").
  final Map<String, String> why;
  final Map<StyleKind, List<String>> items;
}

class GroomingStep {
  const GroomingStep({
    required this.id,
    required this.minuteOfDay,
    required this.name,
  });

  final String id;
  final int minuteOfDay;
  final Map<String, String> name;
}

/// Data-driven style content (assets/content/grooming.json, spec §21, §71).
class GroomingContent {
  const GroomingContent({
    required this.items,
    required this.shapes,
    required this.routine,
  });

  final Map<String, StyleItem> items;
  final Map<FaceShape, ShapeGuide> shapes;
  final List<GroomingStep> routine;

  static String pick(Map<String, String> m, String lang) =>
      m[lang] ?? m['en'] ?? m.values.first;

  List<StyleItem> suggestions(FaceShape shape, StyleKind kind,
          {StyleFit fit = StyleFit.all}) =>
      [
        for (final id in shapes[shape]?.items[kind] ?? const <String>[])
          if (items[id] case final item? when item.suits(fit)) item,
      ];

  factory GroomingContent.fromJson(Map<String, dynamic> j) {
    Map<String, String> text(Object? v) =>
        (v as Map<String, dynamic>).map((k, v) => MapEntry(k, v as String));
    return GroomingContent(
      items: {
        for (final e in (j['items'] as List).cast<Map<String, dynamic>>())
          e['id'] as String: StyleItem(
            id: e['id'] as String,
            kind: StyleKind.values.byName(e['kind'] as String),
            name: text(e['name']),
            desc: text(e['desc']),
            image: e['image'] as String?,
            credit: e['credit'] as String?,
            fit: StyleFit.values.asNameMap()[e['fit']] ?? StyleFit.all,
          ),
      },
      shapes: {
        for (final e in (j['shapes'] as Map<String, dynamic>).entries)
          FaceShape.values.byName(e.key): ShapeGuide(
            why: text((e.value as Map<String, dynamic>)['why']),
            items: {
              for (final k in StyleKind.values)
                k: ((e.value as Map<String, dynamic>)[k.name] as List? ??
                        const [])
                    .cast<String>(),
            },
          ),
      },
      routine: [
        for (final e in (j['routine'] as List).cast<Map<String, dynamic>>())
          GroomingStep(
            id: e['id'] as String,
            minuteOfDay: e['minute'] as int,
            name: text(e['name']),
          ),
      ],
    );
  }
}
