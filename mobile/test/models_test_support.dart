import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/app/theme.dart';
import 'package:phoenix/core/ai/engine_provider.dart';
import 'package:phoenix/features/models/presentation/providers/model_providers.dart';
import 'package:phoenix_core/phoenix_core.dart';

class FakeEngine implements InferencePort {
  @override
  EngineState get state => EngineState.idle;
  @override
  Future<void> loadModel(String modelPath) async {}
  @override
  Stream<String> prompt(
    String prompt, {
    InferenceParams params = const InferenceParams(),
  }) => const Stream.empty();
  @override
  Future<void> stop() async {}
  @override
  Future<void> dispose() async {}
}

class FavOnlyOn extends ModelFavOnly {
  @override
  bool build() => true;
}

class ActiveModelSeed extends ActiveModel {
  ActiveModelSeed(this._seed);
  final AiModel _seed;
  @override
  AiModel? build() => _seed;
}

Future<void> loadFonts() async {
  final loader = FontLoader('DMSans')
    ..addFont(rootBundle.load('assets/fonts/DMSans-Regular.ttf'));
  await loader.load();
}

Future<void> pump(
  WidgetTester tester,
  ModelRepository repo,
  Widget screen, {
  List<Override> extra = const [],
}) async {
  tester.view.physicalSize = const Size(1100, 760);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        modelRepositoryProvider.overrideWithValue(repo),
        inferenceEngineProvider.overrideWithValue(FakeEngine()),
        ...extra,
      ],
      child: MaterialApp(theme: buildPhoenixDarkTheme(), home: screen),
    ),
  );
  await tester.pumpAndSettle();
}

Future<ModelRepository> seeded() async {
  final repo = InMemoryModelRepository();
  await repo.add(
    AiModel(
      name: 'Llama-3.1-8B-Instruct',
      key: '/home/u/models/llama-3.1-8b-q4.gguf',
      isLiked: true,
    ),
  );
  await repo.add(
    AiModel(
      name: 'Qwen2.5-7B-Instruct',
      key: '/home/u/models/qwen2.5-7b-q5.gguf',
    ),
  );
  await repo.add(
    AiModel(
      name: 'Mistral-7B-Instruct',
      key: '/home/u/models/mistral-7b-q4.gguf',
      isLiked: true,
    ),
  );
  return repo;
}
