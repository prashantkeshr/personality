import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/services/weight_journey.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/format/body_format.dart';

/// A winding trail from the starting weight to the goal flag. The walker
/// moves along it as the trend gets closer; milestone flags light up as they
/// are passed. Tap a flag to see the weight it stands for.
class JourneyTrail extends StatefulWidget {
  const JourneyTrail({
    super.key,
    required this.journey,
    required this.format,
    required this.onSetGoal,
    this.maintain = false,
  });

  final WeightJourney journey;
  final BodyFormat format;
  final VoidCallback onSetGoal;

  /// The start was already inside the goal range: no trail to walk, the
  /// journey is about staying there.
  final bool maintain;

  @override
  State<JourneyTrail> createState() => _JourneyTrailState();
}

class _JourneyTrailState extends State<JourneyTrail>
    with SingleTickerProviderStateMixin {
  late final _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  double _from = 0;
  double? _picked; // the milestone whose weight is shown

  double get _to => widget.journey.progress ?? 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  @override
  void didUpdateWidget(JourneyTrail old) {
    super.didUpdateWidget(old);
    if ((old.journey.progress ?? 0) != _to) {
      _from = _current;
      _run();
    }
  }

  double get _current =>
      _from + (_to - _from) * Curves.easeOutCubic.transform(_anim.value);

  void _run() {
    if (!mounted) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _anim.value = 1;
    } else {
      _anim.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _tap(Offset p, Size size) {
    final j = widget.journey;
    if (j.targetKg == null) return;
    final trail = _Trail(size);
    for (final m in WeightJourney.milestones) {
      if ((trail.at(m) - p).distance < 28) {
        HapticFeedback.selectionClick();
        setState(() => _picked = _picked == m ? null : m);
        return;
      }
    }
    setState(() => _picked = null);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final j = widget.journey;
    final f = widget.format;
    final target = j.targetKg;
    final p = j.progress;
    final percent = ((p ?? 0) * 100).round();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.weightJourneyTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (p != null)
                  _Pill(
                    text: p >= 1
                        ? l.weightJourneyReached
                        : l.weightJourneyProgress(percent),
                    highlight: p >= 1,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Semantics(
              label: target == null
                  ? l.weightJourneyNoGoal
                  : l.weightJourneySemantics(
                      percent,
                      f.weight(j.startKg),
                      f.weight(target),
                    ),
              child: LayoutBuilder(
                builder: (context, c) {
                  final size = Size(c.maxWidth, 190);
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (d) => _tap(d.localPosition, size),
                    child: AnimatedBuilder(
                      animation: _anim,
                      builder: (context, _) => CustomPaint(
                        size: size,
                        painter: _TrailPainter(
                          progress: target == null ? null : _current,
                          picked: _picked,
                          scheme: theme.colorScheme,
                          textStyle: theme.textTheme.labelMedium!,
                          startLabel: f.weight(j.startKg),
                          goalLabel: target == null ? '?' : f.weight(target),
                          walker: Icons.directions_walk,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (target == null)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.maintain
                          ? l.weightJourneyMaintain
                          : l.weightJourneyNoGoal,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  TextButton(
                    key: const Key('journey-set-goal'),
                    onPressed: widget.onSetGoal,
                    child: Text(l.weightJourneySetGoal),
                  ),
                ],
              )
            else
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _picked == null
                      ? l.weightJourneyTapHint
                      : l.weightMilestoneAt(
                          (_picked! * 100).round(),
                          f.weight(j.milestoneKg(_picked!)),
                        ),
                  key: ValueKey(_picked),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _picked == null
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.highlight});
  final String text;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: highlight ? s.tertiaryContainer : s.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: highlight ? s.onTertiaryContainer : s.onPrimaryContainer,
        ),
      ),
    );
  }
}

/// The trail's geometry, shared by painting and hit-testing.
class _Trail {
  _Trail(this.size) {
    final w = size.width, h = size.height;
    path = Path()
      ..moveTo(w * 0.07, h * 0.86)
      ..cubicTo(w * 0.40, h * 0.98, w * 0.18, h * 0.45, w * 0.50, h * 0.50)
      ..cubicTo(w * 0.82, h * 0.55, w * 0.62, h * 0.10, w * 0.90, h * 0.18);
    metric = path.computeMetrics().first;
  }

  final Size size;
  late final Path path;
  late final ui.PathMetric metric;

  Offset at(double t) =>
      metric.getTangentForOffset(metric.length * t.clamp(0.0, 1.0))!.position;

  Path upTo(double t) => metric.extractPath(0, metric.length * t);
}

class _TrailPainter extends CustomPainter {
  _TrailPainter({
    required this.progress,
    required this.picked,
    required this.scheme,
    required this.textStyle,
    required this.startLabel,
    required this.goalLabel,
    required this.walker,
  });

  /// Null when there is no goal: the trail is drawn without a walker.
  final double? progress;
  final double? picked;
  final ColorScheme scheme;
  final TextStyle textStyle;
  final String startLabel;
  final String goalLabel;
  final IconData walker;

  @override
  void paint(Canvas canvas, Size size) {
    final trail = _Trail(size);
    final p = progress ?? 0;

    // Base trail: a soft, dashed road.
    final road = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..color = scheme.surfaceContainerHighest;
    canvas.drawPath(trail.path, road);
    final dash = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = scheme.outlineVariant;
    for (var d = 0.0; d < trail.metric.length; d += 14) {
      canvas.drawPath(trail.metric.extractPath(d, d + 6), dash);
    }

    // The way already walked.
    if (p > 0) {
      final walked = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.linear(trail.at(0), trail.at(1), [
          scheme.primary,
          scheme.tertiary,
        ]);
      canvas.drawPath(trail.upTo(p), walked);
    }

    // Start post.
    canvas.drawCircle(trail.at(0), 7, Paint()..color = scheme.outline);
    _label(canvas, startLabel, trail.at(0) + const Offset(0, -22));

    // Milestone flags.
    for (final m in WeightJourney.milestones.take(3)) {
      final c = trail.at(m);
      final reached = progress != null && p >= m;
      canvas.drawCircle(
        c,
        picked == m ? 12 : 9,
        Paint()..color = reached ? scheme.tertiary : scheme.surface,
      );
      canvas.drawCircle(
        c,
        picked == m ? 12 : 9,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = reached ? scheme.tertiary : scheme.outline,
      );
      if (reached) {
        _icon(canvas, Icons.check, c, 12, scheme.onTertiary);
      }
    }

    // Goal flag.
    final g = trail.at(1);
    final done = progress != null && p >= 1;
    final pole = Paint()
      ..color = scheme.onSurface
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(g, g + const Offset(0, -38), pole);
    final flag = Path()
      ..moveTo(g.dx, g.dy - 38)
      ..lineTo(g.dx + 26, g.dy - 30)
      ..lineTo(g.dx, g.dy - 22)
      ..close();
    canvas.drawPath(
      flag,
      Paint()..color = done ? const Color(0xFFF2C14E) : scheme.primary,
    );
    canvas.drawCircle(g, 5, Paint()..color = scheme.onSurface);
    _label(canvas, goalLabel, g + const Offset(-4, 18));

    // The walker, with a soft glow.
    if (progress != null) {
      final w = trail.at(p);
      canvas.drawCircle(
        w,
        24,
        Paint()
          ..color = scheme.primary.withValues(alpha: 0.18)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      canvas.drawCircle(w, 17, Paint()..color = scheme.primary);
      canvas.drawCircle(
        w,
        17,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = scheme.surface,
      );
      _icon(canvas, walker, w, 20, scheme.onPrimary);
    }
  }

  void _label(Canvas canvas, String text, Offset centre) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle.copyWith(color: scheme.onSurfaceVariant),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, centre - Offset(tp.width / 2, tp.height / 2));
  }

  void _icon(
    Canvas canvas,
    IconData icon,
    Offset centre,
    double size,
    Color c,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          fontSize: size,
          color: c,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, centre - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_TrailPainter old) =>
      old.progress != progress ||
      old.picked != picked ||
      old.scheme != scheme ||
      old.startLabel != startLabel ||
      old.goalLabel != goalLabel;
}

/// Four quick numbers under the trail.
class JourneyStats extends StatelessWidget {
  const JourneyStats({super.key, required this.journey, required this.format});

  final WeightJourney journey;
  final BodyFormat format;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final j = journey;
    final week = j.weekChangeKg;
    final toGo = j.toGoKg;
    final tiles = [
      (
        Icons.date_range,
        l.weightStatWeek,
        week == null ? '—' : format.weightChange(week),
      ),
      (
        Icons.flag_outlined,
        l.weightStatSinceStart,
        format.weightChange(j.changeSinceStartKg),
      ),
      (
        Icons.near_me_outlined,
        l.weightStatToGo,
        toGo == null ? '—' : format.weight(toGo),
      ),
      (
        Icons.local_fire_department_outlined,
        l.weightStatStreak,
        l.weightStreakWeeks(j.streakWeeks),
      ),
    ];
    return LayoutBuilder(
      builder: (context, c) {
        final w = (c.maxWidth - AppSpacing.sm) / 2;
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final (icon, label, value) in tiles)
              SizedBox(
                width: w,
                child: _StatTile(icon: icon, label: label, value: value),
              ),
          ],
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Step on the scale": a drawn scale whose display shows the weight, and a
/// ruler to drag. Returns the chosen kg, or null if dismissed.
Future<double?> showScaleSheet(
  BuildContext context, {
  required double initialKg,
  required bool metric,
  required BodyFormat format,
}) => showModalBottomSheet<double>(
  context: context,
  // Above the floating tab bar, not underneath it.
  useRootNavigator: true,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) =>
      _ScaleSheet(initialKg: initialKg, metric: metric, format: format),
);

class _ScaleSheet extends StatefulWidget {
  const _ScaleSheet({
    required this.initialKg,
    required this.metric,
    required this.format,
  });
  final double initialKg;
  final bool metric;
  final BodyFormat format;

  @override
  State<_ScaleSheet> createState() => _ScaleSheetState();
}

class _ScaleSheetState extends State<_ScaleSheet> {
  late double _kg = snapWeight(
    clampWeight(widget.initialKg),
    metric: widget.metric,
  );
  double _drag = 0; // pixels not yet turned into a step

  static const _px = 14.0; // ruler pixels per step

  double get _stepKg => widget.metric ? 0.1 : 0.2 / 2.20462262185;

  void _step(int n) {
    final next = snapWeight(
      clampWeight(_kg + n * _stepKg),
      metric: widget.metric,
    );
    if (next == _kg) return;
    // A firmer tick on every whole kg / lb.
    final unit = widget.metric ? 1.0 : 1 / 2.20462262185;
    final crossedWhole = (next / unit).floor() != (_kg / unit).floor();
    crossedWhole
        ? HapticFeedback.mediumImpact()
        : HapticFeedback.selectionClick();
    setState(() => _kg = next);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final f = widget.format;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.weightLogTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 150,
              width: 220,
              child: CustomPaint(
                painter: _ScalePainter(scheme: theme.colorScheme),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      f.weight(_kg),
                      key: const Key('scale-value'),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onInverseSurface,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l.weightLogHint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                IconButton.filledTonal(
                  key: const Key('scale-minus'),
                  tooltip: l.weightDecrease,
                  onPressed: () => _step(-1),
                  icon: const Icon(Icons.remove),
                ),
                Expanded(
                  child: Semantics(
                    slider: true,
                    value: f.weight(_kg),
                    increasedValue: f.weight(_kg + _stepKg),
                    decreasedValue: f.weight(_kg - _stepKg),
                    onIncrease: () => _step(1),
                    onDecrease: () => _step(-1),
                    child: GestureDetector(
                      key: const Key('scale-ruler'),
                      behavior: HitTestBehavior.opaque,
                      // Drag left to go up, like turning a dial.
                      onHorizontalDragUpdate: (d) {
                        _drag -= d.delta.dx;
                        while (_drag.abs() >= _px) {
                          _step(_drag.sign.toInt());
                          _drag -= _drag.sign * _px;
                        }
                      },
                      onHorizontalDragEnd: (_) => _drag = 0,
                      child: SizedBox(
                        height: 64,
                        child: CustomPaint(
                          painter: _RulerPainter(
                            kg: _kg,
                            metric: widget.metric,
                            px: _px,
                            scheme: theme.colorScheme,
                            textStyle: theme.textTheme.labelSmall!,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  key: const Key('scale-plus'),
                  tooltip: l.weightIncrease,
                  onPressed: () => _step(1),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: const Key('scale-save'),
                onPressed: () => Navigator.pop(context, _kg),
                icon: const Icon(Icons.check),
                label: Text(l.weightLogSave),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScalePainter extends CustomPainter {
  _ScalePainter({required this.scheme});
  final ColorScheme scheme;

  @override
  void paint(Canvas canvas, Size size) {
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height - 10),
      const Radius.circular(36),
    );
    // Shadow and platform.
    canvas.drawRRect(
      body.shift(const Offset(0, 8)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..shader = ui.Gradient.linear(Offset.zero, Offset(0, size.height), [
          scheme.surfaceContainerHighest,
          scheme.surfaceContainerHigh,
        ]),
    );
    canvas.drawRRect(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = scheme.outlineVariant,
    );
    // Display window.
    final display = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, 48),
        width: size.width * 0.7,
        height: 54,
      ),
      const Radius.circular(12),
    );
    canvas.drawRRect(display, Paint()..color = scheme.inverseSurface);
    // Foot pads.
    final pad = Paint()..color = scheme.outlineVariant.withValues(alpha: 0.7);
    for (final dx in [-0.22, 0.22]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width * (0.5 + dx), size.height * 0.72),
            width: size.width * 0.26,
            height: 26,
          ),
          const Radius.circular(13),
        ),
        pad,
      );
    }
  }

  @override
  bool shouldRepaint(_ScalePainter old) => old.scheme != scheme;
}

class _RulerPainter extends CustomPainter {
  _RulerPainter({
    required this.kg,
    required this.metric,
    required this.px,
    required this.scheme,
    required this.textStyle,
  });

  final double kg;
  final bool metric;
  final double px;
  final ColorScheme scheme;
  final TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final value = metric ? kg : kg * 2.20462262185;
    final step = metric ? 0.1 : 0.2;
    final mid = size.width / 2;
    final ticks = (size.width / px / 2).ceil() + 1;
    final base = (value / step).round();
    for (var i = -ticks; i <= ticks; i++) {
      final n = base + i;
      final x = mid + (n * step - value) / step * px;
      final whole =
          (n * step).abs() % 1 < 1e-6 || (1 - (n * step).abs() % 1) < 1e-6;
      final half = !whole && metric && n % 5 == 0;
      final h = whole ? 30.0 : (half ? 20.0 : 12.0);
      final fade = 1 - ((x - mid).abs() / mid).clamp(0.0, 1.0);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, h),
        Paint()
          ..strokeWidth = whole ? 2 : 1
          ..color = scheme.onSurfaceVariant.withValues(
            alpha: 0.25 + 0.6 * fade,
          ),
      );
      if (whole) {
        final tp = TextPainter(
          text: TextSpan(
            text: (n * step).round().toString(),
            style: textStyle.copyWith(
              color: scheme.onSurfaceVariant.withValues(
                alpha: 0.3 + 0.7 * fade,
              ),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x - tp.width / 2, 34));
      }
    }
    // Centre needle.
    final needle = Path()
      ..moveTo(mid - 7, 0)
      ..lineTo(mid + 7, 0)
      ..lineTo(mid, 12)
      ..close();
    canvas.drawPath(needle, Paint()..color = scheme.primary);
    canvas.drawLine(
      Offset(mid, 0),
      Offset(mid, 32),
      Paint()
        ..strokeWidth = 3
        ..color = scheme.primary,
    );
  }

  @override
  bool shouldRepaint(_RulerPainter old) => old.kg != kg || old.scheme != scheme;
}

/// A short celebration when a weigh-in passes a milestone.
Future<void> showMilestoneCelebration(
  BuildContext context, {
  required double milestone,
  required String weight,
}) {
  HapticFeedback.heavyImpact();
  return showDialog<void>(
    context: context,
    builder: (c) => _Celebration(milestone: milestone, weight: weight),
  );
}

class _Celebration extends StatefulWidget {
  const _Celebration({required this.milestone, required this.weight});
  final double milestone;
  final String weight;

  @override
  State<_Celebration> createState() => _CelebrationState();
}

class _CelebrationState extends State<_Celebration>
    with SingleTickerProviderStateMixin {
  late final _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      MediaQuery.disableAnimationsOf(context)
          ? _anim.value = 1
          : _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final goal = widget.milestone >= 1;
    return AlertDialog(
      key: const Key('weight-celebration'),
      icon: SizedBox(
        height: 110,
        width: 160,
        child: AnimatedBuilder(
          animation: _anim,
          builder: (_, _) => CustomPaint(
            painter: _BurstPainter(
              t: _anim.value,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.tertiary,
                const Color(0xFFF2C14E),
                theme.colorScheme.secondary,
              ],
            ),
            child: Center(
              child: Transform.scale(
                scale: Curves.elasticOut.transform(_anim.value.clamp(0.0, 1.0)),
                child: Icon(
                  goal ? Icons.emoji_events : Icons.flag,
                  size: 56,
                  color: goal
                      ? const Color(0xFFF2C14E)
                      : theme.colorScheme.tertiary,
                ),
              ),
            ),
          ),
        ),
      ),
      title: Text(
        goal
            ? l.weightCelebrateGoal
            : l.weightCelebrateMilestone((widget.milestone * 100).round()),
        textAlign: TextAlign.center,
      ),
      content: Text(
        goal ? l.weightCelebrateGoalBody : l.weightCelebrateBody(widget.weight),
        textAlign: TextAlign.center,
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.weightCelebrateOk),
        ),
      ],
    );
  }
}

/// Confetti-like dots flying out from the middle.
class _BurstPainter extends CustomPainter {
  _BurstPainter({required this.t, required this.colors});
  final double t;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0 || t >= 1) return;
    final c = size.center(Offset.zero);
    final r = math.Random(7);
    for (var i = 0; i < 26; i++) {
      final angle = i / 26 * 2 * math.pi + r.nextDouble() * 0.3;
      final dist = (40 + r.nextDouble() * 40) * Curves.easeOut.transform(t);
      final p = c + Offset(math.cos(angle), math.sin(angle)) * dist;
      canvas.drawCircle(
        p,
        2.5 + r.nextDouble() * 2,
        Paint()..color = colors[i % colors.length].withValues(alpha: 1 - t),
      );
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.t != t;
}
