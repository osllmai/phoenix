import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:crypto/crypto.dart';

import 'catalog_entry.dart';
import 'download_progress.dart';

const modelsSubdir = 'models';

abstract class ModelDownloader {
  Stream<DownloadProgress> download(CatalogEntry entry);
}

class BgModelDownloader implements ModelDownloader {
  const BgModelDownloader();

  @override
  Stream<DownloadProgress> download(CatalogEntry entry) async* {
    final controller = StreamController<DownloadProgress>();
    final task = DownloadTask(
      url: entry.url,
      filename: entry.filename,
      baseDirectory: BaseDirectory.applicationSupport,
      directory: modelsSubdir,
      updates: Updates.statusAndProgress,
    );

    unawaited(_run(task, entry, controller));
    yield* controller.stream;
  }

  Future<void> _run(
    DownloadTask task,
    CatalogEntry entry,
    StreamController<DownloadProgress> out,
  ) async {
    try {
      final result = await FileDownloader().download(
        task,
        onProgress: (p) => out.add(
          DownloadProgress(
            phase: DownloadPhase.downloading,
            fraction: p.clamp(0.0, 1.0),
          ),
        ),
      );
      if (result.status != TaskStatus.complete) {
        out.add(DownloadProgress(
          phase: DownloadPhase.failed,
          error: result.exception?.description ?? result.status.name,
        ));
        return;
      }
      final path = await task.filePath();
      out.add(const DownloadProgress(
        phase: DownloadPhase.verifying,
        fraction: 1.0,
      ));
      if (!await _verify(path, entry.md5sum)) {
        await File(path).delete().catchError((_) => File(path));
        out.add(const DownloadProgress(
          phase: DownloadPhase.failed,
          error: 'Checksum mismatch',
        ));
        return;
      }
      out.add(DownloadProgress(
        phase: DownloadPhase.done,
        fraction: 1.0,
        path: path,
      ));
    } catch (e) {
      out.add(DownloadProgress(phase: DownloadPhase.failed, error: '$e'));
    } finally {
      await out.close();
    }
  }

  Future<bool> _verify(String path, String md5sum) async {
    if (md5sum.isEmpty) return true;
    final digest = await md5.bind(File(path).openRead()).first;
    return digest.toString() == md5sum.toLowerCase();
  }
}
