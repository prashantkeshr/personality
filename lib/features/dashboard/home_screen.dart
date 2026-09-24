import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/body_format.dart';
import '../../shared/widgets/empty_state.dart';
import '../health/body_providers.dart';

/// Today-first dashboard (spec §63). Summary cards appear as features ship.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.clock = DateTime.now});

  final DateTime Function() clock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat.yMMMMEEEEd(locale).format(clock());

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Semantics(
            header: true,
            child: Text(l10n.todayTitle, style: theme.textTheme.headlineSmall),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(date,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.xl),
          const _BodySummary(),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: EmptyState(
              icon: Icons.today_outlined,
              title: l10n.homeEmptyTitle,
              message: l10n.homeEmptyBody,
            ),
          ),
        ],
      ),
    );
  }
}

class _BodySummary extends ConsumerWidget {
  const _BodySummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format =
        BodyFormat.of(context, ref.watch(settingsControllerProvider).unitSystem);
    final height = ref.watch(primaryHeightProvider).value;
    final weights = ref.watch(weightRecordsProvider).value ?? const [];

    if (height == null) {
      return Card(
        child: EmptyState(
          icon: Icons.height,
          title: l10n.heightTitle,
          message: l10n.heightEmpty,
          action: FilledButton(
            onPressed: () => context.push(AppRoutes.height),
            child: Text(l10n.heightAdd),
          ),
        ),
      );
    }

    Widget metric(String label, String value, String route) => Expanded(
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.push(route),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Text(value, style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            ),
          ),
        );

    return Row(
      children: [
        metric(l10n.heightTitle, format.height(height.value), AppRoutes.height),
        const SizedBox(width: AppSpacing.md),
        metric(
          l10n.weightTitle,
          weights.isEmpty
              ? l10n.measurementNotRecorded
              : format.weight(weights.first.value),
          AppRoutes.weight,
        ),
      ],
    );
  }
}
