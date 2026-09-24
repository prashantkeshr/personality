import 'package:flutter/material.dart';

import '../../domain/entities/provenance.dart';
import '../../l10n/app_localizations.dart';
import '../format/body_format.dart';

IconData sourceIcon(DataSource s) => switch (s) {
      DataSource.userEntered => Icons.edit_outlined,
      DataSource.cameraDerived => Icons.photo_camera_outlined,
      DataSource.deviceDerived => Icons.sensors,
      DataSource.healthPlatform => Icons.health_and_safety_outlined,
      DataSource.calculated => Icons.functions,
      DataSource.imported => Icons.download_outlined,
      DataSource.aiGenerated => Icons.auto_awesome_outlined,
    };

/// Shows where a value came from (spec §9). Icon + text, never color alone.
class ProvenanceChip extends StatelessWidget {
  const ProvenanceChip({super.key, required this.source, this.confidence});

  final DataSource source;
  final Confidence? confidence;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final style = Theme.of(context)
        .textTheme
        .labelMedium
        ?.copyWith(color: scheme.onSurfaceVariant);
    final label = [
      l10n.sourceLabel(source),
      if (confidence != null) l10n.confidenceLabel(confidence!),
    ].join(' · ');

    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(sourceIcon(source), size: 14, color: scheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Flexible(child: Text(label, style: style)),
          ],
        ),
      ),
    );
  }
}
