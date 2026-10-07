import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/repositories/posture_repository.dart';
import '../../domain/services/posture_recommendations.dart';
import '../health/health_providers.dart';

final postureRepositoryProvider = Provider((ref) => PostureRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider)));

final postureHistoryProvider = StreamProvider<List<SavedPosture>>(
    (ref) => ref.watch(postureRepositoryProvider).watchAll());

/// Data-driven exercise content (spec §71).
final exerciseLibraryProvider = FutureProvider<List<ExerciseContent>>((ref) async {
  final raw = await rootBundle.loadString('assets/content/posture_exercises.json',
      cache: false);
  return [
    for (final e in jsonDecode(raw) as List)
      ExerciseContent.fromJson(e as Map<String, dynamic>),
  ];
});
