import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../settings/preference_controls.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _pageCount = 3;
  final _controller = PageController();
  int _page = 0;
  bool _finishing = false;

  @override
  void dispose() {
    _controller.dispose();
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
    final error = AppLocalizations.of(context).settingsSaveError;
    try {
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
                    children: const [
                      _WelcomePage(),
                      _PrivacyPage(),
                      _PreferencesPage(),
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
