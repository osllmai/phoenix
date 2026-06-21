import 'package:flutter/material.dart';

import '../../../../core/responsive/breakpoints.dart';

/// A labelled setting row: name + description on one side, control on the other.
/// Side-by-side when wide; stacked (label above control) on phone.
class SettingField extends StatelessWidget {
  const SettingField({
    super.key,
    required this.name,
    required this.description,
    required this.control,
  });

  final String name;
  final String description;
  final Widget control;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 2),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );

    final stacked = !formFactorOf(context).hasSidePane;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: stacked
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [label, const SizedBox(height: 10), control],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 240, child: label),
                const SizedBox(width: 16),
                Expanded(child: Align(alignment: Alignment.centerLeft, child: control)),
              ],
            ),
    );
  }
}

class SettingGroup extends StatelessWidget {
  const SettingGroup({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: Border.all(color: scheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Text(
                title!.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      letterSpacing: 1.0,
                    ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}
