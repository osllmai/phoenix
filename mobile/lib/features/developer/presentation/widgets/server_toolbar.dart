import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../data/server_health.dart';
import '../providers/server_health_provider.dart';

class ServerToolbar extends ConsumerWidget {
  const ServerToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final health = ref.watch(serverHealthProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _StatusPill(health: health),
          SelectableText(
            apiBaseUrl,
            style: TextStyle(
              fontFamily: 'monospace',
              color: scheme.onSurfaceVariant,
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => ref.invalidate(serverHealthProvider),
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.health});

  final AsyncValue<ServerHealth> health;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reachable = health.value?.reachable ?? false;
    final color = health.isLoading
        ? scheme.onSurfaceVariant
        : reachable
            ? scheme.primary
            : scheme.error;
    final label = health.isLoading
        ? 'Checking…'
        : reachable
            ? 'Running'
            : 'Unreachable';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
