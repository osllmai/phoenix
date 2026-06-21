import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/app/theme.dart';
import 'package:phoenix/features/extensions/presentation/screens/extensions_screen.dart';

/// Real-backend proof: no mocks/overrides, so the default dioProvider hits the
/// live API at PHOENIX_API_BASE_URL (docker backend on localhost). Requires the
/// stack to be UP. Run explicitly: `flutter test integration_test/`.
Future<void> _pumpUntil(WidgetTester tester, Finder f, {int tries = 60}) async {
  for (var i = 0; i < tries; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (f.evaluate().isNotEmpty) return;
  }
}

void main() {
  testWidgets('extensions screen renders seeded data from the live backend', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildPhoenixDarkTheme(),
          home: const ExtensionsScreen(),
        ),
      ),
    );

    final seeded = find.text('Local Search');
    await _pumpUntil(tester, seeded);
    expect(seeded, findsOneWidget);
  });
}
