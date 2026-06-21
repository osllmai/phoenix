import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/feature/feature_registry.dart';
import '../core/onboarding/onboarding_providers.dart';
import 'app_shell.dart';

/// The app router, derived entirely from the feature registry. No feature is
/// referenced directly here — routes come from the enabled [FeatureModule]s.
final routerProvider = Provider<GoRouter>((ref) {
  final registry = ref.watch(featureRegistryProvider);
  final nav = registry.navItems();
  final seenWelcome = ref.watch(seenWelcomeProvider);
  final home = nav.isNotEmpty ? nav.first.path : '/';
  return GoRouter(
    initialLocation: seenWelcome ? home : '/welcome',
    routes: [
      ...registry.rootRoutes(),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: registry.shellRoutes(),
      ),
    ],
  );
});
