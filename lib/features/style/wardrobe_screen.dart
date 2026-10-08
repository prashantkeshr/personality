import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/snapshot_repository.dart' show preparePhoto;
import '../../domain/services/outfit_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/visual/reveal.dart';
import '../../shared/visual/scan_overlay.dart';
import '../../shared/widgets/empty_state.dart';
import '../camera/camera_providers.dart';
import '../camera/camera_source.dart';
import '../camera/portrait_lock.dart';
import '../health/widgets/add_record_sheet.dart' show confirmDelete;
import 'style_labels.dart';
import 'style_providers.dart';
import 'style_widgets.dart';

class WardrobeScreen extends ConsumerStatefulWidget {
  const WardrobeScreen({super.key});

  @override
  ConsumerState<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends ConsumerState<WardrobeScreen> {
  GarmentCategory? _filter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final all = ref.watch(wardrobeProvider).value ?? const <WardrobeItem>[];
    final photos = ref.watch(wardrobePhotosProvider).value ?? const {};
    final items = _filter == null ? all : all.where((i) => i.category == _filter).toList();
    final present = {for (final i in all) i.category};

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.featureWardrobe),
        actions: [
          TextButton.icon(
            onPressed: all.length < 2 ? null : () => context.push(AppRoutes.outfits),
            icon: const Icon(Icons.auto_awesome_outlined),
            label: Text(l10n.outfitIdeas),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          showDragHandle: true,
          builder: (_) => const AddGarmentSheet(),
        ),
        icon: const Icon(Icons.add),
        label: Text(l10n.wardrobeAdd),
      ),
      body: all.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.checkroom_outlined,
                title: l10n.featureWardrobe,
                message: l10n.wardrobeEmpty,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: Text('${l10n.filterAll} · ${all.length}'),
                        selected: _filter == null,
                        onSelected: (_) => setState(() => _filter = null),
                      ),
                    ),
                    for (final c in GarmentCategory.values)
                      if (present.contains(c))
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: ChoiceChip(
                            label: Text(l10n.categoryName(c)),
                            selected: _filter == c,
                            onSelected: (_) => setState(() => _filter = c),
                          ),
                        ),
                  ]),
                ),
                const SizedBox(height: AppSpacing.md),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 0.8,
                  children: [
                    for (final (i, item) in items.indexed)
                      Reveal(
                        index: i.clamp(0, 12),
                        child: GestureDetector(
                          onTap: () => _actions(context, item),
                          child: GarmentTile(item: item, photo: photos[item.id]),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(l10n.wardrobePrivacy, style: theme.textTheme.bodySmall),
              ],
            ),
    );
  }

  void _actions(BuildContext context, WardrobeItem item) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            title: Text(item.name, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text([
              l10n.categoryName(item.category),
              l10n.patternName(item.pattern),
              l10n.formalityName(item.formality),
            ].join(' · ')),
          ),
          ListTile(
            leading: Icon(item.favorite ? Icons.favorite : Icons.favorite_border),
            title: Text(item.favorite ? l10n.favoriteRemove : l10n.favoriteAdd),
            onTap: () {
              ref.read(styleRepositoryProvider).setFavorite(item.id, !item.favorite);
              Navigator.pop(sheet);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(l10n.actionDelete),
            onTap: () async {
              Navigator.pop(sheet);
              if (await confirmDelete(context)) {
                await ref.read(styleRepositoryProvider).deleteItem(item.id);
              }
            },
          ),
        ]),
      ),
    );
  }
}

class AddGarmentSheet extends ConsumerStatefulWidget {
  const AddGarmentSheet({super.key});

  @override
  ConsumerState<AddGarmentSheet> createState() => _AddGarmentSheetState();
}

class _AddGarmentSheetState extends ConsumerState<AddGarmentSheet> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  GarmentCategory _category = GarmentCategory.top;
  GarmentPattern _pattern = GarmentPattern.solid;
  String _hex = '#1F2A44';
  double _formality = 3;
  final _occasions = <Occasion>{};
  Uint8List? _photo;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final raw = await context.push<Uint8List>(AppRoutes.garmentPhoto);
    if (raw == null) return;
    final prepared = await compute(preparePhoto, raw);
    if (prepared == null || !mounted) return;
    final sampled = await compute(sampleGarmentColor, prepared.jpeg);
    setState(() {
      _photo = prepared.jpeg;
      if (sampled != null) _hex = sampled;
    });
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(styleRepositoryProvider).addItem(
            name: _name.text,
            category: _category,
            colorHex: _hex,
            pattern: _pattern,
            formality: _formality.round(),
            occasions: _occasions,
            photo: _photo,
          );
      navigator.pop();
    } catch (e, st) {
      AppLogger.error('wardrobe.add', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l10n.recordSaveError)));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final colors = ref.watch(garmentColorsProvider).value ?? const <NamedColor>[];
    final preview = WardrobeItem(
      id: 'preview',
      name: _name.text.isEmpty ? l10n.categoryName(_category) : _name.text,
      category: _category,
      colorHex: _hex,
      pattern: _pattern,
      formality: _formality.round(),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl),
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.wardrobeAdd, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.md),
              Row(children: [
                SizedBox(
                  width: 96,
                  height: 120,
                  child: GarmentTile(item: preview, photo: _photo, showName: false),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        key: const Key('garment-name'),
                        controller: _name,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(labelText: l10n.garmentName),
                        onChanged: (_) => setState(() {}),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? l10n.validationRequired
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      OutlinedButton.icon(
                        onPressed: _takePhoto,
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: Text(_photo == null ? l10n.garmentPhoto : l10n.garmentRetakePhoto),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.garmentCategory, style: theme.textTheme.labelLarge),
              Wrap(spacing: AppSpacing.xs, children: [
                for (final c in GarmentCategory.values)
                  ChoiceChip(
                    label: Text(l10n.categoryName(c)),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = c),
                  ),
              ]),
              const SizedBox(height: AppSpacing.md),
              Text(_photo == null ? l10n.garmentColour : l10n.garmentColourFromPhoto,
                  style: theme.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
                for (final (i, c) in colors.indexed)
                  Swatch(
                    hex: c.hex,
                    index: i.clamp(0, 10),
                    size: 36,
                    label: c.label(lang),
                    selected: c.hex == _hex,
                    onTap: () => setState(() => _hex = c.hex),
                  ),
              ]),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.garmentPattern, style: theme.textTheme.labelLarge),
              Wrap(spacing: AppSpacing.xs, children: [
                for (final p in GarmentPattern.values)
                  ChoiceChip(
                    label: Text(l10n.patternName(p)),
                    selected: _pattern == p,
                    onSelected: (_) => setState(() => _pattern = p),
                  ),
              ]),
              const SizedBox(height: AppSpacing.md),
              Text('${l10n.garmentFormality}: ${l10n.formalityName(_formality.round())}',
                  style: theme.textTheme.labelLarge),
              Slider(
                value: _formality,
                min: 1,
                max: 5,
                divisions: 4,
                label: l10n.formalityName(_formality.round()),
                onChanged: (v) => setState(() => _formality = v),
              ),
              Text(l10n.garmentOccasions, style: theme.textTheme.labelLarge),
              Text(l10n.garmentOccasionsHelp, style: theme.textTheme.bodySmall),
              Wrap(spacing: AppSpacing.xs, children: [
                for (final o in Occasion.values)
                  FilterChip(
                    label: Text(l10n.occasionName(o)),
                    selected: _occasions.contains(o),
                    onSelected: (on) =>
                        setState(() => on ? _occasions.add(o) : _occasions.remove(o)),
                  ),
              ]),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(l10n.actionSave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Takes one garment photo (back camera) and returns its bytes.
class GarmentPhotoScreen extends ConsumerStatefulWidget {
  const GarmentPhotoScreen({super.key});

  @override
  ConsumerState<GarmentPhotoScreen> createState() => _GarmentPhotoScreenState();
}

class _GarmentPhotoScreenState extends ConsumerState<GarmentPhotoScreen> {
  late final CameraSource _camera = ref.read(cameraSourceProvider);
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    PortraitLock.enter();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _camera.start(CameraLens.back, ref.read(cameraPowerModeProvider), (_) {}));
  }

  @override
  void dispose() {
    PortraitLock.exit();
    _camera.stop();
    super.dispose();
  }

  Future<void> _shoot() async {
    setState(() => _busy = true);
    final bytes = await _camera.capturePhoto();
    if (!mounted) return;
    if (bytes == null) {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).cameraFailed)));
      return;
    }
    context.pop(bytes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.garmentPhoto)),
      body: ValueListenableBuilder<CameraSourceState>(
        valueListenable: _camera.state,
        builder: (context, cam, _) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Stack(fit: StackFit.expand, children: [
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
                  ScanOverlay(
                      color: Theme.of(context).colorScheme.primary, scanning: false),
                ]),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.garmentPhotoTip),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: cam.running && !_busy ? _shoot : null,
              icon: const Icon(Icons.camera),
              label: Text(l10n.snapCapture),
            ),
          ],
        ),
      ),
    );
  }
}
