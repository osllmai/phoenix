import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/feature/feature_module.dart';
import 'presentation/screens/settings_screen.dart';

/// Settings feature, self-registered with the app shell.
class SettingsModule implements FeatureModule {
  const SettingsModule();

  @override
  String get id => 'settings';

  @override
  List<RouteBase> routes() => [
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ];

  @override
  List<FeatureNavItem> navItems() => const [
        FeatureNavItem(
          label: 'Settings',
          icon: Icons.settings_outlined,
          path: '/settings',
          isFooter: true,
        ),
      ];
}
