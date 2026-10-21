import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/router.dart';
import '../../domain/entities/discipline.dart';
import '../../domain/entities/exercise_library.dart';
import '../../domain/entities/grooming.dart';
import '../../domain/entities/makeup.dart';
import '../../domain/services/meal_planner.dart';
import '../content/content_providers.dart';
import '../face/face_providers.dart';
import '../growth/growth_providers.dart';
import '../plans/plan_providers.dart';
import '../style/style_extras.dart';

/// The picture shown with a suggestion: the app's own photos and drawings.
sealed class CoachVisual {
  const CoachVisual();
}

class PhotoVisual extends CoachVisual {
  const PhotoVisual(this.asset);
  final String asset;
}

class FigureVisual extends CoachVisual {
  const FigureVisual(this.motionId);
  final String motionId;
}

class HairVisual extends CoachVisual {
  const HairVisual(this.shape);
  final String shape;
}

class GlassesVisual extends CoachVisual {
  const GlassesVisual(this.itemId);
  final String itemId;
}

class ColourVisual extends CoachVisual {
  const ColourVisual(this.hex);
  final String hex;
}

/// An app section (its photo or icon comes from the feature registry).
class SectionVisual extends CoachVisual {
  const SectionVisual(this.feature);
  final String? feature;
}

enum KnowledgeKind {
  exercise,
  program,
  skill,
  answer,
  makeup,
  trend,
  hairstyle,
  beard,
  glasses,
  meal,
  section,
}

/// One searchable piece of the app's built-in knowledge.
class KnowledgeItem {
  const KnowledgeItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.text,
    required this.route,
    required this.visual,
    this.keywords = '',
    this.weight = 1,
  });

  final String id;
  final KnowledgeKind kind;

  /// In the user's language where the content has it.
  final String title;

  /// What the coach may quote, kept short.
  final String text;
  final String route;
  final CoachVisual visual;

  /// Extra search words (English and Hindi synonyms).
  final String keywords;

  /// Ranking multiplier: the app's own curated guides outrank the large
  /// downloaded exercise library.
  final double weight;
}

const _stop = {
  'a', 'an', 'and', 'are', 'as', 'at', 'be', 'by', 'can', 'do', 'does', 'for',
  'from', 'get', 'have', 'how', 'i', 'if', 'in', 'is', 'it', 'its', 'me', 'my',
  'of', 'on', 'or', 'should', 'so', 'some', 'that', 'the', 'this', 'to', 'up',
  'what', 'when', 'which', 'who', 'why', 'will', 'with', 'you', 'your', 'want',
  'need', 'best', 'good', 'help', 'tell', 'about', 'any', 'more', 'much',
  'please', 'give', 'suggest', 'recommend', 'way', 'ways', 'tips', 'tip',
  'क्या', 'कैसे', 'है', 'हैं', 'मैं', 'मेरे', 'मेरा', 'के', 'की', 'का', 'को', 'में',
  'और', 'से', 'लिए', 'करें', 'कौन',
};

final _word = RegExp(r'[\p{L}\p{N}]+', unicode: true);

/// Lower-case words without common filler, with a light English stem.
List<String> coachTokens(String s) => [
  for (final m in _word.allMatches(s.toLowerCase()))
    if (!_stop.contains(m.group(0)) && m.group(0)!.length > 1) _stem(m.group(0)!),
];

String _stem(String w) {
  if (w.length > 5 && w.endsWith('ing')) return w.substring(0, w.length - 3);
  if (w.length > 4 && w.endsWith('es')) return w.substring(0, w.length - 2);
  if (w.length > 3 && w.endsWith('s') && !w.endsWith('ss')) {
    return w.substring(0, w.length - 1);
  }
  return w;
}

/// BM25 search over the knowledge items; titles and keywords count more.
class KnowledgeIndex {
  KnowledgeIndex(this.items) {
    for (var i = 0; i < items.length; i++) {
      final it = items[i];
      final tokens = [
        for (var r = 0; r < 3; r++) ...coachTokens(it.title),
        for (var r = 0; r < 2; r++) ...coachTokens(it.keywords),
        ...coachTokens(it.text),
      ];
      _lengths.add(tokens.length);
      final tf = <String, int>{};
      for (final t in tokens) {
        tf[t] = (tf[t] ?? 0) + 1;
      }
      tf.forEach((t, n) => (_postings[t] ??= []).add((i, n)));
    }
    _avg = _lengths.isEmpty
        ? 1
        : _lengths.fold<int>(0, (a, b) => a + b) / _lengths.length;
  }

  final List<KnowledgeItem> items;
  final _postings = <String, List<(int, int)>>{};
  final _lengths = <int>[];
  late final double _avg;

  /// The best [k] matches, at most [perKind] of one kind so answers mix
  /// exercises, tips and app sections.
  List<KnowledgeItem> search(String query, {int k = 6, int perKind = 3}) {
    final terms = coachTokens(query).toSet();
    final scores = <int, double>{};
    final n = items.length;
    for (final t in terms) {
      // Prefix matches catch plurals and compounds ("stretch" ~ "stretches").
      final lists = t.length >= 4
          ? [
              for (final e in _postings.entries)
                if (e.key == t || (e.key.startsWith(t) && e.key.length - t.length <= 3))
                  e.value,
            ]
          : [?_postings[t]];
      for (final list in lists) {
        final idf = math.log(1 + (n - list.length + 0.5) / (list.length + 0.5));
        for (final (i, f) in list) {
          final len = _lengths[i];
          final s = idf * (f * 2.2) / (f + 1.2 * (0.25 + 0.75 * len / _avg));
          scores[i] = (scores[i] ?? 0) + s * items[i].weight;
        }
      }
    }
    final ranked = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final out = <KnowledgeItem>[];
    final perKindCount = <KnowledgeKind, int>{};
    for (final e in ranked) {
      final it = items[e.key];
      final c = perKindCount[it.kind] ?? 0;
      if (c >= perKind) continue;
      perKindCount[it.kind] = c + 1;
      out.add(it);
      if (out.length >= k) break;
    }
    return out;
  }
}

String _pick(Map<String, String> m, String lang) =>
    m[lang] ?? m['en'] ?? (m.isEmpty ? '' : m.values.first);

String _short(String s, [int max = 260]) =>
    s.length <= max ? s : '${s.substring(0, max).trimRight()}…';

Future<List<Map<String, dynamic>>> _sections() async => (jsonDecode(
  await rootBundle.loadString('assets/content/app_sections.json', cache: false),
) as List)
    .cast<Map<String, dynamic>>();

/// Everything the coach can search, in the user's language.
final coachKnowledgeProvider = FutureProvider.family<KnowledgeIndex, String>((
  ref,
  lang,
) async {
  final exercises = await ref.watch(exerciseCatalogProvider.future);
  final programs = await ref.watch(programCatalogProvider.future);
  final skills = await ref.watch(disciplinesProvider.future);
  final qa = await ref.watch(styleQaProvider.future);
  final makeup = await ref.watch(makeupContentProvider.future);
  final trends = await ref.watch(trendsProvider.future);
  final grooming = await ref.watch(groomingContentProvider.future);
  final meals = await ref.watch(mealLibraryProvider.future);
  final sections = await _sections();
  return KnowledgeIndex([
    // Built-in and pack exercises (packs can add thousands; text only).
    for (final LibraryExercise e in exercises)
      KnowledgeItem(
        id: 'ex:${e.id}',
        kind: KnowledgeKind.exercise,
        title: LibraryExercise.pick(e.name, lang),
        text: _short([
          LibraryExercise.pick(e.summary, lang),
          if (e.dose.isNotEmpty) LibraryExercise.pick(e.dose, lang),
          ...(e.steps[lang] ?? e.steps['en'] ?? const []).take(3),
          if (e.safety.isNotEmpty) LibraryExercise.pick(e.safety, lang),
        ].where((s) => s.isNotEmpty).join(' ')),
        keywords: [
          e.category.name,
          ?e.discipline,
          ...e.muscles,
          ?e.bodyPart,
          if (lang != 'en') LibraryExercise.pick(e.name, 'en'),
        ].join(' '),
        route: '${AppRoutes.exerciseLibrary}/${e.id}',
        weight: e.pack == null ? 1.4 : 0.6,
        visual: e.motion != null
            ? FigureVisual(e.motion!)
            : const SectionVisual('exercise'),
      ),
    for (final WorkoutProgram p in programs)
      KnowledgeItem(
        id: 'pr:${p.id}',
        kind: KnowledgeKind.program,
        title: _pick(p.title, lang),
        text: _short(_pick(p.summary, lang)),
        keywords: 'workout routine program ${p.category.name} ${p.level}',
        route: '${AppRoutes.programs}/${p.id}',
        visual: () {
          final first = p.steps.isEmpty
              ? null
              : exercises.where((e) => e.id == p.steps.first.exercise).firstOrNull;
          return first?.motion != null
              ? FigureVisual(first!.motion!)
              : const SectionVisual('exercise');
        }(),
      ),
    for (final Discipline d in skills)
      KnowledgeItem(
        id: 'sk:${d.id}',
        kind: KnowledgeKind.skill,
        title: _pick(d.name, lang),
        text: _short(
          '${_pick(d.about, lang)} ${_pick(d.trains, lang)} ${_pick(d.safety, lang)}',
        ),
        keywords: '${d.family} skill practice martial art ${_pick(d.region, 'en')}',
        route: '${AppRoutes.skills}/${d.id}',
        visual: FigureVisual(d.motion),
      ),
    for (final q in qa)
      KnowledgeItem(
        id: 'qa:${q.id}',
        kind: KnowledgeKind.answer,
        title: _pick(q.q, lang),
        text: _short(_pick(q.a, lang), 420),
        keywords: '${q.topic.name} ${_pick(q.q, 'en')}',
        route: AppRoutes.styleQa,
        visual: const SectionVisual('styleQa'),
      ),
    for (final e in makeup.shapes.entries)
      KnowledgeItem(
        id: 'mk:${e.key.name}',
        kind: KnowledgeKind.makeup,
        title: 'Makeup for ${e.key.name} faces',
        text: _short(
          '${MakeupContent.pick(e.value.blush, lang)} '
          '${MakeupContent.pick(e.value.contour, lang)} '
          '${MakeupContent.pick(e.value.highlight, lang)}',
          420,
        ),
        keywords: 'makeup blush contour highlight face shape ${e.key.name}',
        route: AppRoutes.makeup,
        visual: const SectionVisual('makeupGuide'),
      ),
    for (final u in makeup.palettes.entries)
      for (final a in u.value.entries)
        for (final s in a.value)
          KnowledgeItem(
            id: 'sh:${s.id}',
            kind: KnowledgeKind.makeup,
            title: '${MakeupContent.pick(s.name, lang)} (${a.key.name})',
            text: 'A ${a.key.name} shade for a ${u.key.name} undertone.',
            keywords: 'shade colour ${a.key.name} ${u.key.name} undertone lipstick',
            route: '${AppRoutes.tryOn}?${a.key == MakeupArea.blush ? 'blush' : 'lip'}=${s.hex}',
            visual: ColourVisual(s.hex),
          ),
    for (final t in trends.items)
      KnowledgeItem(
        id: 'tr:${t.id}',
        kind: KnowledgeKind.trend,
        title: _pick(t.title, lang),
        text: _short(_pick(t.desc, lang)),
        keywords: 'trend trending popular ${t.kind}',
        route: t.style != null && grooming.items[t.style] != null
            ? '${AppRoutes.tryOn}?item=${t.style}'
            : AppRoutes.trends,
        visual: t.colour != null
            ? ColourVisual(t.colour!)
            : grooming.items[t.style]?.hair != null
            ? HairVisual(grooming.items[t.style]!.hair!)
            : const SectionVisual('styleTrends'),
      ),
    for (final StyleItem i in grooming.items.values)
      KnowledgeItem(
        id: 'st:${i.id}',
        kind: switch (i.kind) {
          StyleKind.hair => KnowledgeKind.hairstyle,
          StyleKind.beard => KnowledgeKind.beard,
          StyleKind.glasses => KnowledgeKind.glasses,
        },
        title: GroomingContent.pick(i.name, lang),
        text: _short(
          '${GroomingContent.pick(i.desc, lang)} Suits: ${[
            for (final s in grooming.shapes.entries)
              if (s.value.items[i.kind]?.contains(i.id) ?? false) s.key.name,
          ].join(', ')} faces.',
        ),
        keywords: '${i.kind.name} ${i.kind == StyleKind.hair ? 'haircut hairstyle' : ''}'
            ' ${i.fit.name}',
        route: '${AppRoutes.tryOn}?item=${i.id}',
        visual: i.image != null
            ? PhotoVisual(i.image!)
            : i.hair != null
            ? HairVisual(i.hair!)
            : GlassesVisual(i.id),
      ),
    for (final MealOption m in meals)
      KnowledgeItem(
        id: 'ml:${m.id}',
        kind: KnowledgeKind.meal,
        title: m.nameIn(lang),
        text: '${m.portionIn(lang)}: about ${m.kcal} kcal and ${m.protein} g protein '
            '(${m.slot.name}).',
        keywords: 'meal food eat ${m.slot.name} ${m.base} '
            '${m.protein >= 20 ? 'high protein' : ''} ${m.kcal <= 300 ? 'light low calorie' : ''}',
        route: AppRoutes.meals,
        visual: const SectionVisual('meals'),
      ),
    for (final s in sections)
      KnowledgeItem(
        id: 'ap:${s['id']}',
        kind: KnowledgeKind.section,
        title: _pick((s['title'] as Map).cast<String, String>(), lang),
        text: _pick((s['desc'] as Map).cast<String, String>(), lang),
        keywords: s['keywords'] as String? ?? '',
        route: s['route'] as String,
        visual: SectionVisual(s['feature'] as String?),
      ),
  ]);
});
