import 'dart:convert';

import 'package:shelf/shelf.dart';

/// Paths that answer without a key: liveness probes and CORS preflight.
const _openPaths = {'/health'};

/// Requires a shared key on every gateway call when [expectedKey] is set.
///
/// Loopback binding and loopback-only CORS stop *browsers* on other origins,
/// but any local process can still reach the socket — this is what stops it.
/// A null/empty key leaves the gateway open, which keeps existing local setups
/// working; enabling it is opt-in via `PHOENIX_GATEWAY_API_KEY`.
Middleware requireApiKey(String? expectedKey) {
  final key = expectedKey?.trim() ?? '';
  if (key.isEmpty) return (handler) => handler;

  return (Handler inner) => (Request req) async {
    if (req.method == 'OPTIONS' || _openPaths.contains(req.requestedUri.path)) {
      return inner(req);
    }
    return _presentedKey(req) == key ? inner(req) : _unauthorized();
  };
}

/// Accepts both house styles: OpenAI's `Authorization: Bearer …` and
/// Anthropic's `x-api-key`, so either SDK works unchanged.
String? _presentedKey(Request req) {
  final apiKey = req.headers['x-api-key'];
  if (apiKey != null && apiKey.isNotEmpty) return apiKey.trim();

  final auth = req.headers['authorization'];
  if (auth == null) return null;
  final parts = auth.split(' ');
  if (parts.length == 2 && parts.first.toLowerCase() == 'bearer') return parts.last.trim();
  return null;
}

Response _unauthorized() => Response.unauthorized(
  jsonEncode({
    'error': {'type': 'authentication_error', 'message': 'Invalid or missing API key.'},
  }),
  headers: {'content-type': 'application/json'},
);
