import 'package:flutter/material.dart';

import '../data/fleet_sample.dart';
import 'console_card.dart';

class FleetWorktreesCard extends StatelessWidget {
  const FleetWorktreesCard({
    super.key,
    required this.worktrees,
    required this.summary,
  });

  final List<FleetWorktree> worktrees;
  final String summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConsoleCard(
      title: 'Worktrees',
      trailing: Text(
        summary,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      bodyPadding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < worktrees.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            _WorktreeRow(wt: worktrees[i]),
          ],
        ],
      ),
    );
  }
}

class _WorktreeRow extends StatelessWidget {
  const _WorktreeRow({required this.wt});

  final FleetWorktree wt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dim = theme.textTheme.bodySmall?.copyWith(
      color: scheme.onSurfaceVariant,
    );
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: _dot(wt.state, scheme),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(wt.name, style: const TextStyle(fontFamily: 'monospace')),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  wt.path,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _Pill(label: wt.statusLabel, state: wt.state, leads: wt.leads),
            ],
          ),
          const SizedBox(height: 8),
          for (final line in wt.summary) Text(line, style: dim),
          if (wt.diffstat != null)
            Text(
              wt.diffstat!,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          const SizedBox(height: 2),
          _Meta(meta: wt.meta, denied: wt.routeDenied),
          if (wt.canViewDiff) ...[
            const SizedBox(height: 8),
            OutlinedButton(onPressed: () {}, child: const Text('View diff')),
          ],
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.meta, required this.denied});

  final String meta;
  final bool denied;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final parts = meta.split(' · ');
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 10,
          color: scheme.onSurfaceVariant,
        ),
        children: [
          for (var i = 0; i < parts.length; i++)
            TextSpan(
              text: i == 0 ? parts[i] : ' · ${parts[i]}',
              style: i == 1
                  ? TextStyle(color: denied ? scheme.error : scheme.tertiary)
                  : null,
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.state, required this.leads});

  final String label;
  final FleetWorktreeState state;
  final bool leads;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final highlight =
        leads ||
        state == FleetWorktreeState.done ||
        state == FleetWorktreeState.running;
    final fg = state == FleetWorktreeState.blocked
        ? scheme.error
        : highlight
        ? scheme.tertiary
        : scheme.onSurfaceVariant;
    final bg = leads
        ? scheme.primaryContainer
        : highlight
        ? scheme.tertiary.withValues(alpha: 0.15)
        : scheme.surfaceContainerHighest;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: leads ? scheme.onPrimaryContainer : fg,
        ),
      ),
    );
  }
}

Color _dot(FleetWorktreeState s, ColorScheme c) {
  switch (s) {
    case FleetWorktreeState.running:
    case FleetWorktreeState.done:
      return c.tertiary;
    case FleetWorktreeState.blocked:
      return c.error;
  }
}
