import 'package:flutter/material.dart';

import '../data/maestro_sample.dart';
import 'console_card.dart';

class MaestroGoalCard extends StatelessWidget {
  const MaestroGoalCard({super.key, required this.goal});

  final MaestroGoal goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ConsoleCard(
      title: 'Running on desktop',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(goal.text, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
              children: [
                const TextSpan(text: 'pattern '),
                TextSpan(
                  text: goal.pattern,
                  style: TextStyle(
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: ' · ${goal.flow} · ${goal.conductor}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
