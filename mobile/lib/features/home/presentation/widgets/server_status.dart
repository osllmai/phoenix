import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/dashboard_controller.dart';
import 'dashboard_card.dart';

class ServerStatus extends ConsumerWidget {
  const ServerStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final state = ref.watch(dashboardControllerProvider);
    return DashboardCard(
      title: 'Local server',
      action: TextButton(
        onPressed: () => context.go('/developer'),
        child: const Text('Manage'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state.serverRunning
                      ? scheme.primary
                      : scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                state.serverRunning ? 'Running' : 'Stopped',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '· ${state.serverEndpoint}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _Endpoint(method: 'POST', path: '/v1/chat/completions', api: 'OpenAI'),
          const SizedBox(height: 8),
          const _Endpoint(method: 'POST', path: '/v1/messages', api: 'Anthropic'),
        ],
      ),
    );
  }
}

class _Endpoint extends StatelessWidget {
  const _Endpoint({required this.method, required this.path, required this.api});

  final String method;
  final String path;
  final String api;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Text(
            method,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              path,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ),
          Text(
            api,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
