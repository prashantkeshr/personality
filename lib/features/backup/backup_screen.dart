import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../core/device/file_bridge.dart';
import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../data/backup/backup_service.dart';
import '../../l10n/app_localizations.dart';
import '../health/health_providers.dart';

final fileBridgeProvider = Provider<FileBridge>((ref) => const PlatformFileBridge());

final backupServiceProvider = Provider(
    (ref) => BackupService(ref.watch(appDatabaseProvider), clock: ref.watch(clockProvider)));

/// When this phone last made an encrypted backup (device setting, never backed up).
final lastBackupProvider = StreamProvider<DateTime?>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.appSettingsEntries)..where((t) => t.key.equals(_lastKey)))
      .watchSingleOrNull()
      .map((r) => r == null ? null : DateTime.tryParse(r.value));
});

const _lastKey = 'backup.last';

Future<void> _markBackedUp(AppDatabase db, DateTime at) =>
    db.into(db.appSettingsEntries).insertOnConflictUpdate(AppSettingsEntriesCompanion.insert(
        key: _lastKey,
        value: at.toUtc().toIso8601String(),
        updatedAt: at.toUtc().millisecondsSinceEpoch));

/// Move everything to another phone, keep a safe copy, or open it elsewhere.
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _photos = true;
  String? _busy; // which action is running

  String _stamp() => DateFormat('yyyy-MM-dd').format(ref.read(clockProvider)());

  Future<void> _run(String id, Future<void> Function() task) async {
    if (_busy != null) return;
    setState(() => _busy = id);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await task();
    } on BackupError catch (e) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(_errorText(l10n, e.kind))));
    } catch (e, st) {
      AppLogger.error('backup.$id', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupFailed)));
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  static String _errorText(AppLocalizations l10n, BackupErrorKind k) => switch (k) {
        BackupErrorKind.notABackup => l10n.backupErrorNotBackup,
        BackupErrorKind.damaged => l10n.backupErrorDamaged,
        BackupErrorKind.wrongPassphrase => l10n.backupErrorPassphrase,
        BackupErrorKind.tooNew => l10n.backupErrorTooNew,
      };

  Future<void> _backup({required bool share}) async {
    final pass = await showDialog<String>(
        context: context, builder: (_) => const _PassphraseDialog(create: true));
    if (pass == null || !mounted) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await _run(share ? 'share' : 'save', () async {
      final bytes = await ref.read(backupServiceProvider).createBackup(pass, photos: _photos);
      final name = 'personality-${_stamp()}.personality';
      const mime = 'application/octet-stream';
      final files = ref.read(fileBridgeProvider);
      if (share) {
        await files.share(name, mime, bytes);
      } else if (!await files.save(name, mime, bytes)) {
        return;
      }
      await _markBackedUp(ref.read(appDatabaseProvider), ref.read(clockProvider)());
      if (!share) messenger.showSnackBar(SnackBar(content: Text(l10n.backupSaved)));
    });
  }

  Future<void> _restore() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final Uint8List? bytes;
    try {
      bytes = await ref.read(fileBridgeProvider).open();
    } catch (e, st) {
      AppLogger.error('backup.open', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupFailed)));
      return;
    }
    if (bytes == null || !mounted) return;
    final pass = await showDialog<String>(
        context: context, builder: (_) => const _PassphraseDialog(create: false));
    if (pass == null || !mounted) return;
    BackupContents? contents;
    await _run('open', () async {
      contents = await ref.read(backupServiceProvider).open(bytes!, pass);
    });
    final c = contents;
    if (c == null || !mounted) return;
    final mode = await showDialog<RestoreMode>(
        context: context, builder: (_) => _RestoreDialog(contents: c));
    if (mode == null || !mounted) return;
    await _run('restore', () async {
      await ref.read(backupServiceProvider).restore(c, mode: mode);
      await ref.read(settingsControllerProvider.notifier).reload();
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupRestored(c.records))));
    });
  }

  Future<void> _export({required bool csv, required bool share}) => _run(
        '${csv ? 'csv' : 'json'}-${share ? 'share' : 'save'}',
        () async {
          final l10n = AppLocalizations.of(context);
          final messenger = ScaffoldMessenger.of(context);
          final service = ref.read(backupServiceProvider);
          final bytes = csv ? await service.exportCsvZip() : await service.exportJson();
          final name = 'personality-${_stamp()}.${csv ? 'zip' : 'json'}';
          final mime = csv ? 'application/zip' : 'application/json';
          final files = ref.read(fileBridgeProvider);
          if (share) {
            await files.share(name, mime, bytes);
          } else if (await files.save(name, mime, bytes)) {
            messenger.showSnackBar(SnackBar(content: Text(l10n.backupSaved)));
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final last = ref.watch(lastBackupProvider).value;
    final locale = Localizations.localeOf(context).toLanguageTag();

    Widget spinnerOr(String id, IconData icon) => _busy == id
        ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
        : Icon(icon);

    Widget section(String title, String info, List<Widget> children) => Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(info,
                  style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.md),
              ...children,
            ]),
          ),
        );

    final idle = _busy == null;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(l10n.backupIntro,
              style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.lg),
          section(l10n.backupEncrypted, l10n.backupEncryptedInfo, [
            SwitchListTile(
              key: const Key('backup-photos'),
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.backupIncludePhotos),
              subtitle: Text(l10n.backupIncludePhotosInfo),
              value: _photos,
              onChanged: (v) => setState(() => _photos = v),
            ),
            Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
              FilledButton.icon(
                key: const Key('backup-save'),
                onPressed: idle ? () => _backup(share: false) : null,
                icon: spinnerOr('save', Icons.save_alt),
                label: Text(l10n.backupSaveFile),
              ),
              OutlinedButton.icon(
                key: const Key('backup-share'),
                onPressed: idle ? () => _backup(share: true) : null,
                icon: spinnerOr('share', Icons.share),
                label: Text(l10n.backupShare),
              ),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Text(
                last == null
                    ? l10n.backupNever
                    : l10n.backupLast(DateFormat.yMMMd(locale).add_jm().format(last.toLocal())),
                style: theme.textTheme.bodySmall),
          ]),
          const SizedBox(height: AppSpacing.md),
          section(l10n.backupRestoreTitle, l10n.backupRestoreInfo, [
            FilledButton.tonalIcon(
              key: const Key('backup-restore'),
              onPressed: idle ? _restore : null,
              icon: spinnerOr(_busy == 'open' ? 'open' : 'restore', Icons.restore),
              label: Text(l10n.backupChooseFile),
            ),
          ]),
          const SizedBox(height: AppSpacing.md),
          section(l10n.backupExportTitle, l10n.backupExportInfo, [
            for (final csv in [true, false])
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(csv ? Icons.table_chart_outlined : Icons.data_object),
                title: Text(csv ? l10n.backupCsv : l10n.backupJson),
                subtitle: Text(csv ? l10n.backupCsvInfo : l10n.backupJsonInfo),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                    key: Key('export-${csv ? 'csv' : 'json'}-save'),
                    tooltip: l10n.backupSaveFile,
                    onPressed: idle ? () => _export(csv: csv, share: false) : null,
                    icon: spinnerOr('${csv ? 'csv' : 'json'}-save', Icons.save_alt),
                  ),
                  IconButton(
                    tooltip: l10n.backupShare,
                    onPressed: idle ? () => _export(csv: csv, share: true) : null,
                    icon: spinnerOr('${csv ? 'csv' : 'json'}-share', Icons.share),
                  ),
                ]),
              ),
          ]),
          const SizedBox(height: AppSpacing.lg),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.lock_outline, size: 18, color: scheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(l10n.backupPrivacy, style: theme.textTheme.bodySmall)),
          ]),
        ],
      ),
    );
  }
}

class _PassphraseDialog extends StatefulWidget {
  const _PassphraseDialog({required this.create});
  final bool create;

  @override
  State<_PassphraseDialog> createState() => _PassphraseDialogState();
}

class _PassphraseDialogState extends State<_PassphraseDialog> {
  final _pass = TextEditingController();
  final _again = TextEditingController();
  bool _hidden = true;
  String? _error;

  @override
  void dispose() {
    _pass.dispose();
    _again.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context);
    if (widget.create) {
      if (_pass.text.length < 8) {
        setState(() => _error = l10n.backupPassphraseShort);
        return;
      }
      if (_pass.text != _again.text) {
        setState(() => _error = l10n.backupPassphraseMismatch);
        return;
      }
    } else if (_pass.text.isEmpty) {
      return;
    }
    Navigator.of(context).pop(_pass.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.create ? l10n.backupPassphraseCreate : l10n.backupPassphraseEnter),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (widget.create) ...[
            Text(l10n.backupPassphraseWarning),
            const SizedBox(height: AppSpacing.md),
          ],
          TextField(
            key: const Key('passphrase'),
            controller: _pass,
            obscureText: _hidden,
            autofocus: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: l10n.backupPassphrase,
              errorText: widget.create ? null : _error,
              suffixIcon: IconButton(
                tooltip: l10n.backupShowPassphrase,
                icon: Icon(_hidden ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _hidden = !_hidden),
              ),
            ),
            onSubmitted: widget.create ? null : (_) => _submit(),
          ),
          if (widget.create)
            TextField(
              key: const Key('passphrase-again'),
              controller: _again,
              obscureText: _hidden,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                  labelText: l10n.backupPassphraseAgain, errorText: _error),
              onSubmitted: (_) => _submit(),
            ),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.actionCancel)),
        FilledButton(
            key: const Key('passphrase-ok'), onPressed: _submit, child: Text(l10n.backupContinue)),
      ],
    );
  }
}

class _RestoreDialog extends StatelessWidget {
  const _RestoreDialog({required this.contents});
  final BackupContents contents;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    return AlertDialog(
      title: Text(l10n.backupRestoreTitle),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Text(l10n.backupFound(
          DateFormat.yMMMd(locale).add_jm().format(contents.createdAt.toLocal()),
          contents.records,
          contents.photos,
        )),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.backupMergeInfo),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.backupReplaceInfo),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.actionCancel)),
        TextButton(
          key: const Key('restore-replace'),
          onPressed: () => Navigator.of(context).pop(RestoreMode.replace),
          child: Text(l10n.backupReplace),
        ),
        FilledButton(
          key: const Key('restore-merge'),
          onPressed: () => Navigator.of(context).pop(RestoreMode.merge),
          child: Text(l10n.backupMerge),
        ),
      ],
    );
  }
}
