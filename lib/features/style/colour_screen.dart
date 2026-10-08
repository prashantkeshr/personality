import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/style_repository.dart';
import '../../domain/services/palette_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/visual/reveal.dart';
import 'style_labels.dart';
import 'style_providers.dart';
import 'style_widgets.dart';

/// Colour & style profile (spec §22–23): a short guided quiz gives an
/// undertone and depth, which select a personal palette.
class ColourScreen extends ConsumerStatefulWidget {
  const ColourScreen({super.key});

  @override
  ConsumerState<ColourScreen> createState() => _ColourScreenState();
}

class _ColourScreenState extends ConsumerState<ColourScreen> {
  bool _retake = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(styleProfileProvider).value;
    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.colourTitle)),
      body: !profile.hasPalette || _retake
          ? _Quiz(onDone: () => setState(() => _retake = false))
          : _PaletteView(
              profile: profile, onRetake: () => setState(() => _retake = true)),
    );
  }
}

class _Quiz extends ConsumerStatefulWidget {
  const _Quiz({required this.onDone});

  final VoidCallback onDone;

  @override
  ConsumerState<_Quiz> createState() => _QuizState();
}

class _QuizState extends ConsumerState<_Quiz> {
  final _page = PageController();
  VeinAnswer? _vein;
  JewelleryAnswer? _jewel;
  SunAnswer? _sun;
  SkinDepth? _depth;
  int _step = 0;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  void _next() {
    final reduce = MediaQuery.disableAnimationsOf(context);
    setState(() => _step++);
    if (reduce) {
      _page.jumpToPage(_step);
    } else {
      _page.animateToPage(_step,
          duration: const Duration(milliseconds: 380), curve: Curves.easeOutCubic);
    }
  }

  Future<void> _finish() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final r = UndertoneQuiz.evaluate(_vein!, _jewel!, _sun!);
      await ref.read(styleRepositoryProvider).setPalette(r.undertone, _depth!);
      widget.onDone();
    } catch (e, st) {
      AppLogger.error('colour.quiz', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
    }
  }

  Widget _options<T>(String question, String help, List<(T, String)> options,
      T? value, ValueChanged<T> onPick) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        Text(question, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        Text(help, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.lg),
        for (final (i, (v, label)) in options.indexed)
          Reveal(
            index: i,
            child: Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              color: value == v ? theme.colorScheme.primaryContainer : null,
              child: ListTile(
                title: Text(label),
                trailing: value == v ? const Icon(Icons.check_circle) : null,
                onTap: () {
                  onPick(v);
                  Future.delayed(const Duration(milliseconds: 180), _next);
                },
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    const depthSwatches = {
      SkinDepth.light: '#F1D3BC',
      SkinDepth.medium: '#C68E63',
      SkinDepth.deep: '#7A4E2D',
    };
    return Column(children: [
      LinearProgressIndicator(value: (_step + 1) / 4),
      Expanded(
        child: PageView(
          controller: _page,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _options(l10n.quizVeinQ, l10n.quizVeinHelp, [
              (VeinAnswer.blueOrPurple, l10n.quizVeinBlue),
              (VeinAnswer.green, l10n.quizVeinGreen),
              (VeinAnswer.both, l10n.quizVeinBoth),
            ], _vein, (v) => _vein = v),
            _options(l10n.quizJewelQ, l10n.quizJewelHelp, [
              (JewelleryAnswer.silver, l10n.quizJewelSilver),
              (JewelleryAnswer.gold, l10n.quizJewelGold),
              (JewelleryAnswer.both, l10n.quizJewelBoth),
            ], _jewel, (v) => _jewel = v),
            _options(l10n.quizSunQ, l10n.quizSunHelp, [
              (SunAnswer.burns, l10n.quizSunBurns),
              (SunAnswer.tans, l10n.quizSunTans),
              (SunAnswer.both, l10n.quizSunBoth),
            ], _sun, (v) => _sun = v),
            ListView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              children: [
                Text(l10n.quizDepthQ, style: theme.textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.sm),
                Text(l10n.quizDepthHelp, style: theme.textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (final (i, e) in depthSwatches.entries.indexed)
                      // The whole option (swatch and label) is tappable.
                      InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        onTap: () => setState(() => _depth = e.key),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Column(children: [
                            Swatch(
                              hex: e.value,
                              index: i,
                              size: 72,
                              label: l10n.depthName(e.key),
                              selected: _depth == e.key,
                              onTap: () => setState(() => _depth = e.key),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(l10n.depthName(e.key),
                                style: _depth == e.key
                                    ? TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: theme.colorScheme.primary)
                                    : null),
                          ]),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: _depth == null ? null : _finish,
                  child: Text(l10n.quizSeePalette),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(l10n.colourDisclaimer, style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}

class _PaletteView extends ConsumerWidget {
  const _PaletteView({required this.profile, required this.onRetake});

  final StyleProfile profile;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final palette = profile.palette!;
    final names = ref.watch(garmentColorsProvider).value ?? const <NamedColor>[];
    var i = 0;

    Widget group(String title, List<String> hexes, String note) => Reveal(
          index: i++,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  Text(note, style: theme.textTheme.bodySmall),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      for (final (j, h) in hexes.indexed)
                        Swatch(
                          hex: h,
                          index: j,
                          label: nearestNamed(names, h)?.label(lang),
                          onTap: () => context.push(
                              '${AppRoutes.drape}?hex=${Uri.encodeComponent(h)}'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Reveal(
          index: i++,
          child: Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.colourYourPalette, style: theme.textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                      '${l10n.undertoneName(profile.undertone!)} · ${l10n.depthName(profile.depth!)}',
                      style: theme.textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.sm),
                  Text(l10n.undertoneExplain(profile.undertone!)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Reveal(
          index: i++,
          child: FilledButton.icon(
            onPressed: () => context.push(
                '${AppRoutes.drape}?hex=${Uri.encodeComponent(palette.best.first)}'),
            icon: const Icon(Icons.face_retouching_natural),
            label: Text(l10n.drapeOpen),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        group(l10n.paletteBest, palette.best, l10n.paletteBestNote),
        const SizedBox(height: AppSpacing.md),
        group(l10n.paletteNeutrals, palette.neutrals, l10n.paletteNeutralsNote),
        const SizedBox(height: AppSpacing.md),
        group(l10n.paletteSparingly, palette.sparingly, l10n.paletteSparinglyNote),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.stylePrefsTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            for (final s in StylePreference.values)
              FilterChip(
                label: Text(l10n.stylePrefName(s)),
                selected: profile.styles.contains(s),
                onSelected: (on) {
                  final next = {...profile.styles};
                  on ? next.add(s) : next.remove(s);
                  ref.read(styleRepositoryProvider).setStyles(next);
                },
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          onPressed: onRetake,
          icon: const Icon(Icons.replay),
          label: Text(l10n.quizRetake),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.colourDisclaimer, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
