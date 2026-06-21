import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/feature/feature_module.dart';
import 'presentation/screens/home_screen.dart';

/// Dashboard / overview feature, self-registered with the app shell.
class HomeModule implements FeatureModule {
  const HomeModule();

  @override
  String get id => 'home';

  @override
  List<RouteBase> routes() => [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      ];

  @override
  List<FeatureNavItem> navItems() => const [
        FeatureNavItem(
          label: 'Home',
          icon: Icons.dashboard_outlined,
          path: '/home',
        ),
      ];
}
