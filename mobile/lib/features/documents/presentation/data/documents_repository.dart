import 'package:dio/dio.dart';

import '../providers/document.dart';
import 'document_dto.dart';
import 'document_mapper.dart';

class DocumentsRepository {
  const DocumentsRepository(this._dio);

  final Dio _dio;

  Future<List<PhoenixDocument>> list() async {
    final res = await _dio.get<List<dynamic>>('/documents/');
    final data = res.data ?? const [];
    return data
        .map((e) => DocumentListItemDto.fromJson(e as Map<String, dynamic>))
        .map(fromListItem)
        .toList();
  }

  Future<PhoenixDocument> detail(String id) async {
    final res = await _dio.get<Map<String, dynamic>>('/documents/$id/');
    return fromDetail(DocumentDetailDto.fromJson(res.data!));
  }

  Future<DocumentCreatedDto> create({
    required String title,
    required String sourcePath,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/documents/',
      data: {'title': title, 'source_path': sourcePath},
    );
    return DocumentCreatedDto.fromJson(res.data!);
  }

  Future<void> delete(String id) async {
    await _dio.delete<void>('/documents/$id/');
  }
}
