import 'package:flutter/material.dart';

import '../data/flows_sample.dart';
import 'flow_step_status.dart';

class FlowStepTile extends StatelessWidget {
  const FlowStepTile({
    super.key,
    required this.step,
    required this.index,
    required this.isLast,
    required this.gatePrompt,
  });

  final FlowStep step;
  final int index;
  final bool isLast;
  final String gatePrompt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Rail(step: step, index: index, isLast: isLast),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TitleLine(step: step),
                  if (step.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      step.subtitle!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                  if (step.status != FlowStepStatus.done) ...[
                    const SizedBox(height: 6),
                    FlowStepBadge(status: step.status),
                  ],
                  if (step.status == FlowStepStatus.gateWaiting)
                    FlowApproveBox(prompt: gatePrompt),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({required this.step, required this.index, required this.isLast});

  final FlowStep step;
  final int index;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final connector = step.status == FlowStepStatus.done
        ? scheme.tertiary
        : scheme.outline;
    return Column(
      children: [
        _Dot(step: step, index: index),
        if (!isLast) Expanded(child: Container(width: 2, color: connector)),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.step, required this.index});

  final FlowStep step;
  final int index;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (border, fill, fg, glyph) = switch (step.status) {
      FlowStepStatus.done =>
        (scheme.tertiary, scheme.tertiary, scheme.onTertiary, '✓'),
      FlowStepStatus.running =>
        (scheme.tertiary, scheme.surface, scheme.tertiary, '●'),
      FlowStepStatus.failed =>
        (scheme.error, scheme.errorContainer, scheme.error, '✕'),
      FlowStepStatus.gateWaiting =>
        (scheme.primary, scheme.primaryContainer, scheme.onPrimaryContainer, '⚖'),
      FlowStepStatus.pending => (
          scheme.outline,
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant,
          '${index + 1}',
        ),
    };
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 2),
      ),
      child: Text(glyph, style: TextStyle(fontSize: 11, color: fg, height: 1)),
    );
  }
}

class _TitleLine extends StatelessWidget {
  const _TitleLine({required this.step});

  final FlowStep step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(
          child: Text(
            step.title,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          step.kind.toUpperCase(),
          style: theme.textTheme.labelSmall
              ?.copyWith(color: scheme.onSurfaceVariant, letterSpacing: 0.5),
        ),
      ],
    );
  }
}
