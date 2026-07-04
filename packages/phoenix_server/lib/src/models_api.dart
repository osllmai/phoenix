import 'dart:convert';

import 'package:phoenix_core/phoenix_core.dart';
import 'package:phoenix_server/src/completion.dart';
import 'package:phoenix_server/src/completions_api.dart';
import 'package:phoenix_server/src/messages_api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// JSON view of a model for the HTTP API.
Map<String, Object?> modelToJson(AiModel m) => {
  'id': m.id,
  'name': m.name,
  'path': m.key,
  'installed': m.isInstalled,
  'liked': m.isLiked,
  'addedAt': m.addedAt?.toIso8601String(),
};

/// Model-management routes wrapping [manager]:
/// `GET /v1/models` · `POST /v1/models` · `POST /v1/models/<id>/select` ·
/// `POST /v1/models/<id>/like` · `DELETE /v1/models/<id>`.
Router modelsApi(ModelManager manager) {
  final r = Router();

  r.get('/v1/models', (Request req) async {
    final list = await manager.list();
    final active = manager.active;
    return _json({
      'active': active == null ? null : modelToJson(active),
      'data': [for (final m in list) modelToJson(m)],
    });
  });

  r.post('/v1/models', (Request req) async {
    final body = await _body(req);
    try {
      final m = await manager.addLocal(
        name: (body['name'] as String?)?.trim() ?? '',
        path: (body['path'] as String?)?.trim() ?? '',
      );
      return _json(modelToJson(m), status: 201);
    } on ArgumentError catch (e) {
      return _error(400, '${e.message}');
    }
  });

  r.post('/v1/models/<id>/select', (Request req, String id) async {
    final m = await _find(manager, id);
    if (m == null) return _error(404, 'model not found');
    try {
      await manager.select(m);
      return _json({'active': modelToJson(m)});
    } on ArgumentError catch (e) {
      return _error(409, '${e.message}');
    } on StateError catch (e) {
      return _error(409, e.message);
    } on EngineException catch (e) {
      return _error(502, 'engine ${e.kind.name}: ${e.message}');
    }
  });

  r.post('/v1/models/<id>/like', (Request req, String id) async {
    final m = await _find(manager, id);
    if (m == null) return _error(404, 'model not found');
    final body = await _body(req);
    final liked = body['liked'] as bool? ?? !m.isLiked;
    await manager.setLiked(m, liked);
    return _json({'ok': true, 'liked': liked});
  });

  r.delete('/v1/models/<id>', (Request req, String id) async {
    final m = await _find(manager, id);
    if (m == null) return _error(404, 'model not found');
    await manager.remove(m);
    return _json({'ok': true});
  });

  return r;
}

/// The full gateway handler: CORS + health + model routes + chat completions.
Handler buildGatewayHandler(PhoenixCore core) {
  final completions = CompletionEngine(core);
  final router = Router()
    ..mount('/', modelsApi(core.models))
    ..mount('/', completionsApi(completions, core.models))
    ..mount('/', messagesApi(completions, core.models))
    ..get('/health', (Request req) => _json({'ok': true}));
  return const Pipeline().addMiddleware(_cors()).addHandler(router.call);
}

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, x-api-key, anthropic-version',
};

Middleware _cors() => (handler) => (req) async {
  if (req.method == 'OPTIONS') return Response.ok(null, headers: _corsHeaders);
  final res = await handler(req);
  return res.change(headers: _corsHeaders);
};

Future<AiModel?> _find(ModelManager manager, String id) async {
  final n = int.tryParse(id);
  if (n == null) return null;
  for (final m in await manager.list()) {
    if (m.id == n) return m;
  }
  return null;
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
