import 'package:flutter/material.dart';

import '../data/maestro_sample.dart';
import 'console_card.dart';

class MaestroEventsCard extends StatelessWidget {
  const MaestroEventsCard({super.key, required this.events});

  final List<MaestroEvent> events;

  @override
  Widget build(BuildContext context) {
    return ConsoleCard(
      title: 'Events',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final e in events) _EventRow(event: e),
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.event});

  final MaestroEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          children: [
            TextSpan(
              text: '${event.time} ',
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            TextSpan(
              text: '${event.actor} ',
              style: TextStyle(color: scheme.primary),
            ),
            if (event.outcome != null)
              TextSpan(
                text: '${event.outcome} ',
                style: TextStyle(color: scheme.tertiary),
              ),
            TextSpan(
              text: event.text,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
