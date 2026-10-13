import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../health/body_providers.dart';
import 'blueprint_widgets.dart';
import 'growth_providers.dart';
import 'skills_screens.dart';

/// "My Growth": the Blueprint, skills and everything that tracks progress.
class GrowthScreen extends ConsumerWidget {
  const GrowthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final disciplines = ref.watch(disciplinesProvider).value ?? const [];

    Widget link(IconData icon, String label, String route, {Key? key}) => Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            key: key,
            leading: Icon(icon, color: theme.colorScheme.primary),
            title: Text(label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(route),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(l.navGrowth),
        actions: const [ProfileMenuButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 112),
        children: [
          const GrowthSearchBar(),
          const SizedBox(height: AppSpacing.lg),
          const BlueprintSection(),
          const SizedBox(height: AppSpacing.xl),
          Row(children: [
            Expanded(child: Text(l.skillsTitle, style: theme.textTheme.titleLarge)),
            TextButton(
              key: const Key('see-all-skills'),
              onPressed: () => context.push(AppRoutes.skills),
              child: Text(l.skillsSeeAll),
            ),
          ]),
          Text(l.skillsIntro, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 196,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: disciplines.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, i) => DisciplineCard(discipline: disciplines[i]),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(l.growthProgress, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          ...[
            link(Icons.play_circle_outline, l.workoutsTitle, AppRoutes.programs),
            link(Icons.timeline, l.journeyTitle, AppRoutes.journey),
            link(Icons.insights_outlined, l.insightsTitle, AppRoutes.insights),
            link(Icons.auto_awesome_outlined, l.evolutionTitle, AppRoutes.evolution),
            link(Icons.check_circle_outline, l.featureHabits, AppRoutes.habits),
            link(Icons.event_note_outlined, l.featureRoutines, AppRoutes.routines),
            link(Icons.flag_outlined, l.goalFinderTitle, AppRoutes.goalFinder, key: const Key('growth-goals')),
          ].expand((w) => [w, const SizedBox(height: AppSpacing.sm)]),
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: Icon(Icons.smart_toy_outlined, color: theme.colorScheme.outline),
              title: Text(l.featureAiCoach),
              subtitle: Text(l.growthCoachSoon),
              enabled: false,
            ),
          ),
        ],
      ),
    );
  }
}

/// Avatar with the user's initial: profile, goals, backup, packs, settings.
class ProfileMenuButton extends ConsumerWidget {
  const ProfileMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final name = ref.watch(profileProvider).value?.displayName?.trim() ?? '';
    final items = [
      (Icons.person_outline, l.featureProfile, AppRoutes.profile),
      (Icons.flag_outlined, l.goalFinderTitle, AppRoutes.goalFinder),
      (Icons.backup_outlined, l.backupTitle, AppRoutes.backup),
      (Icons.download_for_offline_outlined, l.contentTitle, AppRoutes.content),
      (Icons.settings_outlined, l.settingsTitle, AppRoutes.settings),
    ];
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: PopupMenuButton<String>(
        key: const Key('profile-menu'),
        tooltip: l.profileMenu,
        onSelected: (route) => context.push(route),
        itemBuilder: (_) => [
          for (final (icon, label, route) in items)
            PopupMenuItem(
              value: route,
              child: Row(children: [Icon(icon, size: 20), const SizedBox(width: AppSpacing.md), Text(label)]),
            ),
        ],
        child: CircleAvatar(
          radius: 17,
          backgroundColor: scheme.primaryContainer,
          child: name.isEmpty
              ? Icon(Icons.person, size: 20, color: scheme.onPrimaryContainer)
              : Text(name.characters.first.toUpperCase(),
                  style: TextStyle(color: scheme.onPrimaryContainer, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
