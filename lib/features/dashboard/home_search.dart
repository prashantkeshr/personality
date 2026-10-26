import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../coach/coach_knowledge.dart';
import '../coach/coach_screen.dart' show CoachVisualView, coachKindLabel;

/// Home's search field: opens search over everything in the app.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        key: const Key('home-search'),
        borderRadius: BorderRadius.circular(28),
        onTap: () => context.push(AppRoutes.homeSearch),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
          child: Row(children: [
            Icon(Icons.search, color: scheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                l.homeSearchHint,
                style: TextStyle(color: scheme.onSurfaceVariant),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.auto_awesome, color: scheme.primary, size: 20),
          ]),
        ),
      ),
    );
  }
}

/// Searches exercises, workouts, skills, meals, styles, answers and every
/// screen of the app, on the phone; offers to ask the coach.
class HomeSearchScreen extends ConsumerStatefulWidget {
  const HomeSearchScreen({super.key});

  @override
  ConsumerState<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends ConsumerState<HomeSearchScreen> {
  final _q = TextEditingController();

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final index = ref.watch(coachKnowledgeProvider(lang)).value;
    final query = _q.text.trim();
    final results = index == null || query.length < 2
        ? const <KnowledgeItem>[]
        : index.search(query, k: 24, perKind: 6);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          key: const Key('home-search-field'),
          controller: _q,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(hintText: l.homeSearchHint, border: InputBorder.none),
          onChanged: (_) => setState(() {}),
        ),
        actions: [
          if (query.isNotEmpty)
            IconButton(
              tooltip: l.actionCancel,
              onPressed: () => setState(_q.clear),
              icon: const Icon(Icons.close),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          if (query.length >= 2)
            ListTile(
              key: const Key('search-ask-coach'),
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(Icons.auto_awesome, color: theme.colorScheme.onPrimaryContainer),
              ),
              title: Text(l.homeSearchAsk(query)),
              onTap: () => context.push('${AppRoutes.coach}?q=${Uri.encodeQueryComponent(query)}'),
            ),
          for (final r in results)
            ListTile(
              key: Key('search-${r.id}'),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox.square(dimension: 48, child: CoachVisualView(visual: r.visual)),
              ),
              title: Text(r.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                '${coachKindLabel(l, r.kind)} · ${r.text}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => context.push(r.route),
            ),
          if (query.length >= 2 && results.isEmpty && index != null)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(l.homeSearchNone, textAlign: TextAlign.center),
            ),
          if (query.length < 2)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                l.homeSearchTip,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
        ],
      ),
    );
  }
}
