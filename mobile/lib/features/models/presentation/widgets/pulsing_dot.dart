import 'package:flutter/material.dart';

/// A small status dot that gently pulses (opacity) to signal "live/active".
/// Honors reduced-motion: renders static when animations are disabled.
class PulsingDot extends StatefulWidget {
  const PulsingDot({super.key, this.size = 10, this.color});

  final double size;
  final Color? color;

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduce) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    final dot = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
    final reduce = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduce) return dot;
    return FadeTransition(
      opacity: Tween(begin: 0.35, end: 1.0).animate(_c),
      child: dot,
    );
  }
}
