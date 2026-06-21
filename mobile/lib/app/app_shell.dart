import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/feature/feature_module.dart';
import '../core/feature/feature_registry.dart';
import '../core/responsive/breakpoints.dart';
import '../features/command_palette/command_palette.dart';
import 'shell/app_sidebar.dart';

/// Responsive app shell built from the feature registry's nav items: the grouped
/// workbench sidebar on tablet/desktop, a curated bottom bar on phone.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(featureRegistryProvider).navItems();
    final location = GoRouterState.of(context).uri.path;

    if (formFactorOf(context).isPhone) {
      final bottom = items
          .where((i) => !i.isFooter && i.group == NavGroup.workspace)
          .toList();
      final selected = bottom.indexWhere((i) => i.path == location);
      return Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selected < 0 ? 0 : selected,
          onDestinationSelected: (i) => context.go(bottom[i].path),
          destinations: [
            for (final it in bottom)
              NavigationDestination(icon: Icon(it.icon), label: it.label),
          ],
        ),
      );
    }

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () =>
            showCommandPalette(context),
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
            showCommandPalette(context),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: Row(
            children: [
              AppSidebar(
                items: items,
                currentPath: location,
                onNavigate: (path) => context.go(path),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
