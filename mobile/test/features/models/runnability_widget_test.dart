import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/features/models/data/catalog_entry.dart';
import 'package:phoenix/features/models/data/device_capabilities.dart';
import 'package:phoenix/features/models/data/download_progress.dart';
import 'package:phoenix/features/models/presentation/providers/catalog_download_controller.dart';
import 'package:phoenix/features/models/presentation/widgets/catalog_entry_action.dart';
import 'package:phoenix/features/models/presentation/widgets/catalog_entry_tile.dart';

import 'models_catalog_support.dart';

const _big = CatalogEntry(
  org: 'meta',
  modelName: 'llama-70b',
  name: 'Llama 70B',
  filename: 'big.gguf',
  url: 'https://example.com/big.gguf',
  filesizeGb: 40,
  ramRequired: 48,
  capability: 'text',
);

const _small = CatalogEntry(
  org: 'qwen',
  modelName: 'qwen2-small',
  name: 'Qwen2 Small',
  filename: 'small.gguf',
  url: 'https://example.com/small.gguf',
  filesizeGb: 0.9,
  ramRequired: 4,
  capability: 'text',
);

Future<MockModelDownloader> _pump(
  WidgetTester tester,
  Widget child,
  double ramGb,
) async {
  final downloader = MockModelDownloader();
  when(() => downloader.download(any()))
      .thenAnswer((_) => const Stream<DownloadProgress>.empty());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        modelDownloaderProvider.overrideWithValue(downloader),
        deviceRamGbProvider.overrideWith((ref) async => ramGb),
      ],
      child: MaterialApp(home: Scaffold(body: child)),
    ),
  );
  await tester.pumpAndSettle();
  return downloader;
}

void main() {
  setUpAll(() => registerFallbackValue(qwenEntry));

  testWidgets('tile shows green runs label when device has ample RAM',
      (tester) async {
    await _pump(tester, const CatalogEntryTile(entry: _small, wide: true), 32);
    expect(find.text('✓ Runs'), findsOneWidget);
  });

  testWidgets('tile shows too-large label when device is too small',
      (tester) async {
    await _pump(tester, const CatalogEntryTile(entry: _big, wide: true), 8);
    expect(find.textContaining('Too large'), findsOneWidget);
  });

  testWidgets('download guard shows dialog for a too-large model',
      (tester) async {
    final downloader =
        await _pump(tester, const CatalogEntryAction(entry: _big), 8);
    await tester.tap(find.text('Download'));
    await tester.pumpAndSettle();
    expect(find.text('Download anyway'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    verifyNever(() => downloader.download(any()));
  });

  testWidgets('runnable model downloads immediately without a dialog',
      (tester) async {
    final downloader =
        await _pump(tester, const CatalogEntryAction(entry: _small), 32);
    await tester.tap(find.text('Download'));
    await tester.pumpAndSettle();
    expect(find.text('Download anyway'), findsNothing);
    verify(() => downloader.download(any())).called(1);
  });
}
