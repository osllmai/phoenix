import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/features/developer/presentation/data/server_status_repository.dart';

class _MockDio extends Mock implements Dio {}

Response<T> _resp<T>(T data) => Response<T>(
      data: data,
      requestOptions: RequestOptions(path: '/health/'),
      statusCode: 200,
    );

void main() {
  late _MockDio dio;
  late ServerStatusRepository repo;

  setUp(() {
    dio = _MockDio();
    repo = ServerStatusRepository(dio);
  });

  test('health maps ok payload to reachable', () async {
    when(() => dio.get<Map<String, dynamic>>('/health/')).thenAnswer(
      (_) async => _resp<Map<String, dynamic>>(
        {'status': 'ok', 'service': 'phoenix-backend'},
      ),
    );

    final health = await repo.health();

    expect(health.reachable, isTrue);
    expect(health.service, 'phoenix-backend');
  });

  test('health propagates a DioException when the backend is down', () async {
    when(() => dio.get<Map<String, dynamic>>('/health/')).thenThrow(
      DioException(requestOptions: RequestOptions(path: '/health/')),
    );

    expect(repo.health(), throwsA(isA<DioException>()));
  });
}
