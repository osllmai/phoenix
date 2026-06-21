import 'package:flutter/material.dart';

import '../data/flows_sample.dart';
import 'console_card.dart';

class SavedFlowsCard extends StatelessWidget {
  const SavedFlowsCard({super.key, required this.flows});

  final List<SavedFlow> flows;

  @override
  Widget build(BuildContext context) {
    return ConsoleCard(
      title: 'Saved flows',
      subtitle: 'tap Run to fire on the paired desktop',
      bodyPadding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < flows.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            _FlowRow(flow: flows[i]),
          ],
        ],
      ),
    );
  }
}

class _FlowRow extends StatelessWidget {
  const _FlowRow({required this.flow});

  final SavedFlow flow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(flow.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flow.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      flow.shape,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                flow.lastRun,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(width: 8),
              _OutcomeBadge(outcome: flow.outcome),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('Run'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OutcomeBadge extends StatelessWidget {
  const _OutcomeBadge({required this.outcome});

  final FlowRunOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (bg, fg, label) = switch (outcome) {
      FlowRunOutcome.passed =>
        (scheme.tertiary.withValues(alpha: 0.16), scheme.tertiary, '✓ passed'),
      FlowRunOutcome.gated =>
        (scheme.primaryContainer, scheme.onPrimaryContainer, '⚠ gated'),
      FlowRunOutcome.failed =>
        (scheme.errorContainer, scheme.error, '✕ failed'),
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
