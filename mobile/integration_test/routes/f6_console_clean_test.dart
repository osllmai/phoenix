/// F6 — error channel clean on every route.
///
/// Flutter's analogue of "no uncaught console error": no `FlutterError`
/// recorded and no exception raised while the route is mounted, settled, and
/// left again. Layout overflow at size belongs to /flutter-web-preview sizes —
/// not re-implemented here.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'route_harness.dart';

void main() {
  bootstrapRouteSweep();

  group('F6 error channel', () {
    for (final path in sweepablePaths()) {
      testWidgets('F6 $path records no error while mounted', (tester) async {
        await pumpApp(tester);
        final errors = await goTo(tester, path);

        expect(errors, isEmpty, reason: '$path recorded: ${describe(errors)}');
        expect(tester.takeException(), isNull,
            reason: '$path raised an exception during settle');
      });

      testWidgets('F6 $path records no error while being left', (tester) async {
        await pumpApp(tester);
        await goTo(tester, path);
        final errors = await goTo(tester, '/home');

        expect(errors, isEmpty,
            reason: 'leaving $path recorded: ${describe(errors)}');
      });
    }

    testWidgets('a full pass over every route stays clean', (tester) async {
      await pumpApp(tester);
      final all = <FlutterErrorDetails>[];
      for (final path in sweepablePaths()) {
        all.addAll(await goTo(tester, path));
      }
      expect(all, isEmpty,
          reason: 'a sequential pass recorded: ${describe(all)} — a route that '
              'is clean alone and dirty in sequence is leaking state');
    });
  });
}
