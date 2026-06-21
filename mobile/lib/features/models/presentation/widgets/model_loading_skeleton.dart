import 'package:flutter/material.dart';

/// Content skeleton mirroring the model list (rows, not a bare spinner) so the
/// layout doesn't jump when data lands. Gently pulses; static under reduced-motion.
class ModelLoadingSkeleton extends StatefulWidget {
  const ModelLoadingSkeleton({super.key, this.rows = 5});

  final int rows;

  @override
  State<ModelLoadingSkeleton> createState() => _ModelLoadingSkeletonState();
}

class _ModelLoadingSkeletonState extends State<ModelLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
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
    final list = ListView.builder(
      itemCount: widget.rows,
      itemBuilder: (_, _) => const _SkeletonRow(),
    );
    final reduce = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduce) return Opacity(opacity: 0.55, child: list);
    return FadeTransition(
      opacity: Tween(begin: 0.45, end: 1.0).animate(_c),
      child: list,
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _Bar(width: 36, height: 36, color: c, radius: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bar(width: 180, height: 12, color: c),
                const SizedBox(height: 8),
                _Bar(width: 260, height: 10, color: c),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.width,
    required this.height,
    required this.color,
    this.radius = 4,
  });

  final double width;
  final double height;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}
