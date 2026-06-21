import 'package:flutter/material.dart';

import '../data/maestro_sample.dart';
import 'console_card.dart';

class MaestroPlanTimeline extends StatelessWidget {
  const MaestroPlanTimeline({super.key, required this.steps});

  final List<MaestroStep> steps;

  @override
  Widget build(BuildContext context) {
    return ConsoleCard(
      title: 'Plan · timeline',
      bodyPadding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            _StepRow(step: steps[i]),
          ],
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final MaestroStep step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = _markerColor(step.state, scheme);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              step.marker,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'monospace', color: accent),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: step.state == MaestroStepState.running
                        ? scheme.tertiary
                        : scheme.onSurface,
                  ),
                ),
                Text(
                  step.meta,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _MiniStat(label: step.statusLabel, state: step.state),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.state});

  final String label;
  final MaestroStepState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bg = _chipBg(state, scheme);
    final fg = _chipFg(state, scheme);
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

Color _markerColor(MaestroStepState s, ColorScheme c) {
  switch (s) {
    case MaestroStepState.done:
      return c.tertiary;
    case MaestroStepState.running:
      return c.tertiary;
    case MaestroStepState.gated:
      return c.primary;
    case MaestroStepState.pending:
      return c.onSurfaceVariant;
  }
}

Color _chipBg(MaestroStepState s, ColorScheme c) {
  switch (s) {
    case MaestroStepState.running:
      return c.tertiary.withValues(alpha: 0.15);
    case MaestroStepState.done:
      return c.tertiary.withValues(alpha: 0.15);
    case MaestroStepState.gated:
    case MaestroStepState.pending:
      return c.surfaceContainerHighest;
  }
}

Color _chipFg(MaestroStepState s, ColorScheme c) {
  switch (s) {
    case MaestroStepState.running:
    case MaestroStepState.done:
      return c.tertiary;
    case MaestroStepState.gated:
    case MaestroStepState.pending:
      return c.onSurfaceVariant;
  }
}
