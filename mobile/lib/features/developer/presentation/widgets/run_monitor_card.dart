import 'package:flutter/material.dart';

import '../data/flows_sample.dart';
import 'console_card.dart';
import 'flow_step_tile.dart';

class RunMonitorCard extends StatelessWidget {
  const RunMonitorCard({super.key, required this.monitor});

  final RunMonitor monitor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ConsoleCard(
      title: monitor.flowName,
      subtitle: 'running now · live',
      trailing: _StatusChip(label: monitor.statusLabel),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: 0.55,
              minHeight: 4,
              backgroundColor: scheme.surfaceContainerHighest,
              color: scheme.tertiary,
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < monitor.steps.length; i++)
            FlowStepTile(
              step: monitor.steps[i],
              index: i,
              isLast: i == monitor.steps.length - 1,
              gatePrompt: monitor.gatePrompt,
            ),
          const SizedBox(height: 8),
          const _MonitorControls(),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: scheme.tertiary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: scheme.tertiary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: scheme.tertiary),
          ),
        ],
      ),
    );
  }
}

class _MonitorControls extends StatelessWidget {
  const _MonitorControls();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.pause, size: 16),
            label: const Text('Pause'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.stop, size: 16),
            label: const Text('Stop run'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            child: const Text('On desktop'),
          ),
        ),
      ],
    );
  }
}
