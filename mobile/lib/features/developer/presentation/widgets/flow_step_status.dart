import 'package:flutter/material.dart';

import '../data/flows_sample.dart';

class FlowStepBadge extends StatelessWidget {
  const FlowStepBadge({super.key, required this.status});

  final FlowStepStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (bg, fg, label) = switch (status) {
      FlowStepStatus.gateWaiting =>
        (scheme.primaryContainer, scheme.onPrimaryContainer, '✋ approval needed'),
      FlowStepStatus.failed =>
        (scheme.errorContainer, scheme.error, '✕ failed'),
      FlowStepStatus.running =>
        (scheme.tertiary.withValues(alpha: 0.16), scheme.tertiary, '● running'),
      _ => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant, '• queued'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: theme.textTheme.labelSmall?.copyWith(color: fg)),
    );
  }
}

class FlowApproveBox extends StatelessWidget {
  const FlowApproveBox({super.key, required this.prompt});

  final String prompt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            prompt,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: scheme.onPrimaryContainer),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  child: const Text('✋ Approve & publish'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('↻ Redraft'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
