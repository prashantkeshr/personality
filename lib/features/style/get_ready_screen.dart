import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/app_database.dart';
import '../../data/repositories/style_repository.dart';
import '../../domain/entities/body.dart';
import '../../domain/entities/grooming.dart';
import '../../domain/services/get_ready.dart';
import '../../domain/services/health_stats.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/visual/outfit_silhouette.dart';
import '../face/face_providers.dart';
import '../health/body_providers.dart';
import '../health/health_providers.dart';
import 'style_providers.dart';
import 'style_studio_labels.dart';
import 'style_studio_providers.dart';

const _stateKey = 'ready.state';

/// "Get ready for…": one checklist for an occasion, ticks kept for the day.
class GetReadyScreen extends ConsumerStatefulWidget {
  const GetReadyScreen({super.key});

  @override
  ConsumerState<GetReadyScreen> createState() => _GetReadyScreenState();
}

class _GetReadyScreenState extends ConsumerState<GetReadyScreen> {
  ReadyEvent? _event;
  final _done = <String>{};
  bool _restored = false;

  int get _today => Days.key(ref.read(clockProvider)());

  Future<void> _restore() async {
    _restored = true;
    final db = ref.read(appDatabaseProvider);
    final row = await (db.select(db.appSettingsEntries)..where((t) => t.key.equals(_stateKey))).getSingleOrNull();
    if (row == null || !mounted) return;
    try {
      final j = jsonDecode(row.value) as Map<String, dynamic>;
      if (j['day'] != _today) return; // a new day starts fresh
      setState(() {
        _event = ReadyEvent.values.asNameMap()[j['event']];
        _done.addAll((j['done'] as List).cast<String>());
      });
    } catch (_) {}
  }

  Future<void> _persist() {
    final db = ref.read(appDatabaseProvider);
    return db.into(db.appSettingsEntries).insertOnConflictUpdate(AppSettingsEntriesCompanion(
        key: const Value(_stateKey),
        value: Value(jsonEncode({'day': _today, 'event': _event?.name, 'done': _done.toList()})),
        updatedAt: Value(DateTime.now().toUtc().millisecondsSinceEpoch)));
  }

  void _pick(ReadyEvent e) {
    setState(() {
      if (_event != e) _done.clear();
      _event = e;
    });
    _persist();
  }

  void _toggle(String id, bool on) {
    setState(() => on ? _done.add(id) : _done.remove(id));
    _persist();
  }

  @override
  Widget build(BuildContext context) {
    if (!_restored) _restore();
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fit = ref.watch(styleFitProvider);
    final picks = ref.watch(groomingPicksProvider);
    final grooming = ref.watch(groomingContentProvider).value;
    final region = ref.watch(profileProvider).value?.region;
    final ctx = ReadyContext(
      wardrobe: ref.watch(wardrobeProvider).value ?? const [],
      plannedToday: ref.watch(plannedTodayProvider),
      profile: ref.watch(styleProfileProvider).value ?? const StyleProfile(),
      menswear: fit == StyleFit.menswear,
      womenswear: fit == StyleFit.womenswear,
      hairStyleId: picks.hair,
      beardStyleId: picks.beard,
      hotClimate: region?.hotClimate ?? true,
    );
    final list = _event == null ? const <ReadyItem>[] : GetReady.checklist(_event!, ctx);
    String styleName(String? id) =>
        id == null ? '' : GroomingContent.pick(grooming?.items[id]?.name ?? {'en': id}, lang);
    final done = list.where((i) => _done.contains(i.id)).length;

    return Scaffold(
      appBar: AppBar(title: Text(l.featureGetReady)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
        children: [
          Text(l.readyIntro, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.md),
          Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
            for (final e in ReadyEvent.values)
              ChoiceChip(
                key: Key('ready-${e.name}'),
                avatar: Icon(readyEventIcon(e), size: 18),
                label: Text(l.readyEventName(e)),
                selected: _event == e,
                onSelected: (_) => _pick(e),
              ),
          ]),
          if (_event != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(children: [
              Expanded(child: Text(l.readyProgress(done, list.length), style: theme.textTheme.titleMedium)),
              if (done == list.length && list.isNotEmpty) Icon(Icons.verified, color: scheme.primary),
            ]),
            const SizedBox(height: AppSpacing.xs),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: list.isEmpty ? 0 : done / list.length, minHeight: 6),
            ),
            for (final section in ReadySection.values)
              if (list.any((i) => i.section == section)) ...[
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.xs),
                  child: Text(l.readySectionName(section), style: theme.textTheme.titleSmall),
                ),
                for (final item in list.where((i) => i.section == section))
                  Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Column(children: [
                      CheckboxListTile(
                        key: Key('ready-item-${item.id}'),
                        value: _done.contains(item.id),
                        onChanged: (v) => _toggle(item.id, v ?? false),
                        title: Text(l.readyText(item.id, styleName(item.styleId))),
                        subtitle: item.outfit == null ? null : Text(item.outfit!.map((i) => i.name).join(' · ')),
                        secondary: item.route == null
                            ? null
                            : IconButton(
                                tooltip: l.readyOpen,
                                icon: const Icon(Icons.open_in_new),
                                onPressed: () => context.push(item.route!),
                              ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      if (item.outfit != null)
                        SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: OutfitSilhouette(items: item.outfit!, womenswear: ctx.womenswear),
                          ),
                        ),
                    ]),
                  ),
              ],
          ],
        ],
      ),
    );
  }
}
