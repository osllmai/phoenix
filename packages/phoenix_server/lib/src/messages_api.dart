import 'dart:async';
import 'dart:convert';

import 'package:phoenix_core/phoenix_core.dart';
import 'package:phoenix_server/src/completion.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// Anthropic-compatible routes: `POST /v1/messages` (Claude CLI and SDK clients).
Router messagesApi(CompletionEngine engine, ModelManager models) {
  final r = Router();

  r.post('/v1/messages', (Request req) async {
    final body = await _body(req);
    final messagesRaw = body['messages'];
    if (messagesRaw is! List || messagesRaw.isEmpty) {
      return _anthropicError(400, 'invalid_request_error', 'messages must be a non-empty array');
    }

    final maxTokens = body['max_tokens'] as int?;
    if (maxTokens == null || maxTokens < 1) {
      return _anthropicError(400, 'invalid_request_error', 'max_tokens is required');
    }

    final messages = _parseMessages(messagesRaw);
    if (messages.isEmpty) {
      return _anthropicError(400, 'invalid_request_error', 'messages must include user content');
    }

    final modelName = body['model'] as String?;
    final temperature = (body['temperature'] as num?)?.toDouble();
    final stream = body['stream'] as bool? ?? false;
    // The Anthropic top-level `system` is the single source of system prompt;
    // CompletionEngine.complete applies it directly.
    final system = _anthropicSystem(body['system']);

    try {
      await engine.ensureReady(modelName);
    } on ArgumentError catch (e) {
      return _anthropicError(404, 'not_found_error', '${e.message}');
    } on StateError catch (e) {
      return _anthropicError(409, 'invalid_request_error', e.message);
    }

    final active = models.active!;
    final id = 'msg_${DateTime.now().millisecondsSinceEpoch}';

    if (stream) {
      return Response(
        200,
        body: _anthropicSse(
          engine.complete(
            messages,
            model: modelName,
            system: system.isEmpty ? null : system,
            temperature: temperature,
            maxTokens: maxTokens,
          ),
          id: id,
          model: active.name,
        ),
        headers: {
          'content-type': 'text/event-stream; charset=utf-8',
          'cache-control': 'no-cache',
          'connection': 'keep-alive',
        },
      );
    }

    try {
      final text = StringBuffer();
      await for (final token in engine.complete(
        messages,
        model: modelName,
        system: system.isEmpty ? null : system,
        temperature: temperature,
        maxTokens: maxTokens,
      )) {
        text.write(token);
      }
      return _json({
        'id': id,
        'type': 'message',
        'role': 'assistant',
        'model': active.name,
        'content': [
          {'type': 'text', 'text': text.toString()},
        ],
        'stop_reason': 'end_turn',
        'stop_sequence': null,
        'usage': {'input_tokens': 0, 'output_tokens': 0},
      });
    } on EngineException catch (e) {
      return _anthropicError(502, 'api_error', 'engine ${e.kind.name}: ${e.message}');
    }
  });

  return r;
}

List<ApiMessage> _parseMessages(List<dynamic> raw) {
  final out = <ApiMessage>[];
  for (final item in raw) {
    if (item is! Map<String, dynamic>) continue;
    final role = item['role'] as String? ?? '';
    if (role != 'user' && role != 'assistant') continue;
    out.add(ApiMessage.fromJson(item));
  }
  return out;
}

String _anthropicSystem(Object? value) {
  if (value is String) return value;
  if (value is List) {
    return value
        .whereType<Map>()
        .map((b) => b['text'] ?? b['content'] ?? '')
        .join('\n');
  }
  return '';
}

Stream<List<int>> _anthropicSse(Stream<String> tokens, {required String id, required String model}) async* {
  final messageStart = {
    'type': 'message_start',
    'message': {
      'id': id,
      'type': 'message',
      'role': 'assistant',
      'model': model,
      'content': [],
      'stop_reason': null,
      'stop_sequence': null,
      'usage': {'input_tokens': 0, 'output_tokens': 0},
    },
  };
  yield utf8.encode('event: message_start\ndata: ${jsonEncode(messageStart)}\n\n');

  final blockStart = {
    'type': 'content_block_start',
    'index': 0,
    'content_block': {'type': 'text', 'text': ''},
  };
  yield utf8.encode('event: content_block_start\ndata: ${jsonEncode(blockStart)}\n\n');

  try {
    await for (final token in tokens) {
      final delta = {
        'type': 'content_block_delta',
        'index': 0,
        'delta': {'type': 'text_delta', 'text': token},
      };
      yield utf8.encode('event: content_block_delta\ndata: ${jsonEncode(delta)}\n\n');
    }

    final blockStop = {'type': 'content_block_stop', 'index': 0};
    yield utf8.encode('event: content_block_stop\ndata: ${jsonEncode(blockStop)}\n\n');

    final messageDelta = {
      'type': 'message_delta',
      'delta': {'stop_reason': 'end_turn', 'stop_sequence': null},
      'usage': {'output_tokens': 0},
    };
    yield utf8.encode('event: message_delta\ndata: ${jsonEncode(messageDelta)}\n\n');

    yield utf8.encode('event: message_stop\ndata: {"type":"message_stop"}\n\n');
  } on EngineException catch (e) {
    final err = {
      'type': 'error',
      'error': {'type': 'api_error', 'message': 'engine ${e.kind.name}: ${e.message}'},
    };
    yield utf8.encode('event: error\ndata: ${jsonEncode(err)}\n\n');
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

Response _anthropicError(int status, String type, String message) => Response(
  status,
  body: jsonEncode({
    'type': 'error',
    'error': {'type': type, 'message': message},
  }),
  headers: {'content-type': 'application/json'},
);
