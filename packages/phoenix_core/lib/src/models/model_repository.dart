import 'ai_model.dart';

/// Persistence contract for installed models. Real impl is SQLite; tests use the
/// in-memory fake.
abstract interface class ModelRepository {
  Future<int> add(AiModel model);
  Future<List<AiModel>> all();
  Future<void> setLiked(int id, bool liked);
  Future<void> remove(int id);
}

class InMemoryModelRepository implements ModelRepository {
  final _models = <AiModel>[];
  int _seq = 0;

  @override
  Future<int> add(AiModel model) async {
    final id = ++_seq;
    _models.add(model.copyWith(id: id));
    return id;
  }

  @override
  Future<List<AiModel>> all() async => List.unmodifiable(_models);

  @override
  Future<void> setLiked(int id, bool liked) async {
    final i = _models.indexWhere((m) => m.id == id);
    if (i >= 0) _models[i] = _models[i].copyWith(isLiked: liked);
  }

  @override
  Future<void> remove(int id) async => _models.removeWhere((m) => m.id == id);
}
