import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/features/models/data/download_progress.dart';
import 'package:phoenix/features/models/data/remote_catalog_repository.dart';
import 'package:phoenix/features/models/presentation/providers/catalog_download_controller.dart';
import 'package:phoenix/features/models/presentation/screens/models_browse_screen.dart';
import 'package:phoenix/features/models/presentation/widgets/catalog_entry_tile.dart';

import 'models_catalog_support.dart';

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  final downloader = MockModelDownloader();
  when(() => downloader.download(any()))
      .thenAnswer((_) => const Stream<DownloadProgress>.empty());
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        remoteCatalogProvider.overrideWith((ref) async => sampleRemoteList),
        modelDownloaderProvider.overrideWithValue(downloader),
      ],
      child: const MaterialApp(home: ModelsBrowseScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => registerFallbackValue(qwenEntry));

  for (final size in [
    const Size(400, 800),
    const Size(800, 800),
    const Size(1280, 800),
  ]) {
    testWidgets('${size.width.toInt()}x${size.height.toInt()}: '
        'browse renders catalog without overflow', (tester) async {
      await _pumpAt(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byType(CatalogEntryTile), findsNWidgets(2));
      expect(find.text('Qwen2-1.5B-Instruct'), findsOneWidget);
      expect(find.text('2 models'), findsOneWidget);
      expect(find.text('Download'), findsNWidgets(2));
    });
  }
}
