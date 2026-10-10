import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/posture_repository.dart';
import '../../domain/services/posture_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/body_format.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/provenance_chip.dart';
import '../health/widgets/add_record_sheet.dart' show confirmDelete;
import 'posture_labels.dart';
import 'posture_providers.dart';
import 'posture_screen.dart' show MetricTile;

/// Saved posture checks, newest first, each compared with the previous
/// check of the same view (spec §17 "Compare").
class PostureHistoryScreen extends ConsumerWidget {
  const PostureHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tag = Localizations.localeOf(context).toLanguageTag();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.postureHistory),
        actions: [
          TextButton.icon(
            key: const Key('posture-compare'),
            icon: const Icon(Icons.compare_arrows),
            label: Text(l10n.postureCompare),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => const PostureCompareScreen())),
          ),
        ],
      ),
      body: AsyncView(
        value: ref.watch(postureHistoryProvider),
        data: (sessions) {
          if (sessions.isEmpty) {
            return Center(
              child: EmptyState(
                icon: Icons.accessibility_new,
                title: l10n.postureHistory,
                message: l10n.postureHistoryEmpty,
              ),
            );
          }
          SavedPosture? previousOf(int i) {
            for (var j = i + 1; j < sessions.length; j++) {
              if (sessions[j].result.view == sessions[i].result.view) {
                return sessions[j];
              }
            }
            return null;
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: sessions.length,
            itemBuilder: (context, i) {
              final s = sessions[i];
              final prev = previousOf(i);
              final flagged =
                  s.result.metrics.where((m) => m.band != AlignmentBand.aligned).length;
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ExpansionTile(
                  title: Text(
                      '${DateFormat.yMMMd(tag).format(s.recordedAt.toLocal())} · ${DateFormat.jm(tag).format(s.recordedAt.toLocal())}'),
                  subtitle: Text([
                    l10n.viewLabel(s.result.view),
                    l10n.confidenceLabel(s.result.confidence),
                    l10n.postureFlaggedCount(flagged),
                  ].join(' · ')),
                  children: [
                    for (final m in s.result.metrics)
                      MetricTile(
                        metric: m,
                        change: prev?.result[m.metric] == null
                            ? null
                            : m.degrees - prev!.result[m.metric]!.degrees,
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                      child: Row(
                        children: [
                          ProvenanceChip(
                              source: s.result.source,
                              confidence: s.result.confidence),
                          const Spacer(),
                          IconButton(
                            tooltip: l10n.actionDelete,
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              final messenger = ScaffoldMessenger.of(context);
                              try {
                                if (await confirmDelete(context)) {
                                  await ref
                                      .read(postureRepositoryProvider)
                                      .delete(s.id);
                                }
                              } catch (e, st) {
                                AppLogger.error('posture.delete', e, st);
                                messenger.showSnackBar(SnackBar(
                                    content: Text(l10n.recordSaveError)));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Two saved checks of the same view side by side, with the change per
/// metric and a reminder to keep the setup the same.
class PostureCompareScreen extends ConsumerStatefulWidget {
  const PostureCompareScreen({super.key});

  @override
  ConsumerState<PostureCompareScreen> createState() =>
      _PostureCompareScreenState();
}

class _PostureCompareScreenState extends ConsumerState<PostureCompareScreen> {
  PostureView? _view;
  String? _earlier;
  String? _later;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tag = Localizations.localeOf(context).toLanguageTag();
    final all = ref.watch(postureHistoryProvider).value ?? const <SavedPosture>[];
    final views = {
      for (final v in PostureView.values)
        if (all.where((s) => s.result.view == v).length >= 2) v
    };
    final view = _view ?? (views.isEmpty ? null : views.first);
    // Oldest first.
    final sessions = [
      for (final s in all.reversed)
        if (s.result.view == view) s
    ];
    String label(SavedPosture s) =>
        DateFormat.yMMMd(tag).add_jm().format(s.recordedAt.toLocal());
    SavedPosture? byId(String? id) {
      for (final s in sessions) {
        if (s.id == id) return s;
      }
      return null;
    }

    final a = byId(_earlier) ?? (sessions.isEmpty ? null : sessions.first);
    final b = byId(_later) ?? (sessions.isEmpty ? null : sessions.last);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.postureCompareTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Card(
            color: scheme.secondaryContainer,
            child: ListTile(
              leading: const Icon(Icons.straighten),
              title: Text(l10n.postureCompareSetup),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (view == null || a == null || b == null)
            Text(l10n.postureCompareNeedTwo)
          else ...[
            if (views.length > 1)
              SegmentedButton<PostureView>(
                segments: [
                  for (final v in views)
                    ButtonSegment(value: v, label: Text(l10n.viewLabel(v))),
                ],
                selected: {view},
                onSelectionChanged: (s) => setState(() {
                  _view = s.first;
                  _earlier = _later = null;
                }),
              ),
            const SizedBox(height: AppSpacing.md),
            for (final (title, current, set) in [
              (l10n.postureCompareEarlier, a, (String? id) => _earlier = id),
              (l10n.postureCompareLater, b, (String? id) => _later = id),
            ]) ...[
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: current.id,
                decoration: InputDecoration(labelText: title),
                items: [
                  for (final s in sessions)
                    DropdownMenuItem(value: s.id, child: Text(label(s))),
                ],
                onChanged: (id) => setState(() => set(id)),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Table(
                  columnWidths: const {0: FlexColumnWidth(2)},
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      const SizedBox(),
                      for (final h in [
                        l10n.postureCompareEarlier,
                        l10n.postureCompareLater,
                        l10n.postureCompareChange,
                      ])
                        Text(h,
                            textAlign: TextAlign.end,
                            style: theme.textTheme.labelMedium),
                    ]),
                    for (final m in a.result.metrics)
                      if (b.result[m.metric] case final later?)
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(l10n.postureMetricName(m.metric)),
                          ),
                          Text('${m.degrees.toStringAsFixed(1)}°',
                              textAlign: TextAlign.end),
                          Text('${later.degrees.toStringAsFixed(1)}°',
                              textAlign: TextAlign.end),
                          Text(
                              '${later.degrees - m.degrees >= 0 ? '+' : '−'}'
                              '${(later.degrees - m.degrees).abs().toStringAsFixed(1)}°',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: later.degrees.abs() < m.degrees.abs()
                                      ? scheme.primary
                                      : null,
                                  fontWeight: FontWeight.w600)),
                        ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ProvenanceChip(source: b.result.source, confidence: b.result.confidence),
          ],
        ],
      ),
    );
  }
}
