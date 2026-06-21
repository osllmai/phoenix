import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/features/documents/presentation/providers/documents_providers.dart';
import 'package:phoenix/features/documents/presentation/screens/documents_screen.dart';
import 'package:phoenix/features/documents/presentation/widgets/document_inspector.dart';

import '_fakes.dart';

Future<void> _pump(WidgetTester tester, MockDocumentsRepository repo) async {
  tester.view.physicalSize = const Size(1200, 800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [documentsRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: DocumentsScreen()),
    ),
  );
}

void main() {
  testWidgets('list load shows documents from the API', (tester) async {
    final repo = MockDocumentsRepository();
    when(repo.list).thenAnswer((_) async => sampleListDocs);
    when(() => repo.detail(any())).thenAnswer(
      (i) async => detailFor(i.positionalArguments.first as String),
    );

    await _pump(tester, repo);
    await tester.pumpAndSettle();

    expect(find.text('llama-3-technical-report.pdf'), findsWidgets);
    expect(find.text('product-roadmap-2026.docx'), findsOneWidget);
    verify(repo.list).called(1);
  });

  testWidgets('list error shows retry affordance', (tester) async {
    final repo = MockDocumentsRepository();
    when(repo.list).thenAnswer(
      (_) async => throw DioException(
        requestOptions: RequestOptions(path: '/documents/'),
      ),
    );

    await _pump(tester, repo);
    await tester.pumpAndSettle();

    expect(find.text('Could not load documents'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('detail load renders the markdown body', (tester) async {
    final repo = MockDocumentsRepository();
    when(repo.list).thenAnswer((_) async => sampleListDocs);
    when(() => repo.detail(any())).thenAnswer(
      (i) async => detailFor(i.positionalArguments.first as String),
    );

    await _pump(tester, repo);
    await tester.pumpAndSettle();

    expect(find.byType(DocumentInspector), findsOneWidget);
    expect(find.textContaining('Loaded from API'), findsOneWidget);
    verify(() => repo.detail('1')).called(1);
  });
}
