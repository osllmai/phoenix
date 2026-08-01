import 'dart:async';
import 'dart:convert';

import 'package:phoenix_core/phoenix_core.dart';
import 'package:phoenix_server/src/completion.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// OpenAI-compatible chat routes: `POST /v1/chat/completions`.
Router completionsApi(CompletionEngine engine, ModelManager models) {
  final r = Router();

  r.post('/v1/chat/completions', (Request req) async {
    final body = await _body(req);
    final messagesRaw = body['messages'];
    if (messagesRaw is! List || messagesRaw.isEmpty) {
      return _error(400, 'messages must be a non-empty array');
    }

    final messages = [
      for (final m in messagesRaw)
        if (m is Map<String, dynamic>) ApiMessage.fromJson(m),
    ];
    if (messages.isEmpty) {
      return _error(400, 'messages must contain at least one valid message');
    }

    final modelName = body['model'] as String?;
    final temperature = (body['temperature'] as num?)?.toDouble();
    final maxTokens = body['max_tokens'] as int? ?? body['maxTokens'] as int?;
    final stream = body['stream'] as bool? ?? false;

    try {
      await engine.ensureReady(modelName);
    } on ArgumentError catch (e) {
      return _error(404, '${e.message}');
    } on StateError catch (e) {
      return _error(409, e.message);
    }

    final active = models.active!;
    final id = 'chatcmpl-${DateTime.now().millisecondsSinceEpoch}';
    final created = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    if (stream) {
      return Response(
        200,
        body: _sseStream(
          engine.complete(
            messages,
            model: modelName,
            temperature: temperature,
            maxTokens: maxTokens,
          ),
          id: id,
          model: active.name,
          created: created,
        ),
        headers: {
          'content-type': 'text/event-stream; charset=utf-8',
          'cache-control': 'no-cache',
          'connection': 'keep-alive',
        },
      );
    }

    try {
      final content = StringBuffer();
      await for (final token in engine.complete(
        messages,
        model: modelName,
        temperature: temperature,
        maxTokens: maxTokens,
      )) {
        content.write(token);
      }
      return _json({
        'id': id,
        'object': 'chat.completion',
        'created': created,
        'model': active.name,
        'choices': [
          {
            'index': 0,
            'message': {'role': 'assistant', 'content': content.toString()},
            'finish_reason': 'stop',
          },
        ],
        'usage': {
          'prompt_tokens': 0,
          'completion_tokens': 0,
          'total_tokens': 0,
        },
      });
    } on EngineException catch (e) {
      return _error(502, 'engine ${e.kind.name}: ${e.message}');
    } on StateError catch (e) {
      return _error(409, e.message);
    }
  });

  return r;
}

Stream<List<int>> _sseStream(
  Stream<String> tokens, {
  required String id,
  required String model,
  required int created,
}) async* {
  try {
    await for (final token in tokens) {
      final chunk = {
        'id': id,
        'object': 'chat.completion.chunk',
        'created': created,
        'model': model,
        'choices': [
          {
            'index': 0,
            'delta': {'content': token},
            'finish_reason': null,
          },
        ],
      };
      yield utf8.encode('data: ${jsonEncode(chunk)}\n\n');
    }
    final done = {
      'id': id,
      'object': 'chat.completion.chunk',
      'created': created,
      'model': model,
      'choices': [
        {'index': 0, 'delta': {}, 'finish_reason': 'stop'},
      ],
    };
    yield utf8.encode('data: ${jsonEncode(done)}\n\n');
    yield utf8.encode('data: [DONE]\n\n');
  } on EngineException catch (e) {
    final err = {'error': 'engine ${e.kind.name}: ${e.message}'};
    yield utf8.encode('data: ${jsonEncode(err)}\n\n');
  }
}

Future<Map<String, dynamic>> _body(Request req) async {
  final s = await req.readAsString();
  if (s.isEmpty) return {};
  return jsonDecode(s) as Map<String, dynamic>;
}

Response _json(Object? data, {int status = 200}) => Response(
  status,
  body: jsonEncode(data),
  headers: {'content-type': 'application/json'},
);

Response _error(int status, String message) => _json({'error': message}, status: status);
