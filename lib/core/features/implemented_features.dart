import 'feature_registry.dart';

/// Features whose functionality has shipped. Add a feature here only when its
/// complete flow works; everything else is shown as "Coming soon".
const Set<AppFeature> implementedFeatures = {
  // Phase 2
  AppFeature.profile,
  AppFeature.height,
  AppFeature.weight,
  AppFeature.bodyMeasurements,
  AppFeature.bodyProportions,
  // Phase 3
  AppFeature.water,
  AppFeature.meals,
  AppFeature.sleep,
  AppFeature.activity,
  AppFeature.exercise,
  AppFeature.habits,
  // Phase 4
  AppFeature.routines,
  AppFeature.reminders,
  // Phase 5
  AppFeature.cameraCheck,
  // Phase 6
  AppFeature.postureAnalysis,
  // Phase 7
  AppFeature.exerciseCameraTracking,
  // Phase 8
  AppFeature.faceAnalysis,
};
