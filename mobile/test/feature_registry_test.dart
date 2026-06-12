import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:phoenix/app/router.dart';
import 'package:phoenix/core/feature/feature_module.dart';
import 'package:phoenix/core/feature/feature_registry.dart';

/// A trivial feature used to prove modules are composed, not hard-wired.
class _FakeFeature implements FeatureModule {
  const _FakeFeature(this.name);
  final String name;
  @override
  String get id => name;
  @override
  List<RouteBase> routes() =>
      [GoRoute(path: '/$name', builder: (c, s) => Text('screen-$name'))];
  @override
  List<FeatureNavItem> navItems() =>
      [FeatureNavItem(label: name, icon: Icons.star, path: '/$name')];
}

void main() {
  test('registry aggregates routes and nav items across modules', () {
    const reg = FeatureRegistry([_FakeFeature('a'), _FakeFeature('b')]);
    expect(reg.routes().length, 2);
    expect(reg.navItems().map((n) => n.path), ['/a', '/b']);
    expect(reg.byId('b')?.id, 'b');
  });

  testWidgets('shell renders a nav rail from registered features', (tester) async {
    const reg = FeatureRegistry([_FakeFeature('a'), _FakeFeature('b')]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [featureRegistryProvider.overrideWithValue(reg)],
        child: Consumer(
          builder: (context, ref, _) =>
              MaterialApp.router(routerConfig: ref.watch(routerProvider)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Both features show as rail destinations; the initial route renders.
    expect(find.text('a'), findsWidgets);
    expect(find.text('b'), findsWidgets);
    expect(find.text('screen-a'), findsOneWidget);
  });
}
