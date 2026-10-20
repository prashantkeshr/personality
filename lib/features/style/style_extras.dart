import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/grooming.dart';
import '../../domain/entities/makeup.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/visual/hair_art.dart';
import '../../shared/visual/outfit_silhouette.dart' show hexColor;
import '../../shared/visual/style_art.dart';
import '../content/content_providers.dart';
import '../face/face_providers.dart';
import '../face/makeup_screen.dart' show makeupFavoriteId;
import 'style_providers.dart';

String _pick(Map<String, String> m, String lang) =>
    m[lang] ?? m['en'] ?? (m.isEmpty ? '' : m.values.first);

Map<String, String> _text(Object? v) =>
    (v as Map<String, dynamic>).map((k, v) => MapEntry(k, '$v'));

// ---------------------------------------------------------------- Q&A

enum QaTopic { skin, hair, makeup, beard, style, colour, glasses }

class StyleQa {
  const StyleQa(this.id, this.topic, this.q, this.a);
  final String id;
  final QaTopic topic;
  final Map<String, String> q;
  final Map<String, String> a;
}

final styleQaProvider = FutureProvider<List<StyleQa>>((ref) async {
  final raw = await rootBundle.loadString(
    'assets/content/style_qa.json',
    cache: false,
  );
  return [
    for (final e in (jsonDecode(raw) as List).cast<Map<String, dynamic>>())
      StyleQa(
        e['id'] as String,
        QaTopic.values.byName(e['topic'] as String),
        _text(e['q']),
        _text(e['a']),
      ),
  ];
});

String qaTopicLabel(AppLocalizations l, QaTopic t) => switch (t) {
  QaTopic.skin => l.qaSkin,
  QaTopic.hair => l.styleHair,
  QaTopic.makeup => l.makeupTitle,
  QaTopic.beard => l.styleBeard,
  QaTopic.style => l.qaStyle,
  QaTopic.colour => l.qaColour,
  QaTopic.glasses => l.styleGlasses,
};

/// "Ask about style": an offline, searchable set of answers. Works without
/// internet and never sends questions anywhere.
class StyleQaScreen extends ConsumerStatefulWidget {
  const StyleQaScreen({super.key});

  @override
  ConsumerState<StyleQaScreen> createState() => _StyleQaScreenState();
}

class _StyleQaScreenState extends ConsumerState<StyleQaScreen> {
  String _query = '';
  QaTopic? _topic;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final all = ref.watch(styleQaProvider).value ?? const <StyleQa>[];
    final words = _query.toLowerCase().split(RegExp(r'\s+'))
      ..removeWhere((w) => w.length < 2);
    final shown = [
      for (final e in all)
        if ((_topic == null || e.topic == _topic) &&
            words.every((w) =>
                '${_pick(e.q, lang)} ${_pick(e.a, lang)} ${_pick(e.q, 'en')}'
                    .toLowerCase()
                    .contains(w)))
          e,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.qaTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          TextField(
            key: const Key('qa-search'),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l.qaSearchHint,
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ChoiceChip(
                label: Text(l.qaAll),
                selected: _topic == null,
                onSelected: (_) => setState(() => _topic = null),
              ),
              for (final t in QaTopic.values)
                ChoiceChip(
                  key: Key('qa-topic-${t.name}'),
                  label: Text(qaTopicLabel(l, t)),
                  selected: _topic == t,
                  onSelected: (_) => setState(() => _topic = t),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(l.qaNone, textAlign: TextAlign.center),
            ),
          for (final e in shown)
            Card(
              child: ExpansionTile(
                key: Key('qa-${e.id}'),
                shape: const Border(),
                leading: const Icon(Icons.help_outline),
                title: Text(_pick(e.q, lang)),
                subtitle: Text(qaTopicLabel(l, e.topic)),
                childrenPadding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                children: [Text(_pick(e.a, lang))],
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.qaNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------- Trends

class TrendItem {
  const TrendItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.desc,
    this.style,
    this.colour,
  });
  final String id;
  final String kind;
  final Map<String, String> title;
  final Map<String, String> desc;

  /// A style item id (hair, beard, glasses) the trend links to.
  final String? style;
  final String? colour;
}

class Trends {
  const Trends(this.updated, this.season, this.items);
  final String updated;
  final Map<String, String> season;
  final List<TrendItem> items;

  factory Trends.fromJson(Map<String, dynamic> j) => Trends(
    j['updated'] as String? ?? '',
    _text(j['season'] ?? const <String, dynamic>{}),
    [
      for (final e in (j['items'] as List).cast<Map<String, dynamic>>())
        TrendItem(
          id: e['id'] as String,
          kind: e['kind'] as String? ?? 'style',
          title: _text(e['title']),
          desc: _text(e['desc']),
          style: e['style'] as String?,
          colour: e['colour'] as String?,
        ),
    ],
  );
}

/// Built-in trends, replaced by a newer `trends` content pack when the user
/// has downloaded one (packs refresh from the content library).
final trendsProvider = FutureProvider<Trends>((ref) async {
  final raw = await rootBundle.loadString(
    'assets/content/trends.json',
    cache: false,
  );
  var best = Trends.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  final packs = ref.watch(installedPacksProvider).value ?? const [];
  for (final p in packs.where((p) => p.info.kind == 'trends')) {
    try {
      final f = File('${p.dir}/trends.json');
      if (!f.existsSync()) continue;
      final t = Trends.fromJson(
        jsonDecode(await f.readAsString()) as Map<String, dynamic>,
      );
      if (t.updated.compareTo(best.updated) > 0) best = t;
    } catch (e, st) {
      AppLogger.error('trends.pack', e, st);
    }
  }
  return best;
});

String trendKindLabel(AppLocalizations l, String kind) => switch (kind) {
  'hair' => l.styleHair,
  'beard' => l.styleBeard,
  'makeup' => l.makeupTitle,
  'colour' => l.qaColour,
  'glasses' => l.styleGlasses,
  'accessory' => l.trendAccessories,
  _ => l.qaStyle,
};

class TrendsScreen extends ConsumerWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final trends = ref.watch(trendsProvider).value;
    final grooming = ref.watch(groomingContentProvider).value;
    if (trends == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.trendsTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final kinds = <String>{for (final t in trends.items) t.kind};
    return Scaffold(
      appBar: AppBar(title: Text(l.trendsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          Text(_pick(trends.season, lang), style: theme.textTheme.titleLarge),
          Text(
            l.trendsInfo,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          for (final k in kinds) ...[
            const SizedBox(height: AppSpacing.md),
            Text(trendKindLabel(l, k), style: theme.textTheme.titleMedium),
            for (final t in trends.items.where((t) => t.kind == k))
              Card(
                key: Key('trend-${t.id}'),
                child: ListTile(
                  leading: _TrendArt(item: t, grooming: grooming),
                  title: Text(_pick(t.title, lang)),
                  subtitle: Text(_pick(t.desc, lang)),
                  trailing: t.style != null && grooming?.items[t.style] != null
                      ? const Icon(Icons.chevron_right)
                      : null,
                  onTap: t.style == null || grooming?.items[t.style] == null
                      ? null
                      : () => context.push(
                          '${AppRoutes.tryOn}?item=${t.style}',
                        ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _TrendArt extends StatelessWidget {
  const _TrendArt({required this.item, required this.grooming});
  final TrendItem item;
  final GroomingContent? grooming;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final styleItem = grooming?.items[item.style];
    final hair = HairShape.fromName(styleItem?.hair);
    final glasses = glassesStyleFor(item.style ?? '');
    return SizedBox(
      width: 48,
      height: 48,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ColoredBox(
          color: item.colour != null
              ? hexColor(item.colour!)
              : scheme.secondaryContainer,
          child: hair != null
              ? HairArt(shape: hair)
              : glasses != null
              ? Padding(
                  padding: const EdgeInsets.all(6),
                  child: GlassesArt(style: glasses, color: scheme.onSecondaryContainer),
                )
              : item.colour != null
              ? null
              : Icon(Icons.trending_up, color: scheme.onSecondaryContainer),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------- Lookbook

/// Everything the user saved with ♡: hairstyles, beards, glasses, makeup
/// shades, favourite clothes and saved outfits, plus their best colours.
class LookbookScreen extends ConsumerWidget {
  const LookbookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final favs = ref.watch(styleFavoritesProvider).value ?? const <String>{};
    final grooming = ref.watch(groomingContentProvider).value;
    final makeup = ref.watch(makeupContentProvider).value;
    final wardrobe = ref.watch(wardrobeProvider).value ?? const [];
    final outfits = ref.watch(savedOutfitsProvider).value ?? const [];
    final palette = ref.watch(styleProfileProvider).value?.palette;

    final styles = [
      for (final id in favs)
        if (grooming?.items[id] case final StyleItem i) i,
    ];
    final shades = [
      if (makeup != null)
        for (final p in makeup.palettes.values)
          for (final list in p.values)
            for (final s in list)
              if (favs.contains(makeupFavoriteId(s))) s,
    ];
    final clothes = [for (final w in wardrobe) if (w.favorite) w];
    final empty = styles.isEmpty &&
        shades.isEmpty &&
        clothes.isEmpty &&
        outfits.isEmpty &&
        palette == null;

    Widget header(String t) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
      child: Text(t, style: theme.textTheme.titleMedium),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.lookbookTitle)),
      body: ListView(
        key: const Key('lookbook'),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          Text(
            empty ? l.lookbookEmpty : l.lookbookInfo,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (empty) ...[
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: () => context.push(AppRoutes.face),
              icon: const Icon(Icons.face_outlined),
              label: Text(l.lookbookFindStyles),
            ),
          ],
          for (final kind in StyleKind.values)
            if (styles.where((s) => s.kind == kind).isNotEmpty) ...[
              header(switch (kind) {
                StyleKind.hair => l.styleHair,
                StyleKind.beard => l.styleBeard,
                StyleKind.glasses => l.styleGlasses,
              }),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final s in styles.where((s) => s.kind == kind))
                      _StyleTile(
                        item: s,
                        label: _pick(s.name, lang),
                        onRemove: () => ref
                            .read(faceRepositoryProvider)
                            .setFavorite(s.id, false),
                      ),
                  ],
                ),
              ),
            ],
          if (shades.isNotEmpty) ...[
            header(l.makeupTitle),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final s in shades)
                  InputChip(
                    key: Key('look-shade-${s.id}'),
                    avatar: CircleAvatar(backgroundColor: Color(s.argb)),
                    label: Text(MakeupContent.pick(s.name, lang)),
                    onPressed: () =>
                        context.push('${AppRoutes.tryOn}?lip=${s.hex}'),
                    onDeleted: () => ref
                        .read(faceRepositoryProvider)
                        .setFavorite(makeupFavoriteId(s), false),
                  ),
              ],
            ),
          ],
          if (palette != null) ...[
            header(l.lookbookColours),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final hex in palette.best.take(12))
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: hexColor(hex),
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                    ),
                  ),
              ],
            ),
          ],
          if (clothes.isNotEmpty) ...[
            header(l.lookbookClothes),
            for (final w in clothes)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(backgroundColor: hexColor(w.colorHex)),
                title: Text(w.name),
                onTap: () => context.push(AppRoutes.wardrobe),
              ),
          ],
          if (outfits.isNotEmpty) ...[
            header(l.lookbookOutfits),
            for (final o in outfits)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final i in o.items.take(4))
                      Container(
                        width: 14,
                        height: 28,
                        margin: const EdgeInsets.only(right: 2),
                        decoration: BoxDecoration(
                          color: hexColor(i.colorHex),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                  ],
                ),
                title: Text(o.items.map((i) => i.name).join(' · ')),
                onTap: () => context.push(AppRoutes.outfits),
              ),
          ],
        ],
      ),
    );
  }
}

class _StyleTile extends StatelessWidget {
  const _StyleTile({
    required this.item,
    required this.label,
    required this.onRemove,
  });
  final StyleItem item;
  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final hair = HairShape.fromName(item.hair);
    final glasses = glassesStyleFor(item.id);
    final canTry = item.kind != StyleKind.hair || hair != null;
    return Container(
      key: Key('look-${item.id}'),
      width: 120,
      margin: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: canTry
              ? () => context.push('${AppRoutes.tryOn}?item=${item.id}')
              : null,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (item.image != null)
                      Image.asset(item.image!, fit: BoxFit.cover)
                    else
                      ColoredBox(
                        color: scheme.primaryContainer,
                        child: hair != null
                            ? HairArt(shape: hair)
                            : glasses != null
                            ? Padding(
                                padding: const EdgeInsets.all(14),
                                child: GlassesArt(
                                  style: glasses,
                                  color: scheme.onPrimaryContainer,
                                ),
                              )
                            : const Icon(Icons.face_retouching_natural),
                      ),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: IconButton(
                        tooltip: l.favoriteRemove,
                        onPressed: onRemove,
                        icon: const Icon(Icons.favorite, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
