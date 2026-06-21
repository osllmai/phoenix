import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/features/models/data/download_progress.dart';
import 'package:phoenix/features/models/presentation/providers/catalog_download_controller.dart';
import 'package:phoenix/features/models/presentation/providers/model_providers.dart';

import 'models_catalog_support.dart';

ProviderContainer _container(MockModelDownloader downloader) {
  final c = ProviderContainer(
    overrides: [modelDownloaderProvider.overrideWithValue(downloader)],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  setUpAll(() {
    registerFallbackValue(qwenEntry);
  });

  test('done → addLocal called and entry becomes installed', () async {
    final downloader = MockModelDownloader();
    when(() => downloader.download(any()))
        .thenAnswer((_) => downloadSuccess('/tmp/models/${qwenEntry.filename}'));
    final c = _container(downloader);

    c.listen(catalogDownloadControllerProvider, (_, _) {});
    await c.read(modelsControllerProvider.future);
    c.read(catalogDownloadControllerProvider.notifier).start(qwenEntry);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await c.read(modelsControllerProvider.future);

    final models = await c.read(modelManagerProvider).list();
    expect(models.any((m) => m.name == qwenEntry.name), isTrue);
    expect(models.single.key, '/tmp/models/${qwenEntry.filename}');
    expect(c.read(entryInstalledProvider(qwenEntry)), isTrue);

    final progress = c.read(catalogDownloadControllerProvider)[qwenEntry.filename];
    expect(progress?.phase, DownloadPhase.done);
  });

  test('md5 mismatch → state failed, nothing installed', () async {
    final downloader = MockModelDownloader();
    when(() => downloader.download(any()))
        .thenAnswer((_) => downloadFailure());
    final c = _container(downloader);

    c.listen(catalogDownloadControllerProvider, (_, _) {});
    await c.read(modelsControllerProvider.future);
    c.read(catalogDownloadControllerProvider.notifier).start(qwenEntry);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final progress = c.read(catalogDownloadControllerProvider)[qwenEntry.filename];
    expect(progress?.phase, DownloadPhase.failed);
    expect(progress?.error, 'Checksum mismatch');
    expect(c.read(entryInstalledProvider(qwenEntry)), isFalse);
  });

  test('cancel removes the entry from download state', () async {
    final downloader = MockModelDownloader();
    when(() => downloader.download(any())).thenAnswer(
      (_) => Stream<DownloadProgress>.fromIterable(const [
        DownloadProgress(phase: DownloadPhase.downloading, fraction: 0.3),
      ]),
    );
    final c = _container(downloader);
    c.listen(catalogDownloadControllerProvider, (_, _) {});
    await c.read(modelsControllerProvider.future);
    c.read(catalogDownloadControllerProvider.notifier)
      ..start(qwenEntry)
      ..cancel(qwenEntry.filename);
    expect(
      c.read(catalogDownloadControllerProvider)[qwenEntry.filename],
      isNull,
    );
  });
}
