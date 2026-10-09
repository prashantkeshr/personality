import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/snapshot_repository.dart';
import '../../domain/services/face_engine.dart' show FaceShape;
import '../../domain/services/health_stats.dart';
import '../../domain/services/progress_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/visual/reveal.dart';
import '../../shared/visual/style_art.dart';
import '../face/face_providers.dart';
import '../health/health_providers.dart';
import '../plans/plan_providers.dart';
import '../snapshots/snapshot_providers.dart';
import '../style/style_providers.dart';
import 'journey_labels.dart';
import 'journey_providers.dart';
import 'journey_widgets.dart';

String questRoute(QuestKind k) => switch (k) {
      QuestKind.drinkTarget => AppRoutes.water,
      QuestKind.logMeals => AppRoutes.meals,
      QuestKind.postureCheck => AppRoutes.posture,
      QuestKind.completePlan => AppRoutes.plan,
      QuestKind.allHabits => AppRoutes.habits,
      QuestKind.logSleep => AppRoutes.sleep,
      QuestKind.workout => AppRoutes.exercise,
      QuestKind.wearOutfit => AppRoutes.outfits,
      QuestKind.snapshot => AppRoutes.snapshots,
      QuestKind.logWeight => AppRoutes.weight,
    };

/// Hero card: face time-lapse beside level, XP and streak.
class JourneyCard extends ConsumerWidget {
  const JourneyCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final summary = ref.watch(progressSummaryProvider);
    final frames = ref.watch(faceTimelineProvider);
    final today = Days.key(ref.watch(clockProvider)());
    if (summary == null) return const SizedBox(height: 132);
    final level = summary.level;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.journey),
        // The text column sets the height (it grows with larger fonts); the
        // photo fills the left edge.
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 168),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: _photoWidth,
                child: frames.isEmpty
                    ? DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              scheme.primaryContainer,
                              scheme.surfaceContainerHigh,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo_camera_front_outlined,
                                  color: scheme.primary, size: 28),
                              const SizedBox(height: AppSpacing.sm),
                              Text(l10n.journeyStartTimelapse,
                                  textAlign: TextAlign.center,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelSmall),
                            ],
                          ),
                        ),
                      )
                    : Stack(fit: StackFit.expand, children: [
                        FaceTimelapse(frames: frames),
                        Positioned(
                          left: 6,
                          bottom: 6,
                          child: _Chip(l10n.journeySnapshotCount(frames.length)),
                        ),
                      ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(_photoWidth + AppSpacing.lg,
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.journeyTitle,
                          style: theme.textTheme.labelLarge
                              ?.copyWith(color: scheme.primary)),
                      const SizedBox(height: AppSpacing.sm),
                      Row(children: [
                        LevelRing(level: level, size: 56),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.journeyLevel(level.level),
                                  style: theme.textTheme.titleMedium),
                              Text(
                                  l10n.journeyXpToNext(
                                      level.xpForNext - level.xpInLevel,
                                      level.level + 1),
                                  style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ]),
                      const SizedBox(height: AppSpacing.md),
                      Text(l10n.journeyStreak(summary.streak.current),
                          style: theme.textTheme.bodyMedium),
                      const SizedBox(height: AppSpacing.xs),
                      StreakDots(streak: summary.streak, today: today),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _photoWidth = 126.0;
}

class _Chip extends StatelessWidget {
  const _Chip(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Text(text,
              style: const TextStyle(color: Colors.white, fontSize: 11)),
        ),
      );
}

/// Three daily quests chosen from the user's goals.
class QuestsCard extends ConsumerWidget {
  const QuestsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final summary = ref.watch(progressSummaryProvider);
    if (summary == null || summary.quests.isEmpty) return const SizedBox();
    final allDone = summary.quests.every((q) => q.done);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Text(l10n.questsTitle,
                    style: theme.textTheme.titleMedium),
              ),
              Text(l10n.journeyTodayXp(summary.todayXp),
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: theme.colorScheme.primary)),
            ]),
            const SizedBox(height: AppSpacing.xs),
            for (final (i, q) in summary.quests.indexed)
              Reveal(
                index: i,
                child: QuestTile(
                    quest: q,
                    onTap: q.done
                        ? null
                        : () => context.push(questRoute(q.kind))),
              ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              allDone
                  ? l10n.questsAllDone(QuestEngine.allDoneBonus)
                  : l10n.questsAllBonus(QuestEngine.allDoneBonus),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

enum _Feed { bodyPlan, goals, snapshot, faceShape, hairstyles, tryOn, colours, outfit, posture, exercise }

/// Image-led suggestions picked from what the user has and hasn't done.
class ForYouFeed extends ConsumerWidget {
  const ForYouFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ctx = ref.watch(questContextProvider);
    final faces = ref.watch(faceHistoryProvider).value ?? const [];
    final profile = ref.watch(styleProfileProvider).value;
    final snapConsent = ref.watch(snapshotConsentProvider).value ?? false;
    final faceSnaps =
        ref.watch(snapshotsProvider(SnapshotKind.face)).value ?? const [];

    final hasPlan = ref.watch(activeBodyPlanProvider).value != null;
    final items = <_Feed>[
      if (!hasPlan) _Feed.bodyPlan,
      if (ctx.goals.isEmpty) _Feed.goals,
      if (!ctx.snapshotThisWeek && (snapConsent || faceSnaps.isEmpty))
        _Feed.snapshot,
      if (faces.isEmpty) _Feed.faceShape else _Feed.hairstyles,
      _Feed.tryOn,
      if (profile != null && !profile.hasPalette) _Feed.colours,
      if (ctx.wardrobeItems >= 3) _Feed.outfit,
      _Feed.posture,
      _Feed.exercise,
      if (ctx.goals.isNotEmpty) _Feed.goals,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(l10n.forYouTitle, style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 176,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, i) =>
                Reveal(index: i, child: _FeedCard(items[i])),
          ),
        ),
      ],
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard(this.kind);
  final _Feed kind;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (title, info, route) = switch (kind) {
      _Feed.bodyPlan => (l10n.forYouBodyPlan, l10n.forYouBodyPlanInfo, AppRoutes.bodyPlan),
      _Feed.goals => (l10n.forYouGoals, l10n.forYouGoalsInfo, AppRoutes.goalFinder),
      _Feed.snapshot => (l10n.forYouSnapshot, l10n.forYouSnapshotInfo, AppRoutes.snapshots),
      _Feed.faceShape => (l10n.forYouFace, l10n.forYouFaceInfo, AppRoutes.face),
      _Feed.hairstyles => (l10n.forYouHairstyles, l10n.forYouHairstylesInfo, AppRoutes.face),
      _Feed.tryOn => (l10n.forYouTryOn, l10n.forYouTryOnInfo, AppRoutes.tryOn),
      _Feed.colours => (l10n.forYouColours, l10n.forYouColoursInfo, AppRoutes.colours),
      _Feed.outfit => (l10n.forYouOutfit, l10n.forYouOutfitInfo, AppRoutes.outfits),
      _Feed.posture => (l10n.forYouPosture, l10n.forYouPostureInfo, AppRoutes.posture),
      _Feed.exercise => (l10n.forYouExercise, l10n.forYouExerciseInfo, AppRoutes.exerciseLibrary),
    };
    final Widget art = switch (kind) {
      _Feed.bodyPlan => Image.asset('assets/images/goals/plan.jpg',
          fit: BoxFit.cover),
      _Feed.goals => const _Mosaic(['assets/images/goals/fitness.jpg',
          'assets/images/goals/flexibility.jpg', 'assets/images/goals/style.jpg',
          'assets/images/goals/hydration.jpg']),
      _Feed.hairstyles => Image.asset('assets/images/styles/textured_crop.jpg',
          fit: BoxFit.cover),
      _Feed.tryOn => Image.asset('assets/images/styles/short_beard.jpg',
          fit: BoxFit.cover),
      _Feed.faceShape => _ArtPanel(
          child: FaceShapeArt(shape: FaceShape.oval)),
      _Feed.colours => Image.asset('assets/images/goals/feed_colours.jpg',
          fit: BoxFit.cover),
      _Feed.snapshot => _ArtPanel(
          icon: Icons.photo_camera_front_outlined, color: scheme.primary),
      _Feed.outfit => Image.asset('assets/images/goals/feed_wardrobe.jpg',
          fit: BoxFit.cover),
      _Feed.posture => Image.asset('assets/images/goals/posture.jpg',
          fit: BoxFit.cover),
      _Feed.exercise => Image.asset('assets/images/goals/feed_exercise.jpg',
          fit: BoxFit.cover),
    };
    return SizedBox(
      width: 148,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(route),
          child: Stack(
            fit: StackFit.expand,
            children: [
              art,
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 1],
                    colors: [Color(0x00000000), Color(0xE6000000)],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(info,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Color(0xE6FFFFFF), fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A soft gradient panel with a single line-art emblem.
class _ArtPanel extends StatelessWidget {
  const _ArtPanel({this.icon, this.color, this.child});

  final IconData? icon;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primaryContainer, scheme.tertiaryContainer],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 18, 28, 64),
        child: child ??
            FittedBox(
              child: Icon(icon,
                  color: (color ?? scheme.primary).withValues(alpha: 0.8)),
            ),
      ),
    );
  }
}

/// Four small photos in a grid (falls back to a soft panel if missing).
class _Mosaic extends StatelessWidget {
  const _Mosaic(this.images);
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget tile(String a) => Expanded(
          child: Image.asset(a,
              fit: BoxFit.cover,
              height: double.infinity,
              errorBuilder: (_, _, _) =>
                  ColoredBox(color: scheme.primaryContainer)),
        );
    return Column(children: [
      Expanded(child: Row(children: [tile(images[0]), tile(images[1])])),
      Expanded(child: Row(children: [tile(images[2]), tile(images[3])])),
    ]);
  }
}

/// Celebrates newly earned badges once, with a medallion light sweep.
class BadgeCelebrationHost extends ConsumerStatefulWidget {
  const BadgeCelebrationHost({super.key});

  @override
  ConsumerState<BadgeCelebrationHost> createState() =>
      _BadgeCelebrationHostState();
}

class _BadgeCelebrationHostState extends ConsumerState<BadgeCelebrationHost> {
  bool _showing = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(unseenBadgesProvider, (_, next) {
      // While refreshing, the provider still reports the previous list.
      if (next.isLoading) return;
      final badges = next.value;
      if (badges == null || badges.isEmpty || _showing) return;
      _showing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await showDialog<void>(
            context: context, builder: (_) => BadgeUnlockedDialog(badges));
        await ref.read(progressRepositoryProvider).markBadgesSeen(badges);
        ref.invalidate(unseenBadgesProvider);
        _showing = false;
      });
    });
    return const SizedBox.shrink();
  }
}

class BadgeUnlockedDialog extends StatefulWidget {
  const BadgeUnlockedDialog(this.badges, {super.key});
  final List<Award> badges;

  @override
  State<BadgeUnlockedDialog> createState() => _BadgeUnlockedDialogState();
}

class _BadgeUnlockedDialogState extends State<BadgeUnlockedDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1600));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _c.value = 1;
    } else if (!_c.isAnimating && _c.value == 0) {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final badges = widget.badges;
    final first = badges.first;
    final pop = CurvedAnimation(
        parent: _c, curve: const Interval(0, 0.45, curve: Curves.easeOutBack));
    final shine = CurvedAnimation(
        parent: _c, curve: const Interval(0.4, 1, curve: Curves.easeInOut));
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _c,
            builder: (_, _) => Transform.scale(
              scale: 0.6 + 0.4 * pop.value,
              child: Opacity(
                opacity: pop.value.clamp(0.0, 1.0),
                child: BadgeMedallion(
                    badge: first, earned: true, size: 112, shine: shine.value),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
              badges.length == 1
                  ? l10n.badgeUnlocked
                  : l10n.badgesUnlocked(badges.length),
              style: theme.textTheme.labelLarge
                  ?.copyWith(color: theme.colorScheme.primary)),
          const SizedBox(height: AppSpacing.xs),
          Text(badgeTitle(l10n, first),
              style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          Text(badgeInfo(l10n, first),
              style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
          if (badges.length > 1) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: [
                for (final b in badges.skip(1))
                  Tooltip(
                    message: badgeTitle(l10n, b),
                    child: BadgeMedallion(badge: b, earned: true, size: 44),
                  ),
              ],
            ),
          ],
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.badgeContinue),
        ),
      ],
    );
  }
}
