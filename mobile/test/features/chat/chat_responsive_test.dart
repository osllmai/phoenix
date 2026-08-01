import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/core/ai/engine_provider.dart';
import 'package:phoenix/features/chat/presentation/screens/chat_screen.dart';
import 'package:phoenix/features/chat/presentation/widgets/conversation_list.dart';
import 'package:phoenix/features/chat/presentation/widgets/conversation_pane.dart';
import 'package:phoenix/features/chat/presentation/widgets/conversation_rail.dart';
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

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [inferenceEngineProvider.overrideWithValue(_FakeEngine())],
      child: const MaterialApp(home: ChatScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('phone: single pane, conversation list hidden in a drawer', (tester) async {
    await _pumpAt(tester, const Size(400, 800));
    expect(find.byType(ConversationPane), findsOneWidget);
    expect(find.byType(VerticalDivider), findsNothing);
    expect(find.byType(ConversationList), findsNothing);
  });

  testWidgets('tablet: side pane auto-collapses to the rail', (tester) async {
    await _pumpAt(tester, const Size(800, 800));
    expect(find.byType(ConversationRail), findsOneWidget);
    expect(find.byType(ConversationList), findsNothing);
    expect(find.byType(ConversationPane), findsOneWidget);
  });

  testWidgets('desktop: side pane starts expanded', (tester) async {
    await _pumpAt(tester, const Size(1200, 800));
    expect(find.byType(ConversationList), findsOneWidget);
    expect(find.byType(ConversationRail), findsNothing);
    expect(find.byType(ConversationPane), findsOneWidget);
  });
}
