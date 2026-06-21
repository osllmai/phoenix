import 'package:flutter/material.dart';

import '../providers/deepsearch_state.dart';

class ResearchPlan extends StatelessWidget {
  const ResearchPlan({super.key, required this.steps});

  final List<ResearchStep> steps;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Research plan',
                      style: Theme.of(context).textTheme.titleSmall),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: const Text('✓ Completed in 14s'),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: scheme.secondaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < steps.length; i++)
              _StepTile(step: steps[i], isLast: i == steps.length - 1),
          ],
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.step, required this.isLast});

  final ResearchStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dot(scheme),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.label,
                    style: Theme.of(context).textTheme.bodyMedium),
                Text(step.detail,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(ColorScheme scheme) {
    final (bg, fg) = switch (step.status) {
      ResearchStepStatus.done => (scheme.secondaryContainer, scheme.onSecondaryContainer),
      ResearchStepStatus.active => (scheme.primaryContainer, scheme.onPrimaryContainer),
      ResearchStepStatus.pending => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
    };
    final child = switch (step.status) {
      ResearchStepStatus.done => const Icon(Icons.check, size: 14),
      ResearchStepStatus.active => const SizedBox(
          width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
      ResearchStepStatus.pending => const Text('•'),
    };
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: IconTheme(data: IconThemeData(color: fg, size: 14), child: child),
    );
  }
}
