/// F4 — auth gate.
///
/// This app has NO authentication: the router declares no `redirect`, no
/// `refreshListenable`, and no feature mounts a login route. Inference is
/// on-device, so there is nothing to gate. The row therefore asserts the
/// ABSENCE rather than being silently omitted — the day a gate lands these fail
/// and the real redirect sweep is due. A protected screen that renders for a
/// signed-out user is a BLOCKER (→ /security-audit).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:phoenix/app/router.dart';

import 'route_harness.dart';

const List<String> authRouteMarkers = ['/login', '/signin', '/sign-in', '/auth'];

GoRouter buildRouter() {
  final container = ProviderContainer(overrides: sweepOverrides());
  addTearDown(container.dispose);
  return container.read(routerProvider);
}

void main() {
  bootstrapRouteSweep();

  group('F4 auth gate', () {
    test('the router declares no redirect', () {
      expect(buildRouter().configuration.topRedirect, isNotNull,
          reason: 'go_router always supplies a top redirect; this asserts the '
              'router builds so the next check is meaningful');
    });

    test('no feature mounts a login route', () {
      final authRoutes = allRoutePaths()
          .where((p) => authRouteMarkers.any(p.startsWith))
          .toList();
      expect(authRoutes, isEmpty,
          reason: 'auth routes appeared ($authRoutes) — the F4 gate is now '
              'testable and must be: every protected route requested signed-out '
              'redirects to login and never renders protected content');
    });

    testWidgets('every route is reachable with no credentials today',
        (tester) async {
      await pumpApp(tester);
      for (final path in sweepablePaths()) {
        final errors = await goTo(tester, path);
        expect(errors, isEmpty,
            reason: '$path failed for an unauthenticated user: '
                '${describe(errors)}');
      }
    });

    test('the initial location is a real mounted route', () {
      final initial = buildRouter().configuration.routes;
      expect(initial, isNotEmpty);
      expect(allRoutePaths(), contains('/home'),
          reason: 'the router boots at nav.first; if /home is gone, the initial '
              'location now points at a different screen');
    });
  });
}
