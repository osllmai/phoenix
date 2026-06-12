import '../../../core/ai/inference_port.dart';
import '../data/model_repository.dart';
import 'ai_model.dart';

/// Manages installed local models and which one is loaded into the engine.
///
/// Port of the legacy `ModelManager` (add/list/like/delete), plus engine load —
/// engine-agnostic, depends only on [InferencePort] + [ModelRepository].
class ModelManager {
  ModelManager({required this.engine, required this.repository});

  final InferencePort engine;
  final ModelRepository repository;

  AiModel? _active;

  /// The model currently loaded in the engine (null until one is selected).
  AiModel? get active => _active;

  Future<List<AiModel>> list() => repository.all();

  /// Registers a model from a local `.gguf` [path].
  Future<AiModel> addLocal({required String name, required String path}) async {
    final draft = AiModel(name: name, key: path, addedAt: DateTime.now());
    final id = await repository.add(draft);
    return draft.copyWith(id: id);
  }

  /// Loads [model] into the engine and marks it active.
  Future<void> select(AiModel model) async {
    if (!model.isInstalled) {
      throw ArgumentError('Model "${model.name}" has no file (key) to load.');
    }
    await engine.loadModel(model.key!);
    _active = model;
  }

  Future<void> setLiked(AiModel model, bool liked) =>
      repository.setLiked(model.id!, liked);

  Future<void> remove(AiModel model) async {
    if (_active?.id == model.id) _active = null;
    await repository.remove(model.id!);
  }
}
