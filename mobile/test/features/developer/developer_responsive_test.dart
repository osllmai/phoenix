import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/features/developer/presentation/data/server_status_repository.dart';
import 'package:phoenix/features/developer/presentation/screens/developer_screen.dart';
import 'package:phoenix/features/developer/presentation/widgets/desktop_only_stub.dart';
import 'package:phoenix/features/developer/presentation/widgets/request_log_panel.dart';
import 'package:phoenix/features/developer/presentation/widgets/server_toolbar.dart';

import 'developer_test_support.dart';

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        serverStatusRepositoryProvider.overrideWithValue(reachableRepository()),
      ],
      child: const MaterialApp(home: DeveloperScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _withDesktop(Future<void> Function() body) async {
  debugDefaultTargetPlatformOverride = TargetPlatform.linux;
  try {
    await body();
  } finally {
    debugDefaultTargetPlatformOverride = null;
  }
}

void main() {
  for (final size in [const Size(400, 800), const Size(800, 800)]) {
    testWidgets('width ${size.width.toInt()}: desktop-only stub, no console',
        (tester) async {
      await _pumpAt(tester, size);
      expect(find.byType(DesktopOnlyStub), findsOneWidget);
      expect(find.text('Available on desktop'), findsOneWidget);
      expect(find.byType(ServerToolbar), findsNothing);
      expect(find.byType(RequestLogPanel), findsNothing);
    });
  }

  testWidgets('desktop: shows the server console', (tester) async {
    await _withDesktop(() async {
      await _pumpAt(tester, const Size(1280, 800));
      expect(find.byType(DesktopOnlyStub), findsNothing);
      expect(find.byType(ServerToolbar), findsOneWidget);
      expect(find.byType(RequestLogPanel), findsOneWidget);
    });
  });

  for (final size in [const Size(1280, 800), const Size(1100, 800)]) {
    testWidgets('console at ${size.width.toInt()}x${size.height.toInt()} does not overflow',
        (tester) async {
      await _withDesktop(() async {
        await _pumpAt(tester, size);
        expect(tester.takeException(), isNull);
        expect(find.byType(RequestLogPanel), findsOneWidget);
      });
    });
  }
}
