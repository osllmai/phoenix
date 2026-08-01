import 'package:flutter/material.dart';

import 'console_card.dart';

class FleetRunCard extends StatelessWidget {
  const FleetRunCard({super.key, required this.title, required this.meta});

  final String title;
  final String meta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ConsoleCard(
      title: 'Racing on desktop',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            meta,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
