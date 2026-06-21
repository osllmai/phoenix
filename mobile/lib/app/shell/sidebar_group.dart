import 'package:flutter/material.dart';

import '../../core/feature/feature_module.dart';
import 'sidebar_tile.dart';

/// A labelled, collapsible sidebar section (e.g. Workspace, Models) with its
/// nav tiles. When the whole sidebar is collapsed the header is hidden.
class SidebarGroup extends StatelessWidget {
  const SidebarGroup({
    super.key,
    required this.group,
    required this.items,
    required this.collapsed,
    required this.expanded,
    required this.currentPath,
    required this.onToggle,
    required this.onTap,
  });

  final NavGroup group;
  final List<FeatureNavItem> items;
  final bool collapsed;
  final bool expanded;
  final String currentPath;
  final VoidCallback onToggle;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (collapsed)
          Divider(height: 12, indent: 14, endIndent: 14, color: scheme.outlineVariant)
        else
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 16, 6),
              child: Row(
                children: [
                  Text(group.label.toUpperCase(),
                      style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontSize: 11,
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Icon(expanded ? Icons.expand_more : Icons.chevron_right,
                      size: 16, color: scheme.onSurfaceVariant),
                ],
              ),
            ),
          ),
        if (collapsed || expanded)
          for (final item in items)
            SidebarTile(
              item: item,
              selected: currentPath == item.path,
              collapsed: collapsed,
              onTap: () => onTap(item.path),
            ),
      ],
    );
  }
}
