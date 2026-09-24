import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers.dart';
import '../features/dashboard/home_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/settings/settings_screen.dart';
import 'app_shell.dart';
import 'primary_tabs.dart';

abstract final class AppRoutes {
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const health = '/health';
  static const analyze = '/analyze';
  static const coach = '/coach';
  static const style = '/style';
  static const settings = '/settings';
}

final routerProvider = Provider<GoRouter>((ref) {
  // Re-run redirects when onboarding completes.
  final refresh = ValueNotifier(0);
  ref.listen(
    settingsControllerProvider.select((s) => s.onboardingCompleted),
    (_, _) => refresh.value++,
  );

  final router = GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: refresh,
    redirect: (context, state) {
      final done = ref.read(settingsControllerProvider).onboardingCompleted;
      final atOnboarding = state.matchedLocation == AppRoutes.onboarding;
      if (!done && !atOnboarding) return AppRoutes.onboarding;
      if (done && atOnboarding) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.health, builder: (_, _) => const HealthTab()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.analyze,
                builder: (_, _) => const AnalyzeTab()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.coach, builder: (_, _) => const CoachTab()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.style, builder: (_, _) => const StyleTab()),
          ]),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
