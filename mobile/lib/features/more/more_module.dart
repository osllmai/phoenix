import 'package:go_router/go_router.dart';

import '../../core/feature/feature_module.dart';
import 'presentation/screens/more_screen.dart';

/// The phone "More" hub. Contributes the `/more` route; the bottom bar adds the
/// More tab itself (phone-only), so this exposes no nav item.
class MoreModule implements FeatureModule {
  const MoreModule();

  @override
  String get id => 'more';

  @override
  List<RouteBase> routes() => [
        GoRoute(
          path: '/more',
          builder: (context, state) => const MoreScreen(),
        ),
      ];

  @override
  List<FeatureNavItem> navItems() => const [];
}
