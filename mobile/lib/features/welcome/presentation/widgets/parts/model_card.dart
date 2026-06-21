import 'package:flutter/material.dart';

import '../../providers/welcome_content.dart';

/// A selectable model option on the choose-model step: icon, name + tagline,
/// and size/quant spec chips. Highlights when selected.
class ModelCard extends StatelessWidget {
  const ModelCard({
    super.key,
    required this.model,
    required this.selected,
    required this.onTap,
  });

  final OnboardingModel model;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(model.icon, size: 26, color: scheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.name,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(model.tagline,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _spec(theme, model.size),
            const SizedBox(width: 6),
            _spec(theme, model.quant),
          ],
        ),
      ),
    );
  }

  Widget _spec(ThemeData theme, String text) {
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: selected ? scheme.primary : scheme.outline),
      ),
      child: Text(text,
          style: theme.textTheme.labelSmall?.copyWith(
              color: selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant)),
    );
  }
}
