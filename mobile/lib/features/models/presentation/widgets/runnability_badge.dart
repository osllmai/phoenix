import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/catalog_entry.dart';
import '../../data/device_capabilities.dart';
import '../../data/runnability.dart';
import '../../../../app/status_colors.dart';

({Color fg, Color bg}) runnabilityColors(BuildContext context, Runnability r) {
  switch (r) {
    case Runnability.runs:
      return BadgeTones.runnable;
    case Runnability.tight:
      return BadgeTones.marginal;
    case Runnability.tooLarge:
      final cs = Theme.of(context).colorScheme;
      return (fg: cs.error, bg: cs.errorContainer.withValues(alpha: 0.4));
  }
}

String runnabilityLabel(Runnability r, double neededGb, {bool compact = false}) {
  final n = neededGb.ceil();
  switch (r) {
    case Runnability.runs:
      return compact ? '✓ Runs' : 'Runs on your device';
    case Runnability.tight:
      return 'Tight (~$n GB RAM)';
    case Runnability.tooLarge:
      return 'Too large · needs $n GB';
  }
}

class RunnabilityBadge extends ConsumerWidget {
  const RunnabilityBadge({super.key, required this.entry, this.compact = false});

  final CatalogEntry entry;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ram = ref.watch(deviceRamGbProvider);
    final value = ram.value;
    if (value == null) return const SizedBox.shrink();

    final r = runnabilityFor(entry, value);
    final colors = runnabilityColors(context, r.level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.fg.withValues(alpha: 0.6)),
      ),
      child: Text(
        runnabilityLabel(r.level, r.neededGb, compact: compact),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colors.fg,
        ),
      ),
    );
  }
}
