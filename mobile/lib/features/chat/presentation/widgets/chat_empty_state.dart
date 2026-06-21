import 'package:flutter/material.dart';

/// Shown in the conversation pane before the first message: a prompt and a few
/// tappable starter cards that prefill the composer.
class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key, required this.onPick});

  final ValueChanged<String> onPick;

  static const _starters = [
    ('Explain code', 'Walk through a tricky Rust borrow-checker error.'),
    ('Summarize a doc', 'Pull the key milestones from my roadmap file.'),
    ('Draft', 'Write a concise commit message from a diff.'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💬', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              Text('New conversation',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                  'Ask anything — your prompt runs fully on-device. Pick a '
                  'starting point or just type.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 20),
              for (final s in _starters) ...[
                _StarterCard(title: s.$1, subtitle: s.$2, onTap: () => onPick(s.$2)),
                const SizedBox(height: 10),
              ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StarterCard extends StatelessWidget {
  const _StarterCard(
      {required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
