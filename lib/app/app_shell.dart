import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';

/// Primary navigation: bottom bar on phones, rail on tablets/foldables.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _select(int index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final destinations = [
      (Icons.today_outlined, Icons.today, l10n.navHome),
      (Icons.favorite_outline, Icons.favorite, l10n.navHealth),
      (Icons.center_focus_weak, Icons.center_focus_strong, l10n.navAnalyze),
      (Icons.lightbulb_outline, Icons.lightbulb, l10n.navCoach),
      (Icons.checkroom_outlined, Icons.checkroom, l10n.navStyle),
    ];
    final width = MediaQuery.sizeOf(context).width;

    if (width < AppBreakpoints.rail) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: FloatingNavBar(
          selectedIndex: navigationShell.currentIndex,
          onSelected: _select,
          destinations: destinations,
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _select,
              extended: width >= AppBreakpoints.expanded,
              labelType: width >= AppBreakpoints.expanded
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              destinations: [
                for (final (icon, selected, label) in destinations)
                  NavigationRailDestination(
                    icon: Icon(icon),
                    selectedIcon: Icon(selected),
                    label: Text(label),
                  ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}

/// A floating, rounded bottom bar: the selected tab gets a soft pill behind
/// a filled icon and a bolder label. Animations honour reduce motion.
class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<(IconData, IconData, String)> destinations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final reduce = MediaQuery.disableAnimationsOf(context);
    final duration = reduce ? Duration.zero : const Duration(milliseconds: 260);
    final count = destinations.length;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.sm),
        child: Material(
          color: scheme.surfaceContainer,
          elevation: 3,
          shadowColor: Colors.black.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.4)),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 68,
            child: Row(children: [
              for (final (i, (icon, selectedIcon, label)) in destinations.indexed)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: i == selectedIndex,
                    label: label,
                    hint: '${i + 1} / $count',
                    excludeSemantics: true,
                    child: InkWell(
                      onTap: () => onSelected(i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: duration,
                            curve: Curves.easeOutCubic,
                            width: i == selectedIndex ? 56 : 32,
                            height: 30,
                            decoration: BoxDecoration(
                              color: i == selectedIndex
                                  ? scheme.primaryContainer
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              i == selectedIndex ? selectedIcon : icon,
                              size: 22,
                              color: i == selectedIndex
                                  ? scheme.onPrimaryContainer
                                  : scheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: duration,
                            style: theme.textTheme.labelSmall!.copyWith(
                              fontWeight: i == selectedIndex
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: i == selectedIndex
                                  ? scheme.onSurface
                                  : scheme.onSurfaceVariant,
                            ),
                            child: Text(label,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}
