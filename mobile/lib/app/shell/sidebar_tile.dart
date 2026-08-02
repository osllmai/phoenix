import 'package:flutter/material.dart';

import '../../core/feature/feature_module.dart';
import '../radiant.dart';

/// One navigation row in the sidebar. Highlights when its path is active;
/// renders icon-only (with a tooltip) when the sidebar is collapsed.
class SidebarTile extends StatelessWidget {
  const SidebarTile({
    super.key,
    required this.item,
    required this.selected,
    required this.collapsed,
    required this.onTap,
  });

  final FeatureNavItem item;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = selected ? radiantSelectedInk(scheme) : scheme.onSurfaceVariant;
    final tile = Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 12, vertical: 9),
      decoration: selected
          ? radiantEmberHighlight(scheme)
          : BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment:
            collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Icon(item.icon, size: 18, color: fg),
          if (!collapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Text(item.label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: fg,
                      fontSize: 14,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400)),
            ),
          ],
        ],
      ),
    );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: collapsed ? Tooltip(message: item.label, child: tile) : tile,
    );
  }
}
