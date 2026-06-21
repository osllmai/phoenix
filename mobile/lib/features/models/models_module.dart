import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phoenix_core/phoenix_core.dart';

import '../../core/feature/feature_module.dart';
import 'data/catalog_entry.dart';
import 'presentation/screens/add_model_screen.dart';
import 'presentation/screens/model_catalog_detail_screen.dart';
import 'presentation/screens/model_detail_screen.dart';
import 'presentation/screens/models_browse_screen.dart';
import 'presentation/screens/models_screen.dart';
import 'presentation/screens/online_models_screen.dart';
import 'presentation/screens/providers_screen.dart';

/// Models feature, self-registered with the app shell.
class ModelsModule implements FeatureModule {
  const ModelsModule();

  @override
  String get id => 'models';

  @override
  List<RouteBase> routes() => [
    GoRoute(path: '/models', builder: (context, state) => const ModelsScreen()),
    GoRoute(
      path: '/models/add',
      builder: (context, state) => const AddModelScreen(),
    ),
    GoRoute(
      path: '/models/browse',
      builder: (context, state) => const ModelsBrowseScreen(),
    ),
    GoRoute(
      path: '/models/online',
      builder: (context, state) => const OnlineModelsScreen(),
    ),
    GoRoute(
      path: '/models/providers',
      builder: (context, state) => const ProvidersScreen(),
    ),
    GoRoute(
      path: '/models/detail',
      builder: (context, state) =>
          ModelDetailScreen(model: state.extra as AiModel),
    ),
    GoRoute(
      path: '/models/catalog-detail',
      builder: (context, state) =>
          ModelCatalogDetailScreen(entry: state.extra as CatalogEntry),
    ),
  ];

  @override
  List<FeatureNavItem> navItems() => const [
    FeatureNavItem(
        label: 'Local',
        icon: Icons.dns_outlined,
        path: '/models',
        group: NavGroup.models),
    FeatureNavItem(
        label: 'Online',
        icon: Icons.cloud_outlined,
        path: '/models/online',
        group: NavGroup.models),
    FeatureNavItem(
        label: 'Providers',
        icon: Icons.hub_outlined,
        path: '/models/providers',
        group: NavGroup.models),
    FeatureNavItem(
        label: 'Browse',
        icon: Icons.download_outlined,
        path: '/models/browse',
        group: NavGroup.models),
  ];
}
