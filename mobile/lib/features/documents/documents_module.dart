import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/feature/feature_module.dart';
import 'presentation/screens/documents_screen.dart';

class DocumentsModule implements FeatureModule {
  const DocumentsModule();

  @override
  String get id => 'documents';

  @override
  List<RouteBase> routes() => [
        GoRoute(
          path: '/documents',
          builder: (context, state) => const DocumentsScreen(),
        ),
      ];

  @override
  List<FeatureNavItem> navItems() => const [
        FeatureNavItem(
          label: 'Docs',
          icon: Icons.folder_outlined,
          path: '/documents',
        ),
      ];
}
