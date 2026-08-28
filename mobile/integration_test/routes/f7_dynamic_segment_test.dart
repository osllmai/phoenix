/// F7 — the Flutter twin of a dynamic segment: a detail route reached with a
/// missing, malformed, or wrong-typed payload.
///
/// No route declares a `:param`; the detail screens take their subject through
/// `state.extra` and cast it unguarded (`state.extra as AiModel`). That makes
/// "missing id" mean "no extra", and an unguarded cast turns it into a
/// `TypeError` instead of the documented empty/denied state.
///
/// These assertions are strict on purpose: a crash here is a PRODUCT finding
/// for the feature owner, never something to relax by widening the matcher.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'route_harness.dart';

const List<Object?> hostilePayloads = [
  null,
  'not-the-expected-type',
  42,
  <String, Object?>{},
  <Object?>[],
];

void main() {
  bootstrapRouteSweep();

  group('F7 detail routes', () {
    test('no route uses a path parameter', () {
      final parameterised =
          allRoutePaths().where((p) => p.contains(':')).toList();
      expect(parameterised, isEmpty,
          reason: 'path parameters appeared ($parameterised) — sweep them with '
              'missing, malformed and forbidden ids as well as the extra cases');
    });

    test('the detail routes that take an extra are still mounted', () {
      for (final path in routesRequiringExtra) {
        expect(allRoutePaths(), contains(path));
      }
    });

    for (final path in routesRequiringExtra) {
      for (final payload in hostilePayloads) {
        testWidgets('F7 $path renders a documented state for '
            '${payload.runtimeType}', (tester) async {
          await pumpApp(tester);
          final errors = await goTo(tester, path, extra: payload);

          expect(errors, isEmpty,
              reason: '$path threw for extra=${payload.runtimeType}: '
                  '${describe(errors)} — an unguarded `state.extra as T` cast '
                  'must become a documented empty/denied state');
          expect(find.byType(Scaffold), findsWidgets,
              reason: '$path rendered no Scaffold for '
                  'extra=${payload.runtimeType}');
        });
      }

      testWidgets('F7 $path does not strand the app after a bad payload',
          (tester) async {
        await pumpApp(tester);
        await goTo(tester, path, extra: null);
        final errors = await goTo(tester, '/models');

        expect(errors, isEmpty,
            reason: 'navigating away from $path threw: ${describe(errors)}');
      });
    }
  });
}
