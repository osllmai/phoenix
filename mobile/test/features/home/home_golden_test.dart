import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix/app/theme.dart';
import 'package:phoenix/core/ai/engine_provider.dart';
import 'package:phoenix/features/chat/presentation/providers/conversation_list_provider.dart';
import 'package:phoenix/features/home/presentation/screens/home_screen.dart';
import 'package:phoenix/features/models/presentation/providers/model_providers.dart';
import 'package:phoenix_core/phoenix_core.dart';

import 'home_test_data.dart';

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

Widget _homeAt(Size size) {
  return ProviderScope(
    overrides: [
      inferenceEngineProvider.overrideWithValue(_FakeEngine()),
      modelRepositoryProvider.overrideWithValue(seededModelRepository()),
      activeModelProvider.overrideWithValue(kActiveModel),
      conversationListProvider.overrideWith((ref) async => kConversations),
    ],
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: SizedBox.fromSize(
        size: size,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildPhoenixDarkTheme(),
          home: const HomeScreen(),
        ),
      ),
    ),
  );
}

void main() {
  goldenTest(
    'home dashboard adapts across phone, tablet and desktop',
    fileName: 'home_responsive',
    builder: () => GoldenTestGroup(
      columns: 1,
      children: [
        for (final s in const [Size(390, 720), Size(834, 720), Size(1280, 720)])
          GoldenTestScenario(
            name: '${s.width.toInt()}x${s.height.toInt()}',
            constraints: BoxConstraints.tight(s),
            child: _homeAt(s),
          ),
      ],
    ),
  );
}
