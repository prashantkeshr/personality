import 'package:flutter/material.dart';

import '../core/features/feature_registry.dart';
import '../l10n/app_localizations.dart';
import '../shared/widgets/feature_overview_screen.dart';

class HealthTab extends StatelessWidget {
  const HealthTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeatureOverviewScreen(
      title: l10n.navHealth,
      intro: l10n.healthIntro,
      features: const [
        AppFeature.profile,
        AppFeature.height,
        AppFeature.weight,
        AppFeature.bodyMeasurements,
        AppFeature.water,
        AppFeature.meals,
        AppFeature.sleep,
        AppFeature.activity,
        AppFeature.exercise,
        AppFeature.habits,
        AppFeature.routines,
        AppFeature.reminders,
        AppFeature.progress,
      ],
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
      features: const [
        AppFeature.postureAnalysis,
        AppFeature.cameraHeightEstimate,
        AppFeature.faceAnalysis,
        AppFeature.exerciseCameraTracking,
      ],
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
      features: const [
        AppFeature.styleRecommendations,
        AppFeature.wardrobe,
        AppFeature.commerce,
      ],
    );
  }
}
