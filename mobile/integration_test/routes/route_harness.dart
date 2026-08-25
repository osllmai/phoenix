/// Shared harness for the F-tier route sweeps.
///
/// The route list is derived from the feature registry — `phoenixFeatures` is
/// `const`, so the sweep reads the same composition root the app boots from. A
/// hardcoded path array rots the week it lands, and the route it misses is
/// always the one added last.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:phoenix/app/app.dart';
import 'package:phoenix/app/features.dart';
import 'package:phoenix/core/config/env.dart';
import 'package:phoenix/core/feature/feature_module.dart';
import 'package:phoenix/core/feature/feature_registry.dart';
import 'package:phoenix/core/onboarding/onboarding_providers.dart';
import 'package:phoenix/core/onboarding/onboarding_repository.dart';

const Size sweepSurfaceSize = Size(1280, 900);
const double sweepPixelRatio = 1.0;
const Duration settleTimeout = Duration(seconds: 20);

/// Routes whose builder does an unguarded `state.extra as T` cast. Navigating
/// to them without `extra` throws a `TypeError` rather than rendering a
/// documented state — a product finding F7 reports, not a route to skip
/// quietly. Listed here so the sweep can name them.
const Set<String> routesRequiringExtra = {
  '/models/detail',
  '/models/catalog-detail',
};

/// A path the router does not define — F5's probe.
const String unroutedPath = '/this-route-is-not-registered-by-any-feature';

const FeatureRegistry registry = FeatureRegistry(phoenixFeatures);

/// Every path the registry mounts, shell and root, flattened.
List<String> allRoutePaths() => _collect(registry.routes());

List<String> shellRoutePaths() => _collect(registry.shellRoutes());

List<String> rootRoutePaths() => _collect(registry.rootRoutes());

/// Paths safe to push without an `extra` payload.
List<String> sweepablePaths() =>
    allRoutePaths().where((p) => !routesRequiringExtra.contains(p)).toList();

List<String> _collect(List<RouteBase> routes) {
  final found = <String>[];
  void visit(List<RouteBase> nodes) {
    for (final node in nodes) {
      if (node is GoRoute) found.add(node.path);
      visit(node.routes);
    }
  }

  visit(routes);
  found.sort();
  return found;
}

List<FeatureNavItem> navItems() => registry.navItems();

/// Overrides that keep the sweep off the filesystem, off sqflite and off any
/// platform channel — the mobile analogue of the backend's mock lane.
List<Override> sweepOverrides() => [
      featureRegistryProvider.overrideWithValue(registry),
      onboardingRepositoryProvider
          .overrideWithValue(InMemoryOnboardingRepository()),
      seenWelcomeProvider.overrideWithValue(true),
    ];

/// Call once from every sweep's `main()`.
IntegrationTestWidgetsFlutterBinding bootstrapRouteSweep() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadPhoenixEnv);
  return binding;
}

/// Pumps the real app (real router, real shell) sized for a desktop surface.
Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = sweepSurfaceSize;
  tester.view.devicePixelRatio = sweepPixelRatio;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(overrides: sweepOverrides(), child: const PhoenixApp()),
  );
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
}

/// Navigates to [path] and lets the frame settle. Returns any error recorded
/// while the route was mounting.
Future<List<FlutterErrorDetails>> goTo(
  WidgetTester tester,
  String path, {
  Object? extra,
}) async {
  final recorded = <FlutterErrorDetails>[];
  final previous = FlutterError.onError;
  FlutterError.onError = recorded.add;

  try {
    final context = tester.element(find.byType(MaterialApp).first);
    GoRouter.of(context).go(path, extra: extra);
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
  } finally {
    FlutterError.onError = previous;
  }
  return recorded;
}

String describe(List<FlutterErrorDetails> errors) =>
    errors.map((e) => e.exceptionAsString()).join(' | ');
