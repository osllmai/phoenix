import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/features/documents/presentation/data/documents_repository.dart';
import 'package:phoenix/features/documents/presentation/providers/document.dart';

class _MockDio extends Mock implements Dio {}

Response<T> _resp<T>(T data, String path) => Response<T>(
      data: data,
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
    );

void main() {
  late _MockDio dio;
  late DocumentsRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = DocumentsRepository(dio);
  });

  test('list maps API json to PhoenixDocument', () async {
    when(() => dio.get<List<dynamic>>('/documents/')).thenAnswer(
      (_) async => _resp<List<dynamic>>([
        {
          'id': 7,
          'title': 'report.pdf',
          'status': 'ready',
          'created_at': '2026-06-09T10:00:00Z',
        },
      ], '/documents/'),
    );

    final docs = await repo.list();

    expect(docs, hasLength(1));
    expect(docs.first.id, '7');
    expect(docs.first.title, 'report.pdf');
    expect(docs.first.kind, DocKind.pdf);
    expect(docs.first.status, DocStatus.converted);
  });

  test('list propagates a DioException', () async {
    when(() => dio.get<List<dynamic>>('/documents/')).thenThrow(
      DioException(requestOptions: RequestOptions(path: '/documents/')),
    );

    expect(repo.list(), throwsA(isA<DioException>()));
  });

  test('detail maps markdown body', () async {
    when(() => dio.get<Map<String, dynamic>>('/documents/7/')).thenAnswer(
      (_) async => _resp<Map<String, dynamic>>({
        'id': 7,
        'title': 'report.pdf',
        'status': 'ready',
        'created_at': '2026-06-09T10:00:00Z',
        'markdown': '## Body',
        'error': '',
      }, '/documents/7/'),
    );

    final doc = await repo.detail('7');

    expect(doc.id, '7');
    expect(doc.markdown, '## Body');
  });

  test('create posts title + source_path and parses job_id', () async {
    when(() => dio.post<Map<String, dynamic>>(
          '/documents/',
          data: any(named: 'data'),
        )).thenAnswer(
      (_) async => _resp<Map<String, dynamic>>({
        'id': 9,
        'title': 'new.pdf',
        'status': 'pending',
        'job_id': 'job-123',
      }, '/documents/'),
    );

    final created = await repo.create(title: 'new.pdf', sourcePath: '/tmp/x');

    expect(created.id, 9);
    expect(created.jobId, 'job-123');
  });
}
