import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/feature/feature_registry.dart';
import 'app_shell.dart';

/// The app router, derived entirely from the feature registry. No feature is
/// referenced directly here — routes come from the enabled [FeatureModule]s.
final routerProvider = Provider<GoRouter>((ref) {
  final registry = ref.watch(featureRegistryProvider);
  final nav = registry.navItems();
  return GoRouter(
    initialLocation: nav.isNotEmpty ? nav.first.path : '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: registry.routes(),
      ),
    ],
  );
});
