import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/core/network/api_client.dart';
import 'package:phoenix/features/models/data/remote_catalog_repository.dart';

class MockDio extends Mock implements Dio {}

final _fixture = <Map<String, dynamic>>[
  {
    'modelName': 'Qwen2 1.5B Instruct',
    'modelSource': 'Qwen',
    'quantFormat': 'Q4_0',
    'fileSize': 930000000,
    'modelType': 'text',
    'modelCapability': 'chat',
    'license': 'apache-2.0',
    'downloadCount': 5000,
    'likeCount': 120,
    'huggingFaceLink': 'https://huggingface.co/Qwen/Qwen2-1.5B',
    'directDownloadLink':
        'https://huggingface.co/Qwen/Qwen2-1.5B/resolve/main/qwen2.gguf',
    'minRamGB': 4,
  },
  {
    'modelName': 'Llama 3 8B',
    'modelSource': 'meta-llama',
    'quantFormat': 'Q4_K_M',
    'fileSize': 4700000000,
    'downloadCount': 99000,
    'likeCount': 800,
    'huggingFaceLink': 'https://huggingface.co/meta-llama/Llama-3-8B',
    'directDownloadLink':
        'https://huggingface.co/meta-llama/Llama-3-8B/resolve/main/llama3.gguf',
    'minRamGB': 8,
  },
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('maps remote json objects to CatalogEntry', () async {
    final dio = MockDio();
    when(() => dio.get<List<dynamic>>(catalogUrl)).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: catalogUrl),
        data: _fixture,
      ),
    );
    final container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(dio)],
    );
    addTearDown(container.dispose);

    final entries = await container.read(remoteCatalogProvider.future);

    expect(entries, hasLength(2));
    final qwen = entries.first;
    expect(qwen.name, 'Qwen2 1.5B Instruct');
    expect(qwen.org, 'Qwen');
    expect(qwen.url, contains('/resolve/main/qwen2.gguf'));
    expect(qwen.filename, 'qwen2.gguf');
    expect(qwen.downloadCount, 5000);
    expect(qwen.likeCount, 120);
    expect(qwen.capability, 'chat');
    expect(qwen.hfLink, contains('huggingface.co'));
    expect(qwen.filesizeGb, closeTo(0.93, 0.001));
    expect(qwen.ramRequired, 4);
  });

  test('falls back to bundled gguf asset on fetch error', () async {
    final dio = MockDio();
    when(() => dio.get<List<dynamic>>(catalogUrl))
        .thenThrow(DioException(requestOptions: RequestOptions(path: '')));
    final container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(dio)],
    );
    addTearDown(container.dispose);

    final entries = await container.read(remoteCatalogProvider.future);

    expect(entries.length, greaterThan(1000));
    expect(entries.first.hfLink, contains('huggingface.co'));
  });
}
