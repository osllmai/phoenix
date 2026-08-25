import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/core/ai/engine_provider.dart';
import 'package:phoenix/features/chat/presentation/providers/conversation_list_provider.dart';
import 'package:phoenix/features/home/presentation/screens/home_screen.dart';
import 'package:phoenix/features/models/presentation/providers/model_providers.dart';
import 'package:phoenix_core/phoenix_core.dart';

class _FakeEngine implements InferencePort {
  @override
  EngineState get state => EngineState.ready;
  @override
  Future<void> loadModel(String modelPath) async {}
  @override
  Stream<String> prompt(String p, {InferenceParams params = const InferenceParams()}) =>
      const Stream.empty();
  @override
  Future<void> stop() async {}
  @override
  Future<void> dispose() async {}
}

class _EmptyModelRepository implements ModelRepository {
  @override
  Future<int> add(AiModel model) async => 0;
  @override
  Future<List<AiModel>> all() async => const [];
  @override
  Future<void> setLiked(int id, bool liked) async {}
  @override
  Future<void> remove(int id) async {}
}

Future<void> _pumpEmptyAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        inferenceEngineProvider.overrideWithValue(_FakeEngine()),
        modelRepositoryProvider.overrideWithValue(_EmptyModelRepository()),
        activeModelProvider.overrideWithValue(null),
        conversationListProvider.overrideWith((ref) async => const <Conversation>[]),
      ],
      child: const MaterialApp(home: HomeScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final size in [const Size(1280, 800), const Size(900, 520)]) {
    final tag = '${size.width.toInt()}x${size.height.toInt()}';

    testWidgets('empty $tag: no overflow', (tester) async {
      await _pumpEmptyAt(tester, size);
      expect(tester.takeException(), isNull);
    });

    testWidgets('empty $tag: renders no-model + no-conversations states',
        (tester) async {
      await _pumpEmptyAt(tester, size);
      // Tablet width scrolls one lazy column, so the cards below the fold are
      // only built once scrolled to.
      for (final text in const [
        'No model selected',
        'Pick a model to start chatting',
        'Pick a model',
        'No conversations yet',
      ]) {
        final finder = find.text(text);
        if (finder.evaluate().isEmpty) {
          await tester.scrollUntilVisible(finder, 200,
              scrollable: find.byType(Scrollable).first);
        }
        expect(finder, findsOneWidget, reason: 'missing "$text" at $tag');
      }
    });
  }
}
