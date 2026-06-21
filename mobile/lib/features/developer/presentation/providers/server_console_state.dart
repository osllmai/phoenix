import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_console_state.freezed.dart';

@freezed
abstract class ServerStat with _$ServerStat {
  const factory ServerStat({
    required String label,
    required String value,
    @Default('') String hint,
  }) = _ServerStat;
}

@freezed
abstract class ServerEndpoint with _$ServerEndpoint {
  const factory ServerEndpoint({
    required String kind,
    required String url,
  }) = _ServerEndpoint;
}

@freezed
abstract class RequestLogEntry with _$RequestLogEntry {
  const factory RequestLogEntry({
    required String time,
    required String method,
    required String path,
    required String model,
    required int status,
    required String latency,
  }) = _RequestLogEntry;
}

@freezed
abstract class ServerConsoleState with _$ServerConsoleState {
  const factory ServerConsoleState({
    @Default(<ServerStat>[]) List<ServerStat> stats,
    @Default(<ServerEndpoint>[]) List<ServerEndpoint> endpoints,
    @Default(<RequestLogEntry>[]) List<RequestLogEntry> log,
    @Default(true) bool logLive,
  }) = _ServerConsoleState;
}
