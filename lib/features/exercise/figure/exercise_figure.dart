import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/motion.dart';
import 'figure_painter.dart';

/// Every movement the figure knows (built in; packs only reference ids).
final motionLibraryProvider = FutureProvider<Map<String, Motion>>((ref) async {
  final raw = await rootBundle.loadString('assets/content/motions.json');
  return parseMotions(jsonDecode(raw) as Map<String, dynamic>);
});

/// Our own animated figure for an exercise. With reduced motion it shows
/// the key poses side by side instead of moving.
class ExerciseFigure extends ConsumerWidget {
  const ExerciseFigure({super.key, required this.motionId, this.still = false, this.playing = true});

  final String motionId;

  /// A single representative pose (lists, thumbnails).
  final bool still;

  /// Pauses the animation without changing the pose (workout player).
  final bool playing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = ref.watch(motionLibraryProvider).value?[motionId];
    if (m == null) return const SizedBox.shrink();
    return Semantics(
      image: true,
      excludeSemantics: true,
      child: MotionFigure(
        motion: m,
        still: still,
        playing: playing,
        reduceMotion: MediaQuery.disableAnimationsOf(context),
      ),
    );
  }
}

class MotionFigure extends StatefulWidget {
  const MotionFigure({
    super.key,
    required this.motion,
    this.still = false,
    this.playing = true,
    this.reduceMotion = false,
  });

  final Motion motion;
  final bool still;
  final bool playing;
  final bool reduceMotion;

  @override
  State<MotionFigure> createState() => _MotionFigureState();
}

class _MotionFigureState extends State<MotionFigure> with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_tick);
  Duration _elapsed = Duration.zero;
  Duration _offset = Duration.zero;
  late Rect _bounds = motionBounds(widget.motion);
  late Rect? _prop = propRect(widget.motion);

  bool get _animates => !widget.still && !widget.reduceMotion;

  @override
  void initState() {
    super.initState();
    if (_animates && widget.playing) _ticker.start();
  }

  @override
  void didUpdateWidget(MotionFigure old) {
    super.didUpdateWidget(old);
    if (old.motion != widget.motion) {
      _bounds = motionBounds(widget.motion);
      _prop = propRect(widget.motion);
      _offset = Duration.zero;
      _elapsed = Duration.zero;
    }
    final run = _animates && widget.playing;
    if (run && !_ticker.isActive) {
      _offset += _elapsed;
      _elapsed = Duration.zero;
      _ticker.start();
    } else if (!run && _ticker.isActive) {
      _ticker.stop();
    }
  }

  void _tick(Duration d) => setState(() => _elapsed = d);

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Widget _paint(Object pose, FigureColors colors) => CustomPaint(
        painter: FigurePainter(
            pose: pose, view: widget.motion.view, bounds: _bounds, colors: colors, prop: _prop),
        size: Size.infinite,
      );

  @override
  Widget build(BuildContext context) {
    final colors = FigureColors.of(Theme.of(context).colorScheme);
    final m = widget.motion;
    if (widget.still) {
      // The "working" pose says more than the starting one.
      return _paint(m.frames[m.frames.length > 1 ? 1 : 0].pose, colors);
    }
    if (widget.reduceMotion) {
      final poses = m.keyPoses;
      return Row(children: [
        for (final (i, p) in poses.indexed) ...[
          if (i > 0)
            Icon(Icons.arrow_forward, size: 16, color: colors.floor),
          Expanded(child: _paint(p, colors)),
        ],
      ]);
    }
    return _paint(m.poseAt((_offset + _elapsed).inMilliseconds), colors);
  }
}
