import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/snapshot_repository.dart';
import '../../domain/entities/health.dart';
import '../../domain/entities/routine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/visual/reveal.dart';
import '../../shared/visual/scan_overlay.dart';
import '../../shared/widgets/empty_state.dart';
import '../camera/camera_providers.dart';
import '../camera/camera_source.dart';
import '../camera/portrait_lock.dart';
import '../health/widgets/add_record_sheet.dart' show confirmDelete;
import '../routines/routine_providers.dart';
import 'snapshot_providers.dart';

String snapshotKindLabel(AppLocalizations l10n, SnapshotKind k) => switch (k) {
      SnapshotKind.face => l10n.snapFace,
      SnapshotKind.bodyFront => l10n.snapBodyFront,
      SnapshotKind.bodySide => l10n.snapBodySide,
    };

/// Progress snapshots: an opt-in, encrypted, on-device photo timeline for
/// seeing face and body changes over time.
class SnapshotsScreen extends ConsumerStatefulWidget {
  const SnapshotsScreen({super.key});

  @override
  ConsumerState<SnapshotsScreen> createState() => _SnapshotsScreenState();
}

class _SnapshotsScreenState extends ConsumerState<SnapshotsScreen> {
  SnapshotKind _kind = SnapshotKind.face;

  Future<void> _addReminder() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final repo = ref.read(routineRepositoryProvider);
      final id = await repo.createRoutine(
          l10n.snapReminderRoutine, const Weekdays(1 << 6)); // Sundays
      await repo.addItem(id, 9 * 60, l10n.snapReminderItem, RoutineItemKind.custom);
      messenger.showSnackBar(SnackBar(content: Text(l10n.snapReminderAdded)));
    } catch (e, st) {
      AppLogger.error('snapshot.reminder', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final consent = ref.watch(snapshotConsentProvider).value;
    final list = ref.watch(snapshotsProvider(_kind)).value ?? const <Snapshot>[];
    final tag = Localizations.localeOf(context).toLanguageTag();

    if (consent == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!consent) {
      return _ConsentView(onAccept: () async {
        await setSnapshotConsent(ref.read(appDatabaseProvider), true);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.featureProgressSnapshots),
        actions: [
          PopupMenuButton<int>(
            onSelected: (v) async {
              if (v == 0) {
                await _addReminder();
              } else if (v == 1 && await confirmDelete(context)) {
                await ref.read(snapshotRepositoryProvider).deleteAll();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 0, child: Text(l10n.snapWeeklyReminder)),
              PopupMenuItem(value: 1, child: Text(l10n.snapDeleteAll)),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('${AppRoutes.snapshots}/capture?kind=${_kind.name}'),
        icon: const Icon(Icons.photo_camera_outlined),
        label: Text(l10n.snapTake),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
        children: [
          SegmentedButton<SnapshotKind>(
            segments: [
              for (final k in SnapshotKind.values)
                ButtonSegment(value: k, label: Text(snapshotKindLabel(l10n, k))),
            ],
            selected: {_kind},
            showSelectedIcon: false,
            onSelectionChanged: (s) => setState(() => _kind = s.single),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(children: [
            const Icon(Icons.lock_outline, size: 16),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: Text(l10n.snapPrivacyShort, style: theme.textTheme.bodySmall)),
          ]),
          const SizedBox(height: AppSpacing.md),
          if (list.length >= 2)
            FilledButton.tonalIcon(
              onPressed: () => context.push(
                  '${AppRoutes.snapshots}/compare?kind=${_kind.name}'),
              icon: const Icon(Icons.compare),
              label: Text(l10n.snapCompare),
            ),
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xl),
              child: EmptyState(
                icon: Icons.photo_library_outlined,
                title: snapshotKindLabel(l10n, _kind),
                message: l10n.snapEmpty,
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.75,
            children: [
              for (final (i, s) in list.indexed)
                Reveal(
                  index: i,
                  child: GestureDetector(
                    onLongPress: () async {
                      if (await confirmDelete(context)) {
                        await ref.read(snapshotRepositoryProvider).delete(s.id);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      child: Stack(fit: StackFit.expand, children: [
                        Image.memory(s.jpeg, fit: BoxFit.cover, gaplessPlayback: true),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            color: Colors.black54,
                            child: Text(
                              DateFormat.yMMMd(tag).format(s.takenAt.toLocal()),
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
            ],
          ),
          if (list.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(l10n.snapLongPressDelete, style: theme.textTheme.bodySmall),
            ),
        ],
      ),
    );
  }
}

class _ConsentView extends StatelessWidget {
  const _ConsentView({required this.onAccept});

  final Future<void> Function() onAccept;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.featureProgressSnapshots)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          Icon(Icons.photo_library_outlined, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.snapConsentTitle, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.md),
          for (final t in [
            l10n.snapConsentStored,
            l10n.snapConsentNeverUploaded,
            l10n.snapConsentOptIn,
            l10n.snapConsentDelete,
          ])
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle_outline),
              title: Text(t),
            ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(onPressed: onAccept, child: Text(l10n.snapConsentAccept)),
          TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(l10n.actionCancel)),
        ],
      ),
    );
  }
}

/// Takes a snapshot with a guide and a faint "ghost" of the previous
/// snapshot so photos line up over time.
class SnapshotCaptureScreen extends ConsumerStatefulWidget {
  const SnapshotCaptureScreen({super.key, required this.kind});

  final SnapshotKind kind;

  @override
  ConsumerState<SnapshotCaptureScreen> createState() =>
      _SnapshotCaptureScreenState();
}

class _SnapshotCaptureScreenState extends ConsumerState<SnapshotCaptureScreen> {
  late final CameraSource _camera = ref.read(cameraSourceProvider);
  late CameraLens _lens =
      widget.kind == SnapshotKind.face ? CameraLens.front : CameraLens.back;
  Uint8List? _taken;
  int? _countdown;
  Timer? _timer;
  bool _saving = false;
  bool _ghost = true;

  @override
  void initState() {
    super.initState();
    PortraitLock.enter();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void dispose() {
    PortraitLock.exit();
    _timer?.cancel();
    _camera.stop();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() => _taken = null);
    // Preview only: no frame analysis is needed for a snapshot.
    await _camera.start(_lens, ref.read(cameraPowerModeProvider), (_) {});
  }

  void _shoot() {
    _timer?.cancel();
    setState(() => _countdown = 3);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!mounted) return t.cancel();
      if ((_countdown ?? 0) > 1) {
        setState(() => _countdown = _countdown! - 1);
        return;
      }
      t.cancel();
      setState(() => _countdown = null);
      final bytes = await _camera.capturePhoto();
      if (!mounted) return;
      if (bytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).cameraFailed)));
        return;
      }
      await _camera.stop();
      setState(() => _taken = bytes);
    });
  }

  Future<void> _save() async {
    final bytes = _taken;
    if (bytes == null) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      final id = await ref.read(snapshotRepositoryProvider).add(widget.kind, bytes);
      if (id == null) throw StateError('decode');
      messenger.showSnackBar(SnackBar(content: Text(l10n.snapSaved)));
      navigator.pop();
    } catch (e, st) {
      AppLogger.error('snapshot.save', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final previous = ref.watch(snapshotsProvider(widget.kind)).value;
    final ghost = previous == null || previous.isEmpty ? null : previous.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(snapshotKindLabel(l10n, widget.kind)),
        actions: [
          if (_taken == null)
            IconButton(
              tooltip: l10n.cameraSwitch,
              icon: const Icon(Icons.cameraswitch_outlined),
              onPressed: () {
                setState(() => _lens =
                    _lens == CameraLens.front ? CameraLens.back : CameraLens.front);
                _start();
              },
            ),
        ],
      ),
      body: ValueListenableBuilder<CameraSourceState>(
        valueListenable: _camera.state,
        builder: (context, cam, _) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: _taken != null
                    ? Image.memory(_taken!, fit: BoxFit.cover)
                    : Stack(fit: StackFit.expand, children: [
                        if (cam.running)
                          FittedBox(
                            fit: BoxFit.cover,
                            clipBehavior: Clip.hardEdge,
                            child: SizedBox(
                              width: 300,
                              height: 300 * (cam.previewAspectRatio ?? 4 / 3),
                              child: _camera.preview(),
                            ),
                          )
                        else
                          const ColoredBox(color: Colors.black),
                        if (ghost != null && _ghost)
                          Opacity(
                            opacity: 0.3,
                            child: Image.memory(ghost.jpeg, fit: BoxFit.cover),
                          ),
                        ScanOverlay(
                          color: scheme.primary,
                          scanning: false,
                          oval: widget.kind == SnapshotKind.face,
                        ),
                        if (_countdown != null)
                          Center(
                            child: Text('$_countdown',
                                style: const TextStyle(
                                    fontSize: 110,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    shadows: [Shadow(blurRadius: 16)])),
                          ),
                      ]),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (cam.problem != null)
              Text(l10n.cameraPermissionDenied)
            else if (_taken == null) ...[
              if (ghost != null)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.snapGhost),
                  subtitle: Text(l10n.snapGhostHelp),
                  value: _ghost,
                  onChanged: (v) => setState(() => _ghost = v),
                ),
              Text(widget.kind == SnapshotKind.face
                  ? l10n.snapTipFace
                  : l10n.snapTipBody),
              const SizedBox(height: AppSpacing.md),
              FilledButton.icon(
                onPressed: cam.running && _countdown == null ? _shoot : null,
                icon: const Icon(Icons.camera),
                label: Text(l10n.snapCapture),
              ),
            ] else
              Row(children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: const Icon(Icons.lock_outline),
                    label: Text(l10n.snapSaveEncrypted),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _saving ? null : _start,
                    icon: const Icon(Icons.replay),
                    label: Text(l10n.postureRetake),
                  ),
                ),
              ]),
          ],
        ),
      ),
    );
  }
}

/// Before/after comparison with a draggable divider.
class SnapshotCompareScreen extends ConsumerStatefulWidget {
  const SnapshotCompareScreen({super.key, required this.kind});

  final SnapshotKind kind;

  @override
  ConsumerState<SnapshotCompareScreen> createState() =>
      _SnapshotCompareScreenState();
}

class _SnapshotCompareScreenState extends ConsumerState<SnapshotCompareScreen> {
  double _split = 0.5;
  int? _before;
  int _after = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tag = Localizations.localeOf(context).toLanguageTag();
    final list = ref.watch(snapshotsProvider(widget.kind)).value ?? const <Snapshot>[];
    if (list.length < 2) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text(l10n.snapEmpty)));
    }
    final before = list[(_before ?? list.length - 1).clamp(0, list.length - 1)];
    final after = list[_after.clamp(0, list.length - 1)];
    String date(Snapshot s) => DateFormat.yMMMd(tag).format(s.takenAt.toLocal());

    return Scaffold(
      appBar: AppBar(title: Text(l10n.snapCompare)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          LayoutBuilder(builder: (context, c) {
            final w = c.maxWidth;
            return GestureDetector(
              onHorizontalDragUpdate: (d) => setState(
                  () => _split = (_split + d.delta.dx / w).clamp(0.0, 1.0)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Stack(fit: StackFit.expand, children: [
                    Image.memory(after.jpeg, fit: BoxFit.cover, gaplessPlayback: true),
                    ClipRect(
                      clipper: _LeftClipper(_split),
                      child: Image.memory(before.jpeg,
                          fit: BoxFit.cover, gaplessPlayback: true),
                    ),
                    Positioned(
                      left: w * _split - 1.5,
                      top: 0,
                      bottom: 0,
                      child: Container(width: 3, color: Colors.white),
                    ),
                    Positioned(
                      left: (w * _split - 22).clamp(0.0, w - 44),
                      top: 0,
                      bottom: 0,
                      child: const Center(
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.compare_arrows, color: Colors.black87),
                        ),
                      ),
                    ),
                    Positioned(
                        left: 8, top: 8, child: _Tag('${l10n.snapBefore} · ${date(before)}')),
                    Positioned(
                        right: 8, top: 8, child: _Tag('${l10n.snapAfter} · ${date(after)}')),
                  ]),
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.snapCompareHelp, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.snapBefore, style: Theme.of(context).textTheme.labelLarge),
          _Picker(list: list, selected: list.indexOf(before), onPick: (i) => setState(() => _before = i)),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.snapAfter, style: Theme.of(context).textTheme.labelLarge),
          _Picker(list: list, selected: list.indexOf(after), onPick: (i) => setState(() => _after = i)),
        ],
      ),
    );
  }
}

class _LeftClipper extends CustomClipper<Rect> {
  _LeftClipper(this.f);
  final double f;
  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * f, size.height);
  @override
  bool shouldReclip(_LeftClipper o) => o.f != f;
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
      );
}

class _Picker extends StatelessWidget {
  const _Picker({required this.list, required this.selected, required this.onPick});

  final List<Snapshot> list;
  final int selected;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => onPick(i),
          child: Container(
            width: 62,
            decoration: BoxDecoration(
              border: Border.all(
                  color: i == selected ? primary : Colors.transparent, width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.memory(list[i].jpeg, fit: BoxFit.cover, gaplessPlayback: true),
            ),
          ),
        ),
      ),
    );
  }
}
