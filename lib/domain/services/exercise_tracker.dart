/// Camera exercise tracking (spec §18–19): rep counting, hold timing and
/// form cues from pose landmarks.
///
/// Counting uses joint angles with hysteresis (separate "down" and "up"
/// thresholds), light smoothing and a minimum rep time, so landmark jitter
/// cannot produce extra reps. Frames where the needed joints are not
/// clearly visible pause tracking instead of guessing. Cues are general
/// movement guidance, never medical advice.
library;

import 'dart:math' as math;

import '../../ml/pose/pose_estimator.dart';

enum TrackingMode { reps, hold }

enum TrackingPattern {
  squat(TrackingMode.reps),
  armRaise(TrackingMode.reps),
  kneeRaise(TrackingMode.reps),
  plank(TrackingMode.hold),
  wallSit(TrackingMode.hold);

  const TrackingPattern(this.mode);
  final TrackingMode mode;

  static TrackingPattern? fromName(String? n) {
    for (final p in values) {
      if (p.name == n) return p;
    }
    return null;
  }
}

enum FormCue {
  stepIntoView,
  goLower,
  kneesOverToes,
  chestUp,
  raiseHigher,
  raiseEvenly,
  liftKneeHigher,
  keepBodyStraight,
  getIntoPosition,
  goodForm,
}

class TrackerState {
  const TrackerState({
    required this.reps,
    required this.holdSeconds,
    required this.inPosition,
    required this.tracking,
    this.cue,
  });

  static const initial = TrackerState(
      reps: 0, holdSeconds: 0, inPosition: false, tracking: false);

  final int reps;
  final double holdSeconds;

  /// Hold exercises: currently in the target position.
  final bool inPosition;

  /// The needed joints are visible in this frame.
  final bool tracking;
  final FormCue? cue;
}

class _Pt {
  const _Pt(this.x, this.y);
  final double x;
  final double y;
}

/// Angle at [b] formed by a–b–c, degrees in [0, 180].
double _angle(_Pt a, _Pt b, _Pt c) {
  final v1x = a.x - b.x, v1y = a.y - b.y, v2x = c.x - b.x, v2y = c.y - b.y;
  final n = math.sqrt(v1x * v1x + v1y * v1y) * math.sqrt(v2x * v2x + v2y * v2y);
  if (n == 0) return 180;
  final cos = ((v1x * v2x + v1y * v2y) / n).clamp(-1.0, 1.0);
  return math.acos(cos) * 180 / math.pi;
}

class ExerciseTracker {
  ExerciseTracker(this.pattern);

  final TrackingPattern pattern;

  static const minVisibility = 0.5;
  static const minRepTime = Duration(milliseconds: 600);

  int _reps = 0;
  double _hold = 0;
  DateTime? _lastTime;
  DateTime? _lastRep;
  final Map<String, double> _smooth = {};
  final Map<String, bool> _down = {};
  final Map<String, double> _cycleExtreme = {};
  FormCue? _stickyCue;
  DateTime? _stickyUntil;

  int get reps => _reps;
  double get holdSeconds => _hold;

  double _ema(String key, double v) {
    final prev = _smooth[key];
    final next = prev == null ? v : prev * 0.5 + v * 0.5;
    _smooth[key] = next;
    return next;
  }

  /// Cues stay visible for a moment so they can be read.
  void _cue(FormCue c, DateTime t) {
    _stickyCue = c;
    _stickyUntil = t.add(const Duration(seconds: 2));
  }

  FormCue? _currentCue(DateTime t) =>
      (_stickyUntil != null && t.isBefore(_stickyUntil!)) ? _stickyCue : null;

  /// Processes one frame's detection (null when nobody was detected).
  TrackerState update(PoseDetected? pose, DateTime t) {
    final dt = _lastTime == null
        ? 0.0
        : (t.difference(_lastTime!).inMilliseconds / 1000).clamp(0.0, 1.0);
    _lastTime = t;

    _Pt? p(PoseJoint j) {
      final l = pose?[j];
      if (pose == null || l == null || l.visibility < minVisibility) return null;
      return _Pt(l.x * pose.imageWidth, l.y * pose.imageHeight);
    }

    final ok = switch (pattern) {
      TrackingPattern.squat => _squat(p, t),
      TrackingPattern.armRaise => _armRaise(p, t),
      TrackingPattern.kneeRaise => _kneeRaise(p, t),
      TrackingPattern.plank => _plank(p, t, dt),
      TrackingPattern.wallSit => _wallSit(p, t, dt),
    };
    return TrackerState(
      reps: _reps,
      holdSeconds: _hold,
      inPosition: ok == true,
      tracking: ok != null,
      cue: ok == null ? FormCue.stepIntoView : _currentCue(t),
    );
  }

  /// Hysteresis rep detection on one signal. Returns true when a rep
  /// completes. [lowIsDown]: the movement makes the angle smaller.
  bool _cycle(String key, double v, double downAt, double upAt, DateTime t,
      {required bool lowIsDown}) {
    final isDown = _down[key] ?? false;
    final extreme = _cycleExtreme[key];
    _cycleExtreme[key] = extreme == null
        ? v
        : (lowIsDown ? math.min(extreme, v) : math.max(extreme, v));
    final reachedDown = lowIsDown ? v <= downAt : v >= downAt;
    final backUp = lowIsDown ? v >= upAt : v <= upAt;
    if (!isDown && reachedDown) {
      _down[key] = true;
    } else if (isDown && backUp) {
      _down[key] = false;
      _cycleExtreme.remove(key);
      if (_lastRep == null || t.difference(_lastRep!) >= minRepTime) {
        _lastRep = t;
        return true;
      }
    }
    return false;
  }

  /// A partial movement: started, went part of the way, came back.
  bool _partial(String key, double v, double startAt, double fullAt,
      double upAt, {required bool lowIsDown}) {
    if (_down[key] ?? false) return false;
    final e = _cycleExtreme[key];
    if (e == null) return false;
    final went = lowIsDown ? e <= startAt && e > fullAt : e >= startAt && e < fullAt;
    final back = lowIsDown ? v >= upAt : v <= upAt;
    if (went && back) {
      _cycleExtreme.remove(key);
      return true;
    }
    if (back) _cycleExtreme.remove(key);
    return false;
  }

  bool? _squat(_Pt? Function(PoseJoint) p, DateTime t) {
    final lh = p(PoseJoint.leftHip), lk = p(PoseJoint.leftKnee), la = p(PoseJoint.leftAnkle);
    final rh = p(PoseJoint.rightHip), rk = p(PoseJoint.rightKnee), ra = p(PoseJoint.rightAnkle);
    final angles = [
      if (lh != null && lk != null && la != null) _angle(lh, lk, la),
      if (rh != null && rk != null && ra != null) _angle(rh, rk, ra),
    ];
    if (angles.isEmpty) return null;
    final knee = _ema('knee', angles.reduce((a, b) => a + b) / angles.length);
    final wasDown = _down['knee'] ?? false;

    // Form checks while low in the squat.
    if (knee < 125) {
      if (lk != null && rk != null && la != null && ra != null) {
        final kneeGap = (lk.x - rk.x).abs(), ankleGap = (la.x - ra.x).abs();
        if (ankleGap > 0 && kneeGap < ankleGap * 0.7) _cue(FormCue.kneesOverToes, t);
      }
      final sh = p(PoseJoint.leftShoulder) ?? p(PoseJoint.rightShoulder);
      final hip = lh ?? rh;
      if (sh != null && hip != null) {
        final lean = math.atan2((sh.x - hip.x).abs(), (hip.y - sh.y).abs()) * 180 / math.pi;
        if (lean > 50) _cue(FormCue.chestUp, t);
      }
    }
    if (_cycle('knee', knee, 105, 155, t, lowIsDown: true)) {
      _reps++;
      if (_currentCue(t) == null) _cue(FormCue.goodForm, t);
    } else if (!wasDown && _partial('knee', knee, 140, 105, 155, lowIsDown: true)) {
      _cue(FormCue.goLower, t);
    }
    return true;
  }

  bool? _armRaise(_Pt? Function(PoseJoint) p, DateTime t) {
    double? elev(PoseJoint hip, PoseJoint sh, PoseJoint wr) {
      final a = p(hip), b = p(sh), c = p(wr);
      return a == null || b == null || c == null ? null : _angle(a, b, c);
    }

    final l = elev(PoseJoint.leftHip, PoseJoint.leftShoulder, PoseJoint.leftWrist);
    final r = elev(PoseJoint.rightHip, PoseJoint.rightShoulder, PoseJoint.rightWrist);
    if (l == null && r == null) return null;
    final v = _ema('arm', l != null && r != null ? (l + r) / 2 : (l ?? r)!);
    final wasUp = _down['arm'] ?? false;
    // Unevenness uses this frame's angles; smoothing would delay the cue.
    if (l != null && r != null && (l + r) / 2 > 120 && (l - r).abs() > 25) {
      _cue(FormCue.raiseEvenly, t);
    }
    if (_cycle('arm', v, 140, 45, t, lowIsDown: false)) {
      _reps++;
      if (_currentCue(t) == null) _cue(FormCue.goodForm, t);
    } else if (!wasUp && _partial('arm', v, 90, 140, 45, lowIsDown: false)) {
      _cue(FormCue.raiseHigher, t);
    }
    return true;
  }

  bool? _kneeRaise(_Pt? Function(PoseJoint) p, DateTime t) {
    var seen = false;
    for (final (side, sh, hip, knee) in [
      ('L', PoseJoint.leftShoulder, PoseJoint.leftHip, PoseJoint.leftKnee),
      ('R', PoseJoint.rightShoulder, PoseJoint.rightHip, PoseJoint.rightKnee),
    ]) {
      final a = p(sh), b = p(hip), c = p(knee);
      if (a == null || b == null || c == null) continue;
      seen = true;
      final key = 'hip$side';
      final v = _ema(key, _angle(a, b, c));
      final wasUp = _down[key] ?? false;
      if (_cycle(key, v, 120, 155, t, lowIsDown: true)) {
        _reps++;
      } else if (!wasUp && _partial(key, v, 145, 120, 155, lowIsDown: true)) {
        _cue(FormCue.liftKneeHigher, t);
      }
    }
    return seen ? true : null;
  }

  bool? _plank(_Pt? Function(PoseJoint) p, DateTime t, double dt) {
    final leftFirst = p(PoseJoint.leftShoulder) != null && p(PoseJoint.leftHip) != null;
    final sh = leftFirst ? p(PoseJoint.leftShoulder) : p(PoseJoint.rightShoulder);
    final hip = leftFirst ? p(PoseJoint.leftHip) : p(PoseJoint.rightHip);
    final ankle = (leftFirst ? p(PoseJoint.leftAnkle) : p(PoseJoint.rightAnkle)) ??
        (leftFirst ? p(PoseJoint.leftKnee) : p(PoseJoint.rightKnee));
    if (sh == null || hip == null || ankle == null) return null;
    final line = _ema('line', _angle(sh, hip, ankle));
    final tilt = math.atan2((sh.y - hip.y).abs(), (sh.x - hip.x).abs()) * 180 / math.pi;
    final horizontal = tilt < 35;
    final inPos = horizontal && line >= 160;
    if (inPos) {
      _hold += dt;
    } else if (horizontal) {
      _cue(FormCue.keepBodyStraight, t);
    } else {
      _cue(FormCue.getIntoPosition, t);
    }
    return inPos;
  }

  bool? _wallSit(_Pt? Function(PoseJoint) p, DateTime t, double dt) {
    final hip = p(PoseJoint.leftHip) ?? p(PoseJoint.rightHip);
    final knee = p(PoseJoint.leftKnee) ?? p(PoseJoint.rightKnee);
    final ankle = p(PoseJoint.leftAnkle) ?? p(PoseJoint.rightAnkle);
    if (hip == null || knee == null || ankle == null) return null;
    final a = _ema('knee', _angle(hip, knee, ankle));
    final inPos = a >= 70 && a <= 120;
    if (inPos) {
      _hold += dt;
    } else {
      _cue(a > 120 ? FormCue.goLower : FormCue.getIntoPosition, t);
    }
    return inPos;
  }
}
