import 'dart:math' as math;

/// How an exercise moves, drawn by our own figure — no third-party GIFs.
///
/// Body poses use absolute segment angles in degrees:
/// * side view (facing right): limbs 0 = straight down, 90 = forward,
///   180 = overhead, negative = backward; torso 0 = upright, positive =
///   leaning forward; head is relative to the torso (positive = chin down).
/// * front view: limbs 0 = down, 90 = out to the side; torso positive =
///   bending to the figure's left.
/// Each limb pair is (near, far) in side view and (left, right) in front view.
class BodyPose {
  const BodyPose({
    this.torso = 0,
    this.head = 0,
    this.upperArm = const (0, 0),
    this.forearm = const (0, 0),
    this.thigh = const (0, 0),
    this.shin = const (0, 0),
    this.lift = 0,
    this.x = 0,
  });

  final double torso;
  final double head;
  final (double, double) upperArm;
  final (double, double) forearm;
  final (double, double) thigh;
  final (double, double) shin;

  /// Height above the floor as a fraction of standing height (jumps).
  final double lift;

  /// Sideways shift as a fraction of standing height (steps, shuffles).
  final double x;

  static (double, double) _pair(Object? v, (double, double) fallback) {
    if (v == null) return fallback;
    if (v is num) return (v.toDouble(), v.toDouble());
    final l = v as List;
    return ((l[0] as num).toDouble(), (l[1] as num).toDouble());
  }

  /// Compact JSON: `t` torso, `h` head, `ua` upper arms, `fa` forearms
  /// (defaults to the upper arm), `th` thighs, `sh` shins (defaults to the
  /// thigh), `y` lift, `x` shift. A single number applies to both sides.
  factory BodyPose.fromJson(Map<String, dynamic> j) {
    final ua = _pair(j['ua'], (0, 0));
    final th = _pair(j['th'], (0, 0));
    return BodyPose(
      torso: (j['t'] as num?)?.toDouble() ?? 0,
      head: (j['h'] as num?)?.toDouble() ?? 0,
      upperArm: ua,
      forearm: _pair(j['fa'], ua),
      thigh: th,
      shin: _pair(j['sh'], th),
      lift: (j['y'] as num?)?.toDouble() ?? 0,
      x: (j['x'] as num?)?.toDouble() ?? 0,
    );
  }

  static double _l(double a, double b, double t) => a + (b - a) * t;
  static (double, double) _lp((double, double) a, (double, double) b, double t) =>
      (_l(a.$1, b.$1, t), _l(a.$2, b.$2, t));

  BodyPose lerp(BodyPose o, double t) => BodyPose(
        torso: _l(torso, o.torso, t),
        head: _l(head, o.head, t),
        upperArm: _lp(upperArm, o.upperArm, t),
        forearm: _lp(forearm, o.forearm, t),
        thigh: _lp(thigh, o.thigh, t),
        shin: _lp(shin, o.shin, t),
        lift: _l(lift, o.lift, t),
        x: _l(x, o.x, t),
      );
}

/// Face and neck rig for jaw, face and neck routines.
class FacePose {
  const FacePose({
    this.jaw = 0,
    this.smile = 0,
    this.cheeks = 0,
    this.brows = 0,
    this.eyes = 1,
    this.tongue = 0,
    this.tilt = 0,
    this.turn = 0,
    this.nod = 0,
    this.chin = 0,
    this.lips = 0,
    this.jawSide = 0,
  });

  /// 0 closed … 1 wide open.
  final double jaw;

  /// -1 frown … 1 broad smile.
  final double smile;

  /// 0 … 1 puffed.
  final double cheeks;

  /// -1 lowered … 1 raised.
  final double brows;

  /// 1 open … 0 closed.
  final double eyes;

  /// 0 resting … 1 pressed to the roof of the mouth.
  final double tongue;

  /// Ear-to-shoulder tilt in degrees (positive = to the figure's left).
  final double tilt;

  /// -1 … 1 head turn (positive = to the figure's left).
  final double turn;

  /// Degrees: positive looks down, negative looks up.
  final double nod;

  /// 0 … 1 chin tuck (head glides back).
  final double chin;

  /// 0 … 1 lips pushed forward ("oo").
  final double lips;

  /// -1 … 1 lower jaw slides sideways.
  final double jawSide;

  factory FacePose.fromJson(Map<String, dynamic> j) {
    double d(String k, double f) => (j[k] as num?)?.toDouble() ?? f;
    return FacePose(
      jaw: d('jaw', 0),
      smile: d('smile', 0),
      cheeks: d('cheeks', 0),
      brows: d('brows', 0),
      eyes: d('eyes', 1),
      tongue: d('tongue', 0),
      tilt: d('tilt', 0),
      turn: d('turn', 0),
      nod: d('nod', 0),
      chin: d('chin', 0),
      lips: d('lips', 0),
      jawSide: d('jawSide', 0),
    );
  }

  static double _l(double a, double b, double t) => a + (b - a) * t;

  FacePose lerp(FacePose o, double t) => FacePose(
        jaw: _l(jaw, o.jaw, t),
        smile: _l(smile, o.smile, t),
        cheeks: _l(cheeks, o.cheeks, t),
        brows: _l(brows, o.brows, t),
        eyes: _l(eyes, o.eyes, t),
        tongue: _l(tongue, o.tongue, t),
        tilt: _l(tilt, o.tilt, t),
        turn: _l(turn, o.turn, t),
        nod: _l(nod, o.nod, t),
        chin: _l(chin, o.chin, t),
        lips: _l(lips, o.lips, t),
        jawSide: _l(jawSide, o.jawSide, t),
      );
}

enum MotionView { side, front, face, profile }

/// One keyframe: the pose, and how long it takes to move to the next one.
class Keyframe<P> {
  const Keyframe(this.pose, this.ms, {this.hold = 0});
  final P pose;
  final int ms;

  /// Pause on this pose before moving on.
  final int hold;
}

/// A looping sequence of keyframes.
class Motion {
  const Motion({required this.id, required this.view, required this.frames, this.prop});

  final String id;
  final MotionView view;

  /// [BodyPose] keyframes for side/front views, [FacePose] for face views.
  final List<Keyframe<Object>> frames;

  /// Optional support drawn under the figure: `box_hands`, `box_feet` or `bench`.
  final String? prop;

  bool get isFace => view == MotionView.face || view == MotionView.profile;

  int get cycleMs => frames.fold(0, (s, f) => s + f.ms + f.hold);

  factory Motion.fromJson(String id, Map<String, dynamic> j) {
    final view = MotionView.values.asNameMap()[j['view']] ?? MotionView.side;
    final face = view == MotionView.face || view == MotionView.profile;
    final defaultMs = (j['ms'] as num?)?.toInt() ?? 900;
    return Motion(
      id: id,
      view: view,
      prop: j['prop'] as String?,
      frames: [
        for (final f in j['frames'] as List)
          Keyframe<Object>(
            face
                ? FacePose.fromJson(f as Map<String, dynamic>)
                : BodyPose.fromJson(f as Map<String, dynamic>),
            ((f as Map)['ms'] as num?)?.toInt() ?? defaultMs,
            hold: (f['hold'] as num?)?.toInt() ?? 0,
          ),
      ],
    );
  }

  static double _ease(double t) =>
      t < 0.5 ? 4 * t * t * t : 1 - math.pow(-2 * t + 2, 3) / 2;

  /// The pose [elapsedMs] into the loop.
  Object poseAt(int elapsedMs) {
    if (frames.length == 1 || cycleMs == 0) return frames.first.pose;
    var t = elapsedMs % cycleMs;
    for (var i = 0; i < frames.length; i++) {
      final f = frames[i];
      if (t < f.hold) return f.pose;
      t -= f.hold;
      if (t < f.ms) {
        final next = frames[(i + 1) % frames.length].pose;
        final k = _ease(t / f.ms);
        return switch ((f.pose, next)) {
          (final BodyPose a, final BodyPose b) => a.lerp(b, k),
          (final FacePose a, final FacePose b) => a.lerp(b, k),
          _ => f.pose,
        };
      }
      t -= f.ms;
    }
    return frames.first.pose;
  }

  /// Distinct poses to show side by side when motion is reduced.
  List<Object> get keyPoses => [for (final f in frames.take(3)) f.pose];
}

/// Parses `{ "<id>": { view, ms, frames: [...] } }`.
Map<String, Motion> parseMotions(Map<String, dynamic> j) => {
      for (final e in j.entries)
        if (!e.key.startsWith(r'$')) e.key: Motion.fromJson(e.key, e.value as Map<String, dynamic>),
    };
