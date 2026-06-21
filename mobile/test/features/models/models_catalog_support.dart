import 'package:mocktail/mocktail.dart';
import 'package:phoenix/features/models/data/catalog_entry.dart';
import 'package:phoenix/features/models/data/download_progress.dart';
import 'package:phoenix/features/models/data/model_downloader.dart';

class MockModelDownloader extends Mock implements ModelDownloader {}

const qwenEntry = CatalogEntry(
  org: 'qwen',
  modelName: 'qwen2-1_5b-instruct-q4_0',
  name: 'Qwen2-1.5B-Instruct',
  filename: 'qwen2-1_5b-instruct-q4_0.gguf',
  url: 'https://huggingface.co/example/model.gguf',
  filesizeGb: 0.93,
  quant: 'q4_0',
  ramRequired: 4,
  recommended: true,
  md5sum: 'a8c5a783105f87a481543d4ed7d7586d',
);

const metaEntry = CatalogEntry(
  org: 'meta',
  modelName: 'llama-3-8b',
  name: 'Llama 3 8B',
  filename: 'llama-3-8b.gguf',
  url: 'https://example.com/llama.gguf',
  filesizeGb: 4.7,
  quant: 'q4_k_m',
  ramRequired: 8,
);

const sampleCatalog = <String, List<CatalogEntry>>{
  'meta': [metaEntry],
  'qwen': [qwenEntry],
};

const sampleRemoteList = <CatalogEntry>[
  metaEntry,
  qwenEntry,
];

Stream<DownloadProgress> downloadSuccess(String path) async* {
  yield const DownloadProgress(
      phase: DownloadPhase.downloading, fraction: 0.5);
  yield const DownloadProgress(phase: DownloadPhase.verifying, fraction: 1.0);
  yield DownloadProgress(phase: DownloadPhase.done, fraction: 1.0, path: path);
}

Stream<DownloadProgress> downloadFailure() async* {
  yield const DownloadProgress(
      phase: DownloadPhase.downloading, fraction: 0.9);
  yield const DownloadProgress(
      phase: DownloadPhase.failed, error: 'Checksum mismatch');
}
