import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/features/documents/presentation/providers/document.dart';
import 'package:phoenix/features/documents/presentation/providers/documents_providers.dart';
import 'package:phoenix/features/documents/presentation/screens/documents_screen.dart';
import 'package:phoenix/features/documents/presentation/widgets/document_inspector.dart';
import 'package:phoenix/features/documents/presentation/widgets/document_library.dart';

import '_fakes.dart';

Future<MockDocumentsRepository> _pumpAt(
  WidgetTester tester,
  Size size, {
  List<PhoenixDocument>? listResult,
}) async {
  final repo = MockDocumentsRepository();
  when(repo.list).thenAnswer((_) async => listResult ?? sampleListDocs);
  when(() => repo.detail(any())).thenAnswer(
    (i) async => detailFor(i.positionalArguments.first as String),
  );

  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [documentsRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: DocumentsScreen()),
    ),
  );
  await tester.pumpAndSettle();
  return repo;
}

void main() {
  testWidgets('phone: single pane, no inspector side by side', (tester) async {
    await _pumpAt(tester, const Size(400, 800));
    expect(find.byType(DocumentLibrary), findsOneWidget);
    expect(find.byType(VerticalDivider), findsNothing);
    expect(find.byType(DocumentInspector), findsNothing);
  });

  for (final size in [const Size(800, 800), const Size(1200, 800)]) {
    testWidgets('width ${size.width.toInt()}: library + inspector panes',
        (tester) async {
      await _pumpAt(tester, size);
      expect(find.byType(DocumentLibrary), findsOneWidget);
      expect(find.byType(DocumentInspector), findsOneWidget);
      expect(find.byType(VerticalDivider), findsOneWidget);
    });
  }

  testWidgets('phone: tapping a document opens the detail view',
      (tester) async {
    await _pumpAt(tester, const Size(400, 800));
    await tester.tap(find.text('llama-3-technical-report.pdf').first);
    await tester.pumpAndSettle();
    expect(find.byType(DocumentInspector), findsOneWidget);
    expect(find.byType(DocumentLibrary), findsNothing);
  });

  for (final size in [const Size(1280, 800), const Size(900, 520)]) {
    testWidgets(
        '${size.width.toInt()}x${size.height.toInt()}: empty list renders '
        'zero-state without overflow', (tester) async {
      await _pumpAt(tester, size, listResult: const []);
      expect(tester.takeException(), isNull);
      expect(find.text('No documents yet'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Add document'), findsWidgets);
    });
  }
}
