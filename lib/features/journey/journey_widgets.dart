import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/repositories/snapshot_repository.dart';
import '../../domain/services/progress_engine.dart';
import '../../l10n/app_localizations.dart';
import 'journey_labels.dart';
import 'snapshot_aligner.dart';

/// A thin gradient ring showing progress through the current level, with
/// the level number engraved in the middle.
class LevelRing extends StatelessWidget {
  const LevelRing({super.key, required this.level, this.size = 72});

  final Level level;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: AppLocalizations.of(context).journeyLevel(level.level),
      child: SizedBox.square(
        dimension: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: level.progress),
          duration: reduce ? Duration.zero : const Duration(milliseconds: 1100),
          curve: Curves.easeOutCubic,
          builder: (_, v, child) => CustomPaint(
            painter: _RingPainter(v, theme.colorScheme),
            child: child,
          ),
          child: Center(
            child: Text('${level.level}',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value, this.scheme);

  final double value;
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.075;
    final rect = (Offset.zero & size).deflate(stroke / 2 + 1);
    canvas.drawArc(
        rect,
        0,
        math.pi * 2,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = scheme.surfaceContainerHighest);
    if (value <= 0) return;
    final sweep = math.pi * 2 * value.clamp(0.0, 1.0);
    canvas.drawArc(
        rect,
        -math.pi / 2,
        sweep,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round
          ..shader = SweepGradient(
            startAngle: -math.pi / 2,
            endAngle: -math.pi / 2 + math.pi * 2,
            colors: [scheme.tertiary, scheme.primary, scheme.tertiary],
            transform: const GradientRotation(-math.pi / 2),
          ).createShader(rect));
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value;
}

/// The last seven days as small markers: filled = active, ring with a
/// pause bar = rest day used, faint = missed, outlined = today (pending).
class StreakDots extends StatelessWidget {
  const StreakDots({super.key, required this.streak, required this.today});

  final Streak streak;
  final int today;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final days = <DayStatus?>[];
    var d = DateTime.utc(today ~/ 10000, today ~/ 100 % 100, today % 100);
    for (var i = 6; i >= 0; i--) {
      final k = d.subtract(Duration(days: i));
      days.add(streak.days[k.year * 10000 + k.month * 100 + k.day]);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final s in days)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: SizedBox.square(
              dimension: 10,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: switch (s) {
                    DayStatus.active => scheme.primary,
                    DayStatus.rested => scheme.tertiaryContainer,
                    _ => Colors.transparent,
                  },
                  border: Border.all(
                    width: 1.5,
                    color: switch (s) {
                      DayStatus.active => scheme.primary,
                      DayStatus.rested => scheme.tertiary,
                      DayStatus.pending => scheme.primary,
                      _ => scheme.outlineVariant,
                    },
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A struck-metal medallion: bevelled rim, engraved ticks and an emblem.
/// Locked badges are matte with a progress arc.
class BadgeMedallion extends StatelessWidget {
  const BadgeMedallion({
    super.key,
    required this.badge,
    required this.earned,
    this.progress = 0,
    this.size = 64,
    this.shine = 0,
  });

  final Award badge;
  final bool earned;
  final double progress;
  final double size;

  /// 0–1 position of a light sweep across the face (unlock animation).
  final double shine;

  static const _metals = {
    MedalTier.bronze: [Color(0xFFE2B48A), Color(0xFF9A5B33), Color(0xFF6B3A1F)],
    MedalTier.silver: [Color(0xFFF2F4F6), Color(0xFFA9B1BA), Color(0xFF66707A)],
    MedalTier.gold: [Color(0xFFFFE7A3), Color(0xFFD4A437), Color(0xFF8C6410)],
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final metal = _metals[badgeTier(badge)]!;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _MedalPainter(
          metal: earned
              ? metal
              : [
                  scheme.surfaceContainerHighest,
                  scheme.surfaceContainerHigh,
                  scheme.outlineVariant,
                ],
          progress: earned ? 1 : progress.clamp(0.0, 1.0),
          earned: earned,
          arc: scheme.primary,
          shine: shine,
        ),
        child: Center(
          child: Icon(
            badgeIcon(badge),
            size: size * 0.36,
            color: earned
                ? Color.lerp(metal[2], Colors.black, 0.35)
                : scheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

class _MedalPainter extends CustomPainter {
  _MedalPainter({
    required this.metal,
    required this.progress,
    required this.earned,
    required this.arc,
    required this.shine,
  });

  final List<Color> metal;
  final double progress;
  final bool earned;
  final Color arc;
  final double shine;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final outer = Rect.fromCircle(center: c, radius: r * 0.92);
    // Rim: light from the top-left.
    canvas.drawCircle(
        c,
        r * 0.92,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [metal[0], metal[1], metal[2]],
          ).createShader(outer));
    // Face: inverted gradient makes the rim read as a bevel.
    final faceR = r * 0.74;
    final face = Rect.fromCircle(center: c, radius: faceR);
    canvas.drawCircle(
        c,
        faceR,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.3, -0.4),
            radius: 1.1,
            colors: [metal[0], metal[1]],
          ).createShader(face));
    // Engraved ticks around the face.
    final tick = Paint()
      ..color = metal[2].withValues(alpha: earned ? 0.45 : 0.25)
      ..strokeWidth = math.max(0.8, r * 0.025);
    for (var i = 0; i < 36; i++) {
      final a = i * math.pi * 2 / 36;
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(c + dir * (faceR * 0.86), c + dir * (faceR * 0.95), tick);
    }
    // Light sweep for the unlock moment.
    if (earned && shine > 0 && shine < 1) {
      canvas.save();
      canvas.clipPath(Path()..addOval(outer));
      final x = outer.left - r + (outer.width + 2 * r) * shine;
      canvas.drawRect(
          outer,
          Paint()
            ..shader = LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0),
                Colors.white.withValues(alpha: 0.55),
                Colors.white.withValues(alpha: 0),
              ],
              stops: const [0.35, 0.5, 0.65],
              transform: GradientRotation(0.5),
            ).createShader(Rect.fromLTWH(x - r, outer.top, 2 * r, outer.height)));
      canvas.restore();
    }
    // Progress toward a locked badge.
    if (!earned && progress > 0) {
      canvas.drawArc(
          Rect.fromCircle(center: c, radius: r * 0.96),
          -math.pi / 2,
          math.pi * 2 * progress,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = r * 0.07
            ..strokeCap = StrokeCap.round
            ..color = arc);
    }
  }

  @override
  bool shouldRepaint(_MedalPainter old) =>
      old.progress != progress || old.shine != shine || old.earned != earned;
}

/// One snapshot, lined up by the eyes so frames overlay precisely.
class AlignedPhoto extends StatelessWidget {
  const AlignedPhoto({super.key, required this.snapshot});

  final Snapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final out = Size(c.maxWidth, c.maxHeight);
      final image = Size(snapshot.width.toDouble(), snapshot.height.toDouble());
      final m = snapshot.eyes == null
          ? coverTransform(image, out)
          : alignTransform(snapshot.eyes!, image, out);
      return ClipRect(
        child: OverflowBox(
          alignment: Alignment.topLeft,
          minWidth: 0,
          minHeight: 0,
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: Transform(
            transform: m,
            child: Image.memory(
              snapshot.jpeg,
              width: image.width,
              height: image.height,
              fit: BoxFit.fill,
              gaplessPlayback: true,
              excludeFromSemantics: true,
            ),
          ),
        ),
      );
    });
  }
}

/// Face time-lapse from real snapshots (oldest → newest), aligned by the
/// eyes and cross-faded. [index] pins a frame (scrubbing); otherwise it
/// plays when [playing] and motion is allowed.
class FaceTimelapse extends StatefulWidget {
  const FaceTimelapse({
    super.key,
    required this.frames,
    this.index,
    this.playing = true,
    this.onFrame,
    this.frameDuration = const Duration(milliseconds: 900),
  });

  final List<Snapshot> frames;
  final int? index;
  final bool playing;
  final ValueChanged<int>? onFrame;
  final Duration frameDuration;

  @override
  State<FaceTimelapse> createState() => _FaceTimelapseState();
}

class _FaceTimelapseState extends State<FaceTimelapse> {
  Timer? _timer;
  int _i = 0;

  int get _current => widget.index ?? _i;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _schedule();
  }

  @override
  void didUpdateWidget(FaceTimelapse old) {
    super.didUpdateWidget(old);
    if (_i >= widget.frames.length) _i = 0;
    _schedule();
  }

  void _schedule() {
    final run = widget.playing &&
        widget.index == null &&
        widget.frames.length > 1 &&
        !MediaQuery.disableAnimationsOf(context);
    if (!run) {
      _timer?.cancel();
      _timer = null;
      // Without motion, show the latest frame.
      if (widget.index == null && widget.frames.isNotEmpty) {
        _i = widget.frames.length - 1;
      }
      return;
    }
    _timer ??= Timer.periodic(widget.frameDuration, (_) {
      if (!mounted) return;
      setState(() => _i = (_i + 1) % widget.frames.length);
      widget.onFrame?.call(_i);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.frames.isEmpty) return const SizedBox.shrink();
    final s = widget.frames[_current.clamp(0, widget.frames.length - 1)];
    final reduce = MediaQuery.disableAnimationsOf(context);
    return AnimatedSwitcher(
      duration: reduce ? Duration.zero : const Duration(milliseconds: 450),
      layoutBuilder: (current, previous) =>
          Stack(fit: StackFit.expand, children: [...previous, ?current]),
      child: AlignedPhoto(key: ValueKey(s.id), snapshot: s),
    );
  }
}

/// A quest row with an animated progress bar.
class QuestTile extends StatelessWidget {
  const QuestTile({super.key, required this.quest, this.onTap});

  final Quest quest;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final reduce = MediaQuery.disableAnimationsOf(context);
    final fraction = quest.target == 0 ? 0.0 : quest.progress / quest.target;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            AnimatedContainer(
              duration: reduce ? Duration.zero : const Duration(milliseconds: 300),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: quest.done ? scheme.primary : scheme.surfaceContainerHigh,
              ),
              child: Icon(quest.done ? Icons.check : questIcon(quest.kind),
                  size: 18,
                  color: quest.done ? scheme.onPrimary : scheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(questLabel(l10n, quest.kind),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        decoration:
                            quest.done ? TextDecoration.lineThrough : null,
                        color: quest.done ? scheme.onSurfaceVariant : null,
                      )),
                  const SizedBox(height: 6),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: fraction.clamp(0.0, 1.0)),
                    duration: reduce
                        ? Duration.zero
                        : const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder: (_, v, _) => ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: v,
                        minHeight: 4,
                        backgroundColor: scheme.surfaceContainerHighest,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(l10n.questsReward(Quest.xp),
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: scheme.primary)),
          ],
        ),
      ),
    );
  }
}
