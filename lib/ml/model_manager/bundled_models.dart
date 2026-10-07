import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/features/feature_registry.dart';

/// Models that ship inside the app. The ML Kit pose and face models are
/// bundled on Android; downloadable models arrive with the model manager (Phase 11).
final installedModelsProvider = Provider<Set<String>>((ref) {
  final android = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  return android ? const {ModelIds.pose, ModelIds.face} : const {};
});
