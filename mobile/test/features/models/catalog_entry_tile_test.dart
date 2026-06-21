import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/features/models/data/catalog_entry.dart';
import 'package:phoenix/features/models/data/download_progress.dart';
import 'package:phoenix/features/models/presentation/providers/catalog_download_controller.dart';
import 'package:phoenix/features/models/presentation/widgets/catalog_entry_badges.dart';
import 'package:phoenix/features/models/presentation/widgets/catalog_entry_tile.dart';

import 'models_catalog_support.dart';

const _vision = CatalogEntry(
  org: 'meta',
  modelName: 'llava',
  name: 'LLaVA 7B',
  filename: 'llava.gguf',
  url: 'u',
  filesizeGb: 4.2,
  quant: 'q4_0',
  ramRequired: 8,
  capability: 'vision',
  license: 'Apache-2.0',
  downloadCount: 2200000,
  likeCount: 704000,
  gpuRequired: true,
);

Color _badgeColor(WidgetTester tester) {
  final box = tester.widget<Container>(
    find.ancestor(
      of: find.text('vision'),
      matching: find.byType(Container),
    ).first,
  );
  return ((box.decoration as BoxDecoration).color)!;
}

Future<void> _pump(WidgetTester tester, CatalogEntry entry) async {
  final downloader = MockModelDownloader();
  when(() => downloader.download(any()))
      .thenAnswer((_) => const Stream<DownloadProgress>.empty());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [modelDownloaderProvider.overrideWithValue(downloader)],
      child: MaterialApp(
        home: Scaffold(body: CatalogEntryTile(entry: entry, wide: true)),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  setUpAll(() => registerFallbackValue(qwenEntry));

  testWidgets('renders color-coded capability badge + chips', (tester) async {
    await _pump(tester, _vision);
    expect(tester.takeException(), isNull);
    expect(find.text('vision'), findsOneWidget);
    expect(find.text('q4_0'), findsOneWidget);
    expect(find.text('4.20 GB'), findsOneWidget);
    expect(find.text('8 GB RAM'), findsOneWidget);
    expect(find.text('GPU'), findsOneWidget);
    expect(find.text('Apache-2.0'), findsOneWidget);
    expect(find.text('↓ 2.2M'), findsOneWidget);
    expect(find.text('♥ 704K'), findsOneWidget);
    expect(_badgeColor(tester), const Color(0xFF271E33));
  });

  test('formatCount renders M/K', () {
    expect(formatCount(2200000), '2.2M');
    expect(formatCount(704000), '704K');
    expect(formatCount(42), '42');
  });

  testWidgets('capability colors differ per capability', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    final element = tester.element(find.byType(SizedBox));
    final code = capabilityColors(element, 'code');
    final text = capabilityColors(element, 'chat');
    final embed = capabilityColors(element, 'embedding');
    expect(code.fg, isNot(text.fg));
    expect(embed.fg, isNot(code.fg));
  });
}
