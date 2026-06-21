import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:phoenix_core/phoenix_core.dart';

import '../../data/catalog_entry.dart';
import '../../data/download_progress.dart';
import '../../data/model_downloader.dart';
import 'models_controller.dart';

part 'catalog_download_controller.g.dart';

@riverpod
ModelDownloader modelDownloader(Ref ref) => const BgModelDownloader();

@riverpod
class CatalogDownloadController extends _$CatalogDownloadController {
  final _subs = <String, StreamSubscription<DownloadProgress>>{};

  @override
  Map<String, DownloadProgress> build() {
    ref.onDispose(() {
      for (final s in _subs.values) {
        s.cancel();
      }
    });
    return const {};
  }

  DownloadProgress? progressFor(String filename) => state[filename];

  void start(CatalogEntry entry) {
    if (_subs.containsKey(entry.filename)) return;
    final stream = ref.read(modelDownloaderProvider).download(entry);
    _subs[entry.filename] = stream.listen(
      (p) => _onProgress(entry, p),
      onError: (Object e) => _set(entry.filename,
          DownloadProgress(phase: DownloadPhase.failed, error: '$e')),
    );
  }

  void cancel(String filename) {
    _subs.remove(filename)?.cancel();
    final next = {...state}..remove(filename);
    state = next;
  }

  Future<void> _onProgress(CatalogEntry entry, DownloadProgress p) async {
    _set(entry.filename, p);
    if (p.phase == DownloadPhase.done && p.path != null) {
      await ref
          .read(modelsControllerProvider.notifier)
          .addLocal(name: entry.name, path: p.path!);
      ref.invalidate(modelsControllerProvider);
    }
    if (p.phase == DownloadPhase.done || p.phase == DownloadPhase.failed) {
      _subs.remove(entry.filename)?.cancel();
    }
  }

  void _set(String filename, DownloadProgress p) {
    state = {...state, filename: p};
  }
}

@riverpod
bool entryInstalled(Ref ref, CatalogEntry entry) {
  final models = ref.watch(modelsControllerProvider).value ?? const <AiModel>[];
  for (final m in models) {
    if (m.name == entry.name) return true;
    final key = m.key ?? '';
    if (key.isNotEmpty &&
        (key.endsWith('/${entry.filename}') || key == entry.filename)) {
      return true;
    }
  }
  return false;
}
