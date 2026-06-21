import 'package:flutter/material.dart';

import '../../../data/online_catalog_stub.dart';

/// The left provider list on the Online screen: a coloured dot, name and model
/// count per provider. Unavailable providers are dimmed.
class ProviderRail extends StatelessWidget {
  const ProviderRail({
    super.key,
    required this.selectedId,
    required this.onSelect,
  });

  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        border: Border(right: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Text('PROVIDERS',
                style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant, letterSpacing: 1.1)),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: [
                for (final p in onlineProviders)
                  _ProvTile(
                    provider: p,
                    selected: p.id == selectedId,
                    onTap: () => onSelect(p.id),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProvTile extends StatelessWidget {
  const _ProvTile(
      {required this.provider, required this.selected, required this.onTap});

  final OnlineProvider provider;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InkWell(
      onTap: provider.available ? onTap : null,
      child: Opacity(
        opacity: provider.available ? 1 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? theme.cardColor : Colors.transparent,
            border: Border(
                left: BorderSide(
                    color: selected ? scheme.primary : Colors.transparent,
                    width: 3)),
          ),
          child: Row(
            children: [
              Container(
                  width: 10,
                  height: 10,
                  decoration:
                      BoxDecoration(color: provider.dot, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(provider.name,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500))),
              Text(provider.count?.toString() ?? '—',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: scheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
