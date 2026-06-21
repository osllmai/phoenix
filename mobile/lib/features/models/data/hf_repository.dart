import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import 'catalog_entry.dart';

part 'hf_repository.g.dart';

const hfApi = String.fromEnvironment(
  'PHOENIX_HF_API',
  defaultValue: 'https://huggingface.co/api',
);

final _quantRe = RegExp(
  r'(Q\d+_K_[A-Z0-9]+|Q\d+_K|Q\d+_\d+|IQ\d+_[A-Z0-9]+|BF16|F16|F32|FP16)',
  caseSensitive: false,
);

String _quantFromName(String filename) =>
    _quantRe.firstMatch(filename)?.group(0)?.toUpperCase() ?? '';

class HfRepository {
  HfRepository(this._dio);

  final Dio _dio;

  Future<List<CatalogEntry>> search(String query) async {
    final res = await _dio.get<List<dynamic>>(
      '$hfApi/models',
      queryParameters: {
        'filter': 'gguf',
        'sort': 'downloads',
        'direction': -1,
        'limit': 50,
        'search': query,
      },
    );
    final data = res.data ?? const <dynamic>[];
    return data
        .map((e) => _mapListing(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<List<CatalogEntry>> files(String repoId) async {
    final res = await _dio.get<Map<String, dynamic>>('$hfApi/models/$repoId');
    final json = res.data ?? const <String, dynamic>{};
    final siblings = (json['siblings'] as List<dynamic>?) ?? const [];
    final out = <CatalogEntry>[];
    final parts = repoId.split('/');
    final org = parts.length > 1 ? parts.first : '';
    final repoName = parts.length > 1 ? parts.sublist(1).join('/') : repoId;
    for (final s in siblings) {
      final r = (s as Map<String, dynamic>)['rfilename'] as String? ?? '';
      if (!r.toLowerCase().endsWith('.gguf')) continue;
      final size = (s['size'] as num?)?.toDouble();
      out.add(CatalogEntry(
        org: org,
        modelName: repoName,
        name: r.split('/').last,
        filename: r.split('/').last,
        url: 'https://huggingface.co/$repoId/resolve/main/$r',
        filesizeGb: size == null ? 0.0 : size / 1e9,
        quant: _quantFromName(r),
        hfLink: 'https://huggingface.co/$repoId',
        md5sum: '',
      ));
    }
    return out;
  }

  CatalogEntry _mapListing(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? '';
    final slash = id.indexOf('/');
    final org = slash < 0 ? '' : id.substring(0, slash);
    final name = slash < 0 ? id : id.substring(slash + 1);
    final tags = (json['tags'] as List<dynamic>?)?.cast<String>() ?? const [];
    final pipeline = json['pipeline_tag'] as String? ?? '';
    return CatalogEntry(
      org: org,
      modelName: name,
      name: name,
      filename: '',
      url: '',
      downloadCount: (json['downloads'] as num?)?.toInt() ?? 0,
      likeCount: (json['likes'] as num?)?.toInt() ?? 0,
      hfLink: 'https://huggingface.co/$id',
      capability: pipeline.isNotEmpty ? pipeline : '',
      type: tags.contains('text-generation') ? 'text-generation' : '',
    );
  }
}

@riverpod
HfRepository hfRepository(Ref ref) => HfRepository(ref.watch(dioProvider));

@riverpod
Future<List<CatalogEntry>> hfSearch(Ref ref, String query) =>
    ref.watch(hfRepositoryProvider).search(query);

@riverpod
Future<List<CatalogEntry>> hfModelFiles(Ref ref, String repoId) =>
    ref.watch(hfRepositoryProvider).files(repoId);
