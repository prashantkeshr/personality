import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/features/feature_registry.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';
import 'feature_labels.dart';

/// Lists a feature with its capability state from [FeatureRegistry].
/// Non-usable features are shown disabled, never as working buttons.
class FeatureStateTile extends ConsumerWidget {
  const FeatureStateTile({super.key, required this.feature, this.onOpen});

  final AppFeature feature;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref
        .watch(featureRegistryProvider)
        .stateOf(feature, ref.watch(capabilityContextProvider));
    final usable = state.isUsable && onOpen != null;
    final stateLabel = l10n.featureStateLabel(state);

    return ListTile(
      enabled: usable,
      leading: Icon(featureIcon(feature)),
      title: Text(l10n.featureName(feature)),
      trailing: state == FeatureState.available
          ? const Icon(Icons.chevron_right)
          : _StateChip(label: stateLabel),
      onTap: usable ? onOpen : null,
    );
  }
}

class _StateChip extends StatelessWidget {
  const _StateChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Bounded so long labels (and translations) wrap instead of taking the
    // whole tile width on narrow phones.
    final maxWidth = MediaQuery.sizeOf(context).width * 0.4;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
