/// F5 — an unrouted path renders the documented fallback, not a crash or a
/// blank screen.
///
/// The router declares no `errorBuilder`, so go_router's default error screen
/// is what ships. That is asserted here so replacing it stays a deliberate
/// change rather than a silent one.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'route_harness.dart';

const List<String> unroutedProbes = [
  unroutedPath,
  '/models/not-a-real-child',
  '/developer/not-a-real-child',
  '/%00',
];

void main() {
  bootstrapRouteSweep();

  group('F5 unknown route', () {
    test('the probe paths are genuinely unrouted', () {
      final collisions =
          unroutedProbes.where(allRoutePaths().contains).toList();
      expect(collisions, isEmpty,
          reason: 'these probes became real routes: $collisions — pick others');
    });

    for (final path in unroutedProbes) {
      testWidgets('F5 $path renders a fallback, not a blank screen',
          (tester) async {
        await pumpApp(tester);
        await goTo(tester, path);

        expect(find.byType(MaterialApp), findsOneWidget,
            reason: '$path unmounted the app');
        expect(find.byType(Scaffold), findsWidgets,
            reason: '$path rendered no Scaffold — a blank screen fails this row');
      });
    }

    testWidgets('an unknown route does not strand the app', (tester) async {
      await pumpApp(tester);
      await goTo(tester, unroutedPath);
      final errors = await goTo(tester, '/home');

      expect(errors, isEmpty,
          reason: 'navigating back from the fallback threw: ${describe(errors)}');
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
