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

/// Marks a feature whose routes mount at the router root — outside the app
/// shell, with no nav rail (e.g. first-run onboarding, pre-app screens).
abstract interface class PreAppFeature {}

/// The collapsible sections of the app sidebar, in display order. [FeatureNavItem]s
/// are grouped under these; Settings sits in a separate footer (see [FeatureNavItem.isFooter]).
enum NavGroup { workspace, models, developer, tools }

extension NavGroupLabel on NavGroup {
  String get label => switch (this) {
        NavGroup.workspace => 'Workspace',
        NavGroup.models => 'Models',
        NavGroup.developer => 'Developer',
        NavGroup.tools => 'Tools',
      };
}

/// A navigation destination contributed by a [FeatureModule]. A module may
/// contribute several (e.g. Models → Local · Online · Providers · Browse).
class FeatureNavItem {
  const FeatureNavItem({
    required this.label,
    required this.icon,
    required this.path,
    this.group = NavGroup.workspace,
    this.isFooter = false,
  });

  final String label;
  final IconData icon;
  final String path;

  /// Which sidebar section this item lives under.
  final NavGroup group;

  /// Pinned to the sidebar footer instead of a group (e.g. Settings).
  final bool isFooter;
}
