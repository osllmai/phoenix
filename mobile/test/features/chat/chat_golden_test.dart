import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix/app/theme.dart';
import 'package:phoenix/core/ai/engine_provider.dart';
import 'package:phoenix/features/chat/presentation/screens/chat_screen.dart';
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

Widget _chatAt(Size size) {
  return ProviderScope(
    overrides: [inferenceEngineProvider.overrideWithValue(_FakeEngine())],
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: SizedBox.fromSize(
        size: size,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildPhoenixDarkTheme(),
          home: const ChatScreen(),
        ),
      ),
    ),
  );
}

void main() {
  goldenTest(
    'chat surface adapts across phone, tablet and desktop',
    fileName: 'chat_responsive',
    builder: () => GoldenTestGroup(
      columns: 1,
      children: [
        for (final s in const [Size(390, 720), Size(834, 720), Size(1280, 720)])
          GoldenTestScenario(
            name: '${s.width.toInt()}x${s.height.toInt()}',
            constraints: BoxConstraints.tight(s),
            child: _chatAt(s),
          ),
      ],
    ),
  );
}
