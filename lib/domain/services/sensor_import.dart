/// Turns raw on-device sensor events into daily steps, activity sessions
/// and sleep estimates (pure Dart).
library;

import 'health_stats.dart';

/// Play services activity codes we track.
abstract final class MotionCodes {
  static const onBicycle = 1;
  static const walking = 7;
  static const running = 8;
  static const enter = 0;
  static const exit = 1;
}

class MotionSession {
  const MotionSession(this.start, this.end, this.kind);
  final DateTime start;
  final DateTime end;

  /// walking, running or cycling.
  final String kind;
  int get minutes => end.difference(start).inMinutes;
}

abstract final class SensorImport {
  /// Largest believable step gain between two samples; anything bigger is
  /// treated as a counter glitch.
  static const maxStepsPerSample = 15000;

  /// Steps per local day from cumulative counter samples. The counter
  /// resets on reboot: a drop means the new value is all new steps.
  static Map<int, int> stepsPerDay(List<(DateTime, int)> samples) {
    final s = [...samples]..sort((a, b) => a.$1.compareTo(b.$1));
    final out = <int, int>{};
    for (var i = 1; i < s.length; i++) {
      final (_, prev) = s[i - 1];
      final (t, cur) = s[i];
      final gain = cur >= prev ? cur - prev : cur;
      if (gain <= 0 || gain > maxStepsPerSample) continue;
      final day = Days.key(t);
      out[day] = (out[day] ?? 0) + gain;
    }
    return out;
  }

  /// Enter → exit pairs of the same activity, 10 minutes to 6 hours long.
  static List<MotionSession> sessions(List<(DateTime, int, int)> events) {
    final e = [...events]..sort((a, b) => a.$1.compareTo(b.$1));
    final open = <int, DateTime>{};
    final out = <MotionSession>[];
    for (final (t, type, transition) in e) {
      if (transition == MotionCodes.enter) {
        open[type] = t;
      } else if (transition == MotionCodes.exit && open.containsKey(type)) {
        final start = open.remove(type)!;
        final minutes = t.difference(start).inMinutes;
        if (minutes >= 10 && minutes <= 360) {
          final kind = switch (type) {
            MotionCodes.running => 'running',
            MotionCodes.onBicycle => 'cycling',
            _ => 'walking',
          };
          out.add(MotionSession(start, t, kind));
        }
      }
    }
    return out;
  }

  /// Successful sleep segments, merged across short wakes (< 1 h), kept
  /// when 3–16 hours long.
  static List<(DateTime, DateTime)> sleep(List<(DateTime, DateTime, int)> segments) {
    final ok = [
      for (final (s, e, status) in segments)
        if (status == 0 && e.isAfter(s)) (s, e)
    ]..sort((a, b) => a.$1.compareTo(b.$1));
    final merged = <(DateTime, DateTime)>[];
    for (final seg in ok) {
      if (merged.isNotEmpty && seg.$1.difference(merged.last.$2).inMinutes < 60) {
        final last = merged.removeLast();
        merged.add((last.$1, seg.$2.isAfter(last.$2) ? seg.$2 : last.$2));
      } else {
        merged.add(seg);
      }
    }
    return [
      for (final (s, e) in merged)
        if (e.difference(s).inHours >= 3 && e.difference(s).inHours <= 16) (s, e)
    ];
  }

  /// True when two time ranges overlap by more than half of the shorter.
  static bool overlaps(DateTime a1, DateTime a2, DateTime b1, DateTime b2) {
    final start = a1.isAfter(b1) ? a1 : b1;
    final end = a2.isBefore(b2) ? a2 : b2;
    if (!end.isAfter(start)) return false;
    final shorter = [a2.difference(a1), b2.difference(b1)]
        .reduce((x, y) => x < y ? x : y);
    return end.difference(start) * 2 > shorter;
  }
}
