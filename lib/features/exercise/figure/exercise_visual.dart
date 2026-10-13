import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/exercise_library.dart';
import '../../../domain/entities/health.dart';
import '../../content/content_providers.dart';
import 'exercise_figure.dart';

/// The best picture we have for an exercise: open-licence illustrations
/// (start and end poses) when that pack is installed, otherwise our own
/// animated figure, otherwise a category icon.
class ExerciseVisual extends ConsumerWidget {
  const ExerciseVisual({super.key, required this.exercise, this.still = false, this.playing = true});

  final LibraryExercise exercise;
  final bool still;
  final bool playing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = ref.watch(packMediaProvider);
    final files = [for (final i in exercise.images) ?media.media(i)];
    if (files.length >= 2) {
      return IllustrationFlip(files: files, still: still, playing: playing);
    }
    if (exercise.motion != null) {
      return ExerciseFigure(motionId: exercise.motion!, still: still, playing: playing);
    }
    return Center(
      child: Icon(categoryIcon(exercise.category),
          size: 32, color: Theme.of(context).colorScheme.primary),
    );
  }
}

IconData categoryIcon(ExerciseCategory c) => switch (c) {
      ExerciseCategory.cardio => Icons.directions_run,
      ExerciseCategory.yoga => Icons.self_improvement,
      ExerciseCategory.stretching || ExerciseCategory.mobility => Icons.accessibility_new,
      ExerciseCategory.martialArts => Icons.sports_martial_arts,
      ExerciseCategory.face || ExerciseCategory.neck => Icons.face_retouching_natural,
      _ => Icons.fitness_center,
    };

/// Line drawings tinted with the theme colour (works in dark mode), flipping
/// between start and end poses like a slow GIF.
class IllustrationFlip extends StatefulWidget {
  const IllustrationFlip({super.key, required this.files, this.still = false, this.playing = true});
  final List<File> files;
  final bool still;
  final bool playing;

  @override
  State<IllustrationFlip> createState() => _IllustrationFlipState();
}

class _IllustrationFlipState extends State<IllustrationFlip> {
  Timer? _timer;
  var _i = 0;

  bool get _reduce => MediaQuery.disableAnimationsOf(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(IllustrationFlip old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    final run = !widget.still && widget.playing && !_reduce;
    if (run && _timer == null) {
      _timer = Timer.periodic(const Duration(milliseconds: 1100), (_) {
        if (mounted) setState(() => _i = (_i + 1) % widget.files.length);
      });
    } else if (!run) {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  static ColorFilter _tint(Color c) => ColorFilter.matrix([
        0, 0, 0, 0, c.r * 255, //
        0, 0, 0, 0, c.g * 255,
        0, 0, 0, 0, c.b * 255,
        // alpha = source alpha - luminance: dark lines stay, white and
        // transparent areas (letterboxing) become clear.
        -0.299, -0.587, -0.114, 1, 0,
      ]);

  Widget _image(File f, Color c) => ColorFiltered(
        colorFilter: _tint(c),
        child: Image.file(f, fit: BoxFit.contain, gaplessPlayback: true, filterQuality: FilterQuality.medium),
      );

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.onSurface;
    if (widget.still) return _image(widget.files.last, c);
    if (_reduce) {
      return Row(children: [
        for (final (i, f) in widget.files.take(2).indexed) ...[
          if (i > 0) Icon(Icons.arrow_forward, size: 16, color: Theme.of(context).colorScheme.outline),
          Expanded(child: _image(f, c)),
        ],
      ]);
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: KeyedSubtree(key: ValueKey(_i), child: _image(widget.files[_i], c)),
    );
  }
}
