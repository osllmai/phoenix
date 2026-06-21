import 'package:flutter/material.dart';

/// Shared zero-state: a Material icon above a headline, message and one primary
/// action. Reused for the empty and first-run catalog states.
class ModelsEmptyState extends StatelessWidget {
  const ModelsEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.ctaLabel,
    required this.onCta,
  });

  final IconData icon;
  final String title;
  final String message;
  final String ctaLabel;
  final VoidCallback onCta;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: cs.primary),
            const SizedBox(height: 16),
            Text(title, style: text.headlineSmall),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onCta,
              icon: const Icon(Icons.add),
              label: Text(ctaLabel),
            ),
          ],
        ),
      ),
    );
  }
}
