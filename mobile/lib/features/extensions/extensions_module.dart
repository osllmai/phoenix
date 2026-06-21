import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/feature/feature_module.dart';
import 'presentation/screens/extensions_screen.dart';

/// Extensions marketplace feature, self-registered with the app shell.
class ExtensionsModule implements FeatureModule {
  const ExtensionsModule();

  @override
  String get id => 'extensions';

  @override
  List<RouteBase> routes() => [
        GoRoute(
          path: '/extensions',
          builder: (context, state) => const ExtensionsScreen(),
        ),
      ];

  @override
  List<FeatureNavItem> navItems() => const [
        FeatureNavItem(
          label: 'Extensions',
          icon: Icons.extension_outlined,
          path: '/extensions',
          group: NavGroup.tools,
        ),
      ];
}
