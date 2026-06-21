import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_client.dart';
import 'server_health.dart';

part 'server_status_repository.g.dart';

@riverpod
ServerStatusRepository serverStatusRepository(Ref ref) =>
    ServerStatusRepository(ref.watch(dioProvider));

class ServerStatusRepository {
  ServerStatusRepository(this._dio);

  final Dio _dio;

  Future<ServerHealth> health() async {
    final res = await _dio.get<Map<String, dynamic>>('/health/');
    return ServerHealth.fromJson(res.data ?? const <String, dynamic>{});
  }
}
