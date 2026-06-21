import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/feature/feature_module.dart';
import 'presentation/screens/deepsearch_screen.dart';

/// DeepSearch feature: local + web research with a cited answer pane.
class DeepSearchModule implements FeatureModule {
  const DeepSearchModule();

  @override
  String get id => 'deepsearch';

  @override
  List<RouteBase> routes() => [
        GoRoute(
          path: '/deepsearch',
          builder: (context, state) => const DeepSearchScreen(),
        ),
      ];

  @override
  List<FeatureNavItem> navItems() => const [
        FeatureNavItem(
          label: 'Search',
          icon: Icons.travel_explore,
          path: '/deepsearch',
        ),
      ];
}
