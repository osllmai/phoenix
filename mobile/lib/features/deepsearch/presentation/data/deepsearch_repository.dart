import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import 'deepsearch_dto.dart';

final deepSearchRepositoryProvider = Provider<DeepSearchRepository>((ref) {
  return DeepSearchRepository(ref.watch(dioProvider));
});

class DeepSearchRepository {
  const DeepSearchRepository(this._dio);

  final Dio _dio;

  Future<int> startSearch(String query, String scope, String depth) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/deepsearch/',
      data: {'query': query, 'scope': scope, 'depth': depth},
    );
    return SearchStartedDto.fromJson(res.data!).id;
  }

  Future<SearchDetailDto> getRun(int id) async {
    final res = await _dio.get<Map<String, dynamic>>('/deepsearch/$id/');
    return SearchDetailDto.fromJson(res.data!);
  }

  Future<List<SearchListItemDto>> list() async {
    final res = await _dio.get<List<dynamic>>('/deepsearch/');
    return res.data!
        .map((e) => SearchListItemDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
