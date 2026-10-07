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
      appBar: AppBar(title: Text(l10n.postureHistory)),
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
