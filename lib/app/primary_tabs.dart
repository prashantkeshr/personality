import 'package:flutter/material.dart';

import '../core/features/feature_registry.dart';
import '../l10n/app_localizations.dart';
import '../shared/widgets/feature_overview_screen.dart';
import 'router.dart';

class HealthTab extends StatelessWidget {
  const HealthTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeatureOverviewScreen(
      title: l10n.navHealth,
      intro: l10n.healthIntro,
      heroImage: 'assets/images/goals/fitness.jpg',
      features: const [
        AppFeature.profile,
        AppFeature.height,
        AppFeature.weight,
        AppFeature.bodyMeasurements,
        AppFeature.bodyProportions,
        AppFeature.water,
        AppFeature.meals,
        AppFeature.sleep,
        AppFeature.activity,
        AppFeature.exercise,
        AppFeature.habits,
        AppFeature.bodyPlan,
        AppFeature.routines,
        AppFeature.reminders,
        AppFeature.progress,
        AppFeature.healthIntegration,
      ],
      routes: const {
        AppFeature.profile: AppRoutes.profile,
        AppFeature.height: AppRoutes.height,
        AppFeature.weight: AppRoutes.weight,
        AppFeature.bodyMeasurements: AppRoutes.measurements,
        AppFeature.bodyProportions: AppRoutes.proportions,
        AppFeature.water: AppRoutes.water,
        AppFeature.meals: AppRoutes.meals,
        AppFeature.sleep: AppRoutes.sleep,
        AppFeature.activity: AppRoutes.activity,
        AppFeature.exercise: AppRoutes.exercise,
        AppFeature.habits: AppRoutes.habits,
        AppFeature.routines: AppRoutes.routines,
        AppFeature.reminders: AppRoutes.reminders,
        AppFeature.progress: AppRoutes.journey,
        AppFeature.bodyPlan: AppRoutes.bodyPlan,
        AppFeature.healthIntegration: AppRoutes.connected,
      },
    );
  }
}

class AnalyzeTab extends StatelessWidget {
  const AnalyzeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeatureOverviewScreen(
      title: l10n.navAnalyze,
      intro: l10n.analyzeIntro,
      heroImage: 'assets/images/goals/posture.jpg',
      features: const [
        AppFeature.cameraCheck,
        AppFeature.postureAnalysis,
        AppFeature.cameraHeightEstimate,
        AppFeature.faceAnalysis,
        AppFeature.progressSnapshots,
        AppFeature.exerciseCameraTracking,
      ],
      routes: {
        AppFeature.cameraCheck: AppRoutes.cameraCheck,
        AppFeature.postureAnalysis: AppRoutes.posture,
        AppFeature.faceAnalysis: AppRoutes.face,
        AppFeature.progressSnapshots: AppRoutes.snapshots,
        AppFeature.exerciseCameraTracking:
            '${AppRoutes.exerciseLibrary}?camera=1',
      },
    );
  }
}

class CoachTab extends StatelessWidget {
  const CoachTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeatureOverviewScreen(
      title: l10n.navCoach,
      intro: l10n.coachIntro,
      heroImage: 'assets/images/goals/habits.jpg',
      features: const [AppFeature.aiCoach],
    );
  }
}

class StyleTab extends StatelessWidget {
  const StyleTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeatureOverviewScreen(
      title: l10n.navStyle,
      intro: l10n.styleIntro,
      heroImage: 'assets/images/looks/smart_1.jpg',
      features: const [
        AppFeature.styleRecommendations,
        AppFeature.wardrobe,
        AppFeature.commerce,
      ],
      routes: const {
        AppFeature.styleRecommendations: AppRoutes.colours,
        AppFeature.wardrobe: AppRoutes.wardrobe,
      },
    );
  }
}
