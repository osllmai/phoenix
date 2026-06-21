import 'package:phoenix_core/phoenix_core.dart';

const kModels = <AiModel>[
  AiModel(id: 1, name: 'Llama-3.1-8B-Instruct', key: '/m/llama.gguf'),
  AiModel(id: 2, name: 'Qwen2.5-7B', key: '/m/qwen.gguf'),
  AiModel(id: 3, name: 'Mistral-7B', key: '/m/mistral.gguf'),
];

const kActiveModel = AiModel(
  id: 1,
  name: 'Llama-3.1-8B-Instruct',
  key: '/m/llama.gguf',
);

final kConversations = <Conversation>[
  Conversation(
    id: 1,
    title: 'Refactoring the inference port abstraction',
    description: 'Llama-3.1-8B',
    date: DateTime(2026, 6, 18, 14, 1),
    icon: '💬',
  ),
  Conversation(
    id: 2,
    title: 'What does the Q3 report say about churn?',
    description: 'Qwen2.5-7B',
    date: DateTime(2026, 6, 18, 13, 48),
    icon: '🔎',
  ),
];

ModelRepository seededModelRepository() => _SeededModelRepository(kModels);

class _SeededModelRepository implements ModelRepository {
  _SeededModelRepository(this._models);

  final List<AiModel> _models;

  @override
  Future<int> add(AiModel model) async {
    _models.add(model);
    return model.id ?? _models.length;
  }

  @override
  Future<List<AiModel>> all() async => List.unmodifiable(_models);

  @override
  Future<void> setLiked(int id, bool liked) async {}

  @override
  Future<void> remove(int id) async => _models.removeWhere((m) => m.id == id);
}
