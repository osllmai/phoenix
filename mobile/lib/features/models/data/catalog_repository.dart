import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'catalog_entry.dart';

part 'catalog_repository.g.dart';

const _offlineDir = 'assets/catalog/offline_models/';

class CatalogRepository {
  CatalogRepository(this._bundle);

  final AssetBundle _bundle;

  Future<Map<String, List<CatalogEntry>>> loadByOrg() async {
    final manifest = await AssetManifest.loadFromAssetBundle(_bundle);
    final files = manifest
        .listAssets()
        .where((a) => a.startsWith(_offlineDir) && a.endsWith('.json'))
        .toList()
      ..sort();
    final result = <String, List<CatalogEntry>>{};
    for (final asset in files) {
      final org = asset
          .substring(_offlineDir.length, asset.length - '.json'.length);
      final raw = await _bundle.loadString(asset);
      final decoded = jsonDecode(raw) as List<dynamic>;
      final entries = decoded
          .map((e) => CatalogEntry.fromJson(org, e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));
      if (entries.isNotEmpty) result[org] = entries;
    }
    return result;
  }
}

@riverpod
CatalogRepository catalogRepository(Ref ref) =>
    CatalogRepository(rootBundle);

@riverpod
Future<Map<String, List<CatalogEntry>>> modelCatalog(Ref ref) =>
    ref.watch(catalogRepositoryProvider).loadByOrg();
