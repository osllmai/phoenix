import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/core/widgets/desktop_only_panel.dart';
import 'package:phoenix/features/deepsearch/presentation/data/deepsearch_dto.dart';
import 'package:phoenix/features/deepsearch/presentation/data/deepsearch_repository.dart';
import 'package:phoenix/features/deepsearch/presentation/screens/deepsearch_screen.dart';
import 'package:phoenix/features/deepsearch/presentation/widgets/answer_column.dart';
import 'package:phoenix/features/deepsearch/presentation/widgets/first_run_view.dart';
import 'package:phoenix/features/deepsearch/presentation/widgets/sources_pane.dart';

class _MockRepo extends Mock implements DeepSearchRepository {}

SearchDetailDto _readyRun() => SearchDetailDto(
      id: 1,
      query: 'q',
      scope: 'local',
      depth: 'standard',
      status: 'ready',
      answer: 'A grounded answer `[1]`.',
      sources: [
        SearchSourceDto(
          documentId: 7,
          title: 'Matched doc',
          snippet: 'relevant snippet',
          relevance: 0.9,
        ),
      ],
      createdAt: DateTime(2026),
    );

_MockRepo _repo() {
  final repo = _MockRepo();
  when(() => repo.startSearch(any(), any(), any())).thenAnswer((_) async => 1);
  when(() => repo.getRun(any())).thenAnswer((_) async => _readyRun());
  return repo;
}

Future<void> _pumpAt(WidgetTester tester, Size size, DeepSearchRepository repo) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [deepSearchRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: DeepSearchScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _run(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).first, 'inference latency');
  await tester.tap(find.widgetWithText(FilledButton, 'Run'));
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
  for (final size in [const Size(400, 900), const Size(800, 900)]) {
    testWidgets('width ${size.width.toInt()}: full search UI, no desktop gate',
        (tester) async {
      await _pumpAt(tester, size, _repo());
      expect(find.byType(DesktopOnlyPanel), findsNothing);
      expect(find.byType(FirstRunView), findsOneWidget);
    });
  }

  testWidgets('desktop first run: prompts before any result, no panes',
      (tester) async {
    await _withDesktop(() async {
      await _pumpAt(tester, const Size(1280, 900), _repo());
      expect(find.byType(FirstRunView), findsOneWidget);
      expect(find.byType(VerticalDivider), findsNothing);
    });
  });

  testWidgets('desktop: two panes side by side after running', (tester) async {
    await _withDesktop(() async {
      await _pumpAt(tester, const Size(1280, 900), _repo());
      await _run(tester);
      expect(find.byType(AnswerColumn), findsOneWidget);
      expect(find.byType(SourcesPane), findsOneWidget);
    });
  });
}
