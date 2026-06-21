import 'package:go_router/go_router.dart';

import '../../core/feature/feature_module.dart';
import 'presentation/screens/welcome_screen.dart';

/// First-run onboarding feature. Reachable at `/welcome` but contributes no
/// nav item — it's a pre-app route, not a rail destination.
class WelcomeModule implements FeatureModule, PreAppFeature {
  const WelcomeModule();

  @override
  String get id => 'welcome';

  @override
  List<RouteBase> routes() => [
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
      ];

  @override
  List<FeatureNavItem> navItems() => const [];
}
