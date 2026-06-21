import 'package:flutter/material.dart';

import '../providers/server_console_state.dart';
import 'console_card.dart';

class EndpointsCard extends StatelessWidget {
  const EndpointsCard({super.key, required this.endpoints});

  final List<ServerEndpoint> endpoints;

  @override
  Widget build(BuildContext context) {
    return ConsoleCard(
      title: 'Exposed endpoints',
      subtitle: 'point any compatible SDK at these base URLs',
      bodyPadding: EdgeInsets.zero,
      child: Column(
        children: [
          for (final e in endpoints) _EndpointRow(endpoint: e),
        ],
      ),
    );
  }
}

class _EndpointRow extends StatelessWidget {
  const _EndpointRow({required this.endpoint});

  final ServerEndpoint endpoint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              endpoint.kind,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: scheme.onPrimaryContainer),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SelectableText(
              endpoint.url,
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'monospace',
                color: scheme.onSurface,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Copy',
            visualDensity: VisualDensity.compact,
            onPressed: () {},
            icon: const Icon(Icons.copy, size: 16),
          ),
        ],
      ),
    );
  }
}
