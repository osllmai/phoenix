import 'package:phoenix_core/phoenix_core.dart';

/// A chat message in the API request (role + content).
class ApiMessage {
  const ApiMessage(this.role, this.content);
  final String role;
  final String content;

  static ApiMessage fromJson(Map<String, dynamic> j) =>
      ApiMessage(j['role'] as String? ?? 'user', _content(j['content']));

  // Content may be a plain string (OpenAI) or a list of blocks (Anthropic).
  static String _content(Object? c) {
    if (c is String) return c;
    if (c is List) {
      return c
          .whereType<Map>()
          .map((b) => b['text'] ?? b['content'] ?? '')
          .join('\n');
    }
    return '';
  }
}

/// Bridges API requests to [PhoenixCore]: selects the requested model (if known)
/// and streams a stateless completion straight from the engine.
class CompletionEngine {
  CompletionEngine(this.core);
  final PhoenixCore core;

  /// Streams response tokens for [messages]. The system message becomes the
  /// engine `systemPrompt`; the rest are formatted into the prompt.
  ///
  /// Call [ensureReady] before streaming if you need model-selection guarantees.
  Stream<String> complete(
    List<ApiMessage> messages, {
    String? model,
    String? system,
    double? temperature,
    int? maxTokens,
  }) async* {
    final fromMessages = messages.where((m) => m.role == 'system').map((m) => m.content).join('\n');
    final systemPrompt = (system != null && system.isNotEmpty) ? system : fromMessages;
    final turns = messages.where((m) => m.role != 'system').toList();
    final prompt = _formatPrompt(turns);

    final params = InferenceParams(
      systemPrompt: systemPrompt,
      temperature: temperature ?? 0.7,
      maxTokens: maxTokens ?? 512,
    );
    yield* core.engine.prompt(prompt, params: params);
  }

  /// Ensures a model is loaded before completion. Resolves [modelName] when
  /// given; otherwise requires an already-active model from `/v1/models/.../select`.
  Future<void> ensureReady(String? modelName) => _ensureModel(modelName);

  Future<void> _ensureModel(String? modelName) async {
    if (modelName != null) {
      final active = core.models.active;
      if (active != null && (active.name == modelName || active.key == modelName)) {
        return;
      }
      for (final m in await core.models.list()) {
        if (m.name == modelName || m.key == modelName) {
          await core.models.select(m);
          return;
        }
      }
      throw ArgumentError('Model not found: $modelName');
    }
    if (core.models.active == null) {
      throw StateError(
        'No model loaded. POST /v1/models with a GGUF path, then POST /v1/models/<id>/select.',
      );
    }
  }

  String _formatPrompt(List<ApiMessage> turns) {
    final b = StringBuffer();
    for (final m in turns) {
      b.writeln('${m.role}: ${m.content}');
    }
    b.write('assistant:');
    return b.toString();
  }
}
