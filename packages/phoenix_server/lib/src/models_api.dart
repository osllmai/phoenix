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

/// A request Origin is only trusted when it is loopback. CLI/SDK clients
/// (curl, the Dart/Python SDKs) send no Origin at all and pass through.
bool _isLocalhostOrigin(String origin) {
  final uri = Uri.tryParse(origin);
  if (uri == null) return false;
  return uri.host == '127.0.0.1' || uri.host == 'localhost' || uri.host == '::1';
}

Map<String, String> _corsHeadersFor(String? origin) => {
  // Reflect a trusted loopback origin; fall back to `*` only when no browser
  // Origin is present (non-browser clients), never for a foreign site.
  'Access-Control-Allow-Origin': (origin == null || origin.isEmpty) ? '*' : origin,
  'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, x-api-key, anthropic-version',
  'Vary': 'Origin',
};

Middleware _cors() => (handler) => (req) async {
  final origin = req.headers['origin'];
  // Block cross-site browser callers (DNS-rebind / localhost CSRF). A malicious
  // page the user visits must not be able to drive or delete local models.
  if (origin != null && origin.isNotEmpty && !_isLocalhostOrigin(origin)) {
    return Response.forbidden(
      jsonEncode({'error': 'cross-origin requests are not allowed on the local gateway'}),
      headers: {'content-type': 'application/json'},
    );
  }
  if (req.method == 'OPTIONS') return Response.ok(null, headers: _corsHeadersFor(origin));
  final res = await handler(req);
  return res.change(headers: _corsHeadersFor(origin));
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
