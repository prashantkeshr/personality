import 'package:flutter/material.dart';

import '../../core/features/feature_registry.dart';
import '../../l10n/app_localizations.dart';

extension FeatureLabels on AppLocalizations {
  String featureName(AppFeature feature) => switch (feature) {
        AppFeature.profile => featureProfile,
        AppFeature.height => featureHeight,
        AppFeature.bodyMeasurements => featureBodyMeasurements,
        AppFeature.weight => featureWeight,
        AppFeature.water => featureWater,
        AppFeature.meals => featureMeals,
        AppFeature.sleep => featureSleep,
        AppFeature.activity => featureActivity,
        AppFeature.exercise => featureExercise,
        AppFeature.habits => featureHabits,
        AppFeature.routines => featureRoutines,
        AppFeature.reminders => featureReminders,
        AppFeature.progress => featureProgress,
        AppFeature.cameraHeightEstimate => featureCameraHeight,
        AppFeature.postureAnalysis => featurePosture,
        AppFeature.exerciseCameraTracking => featureExerciseTracking,
        AppFeature.faceAnalysis => featureFace,
        AppFeature.styleRecommendations => featureStyle,
        AppFeature.wardrobe => featureWardrobe,
        AppFeature.aiCoach => featureAiCoach,
        AppFeature.healthIntegration => featureHealthIntegration,
        AppFeature.encryptedBackup => featureBackup,
        AppFeature.commerce => featureCommerce,
      };

  String featureStateLabel(FeatureState state) => switch (state) {
        FeatureState.available => featureStateAvailable,
        FeatureState.beta => featureStateBeta,
        FeatureState.comingSoon => featureStateComingSoon,
        FeatureState.deviceRequired => featureStateDeviceRequired,
        FeatureState.modelRequired => featureStateModelRequired,
        FeatureState.onlineRequired => featureStateOnlineRequired,
        FeatureState.premium => featureStatePremium,
      };
}

IconData featureIcon(AppFeature feature) => switch (feature) {
      AppFeature.profile => Icons.person_outline,
      AppFeature.height => Icons.height,
      AppFeature.bodyMeasurements => Icons.straighten,
      AppFeature.weight => Icons.monitor_weight_outlined,
      AppFeature.water => Icons.water_drop_outlined,
      AppFeature.meals => Icons.restaurant_outlined,
      AppFeature.sleep => Icons.bedtime_outlined,
      AppFeature.activity => Icons.directions_walk,
      AppFeature.exercise => Icons.fitness_center,
      AppFeature.habits => Icons.check_circle_outline,
      AppFeature.routines => Icons.schedule,
      AppFeature.reminders => Icons.notifications_none,
      AppFeature.progress => Icons.insights_outlined,
      AppFeature.cameraHeightEstimate => Icons.photo_camera_outlined,
      AppFeature.postureAnalysis => Icons.accessibility_new,
      AppFeature.exerciseCameraTracking => Icons.videocam_outlined,
      AppFeature.faceAnalysis => Icons.face_outlined,
      AppFeature.styleRecommendations => Icons.checkroom_outlined,
      AppFeature.wardrobe => Icons.dry_cleaning_outlined,
      AppFeature.aiCoach => Icons.chat_bubble_outline,
      AppFeature.healthIntegration => Icons.health_and_safety_outlined,
      AppFeature.encryptedBackup => Icons.lock_outline,
      AppFeature.commerce => Icons.shopping_bag_outlined,
    };
