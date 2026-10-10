import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/router.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/health_stats.dart';
import '../../domain/services/progress_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/body_format.dart';
import '../../shared/visual/reveal.dart';
import '../health/body_providers.dart';
import '../health/health_providers.dart';
import '../insights/evolution_screen.dart';
import '../insights/insights_providers.dart';
import 'journey_labels.dart';
import 'journey_providers.dart';
import 'journey_widgets.dart';

/// The transformation dashboard: time-lapse from real snapshots, progress,
/// trends and badges.
class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final summary = ref.watch(progressSummaryProvider);
    final history = ref.watch(progressHistoryProvider).value ?? const [];
    final today = Days.key(ref.watch(clockProvider)());

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.journeyTitle),
        actions: [
          IconButton(
            tooltip: l10n.journeyHowXp,
            icon: const Icon(Icons.info_outline),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(l10n.journeyHowXp),
                content: Text(
                    '${l10n.journeyHowXpBody}\n\n${l10n.journeyRestDaysHelp}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(MaterialLocalizations.of(context).okButtonLabel),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: summary == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                const Reveal(child: _TimelapseSection()),
                const SizedBox(height: AppSpacing.xl),
                Reveal(index: 1, child: _LevelSection(summary, today)),
                const SizedBox(height: AppSpacing.xl),
                Reveal(
                    index: 2,
                    child: _ActivitySection(summary, history, today)),
                const SizedBox(height: AppSpacing.xl),
                const Reveal(index: 3, child: _WeightTrend()),
                const SizedBox(height: AppSpacing.xl),
                const _MilestonesPreview(),
                const SizedBox(height: AppSpacing.xl),
                Semantics(
                  header: true,
                  child: Row(children: [
                    Expanded(
                        child: Text(l10n.journeyBadges,
                            style: theme.textTheme.titleMedium)),
                    Text(
                        l10n.journeyBadgesEarned(
                            summary.badges.where((b) => b.earned).length,
                            summary.badges.length),
                        style: theme.textTheme.bodySmall),
                  ]),
                ),
                const SizedBox(height: AppSpacing.md),
                _BadgeGrid(summary.badges),
              ],
            ),
    );
  }
}

class _TimelapseSection extends ConsumerStatefulWidget {
  const _TimelapseSection();

  @override
  ConsumerState<_TimelapseSection> createState() => _TimelapseSectionState();
}

class _TimelapseSectionState extends ConsumerState<_TimelapseSection> {
  bool _playing = false;
  int? _index;
  bool _compare = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final frames = ref.watch(faceTimelineProvider);
    final locale = Localizations.localeOf(context).toLanguageTag();
    String date(int i) =>
        DateFormat.yMMMd(locale).format(frames[i].takenAt.toLocal());

    if (frames.isEmpty) {
      return Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(AppSpacing.lg),
          leading: Icon(Icons.photo_camera_front_outlined,
              color: theme.colorScheme.primary),
          title: Text(l10n.journeyStartTimelapse),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(AppRoutes.snapshots),
        ),
      );
    }
    final last = frames.length - 1;
    final shown = _index ?? last;

    final Widget stage = _compare && frames.length > 1
        ? Row(children: [
            for (final (i, label) in [(0, l10n.journeyFirst), (last, l10n.journeyLatest)])
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: i == 0 ? AppSpacing.xs : 0,
                      left: i == 0 ? 0 : AppSpacing.xs),
                  child: _Framed(
                    label: '$label · ${date(i)}',
                    child: AlignedPhoto(snapshot: frames[i]),
                  ),
                ),
              ),
          ])
        : _Framed(
            label: date(_playing ? shown : shown),
            child: FaceTimelapse(
              frames: frames,
              index: _playing ? null : shown,
              playing: _playing,
              onFrame: (i) => setState(() => _index = i),
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(aspectRatio: _compare ? 1.5 : 0.85, child: stage),
        const SizedBox(height: AppSpacing.sm),
        if (frames.length == 1)
          Text(l10n.journeyOneSnapshot, style: theme.textTheme.bodySmall)
        else ...[
          if (!_compare)
            Row(children: [
              IconButton.filledTonal(
                tooltip: _playing ? l10n.journeyPause : l10n.journeyPlay,
                icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
                onPressed: () => setState(() => _playing = !_playing),
              ),
              Expanded(
                child: Slider(
                  value: shown.toDouble(),
                  max: last.toDouble(),
                  divisions: last,
                  label: date(shown),
                  onChanged: (v) => setState(() {
                    _playing = false;
                    _index = v.round();
                  }),
                ),
              ),
            ]),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: Icon(_compare ? Icons.slideshow : Icons.compare),
              label: Text(_compare ? l10n.journeyPlay : l10n.journeyCompare),
              onPressed: () => setState(() {
                _compare = !_compare;
                _playing = false;
              }),
            ),
          ),
        ],
        Text(l10n.journeyAlignNote,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

class _Framed extends StatelessWidget {
  const _Framed({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(fit: StackFit.expand, children: [
          ColoredBox(color: Colors.black, child: child),
          Positioned(
            left: 10,
            bottom: 10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(label,
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ),
          ),
        ]),
      );
}

class _LevelSection extends StatelessWidget {
  const _LevelSection(this.summary, this.today);
  final ProgressSummary summary;
  final int today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final level = summary.level;
    final number = NumberFormat.decimalPattern(
        Localizations.localeOf(context).toLanguageTag());
    Widget stat(String label, String value) => Expanded(
          child: Column(children: [
            Text(value, style: theme.textTheme.titleLarge),
            Text(label,
                style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
          ]),
        );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(children: [
          Row(children: [
            LevelRing(level: level, size: 84),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.journeyLevel(level.level),
                      style: theme.textTheme.headlineSmall),
                  Text(
                      l10n.journeyXpToNext(level.xpForNext - level.xpInLevel,
                          level.level + 1),
                      style: theme.textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.sm),
                  StreakDots(streak: summary.streak, today: today),
                  const SizedBox(height: AppSpacing.xs),
                  Text(l10n.journeyRestDays(summary.streak.freezes),
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ]),
          const Divider(height: AppSpacing.xxl),
          Row(children: [
            stat(l10n.journeyTotalXp, number.format(summary.totalXp)),
            stat(l10n.journeyBestStreak, '${summary.streak.best}'),
            stat(
                l10n.journeyActiveDays,
                '${summary.streak.days.values.where((s) => s == DayStatus.active).length}'),
          ]),
        ]),
      ),
    );
  }
}

/// Last four weeks as a heat strip, plus XP per day.
class _ActivitySection extends StatelessWidget {
  const _ActivitySection(this.summary, this.history, this.today);
  final ProgressSummary summary;
  final List<DayActivity> history;
  final int today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final xp = {for (final d in history) d.dayKey: XpRules.forDay(d)};
    xp[today] = summary.todayXp;
    final t = Days.fromKey(today);
    final keys = [
      for (var i = 27; i >= 0; i--) Days.key(DateTime(t.year, t.month, t.day - i)),
    ];
    final max = keys.map((k) => xp[k] ?? 0).fold(60, (a, b) => a > b ? a : b);
    final reduce = MediaQuery.disableAnimationsOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.journeyTrends, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('${l10n.journeyXpPerDay} · ${l10n.journeyLast4Weeks}',
            style: theme.textTheme.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 96,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final k in keys)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: (xp[k] ?? 0) / max),
                      duration: reduce
                          ? Duration.zero
                          : const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      builder: (_, v, _) => FractionallySizedBox(
                        heightFactor: v.clamp(0.02, 1.0),
                        alignment: Alignment.bottomCenter,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: switch (summary.streak.days[k]) {
                              DayStatus.active => scheme.primary,
                              DayStatus.rested => scheme.tertiary,
                              _ => scheme.outlineVariant,
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeightTrend extends ConsumerWidget {
  const _WeightTrend();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final weights = ref.watch(weightRecordsProvider).value ?? const [];
    if (weights.length < 2) return const SizedBox.shrink();
    final format =
        BodyFormat.of(context, ref.watch(settingsControllerProvider).unitSystem);
    final latest = weights.first, first = weights.last;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monitor_weight_outlined),
        title: Text(l10n.journeyWeight),
        subtitle: Text(
            '${format.weight(first.value)} → ${format.weight(latest.value)}'),
        trailing: Text(format.weightChange(latest.value - first.value),
            style: Theme.of(context).textTheme.titleMedium),
        onTap: () => context.push(AppRoutes.weight),
      ),
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  const _BadgeGrid(this.badges);
  final List<AwardProgress> badges;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return LayoutBuilder(builder: (context, c) {
      final columns = c.maxWidth >= 560 ? 4 : 3;
      final w = (c.maxWidth - AppSpacing.md * (columns - 1)) / columns;
      return Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.lg,
        children: [
          for (final (i, b) in badges.indexed)
            SizedBox(
              width: w,
              child: Reveal(
                index: i,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    builder: (_) => Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        BadgeMedallion(
                            badge: b.badge,
                            earned: b.earned,
                            progress: b.progress / b.target,
                            size: 120),
                        const SizedBox(height: AppSpacing.lg),
                        Text(badgeTitle(l10n, b.badge),
                            style: theme.textTheme.titleLarge),
                        const SizedBox(height: AppSpacing.xs),
                        Text(badgeInfo(l10n, b.badge),
                            textAlign: TextAlign.center),
                        if (!b.earned) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(l10n.badgeProgress(b.progress, b.target),
                              style: theme.textTheme.labelLarge),
                        ],
                      ]),
                    ),
                  ),
                  child: Column(children: [
                    BadgeMedallion(
                        badge: b.badge,
                        earned: b.earned,
                        progress: b.progress / b.target,
                        size: 68),
                    const SizedBox(height: AppSpacing.xs),
                    Text(badgeTitle(l10n, b.badge),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                            color: b.earned
                                ? null
                                : theme.colorScheme.onSurfaceVariant)),
                  ]),
                ),
              ),
            ),
        ],
      );
    });
  }
}

/// The latest milestones, with links to the full timeline and insights.
class _MilestonesPreview extends ConsumerWidget {
  const _MilestonesPreview();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ms = ref.watch(evolutionProvider);
    final top = ms.take(4).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(
            child: Text(l10n.evolutionTitle, style: theme.textTheme.titleMedium)),
        TextButton(
          onPressed: () => context.push(AppRoutes.evolution),
          child: Text(l10n.evolutionSeeAll),
        ),
      ]),
      const SizedBox(height: AppSpacing.sm),
      if (top.isEmpty) Text(l10n.evolutionEmpty, style: theme.textTheme.bodySmall),
      for (final (i, m) in top.indexed)
        MilestoneTile(m: m, last: i == top.length - 1),
      Wrap(spacing: AppSpacing.sm, children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.edit_note),
          label: Text(l10n.evolutionAddNote),
          onPressed: () => addMilestoneNote(context, ref),
        ),
        OutlinedButton.icon(
          icon: const Icon(Icons.insights_outlined),
          label: Text(l10n.insightsTitle),
          onPressed: () => context.push(AppRoutes.insights),
        ),
      ]),
    ]);
  }
}
