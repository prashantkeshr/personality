import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers.dart';
import '../features/dashboard/home_screen.dart';
import '../features/habits/habits_screen.dart';
import '../features/health/activity/activity_screen.dart';
import '../features/health/exercise/exercise_log_screen.dart';
import '../features/health/meals/meals_screen.dart';
import '../features/health/sleep/sleep_screen.dart';
import '../features/health/water/water_screen.dart';
import '../features/health/height/height_screen.dart';
import '../features/health/measurements/measurements_screen.dart';
import '../features/health/proportions/proportions_screen.dart';
import '../features/health/weight/weight_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/profile/profile_screen.dart';
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
  static const profile = '/health/profile';
  static const height = '/health/height';
  static const weight = '/health/weight';
  static const measurements = '/health/measurements';
  static const proportions = '/health/proportions';
  static const water = '/health/water';
  static const meals = '/health/meals';
  static const sleep = '/health/sleep';
  static const activity = '/health/activity';
  static const exercise = '/health/exercise';
  static const habits = '/health/habits';
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
              path: AppRoutes.health,
              builder: (_, _) => const HealthTab(),
              routes: [
                GoRoute(
                    path: 'profile',
                    builder: (_, _) => const ProfileScreen()),
                GoRoute(
                    path: 'height', builder: (_, _) => const HeightScreen()),
                GoRoute(
                    path: 'weight', builder: (_, _) => const WeightScreen()),
                GoRoute(
                    path: 'measurements',
                    builder: (_, _) => const MeasurementsScreen()),
                GoRoute(
                    path: 'proportions',
                    builder: (_, _) => const ProportionsScreen()),
                GoRoute(
                    path: 'water', builder: (_, _) => const WaterScreen()),
                GoRoute(
                    path: 'meals', builder: (_, _) => const MealsScreen()),
                GoRoute(
                    path: 'sleep', builder: (_, _) => const SleepScreen()),
                GoRoute(
                    path: 'activity',
                    builder: (_, _) => const ActivityScreen()),
                GoRoute(
                    path: 'exercise',
                    builder: (_, _) => const ExerciseLogScreen()),
                GoRoute(
                    path: 'habits', builder: (_, _) => const HabitsScreen()),
              ],
            ),
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
