import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers.dart';
import '../features/connected/connected_screen.dart';
import '../features/insights/evolution_screen.dart';
import '../features/insights/insights_screen.dart';
import '../features/journey/goal_finder_screen.dart';
import '../features/plans/body_plan_screen.dart';
import '../features/journey/journey_screen.dart';
import '../features/dashboard/home_screen.dart';
import '../features/exercise/exercise_library_screen.dart';
import '../features/exercise/exercise_tracking_screen.dart';
import '../features/face/face_history_screen.dart';
import '../features/face/face_screen.dart';
import '../features/face/try_on_screen.dart';
import '../data/repositories/snapshot_repository.dart' show SnapshotKind;
import '../features/habits/habits_screen.dart';
import '../features/snapshots/snapshots_screen.dart';
import '../features/style/colour_screen.dart';
import '../features/style/drape_screen.dart';
import '../features/style/outfits_screen.dart';
import '../features/style/wardrobe_screen.dart';
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
import '../features/routines/plan_screen.dart';
import '../features/routines/reminders_screen.dart';
import '../features/routines/routines_screen.dart';
import '../features/settings/device_info_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/camera/camera_check_screen.dart';
import '../features/posture/posture_history_screen.dart';
import '../features/posture/posture_screen.dart';
import 'app_shell.dart';
import 'primary_tabs.dart';

abstract final class AppRoutes {
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const journey = '/home/journey';
  static const goalFinder = '/home/goals';
  static const insights = '/home/insights';
  static const evolution = '/home/evolution';
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
  static const exerciseLibrary = '/health/exercise/library';
  static const habits = '/health/habits';
  static const routines = '/health/routines';
  static const plan = '/health/plan';
  static const bodyPlan = '/health/body-plan';
  static const reminders = '/health/reminders';
  static const cameraCheck = '/analyze/camera';
  static const posture = '/analyze/posture';
  static const postureHistory = '/analyze/posture/history';
  static const face = '/analyze/face';
  static const faceHistory = '/analyze/face/history';
  static const tryOn = '/analyze/face/try-on';
  static const snapshots = '/analyze/snapshots';
  static const colours = '/style/colours';
  static const drape = '/style/colours/drape';
  static const wardrobe = '/style/wardrobe';
  static const outfits = '/style/wardrobe/outfits';
  static const garmentPhoto = '/style/wardrobe/photo';
  static const deviceInfo = '/settings/device';
  static const connected = '/settings/connected';
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
        routes: [
          GoRoute(
              path: 'device', builder: (_, _) => const DeviceInfoScreen()),
          GoRoute(
              path: 'connected',
              builder: (_, _) => const ConnectedDataScreen()),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (_, _) => const HomeScreen(),
              routes: [
                GoRoute(
                    path: 'journey',
                    builder: (_, _) => const JourneyScreen()),
                GoRoute(
                    path: 'goals',
                    builder: (_, _) => const GoalFinderScreen()),
                GoRoute(
                    path: 'insights',
                    builder: (_, _) => const InsightsScreen()),
                GoRoute(
                    path: 'evolution',
                    builder: (_, _) => const EvolutionScreen()),
              ],
            ),
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
                  builder: (_, _) => const ExerciseLogScreen(),
                  routes: [
                    GoRoute(
                      path: 'library',
                      builder: (_, state) => ExerciseLibraryScreen(
                          cameraOnly:
                              state.uri.queryParameters['camera'] == '1'),
                      routes: [
                        GoRoute(
                          path: ':id',
                          builder: (_, state) => ExerciseDetailScreen(
                              id: state.pathParameters['id']!),
                          routes: [
                            GoRoute(
                              path: 'track',
                              builder: (_, state) => ExerciseTrackingScreen(
                                  id: state.pathParameters['id']!),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                    path: 'habits', builder: (_, _) => const HabitsScreen()),
                GoRoute(
                  path: 'routines',
                  builder: (_, _) => const RoutinesScreen(),
                  routes: [
                    GoRoute(
                      path: ':id',
                      builder: (_, state) => RoutineEditorScreen(
                          routineId: state.pathParameters['id']!),
                    ),
                  ],
                ),
                GoRoute(path: 'plan', builder: (_, _) => const PlanScreen()),
                GoRoute(
                    path: 'body-plan',
                    builder: (_, _) => const BodyPlanScreen()),
                GoRoute(
                    path: 'reminders',
                    builder: (_, _) => const RemindersScreen()),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.analyze,
              builder: (_, _) => const AnalyzeTab(),
              routes: [
                GoRoute(
                    path: 'camera',
                    builder: (_, _) => const CameraCheckScreen()),
                GoRoute(
                  path: 'snapshots',
                  builder: (_, _) => const SnapshotsScreen(),
                  routes: [
                    GoRoute(
                      path: 'capture',
                      builder: (_, state) => SnapshotCaptureScreen(
                          kind: SnapshotKind.values.byName(
                              state.uri.queryParameters['kind'] ?? 'face')),
                    ),
                    GoRoute(
                      path: 'compare',
                      builder: (_, state) => SnapshotCompareScreen(
                          kind: SnapshotKind.values.byName(
                              state.uri.queryParameters['kind'] ?? 'face')),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'face',
                  builder: (_, _) => const FaceScreen(),
                  routes: [
                    GoRoute(
                        path: 'history',
                        builder: (_, _) => const FaceHistoryScreen()),
                    GoRoute(
                      path: 'try-on',
                      builder: (_, state) => TryOnScreen(
                          initialItem: state.uri.queryParameters['item']),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'posture',
                  builder: (_, _) => const PostureScreen(),
                  routes: [
                    GoRoute(
                        path: 'history',
                        builder: (_, _) => const PostureHistoryScreen()),
                  ],
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.coach, builder: (_, _) => const CoachTab()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.style,
              builder: (_, _) => const StyleTab(),
              routes: [
                GoRoute(
                  path: 'colours',
                  builder: (_, _) => const ColourScreen(),
                  routes: [
                    GoRoute(
                      path: 'drape',
                      builder: (_, state) => DrapeScreen(
                          initialHex: state.uri.queryParameters['hex']),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'wardrobe',
                  builder: (_, _) => const WardrobeScreen(),
                  routes: [
                    GoRoute(
                        path: 'outfits',
                        builder: (_, _) => const OutfitsScreen()),
                    GoRoute(
                        path: 'photo',
                        builder: (_, _) => const GarmentPhotoScreen()),
                  ],
                ),
              ],
            ),
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
