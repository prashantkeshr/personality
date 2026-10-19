import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../data/content/content_packs.dart';
import '../../l10n/app_localizations.dart';
import 'content_providers.dart';

String _size(int bytes) => bytes >= 1 << 20
    ? '${(bytes / (1 << 20)).toStringAsFixed(1)} MB'
    : '${(bytes / 1024).ceil()} KB';

/// Packs this small download on mobile data even with "Wi-Fi only" on.
const smallPackBytes = 2 << 20;

/// Optional packs from our public content library. Nothing is downloaded
/// until the user taps Download; nothing about the user is ever sent.
class ContentScreen extends ConsumerStatefulWidget {
  const ContentScreen({super.key});

  @override
  ConsumerState<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends ConsumerState<ContentScreen> {
  final _progress = <String, double>{};

  String _error(AppLocalizations l10n, Object e) => switch (e) {
        PackError(kind: PackErrorKind.offline) => l10n.contentOffline,
        PackError(kind: PackErrorKind.checksum || PackErrorKind.damaged) => l10n.contentDamaged,
        _ => l10n.contentFailed,
      };

  Future<void> _install(PackInfo p) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final net = await ref.read(networkStateProvider)();
      if (!net.online) throw const PackError(PackErrorKind.offline);
      final wifiOnly = ref.read(wifiOnlyProvider).value ?? true;
      if (wifiOnly && !net.unmetered && p.size > smallPackBytes) {
        // Ask once for this pack rather than failing outright.
        if (!mounted) return;
        final lang = Localizations.localeOf(context).languageCode;
        final useData = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(l10n.contentMobileTitle),
            content: Text(l10n.contentMobileBody(PackInfo.pick(p.title, lang), _size(p.size))),
            actions: [
              TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.contentMobileWait)),
              FilledButton(
                key: const Key('content-use-data'),
                onPressed: () => Navigator.pop(c, true),
                child: Text(l10n.contentMobileUse),
              ),
            ],
          ),
        );
        if (useData != true) return;
      }
      setState(() => _progress[p.id] = 0);
      final store = await ref.read(contentStoreProvider.future);
      await store.install(p, onProgress: (v) {
        if (mounted) setState(() => _progress[p.id] = v);
      });
      ref.invalidate(installedPacksProvider);
      messenger.showSnackBar(SnackBar(content: Text(l10n.contentInstalled)));
    } catch (e, st) {
      if (e is! PackError) AppLogger.error('content.install', e, st);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(_error(l10n, e))));
    } finally {
      if (mounted) setState(() => _progress.remove(p.id));
    }
  }

  Future<void> _remove(InstalledPack p) async {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        content: Text(l10n.contentRemoveConfirm(PackInfo.pick(p.info.title, lang))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.actionCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.contentRemove)),
        ],
      ),
    );
    if (ok != true) return;
    await (await ref.read(contentStoreProvider.future)).remove(p.info.id);
    ref.invalidate(installedPacksProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final installed = ref.watch(installedPacksProvider).value ?? const [];
    final byId = {for (final p in installed) p.info.id: p};
    final manifest = ref.watch(packManifestProvider);
    final wifiOnly = ref.watch(wifiOnlyProvider).value ?? true;

    Widget packCard(PackInfo info, {InstalledPack? have, bool online = true}) {
      final progress = _progress[info.id];
      final update = have != null && online && info.version > have.info.version;
      return Card(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(PackInfo.pick(info.title, lang), style: theme.textTheme.titleMedium)),
              if (have != null)
                Chip(
                  visualDensity: VisualDensity.compact,
                  avatar: Icon(Icons.check_circle, size: 18, color: scheme.primary),
                  label: Text(l10n.contentOnPhone),
                ),
            ]),
            const SizedBox(height: AppSpacing.xs),
            Text(PackInfo.pick(info.summary, lang), style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.xs),
            Text('${_size(info.size)} · ${info.license}${info.credit.isEmpty || info.credit == 'Personality' ? '' : ' · ${info.credit}'}',
                style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
            const SizedBox(height: AppSpacing.sm),
            if (progress != null)
              LinearProgressIndicator(value: progress == 0 ? null : progress)
            else
              Wrap(spacing: AppSpacing.sm, children: [
                if (have == null || update)
                  FilledButton.icon(
                    key: Key('pack-download-${info.id}'),
                    onPressed: _progress.isEmpty ? () => _install(info) : null,
                    icon: Icon(update ? Icons.system_update_alt : Icons.download),
                    label: Text(update ? l10n.contentUpdate : l10n.contentDownload),
                  ),
                if (have != null)
                  TextButton(
                    key: Key('pack-remove-${info.id}'),
                    onPressed: _progress.isEmpty ? () => _remove(have) : null,
                    child: Text(l10n.contentRemove),
                  ),
              ]),
          ]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.contentTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(packManifestProvider.future).then((_) {}, onError: (_) {}),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(l10n.contentIntro, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
            SwitchListTile(
              key: const Key('content-wifi-only'),
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.contentWifiOnly),
              subtitle: Text(l10n.contentWifiOnlyInfo),
              value: wifiOnly,
              onChanged: (v) => setWifiOnly(ref.read(appDatabaseProvider), v),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...manifest.when(
              data: (packs) => [
                for (final p in packs) packCard(p, have: byId[p.id]),
                // Installed packs no longer listed online stay usable.
                for (final have in installed)
                  if (!packs.any((p) => p.id == have.info.id)) packCard(have.info, have: have),
              ],
              loading: () => [
                for (final have in installed) packCard(have.info, have: have, online: false),
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
              error: (e, _) => [
                Card(
                  color: scheme.errorContainer,
                  child: ListTile(
                    leading: Icon(Icons.cloud_off, color: scheme.onErrorContainer),
                    title: Text(_error(l10n, e), style: TextStyle(color: scheme.onErrorContainer)),
                    trailing: TextButton(
                      onPressed: () => ref.invalidate(packManifestProvider),
                      child: Text(l10n.contentRetry),
                    ),
                  ),
                ),
                for (final have in installed) packCard(have.info, have: have, online: false),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.lock_outline, size: 18, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(l10n.contentPrivacy, style: theme.textTheme.bodySmall)),
            ]),
          ],
        ),
      ),
    );
  }
}
