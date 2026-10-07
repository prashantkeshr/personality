import '../services/exercise_tracker.dart';
import '../services/posture_engine.dart' show PostureView;
import 'health.dart';

/// A library exercise loaded from assets/content/exercises.json (spec §18).
class LibraryExercise {
  const LibraryExercise({
    required this.id,
    required this.category,
    required this.name,
    required this.summary,
    required this.steps,
    required this.dose,
    required this.safety,
    this.pattern,
    this.view,
    this.target,
  });

  final String id;
  final ExerciseCategory category;
  final Map<String, String> name;
  final Map<String, String> summary;
  final Map<String, List<String>> steps;
  final Map<String, String> dose;
  final Map<String, String> safety;

  /// Set when the camera can count reps or time a hold.
  final TrackingPattern? pattern;
  final PostureView? view;

  /// Reps, or seconds for holds.
  final int? target;

  bool get trackable => pattern != null;

  static String pick(Map<String, String> m, String lang) =>
      m[lang] ?? m['en'] ?? m.values.first;

  static List<String> pickList(Map<String, List<String>> m, String lang) =>
      m[lang] ?? m['en'] ?? m.values.first;

  factory LibraryExercise.fromJson(Map<String, dynamic> j) {
    Map<String, String> text(String k) =>
        (j[k] as Map<String, dynamic>).map((l, v) => MapEntry(l, v as String));
    final t = j['tracking'] as Map<String, dynamic>?;
    return LibraryExercise(
      id: j['id'] as String,
      category: ExerciseCategory.values.firstWhere(
          (c) => c.name == j['category'],
          orElse: () => ExerciseCategory.generalFitness),
      name: text('name'),
      summary: text('summary'),
      steps: (j['steps'] as Map<String, dynamic>)
          .map((l, v) => MapEntry(l, (v as List).cast<String>())),
      dose: text('dose'),
      safety: text('safety'),
      pattern: TrackingPattern.fromName(t?['pattern'] as String?),
      view: t == null
          ? null
          : (t['view'] == 'side' ? PostureView.side : PostureView.front),
      target: t?['target'] as int?,
    );
  }
}
