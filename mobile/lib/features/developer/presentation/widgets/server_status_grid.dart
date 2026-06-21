import 'package:flutter/material.dart';

import '../providers/server_console_state.dart';
import 'console_card.dart';

class ServerStatusGrid extends StatelessWidget {
  const ServerStatusGrid({super.key, required this.stats, this.columns = 4});

  final List<ServerStat> stats;
  final int columns;

  @override
  Widget build(BuildContext context) {
    return ConsoleCard(
      title: 'Status & usage',
      subtitle: 'on-device gateway · OpenAI + Anthropic compatible',
      child: LayoutBuilder(
        builder: (context, c) {
          final width = (c.maxWidth - 12 * (columns - 1)) / columns;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final s in stats)
                SizedBox(width: width, child: _StatTile(stat: s)),
            ],
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final ServerStat stat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stat.label,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(stat.value, style: theme.textTheme.titleMedium),
          if (stat.hint.isNotEmpty)
            Text(
              stat.hint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
        ],
      ),
    );
  }
}
