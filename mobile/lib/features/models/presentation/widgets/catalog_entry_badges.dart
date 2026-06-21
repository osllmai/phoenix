import 'package:flutter/material.dart';

import '../../data/catalog_entry.dart';

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
    return (fg: const Color(0xFF93BBD0), bg: const Color(0xFF18242C));
  }
  if (c.contains('vision') || c.contains('image')) {
    return (fg: const Color(0xFFC6B2D9), bg: const Color(0xFF271E33));
  }
  if (c.contains('audio') || c.contains('speech')) {
    return (fg: const Color(0xFFFFB070), bg: const Color(0xFF3A2415));
  }
  if (c.contains('embed')) {
    return (fg: const Color(0xFF7FD8C7), bg: const Color(0xFF152A26));
  }
  if (c.contains('text') || c.contains('chat')) {
    return (fg: const Color(0xFF84CC9C), bg: const Color(0xFF1C2A20));
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
