import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers.dart';
import '../features/backup/backup_screen.dart';
import '../features/connected/connected_screen.dart';
import '../features/content/content_screen.dart';
import '../features/style/get_ready_screen.dart';
import '../features/style/glasses_screen.dart';
import '../features/style/outfit_calendar_screen.dart';
import '../features/style/style_dna_screen.dart';
import '../features/style/wardrobe_stats_screen.dart';
import '../features/growth/growth_screen.dart';
import '../features/growth/skills_screens.dart';
import '../features/exercise/workouts_screen.dart';
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
import '../features/face/makeup_screen.dart';
import '../features/style/style_extras.dart';
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
import '../features/about/about_personality_screen.dart';
import '../features/reminders/goal_reminders_screen.dart';
import '../features/routines/reminders_screen.dart';
import '../features/settings/notification_settings.dart';
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
  static const aboutYou = '/home/about';
  static const goalFinder = '/home/goals';
  static const insights = '/home/insights';
  static const evolution = '/home/evolution';
  static const health = '/health';
  static const analyze = '/analyze';
  static const growth = '/growth';
  static const search = '/growth/search';
  static const skills = '/growth/skills';
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
  static const programs = '/health/exercise/programs';
  static const habits = '/health/habits';
  static const routines = '/health/routines';
  static const plan = '/health/plan';
  static const bodyPlan = '/health/body-plan';
  static const reminders = '/health/reminders';
  static const goalReminders = '/health/goal-reminders';
  static const cameraCheck = '/analyze/camera';
  static const posture = '/analyze/posture';
  static const postureHistory = '/analyze/posture/history';
  static const face = '/analyze/face';
  static const faceHistory = '/analyze/face/history';
  static const tryOn = '/analyze/face/try-on';
  static const makeup = '/analyze/face/makeup';
  static const snapshots = '/analyze/snapshots';
  static const colours = '/style/colours';
  static const drape = '/style/colours/drape';
  static const wardrobe = '/style/wardrobe';
  static const outfits = '/style/wardrobe/outfits';
  static const garmentPhoto = '/style/wardrobe/photo';
  static const wardrobeStats = '/style/wardrobe/stats';
  static const styleDna = '/style/dna';
  static const lookbook = '/style/lookbook';
  static const trends = '/style/trends';
  static const styleQa = '/style/ask';
  static const getReady = '/style/ready';
  static const outfitCalendar = '/style/calendar';
  static const glasses = '/style/glasses';
  static const deviceInfo = '/settings/device';
  static const connected = '/settings/connected';
  static const content = '/settings/content';
  static const notifications = '/settings/notifications';
  static const backup = '/settings/backup';
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
          GoRoute(path: 'backup', builder: (_, _) => const BackupScreen()),
          GoRoute(path: 'content', builder: (_, _) => const ContentScreen()),
          GoRoute(
              path: 'notifications',
              builder: (_, _) => const NotificationSettingsScreen()),
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
                    path: 'about',
                    builder: (_, _) => const AboutPersonalityScreen()),
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
                      path: 'programs',
                      builder: (_, _) => const WorkoutsScreen(),
                      routes: [
                        GoRoute(
                          path: ':id',
                          builder: (_, state) =>
                              ProgramDetailScreen(id: state.pathParameters['id']!),
                          routes: [
                            GoRoute(
                              path: 'play',
                              builder: (_, state) =>
                                  WorkoutPlayerScreen(id: state.pathParameters['id']!),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                GoRoute(
                    path: 'goal-reminders',
                    builder: (_, _) => const GoalRemindersScreen()),
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
                          initialItem: state.uri.queryParameters['item'],
                          initialColor: state.uri.queryParameters['color'],
                          initialLip: state.uri.queryParameters['lip'],
                          initialBlush: state.uri.queryParameters['blush']),
                    ),
                    GoRoute(
                        path: 'makeup',
                        builder: (_, _) => const MakeupGuideScreen()),
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
            GoRoute(
              path: AppRoutes.style,
              builder: (_, _) => const StyleTab(),
              routes: [
                GoRoute(
                    path: 'lookbook',
                    builder: (_, _) => const LookbookScreen()),
                GoRoute(
                    path: 'trends', builder: (_, _) => const TrendsScreen()),
                GoRoute(
                    path: 'ask', builder: (_, _) => const StyleQaScreen()),
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
                    GoRoute(path: 'stats', builder: (_, _) => const WardrobeStatsScreen()),
                  ],
                ),
                GoRoute(path: 'dna', builder: (_, _) => const StyleDnaScreen()),
                GoRoute(path: 'ready', builder: (_, _) => const GetReadyScreen()),
                GoRoute(path: 'calendar', builder: (_, _) => const OutfitCalendarScreen()),
                GoRoute(path: 'glasses', builder: (_, _) => const GlassesScreen()),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.growth,
              builder: (_, _) => const GrowthScreen(),
              routes: [
                GoRoute(path: 'search', builder: (_, state) => SearchScreen(initial: state.uri.queryParameters['q'] ?? '')),
                GoRoute(
                  path: 'skills',
                  builder: (_, _) => const SkillsScreen(),
                  routes: [
                    GoRoute(path: ':id', builder: (_, state) => DisciplineScreen(id: state.pathParameters['id']!)),
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
