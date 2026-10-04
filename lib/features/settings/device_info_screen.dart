import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/device/device_tier.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/async_view.dart';

/// Shows what the app detected about this device and how that sets
/// processing quality (spec §7). Hardware facts only — no identifiers.
class DeviceInfoScreen extends ConsumerWidget {
  const DeviceInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    String yesNo(bool v) => v ? l10n.yes : l10n.no;
    String unknown(Object? v, String Function(Object) f) =>
        v == null ? l10n.unknownValue : f(v);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.deviceInfoTitle)),
      body: AsyncView(
        value: ref.watch(deviceSpecsProvider),
        data: (specs) {
          final tier = classifyDevice(specs);
          final policy = ProcessingPolicy.forTier(tier);
          final tierLabel = switch (tier) {
            DeviceTier.high => l10n.tierHigh,
            DeviceTier.medium => l10n.tierMedium,
            DeviceTier.low => l10n.tierLow,
          };
          Widget row(String k, String v) => ListTile(
                title: Text(k),
                trailing: Text(v, style: Theme.of(context).textTheme.bodyLarge),
              );
          return ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                    specs.isUnknown ? l10n.deviceUnknownNote : l10n.deviceInfoIntro,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              row(l10n.deviceTier, tierLabel),
              row(l10n.deviceRam,
                  unknown(specs.ramMb, (v) => l10n.valueGb(((v as int) / 1024).toStringAsFixed(1)))),
              row(l10n.deviceCores, unknown(specs.cpuCores, (v) => '$v')),
              row(l10n.deviceAndroid, unknown(specs.osApiLevel, (v) => 'API $v')),
              row(l10n.deviceStorage,
                  unknown(specs.freeStorageMb, (v) => l10n.valueGb(((v as int) / 1024).toStringAsFixed(1)))),
              row(l10n.deviceCamera, yesNo(specs.hasCamera)),
              const Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
                child: Text(l10n.deviceProcessing,
                    style: Theme.of(context).textTheme.labelLarge),
              ),
              row(l10n.deviceAnalysisRate, l10n.valueFps(policy.analysisFps)),
              row(l10n.deviceCameraResolution, '${policy.maxCameraHeightPx}p'),
              row(l10n.deviceLocalAi, yesNo(policy.localAiAllowed)),
            ],
          );
        },
      ),
    );
  }
}
