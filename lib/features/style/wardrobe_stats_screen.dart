import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/outfit_engine.dart';
import '../../domain/services/wardrobe_stats.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/visual/outfit_silhouette.dart';
import '../health/body_providers.dart';
import '../health/widgets/health_widgets.dart';
import 'style_labels.dart';
import 'style_providers.dart';
import 'style_studio_labels.dart';
import 'style_studio_providers.dart';

/// What gets worn, what doesn't, cost per wear and what's missing.
class WardrobeStatsScreen extends ConsumerWidget {
  const WardrobeStatsScreen({super.key});

  Future<void> _editPrice(BuildContext context, WidgetRef ref, WardrobeItem item) async {
    final result = await showDialog<double>(context: context, builder: (_) => _PriceDialog(item: item));
    if (result == null) return;
    await ref.read(styleRepositoryProvider).setPrice(item.id, result < 0 ? null : result);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final stats = ref.watch(wardrobeStatsProvider);
    final money = moneyFormat(ref.watch(profileProvider).value?.region, locale);

    Widget tile(String value, String label) => Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(children: [
                Text(value, style: theme.textTheme.headlineSmall?.copyWith(color: scheme.primary)),
                Text(label, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
              ]),
            ),
          ),
        );
    Widget heading(String s) => Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
          child: Text(s, style: theme.textTheme.titleMedium),
        );
    Widget itemTile(ItemWear w, {String? trailing}) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(backgroundColor: hexColor(w.item.colorHex), radius: 16),
          title: Text(w.item.name),
          subtitle: Text([
            l.categoryName(w.item.category),
            l.statsWears(w.wears),
            if (w.lastWornDay != null) l.statsLastWorn(DateFormat.MMMd(locale).format(Days.fromKey(w.lastWornDay!))),
          ].join(' · ')),
          trailing: TextButton(
            onPressed: () => _editPrice(context, ref, w.item),
            child: Text(trailing ?? (w.item.price == null ? l.statsAddPrice : money.format(w.item.price))),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l.featureWardrobeStats)),
      body: stats == null
          ? const Center(child: CircularProgressIndicator())
          : stats.items.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(l.statsEmpty, textAlign: TextAlign.center),
                      const SizedBox(height: AppSpacing.md),
                      FilledButton(onPressed: () => context.push(AppRoutes.wardrobe), child: Text(l.featureWardrobe)),
                    ]),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
                  children: [
                    Row(children: [
                      tile('${stats.items.length}', l.statsItems),
                      const SizedBox(width: AppSpacing.sm),
                      tile('${stats.totalWears}', l.statsTotalWears),
                      const SizedBox(width: AppSpacing.sm),
                      tile('${(stats.neutralShare * 100).round()}%', l.statsNeutrals),
                    ]),
                    if (stats.gaps.isNotEmpty) ...[
                      heading(l.statsGaps),
                      for (final g in stats.gaps)
                        Card(
                          color: scheme.tertiaryContainer,
                          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: ListTile(
                            key: Key('gap-${g.name}'),
                            leading: Icon(Icons.add_circle_outline, color: scheme.onTertiaryContainer),
                            title: Text(l.gapName(g), style: TextStyle(color: scheme.onTertiaryContainer)),
                            subtitle: Text(l.gapAdvice(g), style: TextStyle(color: scheme.onTertiaryContainer)),
                          ),
                        ),
                    ],
                    if (stats.mostWorn.isNotEmpty) ...[
                      heading(l.statsMostWorn),
                      for (final w in stats.mostWorn) itemTile(w),
                    ],
                    if (stats.bestValue.isNotEmpty) ...[
                      heading(l.statsBestValue),
                      Text(l.statsBestValueHelp, style: theme.textTheme.bodySmall),
                      for (final w in stats.bestValue)
                        itemTile(w, trailing: l.statsPerWear(money.format(w.costPerWear))),
                    ],
                    if (stats.neverWorn.isNotEmpty) ...[
                      heading(l.statsNeverWorn),
                      Text(l.statsNeverWornHelp, style: theme.textTheme.bodySmall),
                      for (final w in stats.neverWorn) itemTile(w),
                    ],
                  ],
                ),
    );
  }
}

/// Owns its controller so it outlives the dialog's closing animation.
class _PriceDialog extends StatefulWidget {
  const _PriceDialog({required this.item});
  final WardrobeItem item;

  @override
  State<_PriceDialog> createState() => _PriceDialogState();
}

class _PriceDialogState extends State<_PriceDialog> {
  late final _controller = TextEditingController(text: widget.item.price?.toStringAsFixed(0) ?? '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.statsPriceTitle(widget.item.name)),
      content: TextField(
        key: const Key('price-field'),
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: l.statsPrice, helperText: l.statsPriceHelp),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.actionCancel)),
        // An empty or invalid entry clears the price (-1).
        FilledButton(
          onPressed: () => Navigator.pop(context, parsePositive(_controller.text) ?? -1),
          child: Text(l.actionSave),
        ),
      ],
    );
  }
}
