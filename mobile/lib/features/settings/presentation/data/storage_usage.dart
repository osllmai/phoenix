import 'package:path_provider/path_provider.dart';
import 'package:phoenix_core/phoenix_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/presentation/providers/model_providers.dart';

part 'storage_usage.g.dart';

/// Real on-device storage breakdown + total.
class StorageUsage {
  const StorageUsage(this.entries, this.total);
  final List<StorageEntry> entries;
  final int total;
}

/// Computes actual usage: installed model files + app data (DB/settings) + cache.
@riverpod
Future<StorageUsage> storageUsage(Ref ref) async {
  const svc = StorageService();
  final support = await getApplicationSupportDirectory();
  final cache = await getApplicationCacheDirectory();
  final models = await ref.watch(modelRepositoryProvider).all();

  final modelBytes =
      await svc.sizeOfFiles(models.map((m) => m.key).whereType<String>());
  final appData = await svc.sizeOfDirectory(support);
  final cacheBytes = await svc.sizeOfDirectory(cache);

  final entries = [
    StorageEntry('Models', modelBytes),
    StorageEntry('App data', appData),
    StorageEntry('Cache', cacheBytes),
  ];
  return StorageUsage(entries, entries.fold(0, (sum, e) => sum + e.bytes));
}

/// Deletes the app cache directory's contents; returns bytes actually freed.
/// The caller invalidates [storageUsageProvider] from a live ref to refresh.
@riverpod
class CacheCleaner extends _$CacheCleaner {
  @override
  void build() {}

  Future<int> clear() async {
    final cache = await getApplicationCacheDirectory();
    return const StorageService().clearDirectory(cache);
  }
}
