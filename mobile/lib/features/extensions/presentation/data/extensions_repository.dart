import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_client.dart';
import '../providers/extension_entry.dart';

part 'extensions_repository.g.dart';

@riverpod
ExtensionsRepository extensionsRepository(Ref ref) {
  return ExtensionsRepository(ref.watch(dioProvider));
}

class ExtensionsRepository {
  ExtensionsRepository(this._dio);

  final Dio _dio;

  Future<List<ExtensionEntry>> list({String? category, String? query}) async {
    final res = await _dio.get<List<dynamic>>(
      '/extensions/',
      queryParameters: <String, dynamic>{
        'category': ?category,
        if (query != null && query.isNotEmpty) 'q': query,
      },
    );
    final data = res.data ?? const <dynamic>[];
    return data
        .map((e) => ExtensionEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ExtensionEntry> detail(String slug) async {
    final res = await _dio.get<Map<String, dynamic>>('/extensions/$slug/');
    return ExtensionEntry.fromJson(res.data!);
  }

  Future<ExtensionEntry> install(String slug) async {
    final res =
        await _dio.post<Map<String, dynamic>>('/extensions/$slug/install/');
    return ExtensionEntry.fromJson(res.data!);
  }

  Future<ExtensionEntry> uninstall(String slug) async {
    final res =
        await _dio.post<Map<String, dynamic>>('/extensions/$slug/uninstall/');
    return ExtensionEntry.fromJson(res.data!);
  }
}
