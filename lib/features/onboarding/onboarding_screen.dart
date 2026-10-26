import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../settings/preference_controls.dart';
import '../../domain/entities/body.dart';
import '../../shared/format/body_format.dart';
import '../journey/goal_finder_screen.dart' show GoalArt, goalIcon;
import '../../domain/services/training_engine.dart';
import '../training/training_providers.dart';
import '../training/training_screen.dart';
import 'about_you.dart';
import 'permissions_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _pageCount = 7;

  /// Page order: welcome, goals, preferences (units come before height and
  /// weight), about you, training, privacy, permissions.
  static const _aboutPage = 3;
  static const _trainingPage = 4;
  final _controller = PageController();
  final _about = AboutYouData();
  final _reminders = StarterReminders();
  int _page = 0;
  bool _finishing = false;
  TrainingPrefs _training = const TrainingPrefs();

  /// Until the user picks a focus, it follows the gender from About you.
  bool _focusTouched = false;

  @override
  void dispose() {
    _controller.dispose();
    _about.dispose();
    _reminders.dispose();
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

  /// About you is checked as you leave it, so a typo is shown right there
  /// rather than on the last page.
  void _next() {
    final aboutPage = _page == _aboutPage;
    final units = ref.read(settingsControllerProvider).unitSystem;
    if (aboutPage && !_about.valid(units)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).onboardingInvalid)),
      );
      return;
    }
    if (_page + 1 == _trainingPage && !_focusTouched) {
      setState(() => _training =
          _training.copyWith(focus: TrainingPrefs.focusFor(_about.gender)));
    }
    _goTo(_page + 1);
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
      await _reminders.apply(ref, l10n);
      await ref.read(trainingActionsProvider).savePrefs(_training);
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
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.onboardingStep(_page + 1, _pageCount),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(end: (_page + 1) / _pageCount),
                          duration: MediaQuery.disableAnimationsOf(context)
                              ? Duration.zero
                              : const Duration(milliseconds: 300),
                          builder: (_, v, _) => LinearProgressIndicator(
                            key: const Key('onboarding-progress'),
                            value: v,
                            minHeight: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (p) => setState(() => _page = p),
                    children: [
                      const _WelcomePage(),
                      _GoalsPage(data: _about),
                      const _PreferencesPage(),
                      AboutYouPage(data: _about),
                      _TrainingPage(
                        value: _training,
                        about: _about,
                        onChanged: (v) => setState(() {
                          _focusTouched |= v.focus != _training.focus;
                          _training = v;
                        }),
                      ),
                      const _PrivacyPage(),
                      PermissionsPage(reminders: _reminders),
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
                                : _next,
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
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      children: [
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset('assets/images/brand/app_icon.png',
                width: 112, height: 112),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Semantics(
          header: true,
          child: Text(l10n.onboardingWelcomeTitle,
              textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.onboardingWelcomeBody,
            textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.lg),
        for (final (icon, title, body) in [
          (Icons.lock_outline, l10n.welcomePrivateTitle, l10n.welcomePrivateBody),
          (Icons.calendar_month, l10n.welcomePlanTitle, l10n.welcomePlanBody),
          (Icons.auto_awesome, l10n.welcomeAllTitle, l10n.welcomeAllBody),
        ])
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
              ),
              title: Text(title),
              subtitle: Text(body),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
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
                              GoalArt(g),
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

/// Training setup with a live preview of the week it builds.
class _TrainingPage extends StatelessWidget {
  const _TrainingPage({
    required this.value,
    required this.about,
    required this.onChanged,
  });

  final TrainingPrefs value;
  final AboutYouData about;
  final ValueChanged<TrainingPrefs> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final week = TrainingEngine.week(
      prefs: value,
      goals: about.goals,
      age: about.ageRange,
    );
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      children: [
        const SizedBox(height: AppSpacing.lg),
        Semantics(
          header: true,
          child: Text(l10n.onboardingTrainingTitle,
              style: theme.textTheme.headlineSmall),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.onboardingTrainingBody, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        Card(
          key: const Key('onboarding-week'),
          color: scheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.onboardingYourWeek, style: theme.textTheme.labelLarge),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final d in week)
                      if (!d.isRest)
                        Chip(
                          avatar: Icon(sessionIcon(d.type), size: 16),
                          label: Text(sessionLabel(l10n, d.type)),
                          visualDensity: VisualDensity.compact,
                        ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.onboardingWeekNote(
                    week.where((d) => !d.isRest).length,
                    week.where((d) => !d.isRest).first.exercises.length,
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        TrainingPrefsForm(value: value, onChanged: onChanged),
        const SizedBox(height: AppSpacing.sm),
        Text(l10n.onboardingTrainingLater, style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
