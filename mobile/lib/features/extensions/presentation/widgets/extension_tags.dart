import 'package:flutter/material.dart';

import '../providers/extension_entry.dart';

class ExtensionTags extends StatelessWidget {
  const ExtensionTags({super.key, required this.entry});

  final ExtensionEntry entry;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        _Tag(label: entry.category.label, accent: true),
        _Tag(label: entry.size),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, this.accent = false});

  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = accent ? scheme.onPrimaryContainer : scheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outline),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
