import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:phoenix_core/phoenix_core.dart';

import 'model_providers.dart';

part 'models_controller.g.dart';

/// The active (engine-loaded) model, exposed to the UI.
@riverpod
class ActiveModel extends _$ActiveModel {
  @override
  AiModel? build() => null;
  void set(AiModel? v) => state = v;
}

/// Id of the model currently loading (null when idle) — drives the per-tile
/// spinner and the concurrent-load guard.
@riverpod
class LoadingModelId extends _$LoadingModelId {
  @override
  int? build() => null;
  void set(int? v) => state = v;
}

/// Loads + mutates the installed-model list.
@riverpod
class ModelsController extends _$ModelsController {
  ModelManager get _manager => ref.read(modelManagerProvider);

  @override
  Future<List<AiModel>> build() => _manager.list();

  Future<void> addLocal({required String name, required String path}) async {
    await _manager.addLocal(name: name, path: path);
    state = AsyncData(await _manager.list());
  }

  Future<void> select(AiModel model) async {
    ref.read(loadingModelIdProvider.notifier).set(model.id);
    try {
      await _manager.select(model);
      ref.read(activeModelProvider.notifier).set(model);
    } finally {
      ref.read(loadingModelIdProvider.notifier).set(null);
    }
  }

  Future<void> toggleLike(AiModel model) async {
    await _manager.setLiked(model, !model.isLiked);
    state = AsyncData(await _manager.list());
  }

  Future<void> remove(AiModel model) async {
    await _manager.remove(model);
    if (ref.read(activeModelProvider)?.id == model.id) {
      ref.read(activeModelProvider.notifier).set(null);
    }
    state = AsyncData(await _manager.list());
  }
}
