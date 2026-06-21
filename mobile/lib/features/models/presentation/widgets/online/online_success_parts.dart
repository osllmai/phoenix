import 'package:flutter/material.dart';

/// A provider section header (name + `provider/*` tag) on the Online grid.
class SectionHead extends StatelessWidget {
  const SectionHead({super.key, required this.name, required this.tag});
  final String name;
  final String tag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Row(children: [
        Text(name,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: scheme.outlineVariant)),
          child: Text(tag,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: scheme.onSurfaceVariant)),
        ),
      ]),
    );
  }
}

/// The "use your own key" (BYOK) toggle row shown under the OpenAI section.
class ByokRow extends StatelessWidget {
  const ByokRow({super.key, required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(children: [
        Expanded(
          child: Text(
              'BYOK — use your own OpenAI key and pay OpenAI directly instead of '
              'IndoxHub credits.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant)),
        ),
        Switch(value: value, onChanged: onChanged),
      ]),
    );
  }
}
