/// Frame selection (spec §16 "FRAME SELECTION", §67 frame throttling).
///
/// Cameras deliver 30+ frames per second; analysis runs at the power mode's
/// rate and never queues work: if the previous frame is still being
/// analyzed, new frames are dropped instead of piling up.
class FrameSampler {
  FrameSampler({required int targetFps})
      : interval = Duration(microseconds: 1000000 ~/ targetFps);

  final Duration interval;
  DateTime? _last;
  bool _busy = false;

  int accepted = 0;
  int skipped = 0;

  /// Whether to analyze a frame arriving at [at]. Call [done] afterwards.
  bool accept(DateTime at) {
    final last = _last;
    if (_busy || (last != null && at.difference(last) < interval)) {
      skipped++;
      return false;
    }
    _busy = true;
    _last = at;
    accepted++;
    return true;
  }

  void done() => _busy = false;
}
