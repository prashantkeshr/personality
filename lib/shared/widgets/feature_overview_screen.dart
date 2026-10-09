import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/features/feature_registry.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../visual/reveal.dart';
import 'feature_labels.dart';

/// A primary tab: a photo header with its intro, then its features as image
/// cards showing their real capability state.
class FeatureOverviewScreen extends StatelessWidget {
  const FeatureOverviewScreen({
    super.key,
    required this.title,
    required this.intro,
    required this.features,
    this.routes = const {},
    this.heroImage,
  });

  final String title;
  final String intro;
  final List<AppFeature> features;

  /// Route for each feature that has a screen.
  final Map<AppFeature, String> routes;

  /// Bundled photo behind the header.
  final String? heroImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 196,
            title: Text(title),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(fit: StackFit.expand, children: [
                if (heroImage != null)
                  Image.asset(heroImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          ColoredBox(color: scheme.primaryContainer))
                else
                  ColoredBox(color: scheme.primaryContainer),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0, 0.45, 1],
                      colors: [
                        scheme.surface.withValues(alpha: 0.85),
                        scheme.surface.withValues(alpha: 0.2),
                        scheme.surface,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: AppSpacing.md,
                  child: Text(
                    intro,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface, fontWeight: FontWeight.w500),
                  ),
                ),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
            sliver: SliverToBoxAdapter(
              child: Semantics(
                header: true,
                child: Text(l10n.sectionFeatures,
                    style: theme.textTheme.labelLarge),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => Reveal(
                  index: i,
                  child: FeatureCard(
                    feature: features[i],
                    onOpen: routes[features[i]] == null
                        ? null
                        : () => context.push(routes[features[i]]!),
                  ),
                ),
                childCount: features.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A feature as an image card. Non-usable features are dimmed and show
/// their state; they never look like working buttons.
class FeatureCard extends ConsumerWidget {
  const FeatureCard({super.key, required this.feature, this.onOpen});

  final AppFeature feature;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final state = ref
        .watch(featureRegistryProvider)
        .stateOf(feature, ref.watch(capabilityContextProvider));
    final usable = state.isUsable && onOpen != null;
    final image = featureImage(feature);
    final name = l10n.featureName(feature);

    return Semantics(
      button: usable,
      enabled: usable,
      child: Opacity(
        opacity: usable ? 1 : 0.62,
        child: Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: usable ? onOpen : null,
            child: Stack(fit: StackFit.expand, children: [
              if (image != null)
                Image.asset(image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _ArtFallback(feature))
              else
                _ArtFallback(feature),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 1],
                    colors: [Color(0x00000000), Color(0xE0000000)],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.surface.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Icon(featureIcon(feature),
                        size: 18, color: scheme.primary),
                  ),
                ),
              ),
              if (state != FeatureState.available)
                Positioned(
                  top: 10,
                  right: 10,
                  left: 52,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: scheme.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        child: Text(l10n.featureStateLabel(state),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: scheme.onSurfaceVariant)),
                      ),
                    ),
                  ),
                ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Text(name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

/// A soft two-tone gradient with a large line icon, for features without a
/// photo. Each feature gets its own muted hue so the grid has rhythm.
class _ArtFallback extends StatelessWidget {
  const _ArtFallback(this.feature);
  final AppFeature feature;

  static const _hues = [
    Color(0xFF5B8C85), // sage teal
    Color(0xFFB08968), // sand
    Color(0xFF7D7AB8), // lilac
    Color(0xFF4F86A6), // sky
    Color(0xFFC07A6B), // terracotta
    Color(0xFF8A9A5B), // olive
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final base = _hues[feature.index % _hues.length];
    final a = Color.lerp(base, scheme.surface, dark ? 0.55 : 0.35)!;
    final b = Color.lerp(base, scheme.surface, dark ? 0.75 : 0.65)!;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [a, b],
        ),
      ),
      child: Align(
        alignment: const Alignment(0.75, -0.2),
        child: Icon(featureIcon(feature),
            size: 64, color: Colors.white.withValues(alpha: 0.35)),
      ),
    );
  }
}
