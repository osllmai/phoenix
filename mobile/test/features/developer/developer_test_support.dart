import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/features/developer/presentation/data/server_health.dart';
import 'package:phoenix/features/developer/presentation/data/server_status_repository.dart';

class MockServerStatusRepository extends Mock
    implements ServerStatusRepository {}

ServerStatusRepository reachableRepository({String service = 'phoenix-backend'}) {
  final repo = MockServerStatusRepository();
  when(repo.health).thenAnswer(
    (_) async => ServerHealth(reachable: true, service: service),
  );
  return repo;
}

ServerStatusRepository unreachableRepository() {
  final repo = MockServerStatusRepository();
  when(repo.health).thenAnswer(
    (_) async =>
        throw DioException(requestOptions: RequestOptions(path: '/health/')),
  );
  return repo;
}
