import 'package:flutter/material.dart';

import '../data/evaluators_sample.dart';
import 'console_card.dart';
import 'metric_row.dart';

class ScorecardCard extends StatelessWidget {
  const ScorecardCard({super.key, required this.scorecard});

  final Scorecard scorecard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConsoleCard(
      title: scorecard.title,
      subtitle: scorecard.run,
      trailing: _VerdictBadge(
        label: scorecard.verdictLabel,
        passed: scorecard.passed,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final metric in scorecard.metrics) MetricRow(metric: metric),
          const SizedBox(height: 8),
          Text(
            scorecard.note,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _VerdictBadge extends StatelessWidget {
  const _VerdictBadge({required this.label, required this.passed});

  final String label;
  final bool passed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = passed ? scheme.tertiaryContainer : scheme.errorContainer;
    final foreground =
        passed ? scheme.onTertiaryContainer : scheme.onErrorContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: foreground),
      ),
    );
  }
}
