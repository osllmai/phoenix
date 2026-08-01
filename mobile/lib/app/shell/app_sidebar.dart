import 'package:flutter/material.dart';

import '../../core/feature/feature_module.dart';
import '../radiant.dart';
import 'sidebar_footer.dart';
import 'sidebar_group.dart';
import 'sidebar_header.dart';

/// The grouped "workbench" sidebar for tablet/desktop: brand + New + search,
/// collapsible Workspace/Models/Developer/Tools sections, and a pinned footer.
class AppSidebar extends StatefulWidget {
  const AppSidebar({
    super.key,
    required this.items,
    required this.currentPath,
    required this.onNavigate,
  });

  final List<FeatureNavItem> items;
  final String currentPath;
  final ValueChanged<String> onNavigate;

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  bool _collapsed = false;
  final Set<NavGroup> _closedGroups = {};

  @override
  Widget build(BuildContext context) {
    final footer = widget.items.where((i) => i.isFooter).toList();
    final width = _collapsed ? 72.0 : 264.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: radiantPanelDecoration(Theme.of(context).colorScheme),
      child: OverflowBox(
        alignment: Alignment.centerLeft,
        minWidth: width,
        maxWidth: width,
        child: DecoratedBox(
          decoration: radiantPanelSheen(Theme.of(context).colorScheme),
          child: Column(
            children: [
            SidebarHeader(
              collapsed: _collapsed,
              onToggleCollapse: () => setState(() => _collapsed = !_collapsed),
              onNavigate: widget.onNavigate,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final group in NavGroup.values)
                      if (_itemsIn(group).isNotEmpty)
                        SidebarGroup(
                          group: group,
                          items: _itemsIn(group),
                          collapsed: _collapsed,
                          expanded: !_closedGroups.contains(group),
                          currentPath: widget.currentPath,
                          onToggle: () => setState(() =>
                              _closedGroups.contains(group)
                                  ? _closedGroups.remove(group)
                                  : _closedGroups.add(group)),
                          onTap: widget.onNavigate,
                        ),
                  ],
                ),
              ),
            ),
            SidebarFooter(
              items: footer,
              collapsed: _collapsed,
              currentPath: widget.currentPath,
              onTap: widget.onNavigate,
            ),
          ],
          ),
        ),
      ),
    );
  }

  List<FeatureNavItem> _itemsIn(NavGroup group) =>
      widget.items.where((i) => !i.isFooter && i.group == group).toList();
}
