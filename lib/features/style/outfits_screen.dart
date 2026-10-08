import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/outfit_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/visual/reveal.dart';
import '../../shared/widgets/empty_state.dart';
import '../health/widgets/add_record_sheet.dart' show confirmDelete;
import 'style_labels.dart';
import 'style_providers.dart';
import 'style_widgets.dart';

/// Outfit ideas from the user's own wardrobe, with reasons (spec §24–25).
class OutfitsScreen extends ConsumerStatefulWidget {
  const OutfitsScreen({super.key});

  @override
  ConsumerState<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends ConsumerState<OutfitsScreen> {
  Occasion _occasion = Occasion.casual;
  Set<String> _recent = const {};

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final r = await ref.read(styleRepositoryProvider).recentlyWornItems();
    if (mounted) setState(() => _recent = r);
  }

  Future<void> _run(Future<void> Function() f) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      await f();
    } catch (e, st) {
      AppLogger.error('outfit.action', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final wardrobe = ref.watch(wardrobeProvider).value ?? const <WardrobeItem>[];
    final photos = ref.watch(wardrobePhotosProvider).value ?? const {};
    final profile = ref.watch(styleProfileProvider).value;
    final saved = ref.watch(savedOutfitsProvider).value ?? const [];
    final ideas = OutfitEngine.suggest(
      wardrobe: wardrobe,
      occasion: _occasion,
      palette: profile?.palette,
      recentlyWorn: _recent,
    );
    final savedKeys = {
      for (final s in saved) (s.items.map((i) => i.id).toList()..sort()).join('+'),
    };

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.outfitIdeas),
          bottom: TabBar(tabs: [
            Tab(text: l10n.outfitIdeasTab),
            Tab(text: '${l10n.outfitSavedTab} · ${saved.length}'),
          ]),
        ),
        body: TabBarView(children: [
          ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  for (final o in Occasion.values)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: Text(l10n.occasionName(o)),
                        selected: _occasion == o,
                        onSelected: (_) => setState(() => _occasion = o),
                      ),
                    ),
                ]),
              ),
              if (profile?.palette == null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(l10n.outfitPaletteHint, style: theme.textTheme.bodySmall),
                ),
              const SizedBox(height: AppSpacing.md),
              if (ideas.isEmpty)
                EmptyState(
                  icon: Icons.checkroom_outlined,
                  title: l10n.outfitIdeas,
                  message: l10n.outfitNone,
                ),
              for (final (i, idea) in ideas.indexed)
                Reveal(
                  key: ValueKey('${_occasion.name}-${idea.key}'),
                  index: i,
                  child: Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OutfitCollage(items: idea.items, photos: photos),
                          const SizedBox(height: AppSpacing.md),
                          Text(l10n.whyThis, style: theme.textTheme.labelLarge),
                          for (final r in idea.reasons)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text('• ${l10n.outfitReason(r)}'),
                            ),
                          const SizedBox(height: AppSpacing.sm),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: savedKeys.contains(idea.key)
                                ? Chip(
                                    avatar: const Icon(Icons.check, size: 18),
                                    label: Text(l10n.postureSavedShort))
                                : FilledButton.tonalIcon(
                                    onPressed: () => _run(() => ref
                                        .read(styleRepositoryProvider)
                                        .saveOutfit(_occasion,
                                            [for (final it in idea.items) it.id])),
                                    icon: const Icon(Icons.bookmark_add_outlined),
                                    label: Text(l10n.outfitSave),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          saved.isEmpty
              ? Center(
                  child: EmptyState(
                    icon: Icons.bookmark_border,
                    title: l10n.outfitSavedTab,
                    message: l10n.outfitSavedEmpty,
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    for (final s in saved)
                      Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OutfitCollage(items: s.items, photos: photos, height: 180),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                  '${l10n.occasionName(s.occasion)} · ${l10n.outfitWornCount(s.wornDays.length)}',
                                  style: theme.textTheme.bodyMedium),
                              Row(children: [
                                FilledButton.tonalIcon(
                                  onPressed: () => _run(() async {
                                    await ref.read(styleRepositoryProvider).markWorn(s.id);
                                    await _loadRecent();
                                  }),
                                  icon: const Icon(Icons.today_outlined),
                                  label: Text(l10n.outfitWoreToday),
                                ),
                                const Spacer(),
                                IconButton(
                                  tooltip: l10n.actionDelete,
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    if (await confirmDelete(context)) {
                                      await ref.read(styleRepositoryProvider).deleteOutfit(s.id);
                                    }
                                  },
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
        ]),
      ),
    );
  }
}
