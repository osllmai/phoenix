/// F1 — route inventory drift, compared BOTH ways.
///
/// A feature module that mounts a route with no inventory row fails, and an
/// inventory row whose module is gone fails. This is the row that catches the
/// screen added last Friday.
library;

import 'package:flutter_test/flutter_test.dart';

import 'route_harness.dart';

/// The routes this app is known to mount. Adding a feature means adding its
/// rows here in the same change — that is the point of the row.
const List<String> committedInventory = [
  '/',
  '/deepsearch',
  '/developer',
  '/developer/evaluators',
  '/developer/fleet',
  '/developer/flows',
  '/developer/maestro',
  '/documents',
  '/extensions',
  '/forecasting',
  '/home',
  '/models',
  '/models/add',
  '/models/browse',
  '/models/catalog-detail',
  '/models/detail',
  '/models/online',
  '/models/providers',
  '/more',
  '/settings',
  '/speech',
  '/welcome',
];

void main() {
  bootstrapRouteSweep();

  group('F1 route inventory', () {
    test('the registry mounts at least one route', () {
      expect(allRoutePaths(), isNotEmpty);
    });

    test('every mounted route has an inventory row', () {
      final missing =
          allRoutePaths().where((p) => !committedInventory.contains(p)).toList();
      expect(missing, isEmpty,
          reason: 'routes mounted with no inventory row: $missing');
    });

    test('every inventory row is still mounted', () {
      final stale =
          committedInventory.where((p) => !allRoutePaths().contains(p)).toList();
      expect(stale, isEmpty,
          reason: 'inventory rows no feature mounts any more: $stale');
    });

    test('every route path is absolute', () {
      final relative = allRoutePaths().where((p) => !p.startsWith('/')).toList();
      expect(relative, isEmpty,
          reason: 'relative paths break go() navigation: $relative');
    });

    test('no route path is declared twice', () {
      final seen = <String>{};
      final duplicates =
          allRoutePaths().where((p) => !seen.add(p)).toList();
      expect(duplicates, isEmpty,
          reason: 'two features mount the same path: $duplicates');
    });

    test('shell and root routes together cover every route', () {
      expect(shellRoutePaths().length + rootRoutePaths().length,
          allRoutePaths().length);
    });

    test('every nav item points at a mounted route', () {
      final dangling = navItems()
          .map((item) => item.path)
          .where((p) => !allRoutePaths().contains(p))
          .toList();
      expect(dangling, isEmpty,
          reason: 'nav items pointing nowhere: $dangling');
    });

    test('the extra-requiring routes are still the declared ones', () {
      final unmounted = routesRequiringExtra
          .where((p) => !allRoutePaths().contains(p))
          .toList();
      expect(unmounted, isEmpty,
          reason: 'the extra-requiring declaration is stale: $unmounted');
    });
  });
}
