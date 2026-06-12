import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/feature/feature_module.dart';
import 'presentation/screens/chat_screen.dart';

/// Chat feature, self-registered with the app shell.
class ChatModule implements FeatureModule {
  const ChatModule();

  @override
  String get id => 'chat';

  @override
  List<RouteBase> routes() => [
        GoRoute(path: '/', builder: (context, state) => const ChatScreen()),
      ];

  @override
  List<FeatureNavItem> navItems() => const [
        FeatureNavItem(label: 'Chat', icon: Icons.chat_bubble_outline, path: '/'),
      ];
}
