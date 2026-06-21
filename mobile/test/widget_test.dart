import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:phoenix/core/ai/engine_provider.dart';
import 'package:phoenix/features/chat/presentation/screens/chat_screen.dart';
import 'package:phoenix_core/phoenix_core.dart';

/// Fake engine that streams a canned reply word-by-word.
class _FakeEngine implements InferencePort {
  @override
  EngineState get state => EngineState.ready;
  @override
  Future<void> loadModel(String modelPath) async {}
  @override
  Stream<String> prompt(String prompt, {InferenceParams params = const InferenceParams()}) async* {
    for (final w in ['Hi', ' there!']) {
      yield w;
    }
  }
  @override
  Future<void> stop() async {}
  @override
  Future<void> dispose() async {}
}

void main() {
  testWidgets('user can send a message and see the streamed reply', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [inferenceEngineProvider.overrideWithValue(_FakeEngine())],
        child: const MaterialApp(home: ChatScreen()),
      ),
    );

    await tester.enterText(find.byKey(const Key('chatComposer')), 'hello');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(find.text('hello'), findsOneWidget); // user bubble
    expect(
      find.byWidgetPredicate((w) => w is GptMarkdown && w.data == 'Hi there!'),
      findsOneWidget,
    ); // streamed reply, rendered as markdown
  });
}
