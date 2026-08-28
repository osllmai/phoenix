/// F2 — every route resolves (the Flutter analogue of "returns < 500").
/// F3 — every route mounts and settles with no uncaught FlutterError.
///
/// The app has no HTTP layer between the router and the screen, so F2 becomes
/// "the router resolves the path to a real page rather than the error screen",
/// and F3 is the render half.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'route_harness.dart';

void main() {
  bootstrapRouteSweep();

  group('F2 route resolution', () {
    for (final path in sweepablePaths()) {
      testWidgets('F2 $path resolves to a page', (tester) async {
        await pumpApp(tester);
        await goTo(tester, path);

        expect(find.byType(MaterialApp), findsOneWidget,
            reason: '$path unmounted the app');
        expect(find.text('Page Not Found'), findsNothing,
            reason: '$path fell through to the router error screen');
      });
    }
  });

  group('F3 render crash', () {
    for (final path in sweepablePaths()) {
      testWidgets('F3 $path mounts without a FlutterError', (tester) async {
        await pumpApp(tester);
        final errors = await goTo(tester, path);

        expect(errors, isEmpty, reason: '$path threw: ${describe(errors)}');
      });

      testWidgets('F3 $path renders content, not a blank screen',
          (tester) async {
        await pumpApp(tester);
        await goTo(tester, path);

        expect(find.byType(Scaffold), findsWidgets,
            reason: '$path rendered no Scaffold');
      });
    }
  });
}
