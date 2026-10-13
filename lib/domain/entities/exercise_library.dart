import '../services/exercise_tracker.dart';
import '../services/posture_engine.dart' show PostureView;
import 'health.dart';

/// A library exercise: built in (assets/content/exercises.json) or from a
/// downloaded content pack (spec §18).
class LibraryExercise {
  const LibraryExercise({
    required this.id,
    required this.category,
    required this.name,
    required this.steps,
    this.summary = const {},
    this.dose = const {},
    this.safety = const {},
    this.level,
    this.equipment,
    this.muscles = const [],
    this.secondary = const [],
    this.bodyPart,
    this.motion,
    this.images = const [],
    this.credit,
    this.pack,
    this.discipline,
    this.kind,
    this.pattern,
    this.view,
    this.target,
  });

  final String id;
  final ExerciseCategory category;
  final Map<String, String> name;
  final Map<String, List<String>> steps;
  final Map<String, String> summary;
  final Map<String, String> dose;
  final Map<String, String> safety;

  /// beginner, intermediate or expert.
  final String? level;

  /// e.g. "body weight", "dumbbell".
  final String? equipment;
  final List<String> muscles;
  final List<String> secondary;
  final String? bodyPart;

  /// Id in the figure's motion library.
  final String? motion;

  /// `<pack id>/<file>` illustrations, shown when that pack is installed.
  final List<String> images;

  /// Attribution for the text and pictures, when not ours.
  final String? credit;

  /// The content pack it came from; null for built-in exercises.
  final String? pack;

  /// Martial-art or skill it belongs to (e.g. `kalaripayattu`).
  final String? discipline;

  /// stance, technique, drill or conditioning (skills only).
  final String? kind;

  /// Set when the camera can count reps or time a hold.
  final TrackingPattern? pattern;
  final PostureView? view;

  /// Reps, or seconds for holds.
  final int? target;

  bool get trackable => pattern != null;
  bool get bodyweight => equipment == null || equipment == 'body weight' || equipment == 'none';

  static String pick(Map<String, String> m, String lang) =>
      m[lang] ?? m['en'] ?? (m.isEmpty ? '' : m.values.first);

  static List<String> pickList(Map<String, List<String>> m, String lang) =>
      m[lang] ?? m['en'] ?? (m.isEmpty ? const [] : m.values.first);

  factory LibraryExercise.fromJson(Map<String, dynamic> j, {String? pack}) {
    Map<String, String> text(String k) =>
        (j[k] as Map<String, dynamic>? ?? const {}).map((l, v) => MapEntry(l, v as String));
    List<String> list(String k) => [for (final v in j[k] as List? ?? const []) '$v'];
    final t = j['tracking'] as Map<String, dynamic>?;
    return LibraryExercise(
      id: j['id'] as String,
      category: ExerciseCategory.values.asNameMap()[j['category']] ?? ExerciseCategory.generalFitness,
      name: text('name'),
      summary: text('summary'),
      steps: (j['steps'] as Map<String, dynamic>? ?? const {})
          .map((l, v) => MapEntry(l, (v as List).cast<String>())),
      dose: text('dose'),
      safety: text('safety'),
      level: j['level'] as String?,
      equipment: j['equipment'] as String?,
      muscles: list('muscles'),
      secondary: list('secondary'),
      bodyPart: j['bodyPart'] as String?,
      motion: j['motion'] as String?,
      images: list('images'),
      credit: j['credit'] as String?,
      pack: pack,
      discipline: j['discipline'] as String?,
      kind: j['kind'] as String?,
      pattern: TrackingPattern.fromName(t?['pattern'] as String?),
      view: t == null ? null : (t['view'] == 'side' ? PostureView.side : PostureView.front),
      target: t?['target'] as int?,
    );
  }
}

/// One step of a workout: an exercise for a time or a number of reps.
class ProgramStep {
  const ProgramStep({required this.exercise, this.seconds, this.reps, this.rest = 15, this.sides = false});

  final String exercise;
  final int? seconds;
  final int? reps;

  /// Rest after this step, in seconds.
  final int rest;

  /// Done once per side (the player runs it twice).
  final bool sides;

  factory ProgramStep.fromJson(Map<String, dynamic> j) => ProgramStep(
        exercise: j['exercise'] as String,
        seconds: j['seconds'] as int?,
        reps: j['reps'] as int?,
        rest: j['rest'] as int? ?? 15,
        sides: j['sides'] as bool? ?? false,
      );

  /// Rough length used for the program's total: reps take ~3 s each.
  int get workSeconds => (seconds ?? (reps ?? 10) * 3) * (sides ? 2 : 1);
}

/// A guided routine played step by step.
class WorkoutProgram {
  const WorkoutProgram({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.steps,
    this.level = 'beginner',
    this.rounds = 1,
    this.pack,
    this.note = const {},
    this.discipline,
  });

  final String id;
  final Map<String, String> title;
  final Map<String, String> summary;
  final ExerciseCategory category;
  final List<ProgramStep> steps;
  final String level;
  final int rounds;
  final String? pack;

  /// Honest expectations (e.g. what jaw exercises can't do).
  final Map<String, String> note;

  /// Martial-art or skill it trains, if any.
  final String? discipline;

  int get totalSeconds =>
      rounds * steps.fold(0, (s, x) => s + x.workSeconds + x.rest * (x.sides ? 2 : 1));
  int get minutes => (totalSeconds / 60).ceil();

  factory WorkoutProgram.fromJson(Map<String, dynamic> j, {String? pack}) {
    Map<String, String> text(String k) =>
        (j[k] as Map<String, dynamic>? ?? const {}).map((l, v) => MapEntry(l, v as String));
    return WorkoutProgram(
      id: j['id'] as String,
      title: text('title'),
      summary: text('summary'),
      note: text('note'),
      category: ExerciseCategory.values.asNameMap()[j['category']] ?? ExerciseCategory.generalFitness,
      level: j['level'] as String? ?? 'beginner',
      rounds: j['rounds'] as int? ?? 1,
      pack: pack,
      discipline: j['discipline'] as String?,
      steps: [for (final s in j['steps'] as List) ProgramStep.fromJson(s as Map<String, dynamic>)],
    );
  }
}
