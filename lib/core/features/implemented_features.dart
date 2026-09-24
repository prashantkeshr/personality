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
};
