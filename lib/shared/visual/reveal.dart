import 'package:flutter/material.dart';

/// Fades and slides [child] in after [index] × [step]. Instant when the OS
/// "reduce motion" setting is on.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.index = 0,
    this.step = const Duration(milliseconds: 70),
  });

  final Widget child;
  final int index;
  final Duration step;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 420));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _c.value = 1;
    } else {
      Future.delayed(widget.step * widget.index, () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.08), end: Offset.zero)
            .animate(curve),
        child: widget.child,
      ),
    );
  }
}

/// A horizontal bar that animates to [value] (0–1) with a label and value.
class AnimatedValueBar extends StatelessWidget {
  const AnimatedValueBar({
    super.key,
    required this.label,
    required this.valueText,
    required this.value,
    this.color,
  });

  final String label;
  final String valueText;
  final double value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            Text(valueText, style: theme.textTheme.titleSmall),
          ]),
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
            duration: reduce ? Duration.zero : const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (_, v, _) => ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: v,
                minHeight: 8,
                color: color ?? theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
