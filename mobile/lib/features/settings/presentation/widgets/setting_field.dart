import 'package:flutter/material.dart';

/// A labelled setting row: name + description on one side, control on the other.
/// Side-by-side when the panel is wide; stacked (label above control) when narrow
/// — so the control gets full width instead of wrapping in a cramped column.
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 480) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [label, const SizedBox(height: 10), control],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 220, child: label),
              const SizedBox(width: 16),
              Expanded(child: Align(alignment: Alignment.centerLeft, child: control)),
            ],
          );
        },
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
