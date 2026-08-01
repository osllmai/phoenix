import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/features/extensions/presentation/data/extensions_repository.dart';
import 'package:phoenix/features/extensions/presentation/providers/extension_entry.dart';
import 'package:phoenix/features/extensions/presentation/screens/extensions_screen.dart';
import 'package:phoenix/features/extensions/presentation/widgets/marketplace_empty.dart';
import 'package:phoenix/features/extensions/presentation/widgets/browse_pane.dart';
import 'package:phoenix/features/extensions/presentation/widgets/extension_detail.dart';

import 'extensions_test_support.dart';

Future<void> _pumpAt(
  WidgetTester tester,
  Size size, {
  List<ExtensionEntry> entries = sampleEntries,
}) async {
  final repo = MockExtensionsRepository();
  when(() => repo.list(category: any(named: 'category'), query: any(named: 'query')))
      .thenAnswer((_) async => entries);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [extensionsRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: ExtensionsScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('phone: single browse pane, no inline detail or divider',
      (tester) async {
    await _pumpAt(tester, const Size(400, 800));
    expect(find.byType(BrowsePane), findsOneWidget);
    expect(find.byType(VerticalDivider), findsNothing);
    expect(find.byType(ExtensionDetail), findsNothing);
  });

  for (final size in [const Size(800, 800), const Size(1200, 800)]) {
    testWidgets('width ${size.width.toInt()}: browse + detail side by side',
        (tester) async {
      await _pumpAt(tester, size);
      expect(find.byType(BrowsePane), findsOneWidget);
      expect(find.byType(ExtensionDetail), findsOneWidget);
    });
  }

  for (final size in [const Size(1280, 800), const Size(900, 520)]) {
    testWidgets(
        '${size.width.toInt()}x${size.height.toInt()}: empty catalog renders '
        'the zero-state without overflow', (tester) async {
      await _pumpAt(tester, size, entries: const <ExtensionEntry>[]);
      expect(tester.takeException(), isNull);
      expect(find.byType(MarketplaceEmpty), findsOneWidget);
      expect(find.text('No extensions found'), findsOneWidget);
    });
  }
}
