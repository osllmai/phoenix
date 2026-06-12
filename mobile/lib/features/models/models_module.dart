import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/feature/feature_module.dart';
import 'presentation/screens/models_screen.dart';

/// Models feature, self-registered with the app shell.
class ModelsModule implements FeatureModule {
  const ModelsModule();

  @override
  String get id => 'models';

  @override
  List<RouteBase> routes() => [
        GoRoute(path: '/models', builder: (context, state) => const ModelsScreen()),
      ];

  @override
  List<FeatureNavItem> navItems() => const [
        FeatureNavItem(label: 'Models', icon: Icons.dns_outlined, path: '/models'),
      ];
}
