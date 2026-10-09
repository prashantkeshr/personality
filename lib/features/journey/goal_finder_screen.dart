import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/style_repository.dart';
import '../../domain/entities/body.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/format/body_format.dart';
import '../../shared/visual/reveal.dart';
import '../health/body_providers.dart';
import '../style/style_labels.dart';
import '../style/style_providers.dart';

/// Photo for each choice (Unsplash, credited in assets/images/goals/CREDITS.md).
const goalImages = <GoalType, String>{
  GoalType.posture: 'assets/images/goals/posture.jpg',
  GoalType.weightManagement: 'assets/images/goals/weight.jpg',
  GoalType.fitness: 'assets/images/goals/fitness.jpg',
  GoalType.flexibility: 'assets/images/goals/flexibility.jpg',
  GoalType.hydration: 'assets/images/goals/hydration.jpg',
  GoalType.sleep: 'assets/images/goals/sleep.jpg',
  GoalType.habits: 'assets/images/goals/habits.jpg',
  GoalType.style: 'assets/images/goals/style.jpg',
  GoalType.grooming: 'assets/images/goals/grooming.jpg',
};

/// Look photos per style, tagged with who they are styled for. The finder
/// shows the ones matching the user's style fit (all of them if none match).
const styleImages = <StylePreference, List<(String, StyleFit)>>{
  StylePreference.classic: [
    ('assets/images/looks/classic_1.jpg', StyleFit.menswear),
    ('assets/images/looks/classic_2.jpg', StyleFit.menswear),
    ('assets/images/looks/classic_3.jpg', StyleFit.womenswear),
  ],
  StylePreference.minimal: [
    ('assets/images/looks/minimal_1.jpg', StyleFit.womenswear),
    ('assets/images/looks/minimal_2.jpg', StyleFit.womenswear),
    ('assets/images/looks/minimal_3.jpg', StyleFit.menswear),
  ],
  StylePreference.smartCasual: [
    ('assets/images/looks/smart_1.jpg', StyleFit.menswear),
    ('assets/images/looks/smart_2.jpg', StyleFit.menswear),
    ('assets/images/looks/smart_3.jpg', StyleFit.womenswear),
  ],
  StylePreference.street: [
    ('assets/images/looks/street_1.jpg', StyleFit.menswear),
    ('assets/images/looks/street_2.jpg', StyleFit.womenswear),
  ],
  StylePreference.traditional: [
    ('assets/images/looks/traditional_1.jpg', StyleFit.womenswear),
    ('assets/images/looks/traditional_2.jpg', StyleFit.womenswear),
    ('assets/images/looks/traditional_3.jpg', StyleFit.menswear),
    ('assets/images/looks/traditional_4.jpg', StyleFit.menswear),
  ],
  StylePreference.sporty: [
    ('assets/images/looks/sporty_1.jpg', StyleFit.menswear),
    ('assets/images/looks/sporty_2.jpg', StyleFit.menswear),
    ('assets/images/looks/sporty_3.jpg', StyleFit.womenswear),
  ],
};

/// The look photos to show for [style] given the user's [fit].
List<String> looksFor(StylePreference style, StyleFit fit) {
  final all = styleImages[style]!;
  final match = [
    for (final (path, f) in all)
      if (fit == StyleFit.all || f == StyleFit.all || f == fit) path,
  ];
  return match.isNotEmpty ? match : [for (final (path, _) in all) path];
}

IconData goalIcon(GoalType g) => switch (g) {
      GoalType.posture => Icons.accessibility_new,
      GoalType.weightManagement => Icons.monitor_weight_outlined,
      GoalType.fitness => Icons.directions_run,
      GoalType.flexibility => Icons.self_improvement,
      GoalType.hydration => Icons.water_drop_outlined,
      GoalType.sleep => Icons.bedtime_outlined,
      GoalType.habits => Icons.task_alt,
      GoalType.style => Icons.checkroom_outlined,
      GoalType.grooming => Icons.content_cut,
    };

/// A visual way to choose goals and style: tap the images that appeal.
class GoalFinderScreen extends ConsumerStatefulWidget {
  const GoalFinderScreen({super.key});

  @override
  ConsumerState<GoalFinderScreen> createState() => _GoalFinderScreenState();
}

class _GoalFinderScreenState extends ConsumerState<GoalFinderScreen> {
  int _step = 0;
  Set<GoalType>? _goals;
  Set<StylePreference>? _styles;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // Start from what the user already chose.
    _goals ??= ref.watch(goalsProvider).value?.toSet();
    _styles ??= ref.watch(styleProfileProvider).value?.styles.toSet();
    final fit = ref.watch(profileProvider).value?.effectiveStyleFit ??
        StyleFit.all;
    final goals = _goals, styles = _styles;
    if (goals == null || styles == null) {
      return Scaffold(
          appBar: AppBar(title: Text(l10n.goalFinderTitle)),
          body: const Center(child: CircularProgressIndicator()));
    }

    final count = _step == 0 ? goals.length : styles.length;
    final List<_Choice> choices = _step == 0
        ? [
            for (final g in GoalType.values)
              _Choice(
                key: 'goal-${g.name}',
                label: l10n.goalLabel(g),
                image: goalImages[g]!,
                icon: goalIcon(g),
                selected: goals.contains(g),
                onTap: () => setState(() =>
                    goals.contains(g) ? goals.remove(g) : goals.add(g)),
              ),
          ]
        : [
            for (final s in StylePreference.values)
              for (final (i, image) in looksFor(s, fit).indexed)
                _Choice(
                  key: 'look-${s.name}-$i',
                  label: l10n.stylePrefName(s),
                  image: image,
                  icon: Icons.checkroom_outlined,
                  selected: styles.contains(s),
                  onTap: () => setState(() =>
                      styles.contains(s) ? styles.remove(s) : styles.add(s)),
                ),
          ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.goalFinderTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: (_step + 1) / 2),
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 400),
            builder: (_, v, _) => LinearProgressIndicator(value: v),
          ),
        ),
      ),
      body: CustomScrollView(
        key: ValueKey(_step),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_step == 0 ? l10n.goalFinderStep1 : l10n.goalFinderStep2,
                      style: theme.textTheme.headlineSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                      _step == 0
                          ? l10n.goalFinderStep1Hint
                          : l10n.goalFinderStep2Hint,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.78,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => Reveal(
                    index: i, child: _ChoiceCard(choices[i])),
                childCount: choices.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 96)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(children: [
            if (_step == 1)
              TextButton(
                onPressed: () => setState(() => _step = 0),
                child: Text(l10n.goalFinderBack),
              ),
            Expanded(
              child: Text(l10n.goalFinderSelected(count),
                  textAlign: _step == 1 ? TextAlign.center : TextAlign.start,
                  style: theme.textTheme.bodyMedium),
            ),
            FilledButton(
              onPressed: _step == 0
                  ? () => setState(() => _step = 1)
                  : () => _save(goals, styles),
              child: Text(
                  _step == 0 ? l10n.goalFinderNext : l10n.goalFinderSave),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _save(Set<GoalType> goals, Set<StylePreference> styles) async {
    final messenger = ScaffoldMessenger.of(context);
    final text = AppLocalizations.of(context).goalFinderSaved;
    await ref.read(profileRepositoryProvider).setGoals(goals);
    await ref.read(styleRepositoryProvider).setStyles(styles);
    if (!mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(text)));
    context.pop();
  }
}

class _Choice {
  const _Choice({
    required this.key,
    required this.label,
    required this.image,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String key;
  final String label;
  final String image;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard(this.c);
  final _Choice c;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reduce = MediaQuery.disableAnimationsOf(context);
    final duration = reduce ? Duration.zero : const Duration(milliseconds: 260);
    return Semantics(
      button: true,
      selected: c.selected,
      label: c.label,
      excludeSemantics: true,
      child: GestureDetector(
        key: Key(c.key),
        onTap: c.onTap,
        child: AnimatedScale(
          scale: c.selected ? 0.96 : 1,
          duration: duration,
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: duration,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  width: c.selected ? 3 : 0,
                  color: c.selected ? scheme.primary : Colors.transparent),
              boxShadow: [
                if (c.selected)
                  BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.35),
                      blurRadius: 14),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(fit: StackFit.expand, children: [
                Image.asset(
                  c.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          scheme.primaryContainer,
                          scheme.tertiaryContainer
                        ],
                      ),
                    ),
                    child: Icon(c.icon,
                        size: 48, color: scheme.primary.withValues(alpha: 0.7)),
                  ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.5, 1],
                      colors: [Color(0x00000000), Color(0xB3000000)],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 10,
                  child: Text(c.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ),
                if (photoCredits[c.image] case final credit?)
                  Positioned(
                    left: 8,
                    top: 8,
                    right: 44,
                    child: Text(credit,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Color(0xCCFFFFFF),
                            fontSize: 10,
                            shadows: [Shadow(blurRadius: 4)])),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: AnimatedScale(
                    scale: c.selected ? 1 : 0,
                    duration: duration,
                    curve: Curves.easeOutBack,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: scheme.primary,
                      child: Icon(Icons.check, size: 18, color: scheme.onPrimary),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// Photographer credit per bundled photo (Unsplash License).
const photoCredits = <String, String>{
  'assets/images/goals/posture.jpg': 'Laura Chouette',
  'assets/images/goals/weight.jpg': 'Andreas Rasmussen',
  'assets/images/goals/fitness.jpg': 'Jorge Alberto Vega Barrera',
  'assets/images/goals/flexibility.jpg': 'Matea Brajdić',
  'assets/images/goals/hydration.jpg': 'KOBU Agency',
  'assets/images/goals/sleep.jpg': 'Dmitry Ganin',
  'assets/images/goals/habits.jpg': 'Sixteen Miles Out',
  'assets/images/goals/style.jpg': 'amir soltani',
  'assets/images/goals/grooming.jpg': 'Agustin Fernandez',
  'assets/images/goals/feed_exercise.jpg': 'Rodrigo Rodrigues',
  'assets/images/goals/feed_wardrobe.jpg': 'Thom Bradley',
  'assets/images/goals/feed_colours.jpg': 'Moonstarious Project',
  'assets/images/looks/classic_1.jpg': 'Mohamad Khosravi',
  'assets/images/looks/classic_2.jpg': 'Ruthson Zimmerman',
  'assets/images/looks/minimal_1.jpg': 'Renata K. Needham',
  'assets/images/looks/minimal_2.jpg': 'Ron McClenny',
  'assets/images/looks/smart_1.jpg': 'Mohamad Khosravi',
  'assets/images/looks/smart_2.jpg': 'Shan A. Rajpoot',
  'assets/images/looks/street_1.jpg': 'MARK ADRIANE',
  'assets/images/looks/street_2.jpg': 'Mike Von',
  'assets/images/looks/traditional_1.jpg': 'Chandrakant Sontakke',
  'assets/images/looks/traditional_2.jpg': 'Sabesh Photography LTD',
  'assets/images/looks/sporty_1.jpg': 'Florian Kurrasch',
  'assets/images/looks/sporty_2.jpg': 'Reza Hasannia',
  'assets/images/goals/plan.jpg': 'Leanna Myers',
  'assets/images/looks/classic_3.jpg': 'Laura Chouette',
  'assets/images/looks/minimal_3.jpg': 'Rodrigo Sümmer',
  'assets/images/looks/smart_3.jpg': 'Nassim Boughazi',
  'assets/images/looks/traditional_3.jpg': 'Noor Alam',
  'assets/images/looks/traditional_4.jpg': 'Noor Alam',
  'assets/images/looks/sporty_3.jpg': 'nobleseed nobleseed',
};
