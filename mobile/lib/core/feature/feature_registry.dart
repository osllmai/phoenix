import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'feature_module.dart';

/// Holds the set of enabled [FeatureModule]s and aggregates what they expose.
///
/// This is the single place that knows "which features exist". The router and
/// nav are derived from it — nothing else imports feature screens directly.
class FeatureRegistry {
  const FeatureRegistry(this.modules);

  final List<FeatureModule> modules;

  List<RouteBase> routes() =>
      [for (final m in modules) ...m.routes()];

  /// Routes that mount inside the app shell (with nav rail).
  List<RouteBase> shellRoutes() =>
      [for (final m in modules) if (m is! PreAppFeature) ...m.routes()];

  /// Routes that mount at the router root, outside the shell.
  List<RouteBase> rootRoutes() =>
      [for (final m in modules) if (m is PreAppFeature) ...m.routes()];

  List<FeatureNavItem> navItems() =>
      [for (final m in modules) ...m.navItems()];

  FeatureModule? byId(String id) {
    for (final m in modules) {
      if (m.id == id) return m;
    }
    return null;
  }
}

/// The enabled feature set. Override in tests to load a subset; in `main()` to
/// gate features (e.g. behind flags) as the app grows.
final featureRegistryProvider = Provider<FeatureRegistry>((ref) {
  throw UnimplementedError(
    'featureRegistryProvider must be overridden with the app feature set.',
  );
});
