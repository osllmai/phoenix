import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// A self-describing, loadable feature.
///
/// The app shell composes a list of these instead of importing each screen —
/// so adding/removing a feature is one registry entry, never a central edit.
/// Phoenix is expected to grow large; everything routes through this contract.
abstract interface class FeatureModule {
  /// Stable identifier (also used as a toggle key).
  String get id;

  /// Routes this feature contributes to the router.
  List<RouteBase> routes();

  /// Navigation entries this feature contributes to the app shell.
  /// Empty for features that are reachable but not top-level (e.g. dialogs).
  List<FeatureNavItem> navItems();
}

/// A top-level navigation destination contributed by a [FeatureModule].
class FeatureNavItem {
  const FeatureNavItem({required this.label, required this.icon, required this.path});

  final String label;
  final IconData icon;
  final String path;
}
