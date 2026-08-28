import 'package:flutter/material.dart';

import '../../data/catalog_entry.dart';
import '../../../../app/status_colors.dart';

String formatCount(int n) {
  if (n >= 1000000) {
    return '${(n / 1000000).toStringAsFixed(n >= 10000000 ? 0 : 1)}M';
  }
  if (n >= 1000) {
    return '${(n / 1000).toStringAsFixed(n >= 10000 ? 0 : 1)}K';
  }
  return '$n';
}

({Color fg, Color bg}) capabilityColors(BuildContext context, String raw) {
  final c = raw.toLowerCase();
  if (c.contains('code')) {
    return BadgeTones.vision;
  }
  if (c.contains('vision') || c.contains('image')) {
    return BadgeTones.reasoning;
  }
  if (c.contains('audio') || c.contains('speech')) {
    return BadgeTones.marginal;
  }
  if (c.contains('embed')) {
    return BadgeTones.tools;
  }
  if (c.contains('text') || c.contains('chat')) {
    return BadgeTones.runnable;
  }
  final cs = Theme.of(context).colorScheme;
  return (fg: cs.onSurfaceVariant, bg: cs.surfaceContainerHighest);
}

class CapabilityBadge extends StatelessWidget {
  const CapabilityBadge({super.key, required this.capability});

  final String capability;

  @override
  Widget build(BuildContext context) {
    final colors = capabilityColors(context, capability);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.fg.withValues(alpha: 0.6)),
      ),
      child: Text(
        capability,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colors.fg,
        ),
      ),
    );
  }
}

class MetaChip extends StatelessWidget {
  const MetaChip({
    super.key,
    required this.label,
    this.icon,
    this.subtle = false,
  });

  final String label;
  final IconData? icon;
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = subtle ? cs.onSurfaceVariant : cs.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 3),
          ],
          Text(label, style: TextStyle(fontSize: 11, color: color)),
        ],
      ),
    );
  }
}

class EntryStats extends StatelessWidget {
  const EntryStats({super.key, required this.entry});

  final CatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final style = TextStyle(fontSize: 11, color: cs.onSurfaceVariant);
    return Wrap(
      spacing: 10,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (entry.downloadCount > 0)
          Text('↓ ${formatCount(entry.downloadCount)}', style: style),
        if (entry.likeCount > 0)
          Text('♥ ${formatCount(entry.likeCount)}', style: style),
        if (entry.license.isNotEmpty) Text(entry.license, style: style),
      ],
    );
  }
}
