import 'package:flutter/material.dart';

import '../data/maestro_sample.dart';
import 'console_card.dart';

class MaestroAgentsCard extends StatelessWidget {
  const MaestroAgentsCard({super.key, required this.agents});

  final List<MaestroAgent> agents;

  @override
  Widget build(BuildContext context) {
    return ConsoleCard(
      title: 'Agents · on desktop',
      bodyPadding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < agents.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            _AgentRow(agent: agents[i]),
          ],
        ],
      ),
    );
  }
}

class _AgentRow extends StatelessWidget {
  const _AgentRow({required this.agent});

  final MaestroAgent agent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: _dotColor(agent.state, scheme),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                agent.name,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
              const SizedBox(width: 4),
              Text(
                agent.role,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const Spacer(),
              _StatePill(label: agent.statusLabel, state: agent.state),
            ],
          ),
          const SizedBox(height: 8),
          for (final line in agent.lines)
            Text(
              line,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
        ],
      ),
    );
  }
}

class _StatePill extends StatelessWidget {
  const _StatePill({required this.label, required this.state});

  final String label;
  final MaestroAgentState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final running = state == MaestroAgentState.running;
    final done = state == MaestroAgentState.done;
    final fg = running || done ? scheme.tertiary : scheme.onSurfaceVariant;
    final bg = running || done
        ? scheme.tertiary.withValues(alpha: 0.15)
        : scheme.surfaceContainerHighest;
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

Color _dotColor(MaestroAgentState s, ColorScheme c) {
  switch (s) {
    case MaestroAgentState.running:
    case MaestroAgentState.done:
      return c.tertiary;
    case MaestroAgentState.queued:
    case MaestroAgentState.idle:
      return c.onSurfaceVariant;
  }
}
