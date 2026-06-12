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
  Stream<String> complete(
    List<ApiMessage> messages, {
    String? model,
    double? temperature,
    int? maxTokens,
  }) async* {
    await _ensureModel(model);

    final system = messages.where((m) => m.role == 'system').map((m) => m.content).join('\n');
    final turns = messages.where((m) => m.role != 'system').toList();
    final prompt = _formatPrompt(turns);

    final params = InferenceParams(
      systemPrompt: system,
      temperature: temperature ?? 0.7,
      maxTokens: maxTokens ?? 512,
    );
    yield* core.engine.prompt(prompt, params: params);
  }

  Future<void> _ensureModel(String? model) async {
    if (model == null) return;
    final active = core.models.active;
    if (active != null && (active.name == model || active.key == model)) return;
    final installed = await core.models.list();
    for (final m in installed) {
      if (m.name == model || m.key == model) {
        await core.models.select(m);
        return;
      }
    }
    // Unknown model name: leave the active model as-is (engine decides/errs).
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
