import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/feature/feature_module.dart';
import 'presentation/screens/forecasting_screen.dart';

/// Forecasting (TimesFM) — a Tools-group feature. Compute runs on the paired
/// desktop's PyTorch/Celery backend; this surface is a preview on mobile.
class ForecastingModule implements FeatureModule {
  const ForecastingModule();

  @override
  String get id => 'forecasting';

  @override
  List<RouteBase> routes() => [
        GoRoute(
          path: '/forecasting',
          builder: (context, state) => const ForecastingScreen(),
        ),
      ];

  @override
  List<FeatureNavItem> navItems() => const [
        FeatureNavItem(
          label: 'Forecasting',
          icon: Icons.show_chart,
          path: '/forecasting',
          group: NavGroup.tools,
        ),
      ];
}
