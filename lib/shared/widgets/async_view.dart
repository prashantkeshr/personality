import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../l10n/app_localizations.dart';
import 'empty_state.dart';

/// Renders an [AsyncValue] with consistent loading and error states.
/// Errors are logged by type only and shown as a friendly message.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({super.key, required this.value, required this.data});

  final AsyncValue<T> value;
  final Widget Function(T data) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) {
        AppLogger.error('async_view', e, st);
        final l10n = AppLocalizations.of(context);
        return Center(
          child: EmptyState(
            icon: Icons.error_outline,
            title: l10n.loadErrorTitle,
            message: l10n.loadErrorBody,
          ),
        );
      },
    );
  }
}
