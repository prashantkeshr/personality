import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/features/feature_registry.dart';
import '../../core/providers.dart';
import '../../data/repositories/face_repository.dart';
import '../../domain/entities/grooming.dart';
import '../../ml/face/face_estimator.dart';
import '../../ml/face/mlkit_face_estimator.dart';
import '../../ml/model_manager/bundled_models.dart';
import '../health/health_providers.dart';

/// The bundled ML Kit face model where available; otherwise an estimator
/// that honestly reports "model not installed".
final faceEstimatorProvider = Provider<FaceEstimator>((ref) {
  if (!ref.watch(installedModelsProvider).contains(ModelIds.face)) {
    return const UnavailableFaceEstimator();
  }
  final e = MlKitFaceEstimator();
  ref.onDispose(e.dispose);
  return e;
});

final faceRepositoryProvider = Provider((ref) => FaceRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider)));

final faceHistoryProvider = StreamProvider<List<SavedFaceAnalysis>>(
    (ref) => ref.watch(faceRepositoryProvider).watchAll());

final styleFavoritesProvider = StreamProvider<Set<String>>(
    (ref) => ref.watch(faceRepositoryProvider).watchFavorites());

final groomingContentProvider = FutureProvider<GroomingContent>((ref) async {
  final raw =
      await rootBundle.loadString('assets/content/grooming.json', cache: false);
  return GroomingContent.fromJson(jsonDecode(raw) as Map<String, dynamic>);
});
