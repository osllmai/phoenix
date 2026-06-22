import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/feature/feature_module.dart';
import 'presentation/screens/developer_screen.dart';
import 'presentation/screens/evaluators_screen.dart';
import 'presentation/screens/flows_screen.dart';
import 'presentation/screens/maestro_screen.dart';

/// Developer / server console feature, self-registered with the app shell.
class DeveloperModule implements FeatureModule {
  const DeveloperModule();

  @override
  String get id => 'developer';

  @override
  List<RouteBase> routes() => [
        GoRoute(
          path: '/developer',
          builder: (context, state) => const DeveloperScreen(),
        ),
        GoRoute(
          path: '/developer/maestro',
          builder: (context, state) => const MaestroScreen(),
        ),
        GoRoute(
          path: '/developer/flows',
          builder: (context, state) => const FlowsScreen(),
        ),
        GoRoute(
          path: '/developer/evaluators',
          builder: (context, state) => const EvaluatorsScreen(),
        ),
      ];

  @override
  List<FeatureNavItem> navItems() => const [
        FeatureNavItem(
            label: 'Server',
            icon: Icons.terminal,
            path: '/developer',
            group: NavGroup.developer),
        FeatureNavItem(
            label: 'Maestro',
            icon: Icons.account_tree_outlined,
            path: '/developer/maestro',
            group: NavGroup.developer),
        FeatureNavItem(
            label: 'Flows',
            icon: Icons.schema_outlined,
            path: '/developer/flows',
            group: NavGroup.developer),
        FeatureNavItem(
            label: 'Evaluators',
            icon: Icons.bar_chart_outlined,
            path: '/developer/evaluators',
            group: NavGroup.developer),
      ];
}
