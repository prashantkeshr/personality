import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/device/sensor_bridge.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import 'data_import.dart';

/// Phone sensors first; Health Connect only when it's already on the phone.
class ConnectedDataScreen extends ConsumerStatefulWidget {
  const ConnectedDataScreen({super.key});

  @override
  ConsumerState<ConnectedDataScreen> createState() => _ConnectedDataScreenState();
}

class _ConnectedDataScreenState extends ConsumerState<ConnectedDataScreen> {
  bool _busy = false;

  Future<void> _apply(ConnectedSettings next) async {
    await ref.read(connectedSettingsRepositoryProvider).set(
        steps: next.steps,
        activity: next.activity,
        sleep: next.sleep,
        healthConnect: next.healthConnect);
    await ref.read(sensorBridgeProvider).configure(
        steps: next.steps, activity: next.activity, sleep: next.sleep);
  }

  Future<void> _toggle(ConnectedSettings s, SensorStatus status,
      {bool? steps, bool? activity, bool? sleep}) async {
    final turningOn = (steps ?? false) || (activity ?? false) || (sleep ?? false);
    if (turningOn && !status.activityPermission) {
      final ok = await ref.read(sensorBridgeProvider).requestActivityPermission();
      ref.invalidate(sensorStatusProvider);
      if (!ok) return;
    }
    await _apply(ConnectedSettings(
      steps: steps ?? s.steps,
      activity: activity ?? s.activity,
      sleep: sleep ?? s.sleep,
      healthConnect: s.healthConnect,
    ));
    if (turningOn) await _syncNow();
  }

  Future<void> _connectHc(ConnectedSettings s) async {
    final granted = await ref.read(sensorBridgeProvider).requestHealthConnect();
    ref.invalidate(sensorStatusProvider);
    await _apply(ConnectedSettings(
        steps: s.steps, activity: s.activity, sleep: s.sleep,
        healthConnect: granted.isNotEmpty));
    if (granted.isNotEmpty) await _syncNow();
  }

  Future<void> _syncNow() async {
    if (_busy) return;
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final s = await ref.read(connectedSettingsRepositoryProvider).watch().first;
      final c = await ref.read(dataImporterProvider).sync(s);
      messenger.showSnackBar(SnackBar(content: Text(l10n.connectedSynced(c.total))));
    } catch (e, st) {
      AppLogger.error('connected.sync', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove({required bool healthConnect}) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        content: Text(l10n.connectedRemoveConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: Text(l10n.actionCancel)),
          FilledButton(
              onPressed: () => Navigator.of(c).pop(true), child: Text(l10n.connectedRemove)),
        ],
      ),
    );
    if (ok != true) return;
    final s = await ref.read(connectedSettingsRepositoryProvider).watch().first;
    await _apply(healthConnect
        ? ConnectedSettings(steps: s.steps, activity: s.activity, sleep: s.sleep)
        : ConnectedSettings(healthConnect: s.healthConnect));
    final n = await ref
        .read(dataImporterProvider)
        .disconnect(healthConnect: healthConnect, removeData: true);
    if (!healthConnect) await ref.read(sensorBridgeProvider).clear();
    messenger.showSnackBar(SnackBar(content: Text(l10n.connectedRemoved(n))));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final s = ref.watch(connectedSettingsProvider).value;
    final status = ref.watch(sensorStatusProvider).value;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.connectedTitle)),
      body: s == null || status == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(l10n.connectedIntro,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant)),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.connectedPhoneSensors, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                if (!status.activityPermission && s.anySensor)
                  Card(
                    color: scheme.tertiaryContainer,
                    child: ListTile(
                      leading: const Icon(Icons.directions_walk),
                      title: Text(l10n.connectedPermission),
                      trailing: FilledButton.tonal(
                        onPressed: () async {
                          await ref.read(sensorBridgeProvider).requestActivityPermission();
                          ref.invalidate(sensorStatusProvider);
                          await _apply(s);
                        },
                        child: Text(l10n.connectedAllow),
                      ),
                    ),
                  ),
                Card(
                  child: Column(children: [
                    SwitchListTile(
                      key: const Key('sensor-steps'),
                      secondary: const Icon(Icons.directions_walk),
                      title: Text(l10n.connectedSteps),
                      subtitle: Text(status.stepSensor
                          ? l10n.connectedStepsInfo
                          : l10n.connectedNoSensor),
                      value: s.steps,
                      onChanged: status.stepSensor
                          ? (on) => _toggle(s, status, steps: on)
                          : null,
                    ),
                    SwitchListTile(
                      key: const Key('sensor-activity'),
                      secondary: const Icon(Icons.directions_run),
                      title: Text(l10n.connectedActivity),
                      subtitle: Text(status.playServices
                          ? l10n.connectedActivityInfo
                          : l10n.connectedNoPlay),
                      value: s.activity,
                      onChanged: status.playServices
                          ? (on) => _toggle(s, status, activity: on)
                          : null,
                    ),
                    SwitchListTile(
                      key: const Key('sensor-sleep'),
                      secondary: const Icon(Icons.bedtime_outlined),
                      title: Text(l10n.connectedSleep),
                      subtitle: Text(status.playServices
                          ? l10n.connectedSleepInfo
                          : l10n.connectedNoPlay),
                      value: s.sleep,
                      onChanged: status.playServices
                          ? (on) => _toggle(s, status, sleep: on)
                          : null,
                    ),
                    if (s.anySensor)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _remove(healthConnect: false),
                          child: Text(l10n.connectedRemove),
                        ),
                      ),
                  ]),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.connectedHealthConnect, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(status.healthConnect ? l10n.connectedHcInfo : l10n.connectedHcAbsent),
                      if (status.healthConnect) ...[
                        const SizedBox(height: AppSpacing.md),
                        Wrap(spacing: AppSpacing.sm, children: [
                          FilledButton.tonal(
                            key: const Key('hc-connect'),
                            onPressed: () => _connectHc(s),
                            child: Text(l10n.connectedHcConnect),
                          ),
                          if (s.healthConnect)
                            TextButton(
                              onPressed: () => _remove(healthConnect: true),
                              child: Text(l10n.connectedRemove),
                            ),
                        ]),
                      ],
                    ]),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(children: [
                  Expanded(
                    child: Text(
                        s.lastSync == null
                            ? l10n.connectedNeverSynced
                            : l10n.connectedLastSync(
                                DateFormat.MMMd(locale).add_jm().format(s.lastSync!.toLocal())),
                        style: theme.textTheme.bodySmall),
                  ),
                  FilledButton.icon(
                    key: const Key('sync-now'),
                    onPressed: s.any && !_busy ? _syncNow : null,
                    icon: _busy
                        ? const SizedBox.square(
                            dimension: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.sync),
                    label: Text(l10n.connectedSyncNow),
                  ),
                ]),
                const SizedBox(height: AppSpacing.md),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.lock_outline, size: 18, color: scheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(l10n.connectedPrivacy, style: theme.textTheme.bodySmall)),
                ]),
              ],
            ),
    );
  }
}
