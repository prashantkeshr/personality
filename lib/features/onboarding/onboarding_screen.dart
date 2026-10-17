import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../settings/preference_controls.dart';
import '../../domain/entities/body.dart';
import '../../shared/format/body_format.dart';
import '../journey/goal_finder_screen.dart' show goalIcon, goalImages;
import 'about_you.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _pageCount = 5;
  final _controller = PageController();
  final _about = AboutYouData();
  int _page = 0;
  bool _finishing = false;

  @override
  void dispose() {
    _controller.dispose();
    _about.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) {
      _controller.jumpToPage(page);
    } else {
      _controller.animateToPage(page,
          duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }
  }

  Future<void> _finish() async {
    setState(() => _finishing = true);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    final error = l10n.settingsSaveError;
    try {
      if (!await _about.save(ref)) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.onboardingInvalid)));
        if (mounted) setState(() => _finishing = false);
        return;
      }
      await ref
          .read(settingsControllerProvider.notifier)
          .update((s) => s.copyWith(onboardingCompleted: true));
      // The router redirects to Home once onboarding is marked complete.
    } catch (e, st) {
      AppLogger.error('onboarding.finish', e, st);
      messenger.showSnackBar(SnackBar(content: Text(error)));
      if (mounted) setState(() => _finishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLast = _page == _pageCount - 1;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      l10n.onboardingStep(_page + 1, _pageCount),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (p) => setState(() => _page = p),
                    children: [
                      const _WelcomePage(),
                      _GoalsPage(data: _about),
                      const _PrivacyPage(),
                      const _PreferencesPage(),
                      AboutYouPage(data: _about),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      if (_page > 0)
                        TextButton(
                          onPressed: () => _goTo(_page - 1),
                          child: Text(l10n.actionBack),
                        ),
                      const Spacer(),
                      FilledButton(
                        onPressed: _finishing
                            ? null
                            : isLast
                                ? _finish
                                : () => _goTo(_page + 1),
                        child: Text(
                            isLast ? l10n.actionGetStarted : l10n.actionNext),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageScaffold extends StatelessWidget {
  const _PageScaffold({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      children: [
        const SizedBox(height: AppSpacing.xl),
        Icon(icon, size: 48, color: theme.colorScheme.primary),
        const SizedBox(height: AppSpacing.xl),
        Semantics(
          header: true,
          child: Text(title, style: theme.textTheme.headlineSmall),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...children,
      ],
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _PageScaffold(
      icon: Icons.spa_outlined,
      title: l10n.onboardingWelcomeTitle,
      children: [
        Text(l10n.onboardingWelcomeBody,
            style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

class _PrivacyPage extends StatelessWidget {
  const _PrivacyPage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final points = [
      (Icons.lock_outline, l10n.onboardingPrivacyEncrypted),
      (Icons.photo_camera_outlined, l10n.onboardingPrivacyCamera),
      (Icons.person_off_outlined, l10n.onboardingPrivacyAccount),
      (Icons.memory_outlined, l10n.onboardingPrivacyAi),
    ];
    return _PageScaffold(
      icon: Icons.shield_outlined,
      title: l10n.onboardingPrivacyTitle,
      children: [
        for (final (icon, text) in points)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(icon),
            title: Text(text),
          ),
      ],
    );
  }
}

class _PreferencesPage extends StatelessWidget {
  const _PreferencesPage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Widget label(String text) => Padding(
          padding: const EdgeInsets.only(
              top: AppSpacing.xl, bottom: AppSpacing.sm),
          child: Text(text, style: theme.textTheme.labelLarge),
        );

    return _PageScaffold(
      icon: Icons.tune,
      title: l10n.onboardingPrefsTitle,
      children: [
        Text(l10n.onboardingPrefsBody, style: theme.textTheme.bodyMedium),
        label(l10n.settingsUnits),
        const UnitSystemSelector(),
        label(l10n.settingsLanguage),
        const LanguageSelector(),
        label(l10n.settingsAppearance),
        const ThemeModeSelector(),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

/// Goals first: everything after this page follows from them.
class _GoalsPage extends StatefulWidget {
  const _GoalsPage({required this.data});
  final AboutYouData data;

  @override
  State<_GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<_GoalsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final goals = widget.data.goals;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      children: [
        const SizedBox(height: AppSpacing.lg),
        Semantics(
          header: true,
          child: Text(
            l10n.onboardingGoalsTitle,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.onboardingGoalsBody, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.lg),
        LayoutBuilder(
          builder: (context, c) {
            final w = (c.maxWidth - AppSpacing.sm) / 2;
            return Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final g in GoalType.values)
                  SizedBox(
                    width: w,
                    height: 96,
                    child: Semantics(
                      selected: goals.contains(g),
                      button: true,
                      child: Card(
                        margin: EdgeInsets.zero,
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          key: Key('onboard-goal-${g.name}'),
                          onTap: () => setState(
                            () => goals.contains(g)
                                ? goals.remove(g)
                                : goals.add(g),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(goalImages[g]!, fit: BoxFit.cover),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: goals.contains(g)
                                      ? theme.colorScheme.primary.withValues(
                                          alpha: 0.55,
                                        )
                                      : const Color(0x8A000000),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      goalIcon(g),
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: AppSpacing.xs),
                                    Expanded(
                                      child: Text(
                                        l10n.goalLabel(g),
                                        maxLines: 2,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    if (goals.contains(g))
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
