import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../core/logging/app_logger.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/style_repository.dart';
import '../../domain/entities/body.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/outfit_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/visual/outfit_silhouette.dart';
import '../health/health_providers.dart';
import 'style_labels.dart';
import 'style_providers.dart';
import 'style_studio_providers.dart';

/// Plan outfits by date, two weeks at a time, with occasion tabs.
class OutfitCalendarScreen extends ConsumerStatefulWidget {
  const OutfitCalendarScreen({super.key});

  @override
  ConsumerState<OutfitCalendarScreen> createState() => _OutfitCalendarScreenState();
}

class _OutfitCalendarScreenState extends ConsumerState<OutfitCalendarScreen> {
  int _weekOffset = 0;

  Future<void> _plan(DateTime day, Occasion? occasion) async {
    final picked = await showModalBottomSheet<(String, Occasion)>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _PickOutfitSheet(initial: occasion),
    );
    if (picked == null || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final l = AppLocalizations.of(context);
    try {
      await ref.read(styleRepositoryProvider).planOutfit(Days.key(day), picked.$1, picked.$2);
    } catch (e, st) {
      AppLogger.error('calendar.plan', e, st);
      messenger.showSnackBar(SnackBar(content: Text(l.recordSaveError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final theme = Theme.of(context);
    final now = ref.watch(clockProvider)();
    final today = DateTime(now.year, now.month, now.day);
    final start = today.add(Duration(days: 7 * _weekOffset));
    final days = [for (var i = 0; i < 14; i++) start.add(Duration(days: i))];
    final plans = ref.watch(outfitPlansProvider((Days.key(days.first), Days.key(days.last)))).value ?? const [];
    final outfits = {for (final o in ref.watch(savedOutfitsProvider).value ?? const <SavedOutfit>[]) o.id: o};
    final womenswear = ref.watch(styleFitProvider) == StyleFit.womenswear;
    final tabs = <Occasion?>[null, ...Occasion.values];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.featureOutfitCalendar),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [for (final o in tabs) Tab(text: o == null ? l.filterAll : l.occasionName(o))],
          ),
        ),
        body: TabBarView(children: [
          for (final occasion in tabs)
            ListView(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
              children: [
                Row(children: [
                  IconButton(
                    tooltip: l.calendarEarlier,
                    onPressed: () => setState(() => _weekOffset -= 2),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: Text(
                      '${DateFormat.MMMd(locale).format(days.first)} – ${DateFormat.MMMd(locale).format(days.last)}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: l.calendarLater,
                    onPressed: () => setState(() => _weekOffset += 2),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ]),
                if (outfits.isEmpty)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text(l.calendarNoOutfits),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(AppRoutes.outfits),
                    ),
                  ),
                for (final day in days)
                  _DayCard(
                    day: day,
                    isToday: day == today,
                    isPast: day.isBefore(today),
                    plans: [
                      for (final p in plans)
                        if (p.day == Days.key(day) && (occasion == null || p.occasion == occasion)) p,
                    ],
                    outfits: outfits,
                    womenswear: womenswear,
                    onPlan: outfits.isEmpty ? null : () => _plan(day, occasion),
                  ),
              ],
            ),
        ]),
      ),
    );
  }
}

class _DayCard extends ConsumerWidget {
  const _DayCard({
    required this.day,
    required this.isToday,
    required this.isPast,
    required this.plans,
    required this.outfits,
    required this.womenswear,
    required this.onPlan,
  });

  final DateTime day;
  final bool isToday;
  final bool isPast;
  final List<OutfitPlan> plans;
  final Map<String, SavedOutfit> outfits;
  final bool womenswear;
  final VoidCallback? onPlan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final repo = ref.read(styleRepositoryProvider);
    return Card(
      key: Key('day-${Days.key(day)}'),
      color: isToday ? scheme.primaryContainer : null,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text(isToday ? l.calendarToday : DateFormat.MMMEd(locale).format(day),
                  style: theme.textTheme.titleSmall),
            ),
            if (onPlan != null)
              TextButton.icon(
                key: Key('plan-${Days.key(day)}'),
                onPressed: onPlan,
                icon: const Icon(Icons.add),
                label: Text(l.calendarPlan),
              ),
          ]),
          for (final p in plans)
            if (outfits[p.outfitId] case final o?)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Row(children: [
                  SizedBox(width: 56, height: 110, child: OutfitSilhouette(items: o.items, womenswear: womenswear)),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Chip(label: Text(l.occasionName(p.occasion)), visualDensity: VisualDensity.compact),
                      Text(o.items.map((i) => i.name).join(' · '),
                          style: theme.textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                      Wrap(spacing: AppSpacing.xs, children: [
                        if (isToday || isPast)
                          o.wornDays.contains(Days.key(day))
                              ? Chip(
                                  avatar: Icon(Icons.check, size: 16, color: scheme.primary),
                                  label: Text(l.calendarWorn),
                                  visualDensity: VisualDensity.compact)
                              : TextButton(
                                  key: Key('wore-${p.id}'),
                                  onPressed: () => repo.markWornOn(o.id, Days.key(day)),
                                  child: Text(l.calendarWoreIt),
                                ),
                        TextButton(
                          onPressed: () => repo.removePlan(p.id),
                          child: Text(l.calendarRemove),
                        ),
                      ]),
                    ]),
                  ),
                ]),
              ),
        ]),
      ),
    );
  }
}

class _PickOutfitSheet extends ConsumerStatefulWidget {
  const _PickOutfitSheet({this.initial});
  final Occasion? initial;

  @override
  ConsumerState<_PickOutfitSheet> createState() => _PickOutfitSheetState();
}

class _PickOutfitSheetState extends ConsumerState<_PickOutfitSheet> {
  late Occasion? _occasion = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final womenswear = ref.watch(styleFitProvider) == StyleFit.womenswear;
    final all = ref.watch(savedOutfitsProvider).value ?? const <SavedOutfit>[];
    final shown = _occasion == null ? all : all.where((o) => o.occasion == _occasion).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.calendarPickTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: AppSpacing.xs, children: [
          ChoiceChip(label: Text(l.filterAll), selected: _occasion == null, onSelected: (_) => setState(() => _occasion = null)),
          for (final o in Occasion.values)
            ChoiceChip(label: Text(l.occasionName(o)), selected: _occasion == o, onSelected: (_) => setState(() => _occasion = o)),
        ]),
        const SizedBox(height: AppSpacing.sm),
        if (shown.isEmpty) Text(l.calendarNoneForOccasion, style: theme.textTheme.bodyMedium),
        Flexible(
          child: ListView(shrinkWrap: true, children: [
            for (final o in shown)
              ListTile(
                key: Key('pick-${o.id}'),
                leading: SizedBox(width: 40, height: 80, child: OutfitSilhouette(items: o.items, womenswear: womenswear)),
                title: Text(o.items.map((i) => i.name).join(' · '), maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text(l.occasionName(o.occasion)),
                onTap: () => Navigator.of(context).pop((o.id, _occasion ?? o.occasion)),
              ),
          ]),
        ),
      ]),
    );
  }
}
