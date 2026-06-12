import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/feature/feature_registry.dart';

/// Desktop app shell: a NavigationRail built from the feature registry's nav
/// items, with the routed feature screen as the body. Adding a feature with a
/// nav item makes a rail destination appear automatically.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(featureRegistryProvider).navItems();
    final location = GoRouterState.of(context).uri.path;
    final selected = items.indexWhere((i) => i.path == location);

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selected < 0 ? 0 : selected,
            onDestinationSelected: (i) => context.go(items[i].path),
            labelType: NavigationRailLabelType.all,
            destinations: [
              for (final it in items)
                NavigationRailDestination(
                  icon: Icon(it.icon),
                  label: Text(it.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
