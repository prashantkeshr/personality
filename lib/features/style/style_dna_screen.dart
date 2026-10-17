import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/style_repository.dart';
import '../../domain/services/outfit_engine.dart';
import '../../l10n/app_localizations.dart';
import '../face/face_labels.dart';
import 'style_labels.dart';
import 'style_providers.dart';
import 'style_studio_labels.dart';
import 'style_studio_providers.dart';

/// Style DNA: everything that shapes outfit, grooming and glasses ideas,
/// for every gender, editable at any time.
class StyleDnaScreen extends ConsumerStatefulWidget {
  const StyleDnaScreen({super.key});

  @override
  ConsumerState<StyleDnaScreen> createState() => _StyleDnaScreenState();
}

class _StyleDnaScreenState extends ConsumerState<StyleDnaScreen> {
  Set<StylePreference>? _styles;
  Set<FitPreference>? _fits;
  BudgetLevel? _budget;
  Modesty? _modesty;
  Set<CulturalWear>? _cultural;
  Set<Occasion>? _occasions;
  bool _loaded = false;
  bool _saving = false;

  void _load(StyleProfile p) {
    if (_loaded) return;
    _loaded = true;
    _styles = {...p.styles};
    _fits = {...p.fits};
    _budget = p.budget;
    _modesty = p.modesty;
    _cultural = {...p.cultural};
    _occasions = {...p.occasions};
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final repo = ref.read(styleRepositoryProvider);
      await repo.setStyles(_styles!);
      await repo.setDna(
          fits: _fits!, budget: _budget, modesty: _modesty, cultural: _cultural!, occasions: _occasions!);
      messenger.showSnackBar(SnackBar(content: Text(l.dnaSaved)));
    } catch (e, st) {
      AppLogger.error('style.dna', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l.recordSaveError)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final profile = ref.watch(styleProfileProvider).value;
    if (profile == null) {
      return Scaffold(appBar: AppBar(title: Text(l.featureStyleDna)), body: const Center(child: CircularProgressIndicator()));
    }
    _load(profile);
    final shape = ref.watch(latestFaceShapeProvider);
    final draft = StyleProfile(
      undertone: profile.undertone,
      depth: profile.depth,
      styles: _styles!,
      fits: _fits!,
      budget: _budget,
      modesty: _modesty,
      cultural: _cultural!,
      occasions: _occasions!,
    );

    Widget section(String title, String help, Widget chips) => Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: theme.textTheme.titleMedium),
            Text(help, style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.sm),
            chips,
          ]),
        );
    Widget multi<T>(List<T> values, Set<T> selected, String Function(T) label, {String key = ''}) => Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            for (final v in values)
              FilterChip(
                key: Key('dna-$key-$v'),
                label: Text(label(v)),
                selected: selected.contains(v),
                onSelected: (on) => setState(() => on ? selected.add(v) : selected.remove(v)),
              ),
          ],
        );
    Widget single<T>(List<T> values, T? current, String Function(T) label, void Function(T?) set) => Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            for (final v in values)
              ChoiceChip(
                label: Text(label(v)),
                selected: current == v,
                onSelected: (on) => setState(() => set(on ? v : null)),
              ),
          ],
        );

    final traits = [
      if (profile.hasPalette) l.depthName(profile.depth!),
      if (profile.hasPalette) l.undertoneName(profile.undertone!),
      if (shape != null) l.faceShapeName(shape),
      for (final s in _styles!) l.stylePrefName(s),
      for (final f in _fits!) l.fitName(f),
      for (final c in _cultural!) l.culturalName(c),
      if (_modesty != null) l.modestyName(_modesty!),
      if (_budget != null) l.budgetName(_budget!),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l.featureStyleDna)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 120),
        children: [
          Card(
            color: scheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                    child: Text(l.dnaYour,
                        style: theme.textTheme.titleLarge?.copyWith(color: scheme.onPrimaryContainer)),
                  ),
                  SizedBox.square(
                    dimension: 44,
                    child: Stack(alignment: Alignment.center, children: [
                      CircularProgressIndicator(
                          value: draft.completeness, strokeWidth: 5, backgroundColor: scheme.surface),
                      Text('${(draft.completeness * 100).round()}%',
                          style: theme.textTheme.labelSmall?.copyWith(color: scheme.onPrimaryContainer)),
                    ]),
                  ),
                ]),
                const SizedBox(height: AppSpacing.sm),
                if (traits.isEmpty)
                  Text(l.dnaEmpty, style: TextStyle(color: scheme.onPrimaryContainer))
                else
                  Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: [
                    for (final t in traits)
                      Chip(label: Text(t), visualDensity: VisualDensity.compact, backgroundColor: scheme.surface),
                  ]),
              ]),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.colours),
                icon: const Icon(Icons.palette_outlined),
                label: Text(profile.hasPalette ? l.dnaPaletteDone : l.dnaFindPalette),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.face),
                icon: const Icon(Icons.face_outlined),
                label: Text(shape == null ? l.dnaFindShape : l.faceShapeName(shape)),
              ),
            ),
          ]),
          section(l.dnaStyles, l.dnaStylesHelp,
              multi(StylePreference.values, _styles!, l.stylePrefName, key: 'style')),
          section(l.dnaFits, l.dnaFitsHelp, multi(FitPreference.values, _fits!, l.fitName, key: 'fit')),
          section(l.dnaOccasions, l.dnaOccasionsHelp,
              multi(Occasion.values, _occasions!, l.occasionName, key: 'occasion')),
          section(l.dnaCultural, l.dnaCulturalHelp,
              multi(CulturalWear.values, _cultural!, l.culturalName, key: 'cultural')),
          section(l.dnaModesty, l.dnaModestyHelp,
              single(Modesty.values, _modesty, l.modestyName, (v) => _modesty = v)),
          section(l.dnaBudget, l.dnaBudgetHelp,
              single(BudgetLevel.values, _budget, l.budgetName, (v) => _budget = v)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('dna-save'),
        onPressed: _saving ? null : _save,
        icon: const Icon(Icons.check),
        label: Text(l.actionSave),
      ),
    );
  }
}
