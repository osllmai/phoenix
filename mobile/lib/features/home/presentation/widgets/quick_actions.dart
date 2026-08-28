import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dashboard_card.dart';

class _Action {
  const _Action(this.icon, this.title, this.subtitle, this.route);
  final String icon;
  final String title;
  final String subtitle;
  final String route;
}

const _actions = [
  _Action('💬', 'New chat', 'Start a conversation with the loaded model', '/'),
  _Action('📄', 'Add document', 'Convert & index a PDF or office file', '/documents'),
  _Action('🔎', 'Search', 'DeepSearch across your indexed docs', '/deepsearch'),
];

class QuickActions extends StatelessWidget {
  const QuickActions({super.key, this.stacked = false});

  final bool stacked;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Quick actions',
      child: stacked
          ? Column(
              children: [
                for (final a in _actions)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _Tile(action: a),
                  ),
              ],
            )
          : Row(
              children: [
                for (final a in _actions) ...[
                  Expanded(child: _Tile(action: a)),
                  if (a != _actions.last) const SizedBox(width: 12),
                ],
              ],
            ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.action});

  final _Action action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => context.go(action.route),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(action.icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              action.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              action.subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
