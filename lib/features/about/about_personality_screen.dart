import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/snapshot_repository.dart';
import '../../domain/entities/body.dart';
import '../../domain/services/blueprint_engine.dart';
import '../../domain/services/posture_engine.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/body_format.dart';
import '../../shared/visual/outfit_silhouette.dart' show hexColor;
import '../face/face_labels.dart';
import '../face/face_providers.dart';
import '../growth/blueprint_widgets.dart';
import '../growth/growth_providers.dart';
import '../health/body_providers.dart';
import '../health/proportions/proportions_screen.dart' show ProportionLabels;
import '../journey/journey_providers.dart';
import '../posture/posture_labels.dart';
import '../posture/posture_providers.dart';
import '../snapshots/snapshot_providers.dart';
import '../style/style_labels.dart';
import '../style/style_providers.dart';

/// Everything the app has learned about the user, from their own checks,
/// in one place. Read-only and descriptive: no overall score, no ranking,
/// and each part links to where it can be checked again.
class AboutPersonalityScreen extends ConsumerWidget {
  const AboutPersonalityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: const [
          _Header(),
          SizedBox(height: AppSpacing.md),
          _FaceSection(),
          _BodySection(),
          _PostureSection(),
          _StyleSection(),
          _ProgressSection(),
          _GrowSection(),
        ],
      ),
    );
  }
}

/// Home entry point.
class AboutPersonalityCard extends StatelessWidget {
  const AboutPersonalityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = Theme.of(context).colorScheme;
    return Card(
      key: const Key('about-card'),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.aboutYou),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                s.primaryContainer,
                s.tertiaryContainer.withValues(alpha: 0.6),
              ],
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/brand/app_icon.png',
                  width: 48,
                  height: 48,
                  excludeFromSemantics: true,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.aboutTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      l.aboutHomeInfo,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

/// A titled card; [empty] with [action] when there's nothing yet.
class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.child,
    this.action,
    this.route,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final String? action;
  final String? route;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(title, style: theme.textTheme.titleMedium),
                    ),
                  ),
                  if (action != null && route != null)
                    TextButton(
                      onPressed: () => context.push(route!),
                      child: Text(action!),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
  );
}

/// A label and value row.
class _Fact extends StatelessWidget {
  const _Fact(this.label, this.value, {this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          if (color != null) ...[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final profile = ref.watch(profileProvider).value ?? const Profile();
    final goals = ref.watch(goalsProvider).value ?? const {};
    final faces =
        ref.watch(snapshotsProvider(SnapshotKind.face)).value ??
        const <Snapshot>[];
    final name = profile.displayName?.trim();

    return Column(
      children: [
        CircleAvatar(
          key: const Key('about-avatar'),
          radius: 48,
          backgroundColor: theme.colorScheme.primaryContainer,
          // Newest first: the latest snapshot, private, from this phone.
          backgroundImage: faces.isEmpty ? null : MemoryImage(faces.first.jpeg),
          child: faces.isNotEmpty
              ? null
              : Text(
                  (name == null || name.isEmpty) ? '?' : name[0].toUpperCase(),
                  style: theme.textTheme.headlineMedium,
                ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          (name == null || name.isEmpty) ? l.profileMenu : name,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l.aboutIntro,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (goals.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              for (final g in goals) Chip(label: Text(l.goalLabel(g))),
            ],
          ),
        ],
      ],
    );
  }
}

class _FaceSection extends ConsumerWidget {
  const _FaceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final faces = ref.watch(faceHistoryProvider).value ?? const [];
    final format = BodyFormat.of(
      context,
      ref.watch(settingsControllerProvider).unitSystem,
    );
    final latest = faces.isEmpty
        ? null
        : faces.reduce((a, b) => a.recordedAt.isAfter(b.recordedAt) ? a : b);

    return _Section(
      icon: Icons.face_retouching_natural,
      title: l.aboutFace,
      action: latest == null ? l.aboutCheckNow : l.aboutSeeMore,
      route: latest == null ? AppRoutes.face : AppRoutes.faceHistory,
      child: latest == null
          ? _Empty(l.aboutFaceEmpty)
          : Column(
              key: const Key('about-face'),
              children: [
                _Fact(l.faceResultTitle, l.faceShapeName(latest.result.shape)),
                if (latest.result.alsoLike != null)
                  _Fact(
                    l.aboutAlsoClose,
                    l.faceShapeName(latest.result.alsoLike!),
                  ),
                for (final e in latest.result.ratios.entries)
                  _Fact(l.faceRatioName(e.key), e.value.toStringAsFixed(2)),
                _Fact(l.aboutChecked, format.date(latest.recordedAt)),
              ],
            ),
    );
  }
}

class _BodySection extends ConsumerWidget {
  const _BodySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final format = BodyFormat.of(
      context,
      ref.watch(settingsControllerProvider).unitSystem,
    );
    final height = ref.watch(primaryHeightProvider).value;
    final weights = ref.watch(weightRecordsProvider).value ?? const [];
    final proportions = ref.watch(proportionProvider).value;
    final weight = weights.isEmpty ? null : weights.first; // newest first
    final first = weights.isEmpty ? null : weights.last;
    final bmi = height == null || weight == null
        ? null
        : weight.value / ((height.value / 100) * (height.value / 100));

    if (height == null && weight == null) {
      return _Section(
        icon: Icons.accessibility_new,
        title: l.aboutBody,
        action: l.aboutCheckNow,
        route: AppRoutes.profile,
        child: _Empty(l.aboutBodyEmpty),
      );
    }
    return _Section(
      icon: Icons.accessibility_new,
      title: l.aboutBody,
      action: l.aboutSeeMore,
      route: AppRoutes.weight,
      child: Column(
        key: const Key('about-body'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (height != null)
            _Fact(l.featureHeight, format.height(height.value)),
          if (weight != null)
            _Fact(l.featureWeight, format.weight(weight.value)),
          if (weight != null && first != null && weights.length > 1)
            _Fact(
              l.weightStatSinceStart,
              format.weightChange(weight.value - first.value),
            ),
          if (bmi != null) ...[
            _Fact(l.aboutBmi, bmi.toStringAsFixed(1)),
            Text(
              l.aboutBmiNote,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (proportions != null && proportions.results.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l.featureBodyProportions,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            for (final r in proportions.results.take(4))
              _Fact(l.metricName(r.metric), l.descriptor(r.descriptor)),
          ],
        ],
      ),
    );
  }
}

class _PostureSection extends ConsumerWidget {
  const _PostureSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final format = BodyFormat.of(
      context,
      ref.watch(settingsControllerProvider).unitSystem,
    );
    final all = ref.watch(postureHistoryProvider).value ?? const [];
    final latest = all.isEmpty
        ? null
        : all.reduce((a, b) => a.recordedAt.isAfter(b.recordedAt) ? a : b);

    return _Section(
      icon: Icons.self_improvement,
      title: l.aboutPosture,
      action: latest == null ? l.aboutCheckNow : l.aboutSeeMore,
      route: latest == null ? AppRoutes.posture : AppRoutes.postureHistory,
      child: latest == null
          ? _Empty(l.aboutPostureEmpty)
          : Column(
              key: const Key('about-posture'),
              children: [
                _Fact(l.aboutView, l.viewLabel(latest.result.view)),
                for (final MetricResult m in latest.result.metrics)
                  _Fact(
                    l.postureMetricName(m.metric),
                    '${l.valueDegrees(m.degrees.toStringAsFixed(1))} · ${l.bandLabel(m.band)}',
                    color: bandColor(scheme, m.band),
                  ),
                _Fact(l.aboutChecked, format.date(latest.recordedAt)),
              ],
            ),
    );
  }
}

class _StyleSection extends ConsumerWidget {
  const _StyleSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final style = ref.watch(styleProfileProvider).value;
    final palette = style?.palette;
    if (style == null || (!style.hasPalette && style.styles.isEmpty)) {
      return _Section(
        icon: Icons.palette_outlined,
        title: l.aboutStyle,
        action: l.aboutCheckNow,
        route: AppRoutes.colours,
        child: _Empty(l.aboutStyleEmpty),
      );
    }
    return _Section(
      icon: Icons.palette_outlined,
      title: l.aboutStyle,
      action: l.aboutSeeMore,
      route: AppRoutes.styleDna,
      child: Column(
        key: const Key('about-style'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (style.undertone != null)
            _Fact(l.aboutUndertone, l.undertoneName(style.undertone!)),
          if (style.depth != null)
            _Fact(l.aboutDepth, l.depthName(style.depth!)),
          if (palette != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final hex in palette.best.take(8))
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: hexColor(hex),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ],
          if (style.styles.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final s in style.styles)
                  Chip(label: Text(l.stylePrefName(s))),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ProgressSection extends ConsumerWidget {
  const _ProgressSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final summary = ref.watch(progressSummaryProvider);
    final postures =
        (ref.watch(postureHistoryProvider).value ?? const []).length;
    final snaps =
        (ref.watch(snapshotsProvider(SnapshotKind.face)).value ??
                const <Snapshot>[])
            .length +
        (ref.watch(snapshotsProvider(SnapshotKind.bodyFront)).value ??
                const <Snapshot>[])
            .length +
        (ref.watch(snapshotsProvider(SnapshotKind.bodySide)).value ??
                const <Snapshot>[])
            .length;

    return _Section(
      icon: Icons.trending_up,
      title: l.aboutProgress,
      action: l.aboutSeeMore,
      route: AppRoutes.journey,
      child: Column(
        key: const Key('about-progress'),
        children: [
          if (summary != null) ...[
            _Fact(l.journeyTotalXp, '${summary.totalXp}'),
            _Fact(l.aboutLevel, '${summary.level.level}'),
            _Fact(l.aboutStreak, l.journeyStreak(summary.streak.current)),
            _Fact(l.journeyBestStreak, '${summary.streak.best}'),
          ],
          _Fact(l.aboutPostureChecks, '$postures'),
          _Fact(l.aboutProgressPhotos, '$snaps'),
        ],
      ),
    );
  }
}

class _GrowSection extends ConsumerWidget {
  const _GrowSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // Areas that could use attention, the user's own focus first.
    final areas = [
      for (final s in ref.watch(blueprintProvider))
        if (s.reason != BlueprintReason.onTrack) s,
    ]..sort((a, b) => (b.focus ? 1 : 0).compareTo(a.focus ? 1 : 0));

    return _Section(
      icon: Icons.spa_outlined,
      title: l.aboutGrow,
      child: areas.isEmpty
          ? _Empty(l.aboutGrowEmpty)
          : Column(
              key: const Key('about-grow'),
              children: [
                for (final s in areas.take(4))
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      areaIcon(s.area),
                      color: theme.colorScheme.tertiary,
                    ),
                    title: Text(areaLabel(l, s.area)),
                    subtitle: Text(reasonText(l, s.reason)),
                    trailing: TextButton(
                      onPressed: () => context.push(actionOf(l, s.action).$2),
                      child: Text(l.blueprintGo),
                    ),
                  ),
              ],
            ),
    );
  }
}
