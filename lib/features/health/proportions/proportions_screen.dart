import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/body.dart';
import '../../../domain/services/proportion_engine.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/format/body_format.dart';
import '../../../shared/widgets/async_view.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/provenance_chip.dart';
import '../body_providers.dart';

extension ProportionLabels on AppLocalizations {
  String metricName(ProportionMetric m) => switch (m) {
        ProportionMetric.legLine => metricLegLine,
        ProportionMetric.shoulderBreadth => metricShoulderBreadth,
        ProportionMetric.upperTaper => metricUpperTaper,
        ProportionMetric.hipBalance => metricHipBalance,
      };

  String descriptor(ProportionDescriptor d) => switch (d) {
        ProportionDescriptor.shorterLegLine => descShorterLegLine,
        ProportionDescriptor.balancedLegLine => descBalancedLegLine,
        ProportionDescriptor.longerLegLine => descLongerLegLine,
        ProportionDescriptor.narrowerShoulders => descNarrowerShoulders,
        ProportionDescriptor.averageShoulders => descAverageShoulders,
        ProportionDescriptor.broaderShoulders => descBroaderShoulders,
        ProportionDescriptor.straightTaper => descStraightTaper,
        ProportionDescriptor.moderateTaper => descModerateTaper,
        ProportionDescriptor.pronouncedTaper => descPronouncedTaper,
        ProportionDescriptor.chestFuller => descChestFuller,
        ProportionDescriptor.balancedChestHip => descBalancedChestHip,
        ProportionDescriptor.hipsFuller => descHipsFuller,
      };

  String inputName(String key) => key == ProportionEngine.heightKey
      ? heightTitle
      : measurementName(BodyMeasurementType.fromName(key));
}

class ProportionsScreen extends ConsumerWidget {
  const ProportionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final format =
        BodyFormat.of(context, ref.watch(settingsControllerProvider).unitSystem);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.proportionsTitle)),
      body: AsyncView(
        value: ref.watch(proportionProvider),
        data: (profile) {
          final muted = theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant);
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(l10n.proportionsIntro, style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.proportionsDisclaimer, style: muted),
              const SizedBox(height: AppSpacing.lg),
              if (profile.isEmpty)
                EmptyState(
                  icon: Icons.accessibility_new,
                  title: l10n.proportionsTitle,
                  message: l10n.proportionsEmpty,
                ),
              for (final r in profile.results) ...[
                _ResultCard(result: r, format: format),
                const SizedBox(height: AppSpacing.md),
              ],
              for (final e in profile.missing.entries)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.add_circle_outline),
                  title: Text(l10n.proportionsMissing(
                    e.value.map(l10n.inputName).join(', '),
                    l10n.metricName(e.key),
                  )),
                ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  OutlinedButton(
                    onPressed: () => context.push('/health/height'),
                    child: Text(l10n.heightTitle),
                  ),
                  OutlinedButton(
                    onPressed: () => context.push('/health/measurements'),
                    child: Text(l10n.proportionsAddMeasurements),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, required this.format});

  final ProportionResult result;
  final BodyFormat format;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final value = result.unit == 'ratio'
        ? format.ratio(result.value)
        : format.length(result.value);
    final inputs = result.inputs.entries.map((e) {
      final v = e.key == ProportionEngine.heightKey
          ? format.height(e.value.value)
          : format.length(e.value.value);
      return '${l10n.inputName(e.key)} $v';
    }).join(', ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.metricName(result.metric),
                style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(l10n.descriptor(result.descriptor),
                style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(value, style: theme.textTheme.bodyMedium),
                ProvenanceChip(
                    source: result.source, confidence: result.confidence),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.proportionsBasedOn(inputs),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
