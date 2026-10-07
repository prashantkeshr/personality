/// Deterministic posture recommendations (spec §35–36).
///
/// Rules map observed alignment to gentle, general mobility ideas with an
/// explicit "Why this?". Content is data (assets/content); this file holds
/// only the rules. No AI, no diagnosis.
library;

import '../entities/provenance.dart';
import 'posture_engine.dart';

/// Localized exercise text loaded from assets/content/posture_exercises.json.
class ExerciseContent {
  const ExerciseContent({
    required this.id,
    required this.name,
    required this.summary,
    required this.steps,
    required this.dose,
    required this.safety,
    required this.targets,
  });

  final String id;
  final Map<String, String> name;
  final Map<String, String> summary;
  final Map<String, List<String>> steps;
  final Map<String, String> dose;
  final Map<String, String> safety;
  final Set<PostureMetric> targets;

  static String pick(Map<String, String> m, String lang) =>
      m[lang] ?? m['en'] ?? m.values.first;

  static List<String> pickList(Map<String, List<String>> m, String lang) =>
      m[lang] ?? m['en'] ?? m.values.first;

  factory ExerciseContent.fromJson(Map<String, dynamic> j) {
    Map<String, String> text(String k) =>
        (j[k] as Map<String, dynamic>).map((l, v) => MapEntry(l, v as String));
    return ExerciseContent(
      id: j['id'] as String,
      name: text('name'),
      summary: text('summary'),
      steps: (j['steps'] as Map<String, dynamic>).map((l, v) =>
          MapEntry(l, (v as List).cast<String>())),
      dose: text('dose'),
      safety: text('safety'),
      targets: {
        for (final t in (j['targets'] as List).cast<String>())
          PostureMetric.values.firstWhere((m) => m.name == t),
      },
    );
  }
}

sealed class RecommendationReason {
  const RecommendationReason();
}

/// "Your shoulders measured 4° from level."
final class ObservedReason extends RecommendationReason {
  const ObservedReason(this.metric);
  final MetricResult metric;
}

/// "Your previous check showed this too."
final class RepeatedReason extends RecommendationReason {
  const RepeatedReason(this.metric);
  final PostureMetric metric;
}

/// "Posture is one of your goals."
final class GoalReason extends RecommendationReason {
  const GoalReason();
}

/// "All estimated alignments were within the typical range."
final class MaintenanceReason extends RecommendationReason {
  const MaintenanceReason();
}

class PostureRecommendation {
  const PostureRecommendation({
    required this.exercise,
    required this.reasons,
    required this.confidence,
    this.alternative,
  });

  final ExerciseContent exercise;
  final List<RecommendationReason> reasons;
  final Confidence confidence;
  final ExerciseContent? alternative;
}

abstract final class PostureRecommender {
  static const maxRecommendations = 2;
  static const generalBreakId = 'posture_break';

  /// Recommendations for [latest]. Returns nothing for low-confidence
  /// results: uncertain measurements should not drive suggestions.
  static List<PostureRecommendation> recommend({
    required PostureResult latest,
    required List<ExerciseContent> library,
    PostureResult? previous,
    bool postureGoal = false,
  }) {
    if (latest.confidence == Confidence.low || library.isEmpty) return const [];
    final general = library.where((e) => e.id == generalBreakId).firstOrNull;

    // Most notable deviations first, relative to each metric's own band.
    final flagged = latest.metrics
        .where((m) =>
            m.band != AlignmentBand.aligned && m.confidence != Confidence.low)
        .toList()
      ..sort((a, b) {
        final byBand = b.band.index.compareTo(a.band.index);
        if (byBand != 0) return byBand;
        final ra = a.degrees / PostureBands.degrees[a.metric]!.$1;
        final rb = b.degrees / PostureBands.degrees[b.metric]!.$1;
        return rb.compareTo(ra);
      });

    if (flagged.isEmpty) {
      if (general == null) return const [];
      return [
        PostureRecommendation(
          exercise: general,
          reasons: [
            const MaintenanceReason(),
            if (postureGoal) const GoalReason(),
          ],
          confidence: latest.confidence,
        ),
      ];
    }

    final chosen = <String>{};
    final result = <PostureRecommendation>[];
    for (final m in flagged) {
      if (result.length >= maxRecommendations) break;
      final options = library
          .where((e) => e.targets.contains(m.metric) && !chosen.contains(e.id))
          .toList();
      if (options.isEmpty) continue;
      final pick = options.first;
      chosen.add(pick.id);
      final before = previous?[m.metric];
      result.add(PostureRecommendation(
        exercise: pick,
        reasons: [
          ObservedReason(m),
          if (before != null && before.band != AlignmentBand.aligned)
            RepeatedReason(m.metric),
          if (postureGoal) const GoalReason(),
        ],
        confidence: m.confidence.index < latest.confidence.index
            ? m.confidence
            : latest.confidence,
        alternative: options.length > 1 ? options[1] : general,
      ));
    }
    return result;
  }
}
