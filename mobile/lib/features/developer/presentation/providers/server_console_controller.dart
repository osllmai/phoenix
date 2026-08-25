import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/env.dart';
import 'server_console_state.dart';

part 'server_console_controller.g.dart';

List<ServerStat> get _sampleStats => <ServerStat>[
  ServerStat(label: 'Bind address', value: '127.0.0.1:$gatewayPort', hint: 'loopback only'),
  ServerStat(label: 'Uptime', value: '2h 14m', hint: 'since 10:03 AM'),
  ServerStat(label: 'Requests', value: '312', hint: '0 errors · 99.7% 2xx'),
  ServerStat(label: 'Throughput', value: '43 tok/s', hint: 'avg last 10 req'),
];

List<ServerEndpoint> get _sampleEndpoints => <ServerEndpoint>[
  ServerEndpoint(kind: 'OpenAI', url: 'http://$gatewayHostPort/v1/chat/completions'),
  ServerEndpoint(kind: 'OpenAI', url: 'http://$gatewayHostPort/v1/models'),
  ServerEndpoint(kind: 'Anthropic', url: 'http://$gatewayHostPort/v1/messages'),
];

const _sampleLog = <RequestLogEntry>[
  RequestLogEntry(time: '12:17:04', method: 'POST', path: '/v1/chat/completions', model: 'Llama-3.1-8B', status: 200, latency: '0.38 s'),
  RequestLogEntry(time: '12:16:58', method: 'POST', path: '/v1/messages', model: 'Qwen2.5-14B', status: 200, latency: '2.04 s'),
  RequestLogEntry(time: '12:16:40', method: 'GET', path: '/v1/models', model: '—', status: 200, latency: '0.01 s'),
  RequestLogEntry(time: '12:16:33', method: 'POST', path: '/v1/chat/completions', model: 'Llama-3.1-8B', status: 429, latency: '— queued'),
  RequestLogEntry(time: '12:16:09', method: 'POST', path: '/v1/chat/completions', model: 'Llama-3.1-8B', status: 200, latency: '0.41 s'),
  RequestLogEntry(time: '12:15:52', method: 'POST', path: '/v1/messages', model: '—', status: 401, latency: '0.00 s'),
];

@riverpod
class ServerConsoleController extends _$ServerConsoleController {
  @override
  ServerConsoleState build() => ServerConsoleState(
        stats: _sampleStats,
        endpoints: _sampleEndpoints,
        log: _sampleLog,
      );

  void toggleLogLive() => state = state.copyWith(logLive: !state.logLive);
}
