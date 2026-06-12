import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ai/engine_provider.dart';
import '../../data/model_repository.dart';
import '../../domain/ai_model.dart';
import '../../domain/model_manager.dart';

/// Model persistence. Overridden in `main()` with the SQLite impl; defaults to
/// in-memory for tests/previews.
final modelRepositoryProvider = Provider<ModelRepository>((ref) {
  return InMemoryModelRepository();
});

final modelManagerProvider = Provider<ModelManager>((ref) {
  return ModelManager(
    engine: ref.watch(inferenceEngineProvider),
    repository: ref.watch(modelRepositoryProvider),
  );
});

/// The active (engine-loaded) model, exposed to the UI.
final activeModelProvider = StateProvider<AiModel?>((ref) => null);

/// Loads + mutates the installed-model list.
class ModelsController extends AsyncNotifier<List<AiModel>> {
  ModelManager get _manager => ref.read(modelManagerProvider);

  @override
  Future<List<AiModel>> build() => _manager.list();

  Future<void> addLocal({required String name, required String path}) async {
    await _manager.addLocal(name: name, path: path);
    state = AsyncData(await _manager.list());
  }

  Future<void> select(AiModel model) async {
    await _manager.select(model);
    ref.read(activeModelProvider.notifier).state = model;
  }

  Future<void> toggleLike(AiModel model) async {
    await _manager.setLiked(model, !model.isLiked);
    state = AsyncData(await _manager.list());
  }

  Future<void> remove(AiModel model) async {
    await _manager.remove(model);
    state = AsyncData(await _manager.list());
  }
}

final modelsControllerProvider =
    AsyncNotifierProvider<ModelsController, List<AiModel>>(ModelsController.new);
