import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/feature/feature_registry.dart';
import '../core/responsive/breakpoints.dart';
import '../features/command_palette/command_palette.dart';
import 'default_model_bootstrap.dart';
import 'phone_nav.dart';
import 'radiant.dart';
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
    ref.watch(defaultModelBootstrapProvider);

    if (formFactorOf(context).isPhone) {
      final byPath = {for (final i in items) i.path: i};
      final bottom = [
        for (final p in phonePrimaryPaths)
          if (byPath[p] != null) byPath[p]!,
      ];
      final selected = bottom.indexWhere((i) => i.path == location);
      final onMore = selected < 0;
      return Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: onMore ? bottom.length : selected,
          onDestinationSelected: (i) =>
              context.go(i < bottom.length ? bottom[i].path : '/more'),
          destinations: [
            for (final it in bottom)
              NavigationDestination(
                  icon: Icon(it.icon),
                  label: phoneNavLabels[it.path] ?? it.label),
            const NavigationDestination(
                icon: Icon(Icons.more_horiz), label: 'More'),
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
          body: DecoratedBox(
            decoration: radiantBackdropDecoration(Theme.of(context).colorScheme),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(radiantGap),
                child: Row(
                  children: [
                    AppSidebar(
                      items: items,
                      currentPath: location,
                      onNavigate: (path) => context.go(path),
                    ),
                    const SizedBox(width: radiantGap),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
