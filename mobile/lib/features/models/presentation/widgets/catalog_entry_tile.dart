import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/catalog_entry.dart';
import 'catalog_entry_action.dart';
import 'catalog_entry_badges.dart';
import 'runnability_badge.dart';

class CatalogEntryTile extends StatelessWidget {
  const CatalogEntryTile({super.key, required this.entry, required this.wide});

  final CatalogEntry entry;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final action = CatalogEntryAction(entry: entry);
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Title(entry: entry),
        const SizedBox(height: 6),
        _Chips(entry: entry),
        const SizedBox(height: 6),
        EntryStats(entry: entry),
      ],
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/models/catalog-detail', extra: entry),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: info),
                    const SizedBox(width: 12),
                    action,
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    info,
                    const SizedBox(height: 10),
                    Align(alignment: Alignment.centerLeft, child: action),
                  ],
                ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.entry});

  final CatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.name,
                  style: theme.textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis),
              if (entry.org.isNotEmpty)
                Text(entry.org,
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        if (entry.recommended)
          Icon(Icons.star, size: 16, color: theme.colorScheme.tertiary),
      ],
    );
  }
}

class _Chips extends StatelessWidget {
  const _Chips({required this.entry});

  final CatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        RunnabilityBadge(entry: entry, compact: true),
        if (entry.capability.isNotEmpty)
          CapabilityBadge(capability: entry.capability),
        if (entry.quant.isNotEmpty) MetaChip(label: entry.quant),
        if (entry.filesizeGb > 0)
          MetaChip(label: '${entry.filesizeGb.toStringAsFixed(2)} GB'),
        if (entry.ramRequired > 0)
          MetaChip(label: '${entry.ramRequired} GB RAM', icon: Icons.memory),
        if (entry.gpuRequired) const MetaChip(label: 'GPU', icon: Icons.bolt),
      ],
    );
  }
}
