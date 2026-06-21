import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_client.dart';
import 'catalog_entry.dart';
import 'catalog_repository.dart';

part 'remote_catalog_repository.g.dart';

const catalogUrl = String.fromEnvironment(
  'PHOENIX_CATALOG_URL',
  defaultValue: 'https://local-ai-zone.github.io/gguf_models.json',
);

const _bundledCatalogAsset = 'assets/catalog/gguf_models.json';

String _basename(String url) {
  final clean = url.split('?').first.split('#').first;
  final slash = clean.lastIndexOf('/');
  return slash < 0 ? clean : clean.substring(slash + 1);
}

CatalogEntry mapRemoteEntry(Map<String, dynamic> json) {
  final link = json['directDownloadLink'] as String? ?? '';
  return CatalogEntry(
    org: json['modelSource'] as String? ?? '',
    modelName: json['modelName'] as String? ?? '',
    name: json['modelName'] as String? ?? '',
    filename: _basename(link),
    url: link,
    filesizeGb: ((json['fileSize'] as num?)?.toDouble() ?? 0) / 1e9,
    quant: json['quantFormat'] as String? ?? '',
    ramRequired: (json['minRamGB'] as num?)?.toInt() ?? 0,
    type: json['modelType'] as String? ?? '',
    downloadCount: (json['downloadCount'] as num?)?.toInt() ?? 0,
    likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
    capability: json['modelCapability'] as String? ?? '',
    hfLink: json['huggingFaceLink'] as String? ?? '',
    license: json['license'] as String? ?? '',
    gpuRequired: json['gpuRequired'] as bool? ?? false,
    uploadDate: json['uploadDate'] as String? ?? '',
  );
}

Future<List<CatalogEntry>> _loadBundledCatalog() async {
  final raw = await rootBundle.loadString(_bundledCatalogAsset);
  final data = jsonDecode(raw) as List<dynamic>;
  return data.map((e) => mapRemoteEntry(e as Map<String, dynamic>)).toList();
}

@Riverpod(keepAlive: true)
Future<List<CatalogEntry>> remoteCatalog(Ref ref) async {
  try {
    final res = await ref.watch(dioProvider).get<List<dynamic>>(catalogUrl);
    final data = res.data ?? const <dynamic>[];
    return data.map((e) => mapRemoteEntry(e as Map<String, dynamic>)).toList();
  } catch (_) {
    try {
      return await _loadBundledCatalog();
    } catch (_) {
      final byOrg = await ref.watch(modelCatalogProvider.future);
      return [for (final list in byOrg.values) ...list];
    }
  }
}
