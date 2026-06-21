import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/feature/feature_module.dart';
import 'presentation/screens/speech_screen.dart';

/// Speech feature (Whisper speech-to-text), self-registered with the app shell.
class SpeechModule implements FeatureModule {
  const SpeechModule();

  @override
  String get id => 'speech';

  @override
  List<RouteBase> routes() => [
        GoRoute(path: '/speech', builder: (context, state) => const SpeechScreen()),
      ];

  @override
  List<FeatureNavItem> navItems() => const [
        FeatureNavItem(
          label: 'Speech',
          icon: Icons.mic_none,
          path: '/speech',
          group: NavGroup.tools,
        ),
      ];
}
