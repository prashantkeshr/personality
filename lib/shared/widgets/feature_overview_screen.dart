import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/features/feature_registry.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import 'feature_state_tile.dart';

/// A primary tab that introduces its area and lists its features with their
/// real capability state.
class FeatureOverviewScreen extends StatelessWidget {
  const FeatureOverviewScreen({
    super.key,
    required this.title,
    required this.intro,
    required this.features,
    this.routes = const {},
  });

  final String title;
  final String intro;
  final List<AppFeature> features;

  /// Route for each feature that has a screen.
  final Map<AppFeature, String> routes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
            child: Text(
              intro,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Semantics(
              header: true,
              child: Text(l10n.sectionFeatures,
                  style: theme.textTheme.labelLarge),
            ),
          ),
          for (final f in features)
            FeatureStateTile(
              feature: f,
              onOpen: routes[f] == null ? null : () => context.push(routes[f]!),
            ),
        ],
      ),
    );
  }
}
