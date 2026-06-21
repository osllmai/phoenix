import 'package:flutter/material.dart';

import '../../core/feature/feature_module.dart';
import 'sidebar_tile.dart';

/// The pinned bottom of the sidebar: footer nav (Settings) and the on-device
/// server status chip.
class SidebarFooter extends StatelessWidget {
  const SidebarFooter({
    super.key,
    required this.items,
    required this.collapsed,
    required this.currentPath,
    required this.onTap,
  });

  final List<FeatureNavItem> items;
  final bool collapsed;
  final String currentPath;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 6),
        for (final item in items)
          SidebarTile(
            item: item,
            selected: currentPath == item.path,
            collapsed: collapsed,
            onTap: () => onTap(item.path),
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(collapsed ? 0 : 20, 10, 12, 14),
          child: Row(
            mainAxisAlignment:
                collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: Color(0xFF6FCF97), shape: BoxShape.circle),
              ),
              if (!collapsed) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text('On-device · :24678',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: scheme.onSurfaceVariant, fontSize: 12)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
