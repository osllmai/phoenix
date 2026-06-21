import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/core/network/api_client.dart';
import 'package:phoenix/features/models/data/hf_repository.dart';

class MockDio extends Mock implements Dio {}

Response<T> _resp<T>(T data) =>
    Response<T>(requestOptions: RequestOptions(path: ''), data: data);

final _searchFixture = <Map<String, dynamic>>[
  {
    'id': 'TheBloke/Llama-2-7B-GGUF',
    'downloads': 12345,
    'likes': 678,
    'pipeline_tag': 'text-generation',
    'tags': ['gguf', 'text-generation'],
  },
  {
    'id': 'noorg-model',
    'downloads': 5,
    'likes': 1,
  },
];

final _filesFixture = <String, dynamic>{
  'id': 'TheBloke/Llama-2-7B-GGUF',
  'siblings': [
    {'rfilename': 'README.md'},
    {'rfilename': 'llama-2-7b.Q4_K_M.gguf', 'size': 4_080_000_000},
    {'rfilename': 'subdir/llama-2-7b.BF16.gguf'},
  ],
};

void main() {
  late MockDio dio;

  setUp(() => dio = MockDio());

  test('search maps id to org/name and counts, leaves url empty', () async {
    when(() => dio.get<List<dynamic>>('$hfApi/models',
            queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => _resp<List<dynamic>>(_searchFixture));

    final repo = HfRepository(dio);
    final results = await repo.search('llama');

    expect(results, hasLength(2));
    final first = results.first;
    expect(first.org, 'TheBloke');
    expect(first.name, 'Llama-2-7B-GGUF');
    expect(first.downloadCount, 12345);
    expect(first.likeCount, 678);
    expect(first.capability, 'text-generation');
    expect(first.hfLink, 'https://huggingface.co/TheBloke/Llama-2-7B-GGUF');
    expect(first.url, isEmpty);
    expect(results[1].org, isEmpty);
    expect(results[1].name, 'noorg-model');
  });

  test('files filters to .gguf, builds resolve url and parses quant', () async {
    const repoId = 'TheBloke/Llama-2-7B-GGUF';
    when(() => dio.get<Map<String, dynamic>>('$hfApi/models/$repoId'))
        .thenAnswer((_) async => _resp<Map<String, dynamic>>(_filesFixture));

    final repo = HfRepository(dio);
    final files = await repo.files(repoId);

    expect(files, hasLength(2));
    final f = files.first;
    expect(f.filename, 'llama-2-7b.Q4_K_M.gguf');
    expect(f.url,
        'https://huggingface.co/$repoId/resolve/main/llama-2-7b.Q4_K_M.gguf');
    expect(f.quant, 'Q4_K_M');
    expect(f.filesizeGb, closeTo(4.08, 0.01));
    expect(f.md5sum, isEmpty);
    expect(files[1].filename, 'subdir/llama-2-7b.BF16.gguf'.split('/').last);
    expect(files[1].quant, 'BF16');
    expect(
      files[1].url,
      'https://huggingface.co/$repoId/resolve/main/subdir/llama-2-7b.BF16.gguf',
    );
  });

  test('hfSearchProvider resolves via overridden dio', () async {
    when(() => dio.get<List<dynamic>>('$hfApi/models',
            queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => _resp<List<dynamic>>(_searchFixture));
    final container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(dio)],
    );
    addTearDown(container.dispose);

    final results = await container.read(hfSearchProvider('llama').future);
    expect(results, hasLength(2));
  });
}
