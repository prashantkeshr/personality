import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/body_format.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/empty_state.dart';
import '../health/widgets/add_record_sheet.dart' show confirmDelete;
import 'face_labels.dart';
import 'face_providers.dart';
import 'face_screen.dart' show FaceResultView;

/// Saved face-shape estimates, newest first. Proportions only.
class FaceHistoryScreen extends ConsumerWidget {
  const FaceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tag = Localizations.localeOf(context).toLanguageTag();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.faceHistory)),
      body: AsyncView(
        value: ref.watch(faceHistoryProvider),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: EmptyState(
                icon: Icons.face,
                title: l10n.faceHistory,
                message: l10n.faceHistoryEmpty,
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              for (final s in list)
                Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: ExpansionTile(
                    title: Text(l10n.faceShapeName(s.result.shape)),
                    subtitle: Text([
                      DateFormat.yMMMd(tag).format(s.recordedAt.toLocal()),
                      l10n.confidenceLabel(s.result.confidence),
                    ].join(' · ')),
                    childrenPadding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      FaceResultView(result: s.result),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: IconButton(
                          tooltip: l10n.actionDelete,
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            try {
                              if (await confirmDelete(context)) {
                                await ref.read(faceRepositoryProvider).delete(s.id);
                              }
                            } catch (e, st) {
                              AppLogger.error('face.delete', e, st);
                              messenger.showSnackBar(
                                  SnackBar(content: Text(l10n.recordSaveError)));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
