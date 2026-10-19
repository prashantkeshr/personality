/// A martial art or skill shown as its own card in the Skills hub. The
/// overview and tips are built in; techniques and drills come from packs.
class Discipline {
  const Discipline({
    required this.id,
    required this.family,
    required this.name,
    required this.region,
    required this.about,
    required this.trains,
    required this.safety,
    required this.tips,
    required this.motion,
    required this.hue,
    required this.pack,
  });

  final String id;

  /// `indian` or `world`.
  final String family;
  final Map<String, String> name;
  final Map<String, String> region;
  final Map<String, String> about;
  final Map<String, String> trains;
  final Map<String, String> safety;

  /// Tricks and technique tips, each localized.
  final List<Map<String, String>> tips;

  /// Signature move for the card's figure.
  final String motion;

  /// Card colour (HSL hue, degrees).
  final double hue;

  /// Content pack with this discipline's techniques.
  final String pack;

  bool get indian => family == 'indian';

  /// Yoga and other mind-body practice, shown in its own section.
  bool get mindBody => family == 'mindbody';

  static Map<String, String> _t(Object? v) =>
      (v as Map<String, dynamic>? ?? const {}).map((k, v) => MapEntry(k, v as String));

  factory Discipline.fromJson(Map<String, dynamic> j) => Discipline(
        id: j['id'] as String,
        family: j['family'] as String,
        name: _t(j['name']),
        region: _t(j['region']),
        about: _t(j['about']),
        trains: _t(j['trains']),
        safety: _t(j['safety']),
        tips: [for (final t in j['tips'] as List? ?? const []) _t(t)],
        motion: j['motion'] as String,
        hue: (j['hue'] as num).toDouble(),
        pack: j['pack'] as String,
      );
}
