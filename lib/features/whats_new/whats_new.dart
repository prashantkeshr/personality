import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../permissions/app_permissions.dart' show appKvProvider;

/// Bump when a release brings something worth telling the user about.
const whatsNewRelease = 40;
const whatsNewSeenKey = 'whatsnew.seen';

/// True while this release's notes haven't been seen.
final whatsNewDueProvider = StreamProvider<bool>((ref) => ref
    .watch(appKvProvider)
    .watchPrefix(whatsNewSeenKey)
    .map((m) => (int.tryParse(m[whatsNewSeenKey] ?? '') ?? 0) < whatsNewRelease));

Future<void> markWhatsNewSeen(WidgetRef ref) =>
    ref.read(appKvProvider).put(whatsNewSeenKey, '$whatsNewRelease');

/// One new thing: what it is and where to find it.
typedef _Item = (IconData icon, String title, String body, String route);

List<_Item> _items(AppLocalizations l) => [
      (Icons.calendar_month, l.newTrainingTitle, l.newTrainingBody, AppRoutes.training),
      (Icons.edit_note, l.newBuilderTitle, l.newBuilderBody, AppRoutes.buildWorkout),
      (Icons.record_voice_over, l.newVoiceTitle, l.newVoiceBody, AppRoutes.programs),
      (Icons.search, l.newSearchTitle, l.newSearchBody, AppRoutes.homeSearch),
      (Icons.swipe, l.newSwipeTitle, l.newSwipeBody, AppRoutes.home),
      (Icons.backup_outlined, l.newBackupTitle, l.newBackupBody, AppRoutes.backup),
    ];

/// Small Home card after an update; opens the full list.
class WhatsNewCard extends ConsumerWidget {
  const WhatsNewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(whatsNewDueProvider).value != true) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      key: const Key('whats-new'),
      color: scheme.tertiaryContainer,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        leading: Icon(Icons.auto_awesome, color: scheme.onTertiaryContainer),
        title: Text(l10n.whatsNewTitle, style: TextStyle(color: scheme.onTertiaryContainer)),
        subtitle: Text(l10n.whatsNewCard, style: TextStyle(color: scheme.onTertiaryContainer)),
        onTap: () => context.push(AppRoutes.whatsNew),
        trailing: IconButton(
          key: const Key('whats-new-dismiss'),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () => markWhatsNewSeen(ref),
          icon: Icon(Icons.close, color: scheme.onTertiaryContainer),
        ),
      ),
    );
  }
}

class WhatsNewScreen extends ConsumerStatefulWidget {
  const WhatsNewScreen({super.key});

  @override
  ConsumerState<WhatsNewScreen> createState() => _WhatsNewScreenState();
}

class _WhatsNewScreenState extends ConsumerState<WhatsNewScreen> {
  @override
  void initState() {
    super.initState();
    markWhatsNewSeen(ref);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.whatsNewTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(l10n.whatsNewIntro, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.md),
          for (final (i, (icon, title, body, route)) in _items(l10n).indexed)
            Card(
              key: Key('whats-new-$i'),
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
                ),
                title: Text(title),
                subtitle: Text(body),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => route == AppRoutes.home ? context.go(route) : context.push(route),
              ),
            ),
        ],
      ),
    );
  }
}
