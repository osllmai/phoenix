import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/features/extensions/presentation/data/extensions_repository.dart';
import 'package:phoenix/features/extensions/presentation/providers/extension_entry.dart';
import 'package:phoenix/features/extensions/presentation/providers/marketplace_controller.dart';

import 'extensions_test_support.dart';

ProviderContainer _container(MockExtensionsRepository repo) {
  final c = ProviderContainer(
    overrides: [extensionsRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  late MockExtensionsRepository repo;

  setUp(() {
    repo = MockExtensionsRepository();
    when(() => repo.list(
            category: any(named: 'category'), query: any(named: 'query')))
        .thenAnswer((_) async => sampleEntries);
  });

  test('catalog loads list from repository', () async {
    final c = _container(repo);
    final entries = await c.read(marketplaceCatalogProvider.future);
    expect(entries, sampleEntries);
    verify(() => repo.list(category: null, query: null)).called(1);
  });

  test('catalog surfaces a repository error', () async {
    when(() => repo.list(
            category: any(named: 'category'), query: any(named: 'query')))
        .thenAnswer((_) async => throw Exception('boom'));
    final c = _container(repo);
    c.listen(marketplaceCatalogProvider, (_, _) {}, fireImmediately: true);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(c.read(marketplaceCatalogProvider).hasError, isTrue);
  });

  test('category + search forward to the repository query', () async {
    final c = _container(repo);
    c.listen(marketplaceCatalogProvider, (_, _) {});
    await c.read(marketplaceCatalogProvider.future);
    c.read(marketplaceControllerProvider.notifier)
      ..selectCategory(ExtensionCategory.speech)
      ..search('whisper');
    await c.read(marketplaceCatalogProvider.future);
    verify(() => repo.list(category: 'speech', query: 'whisper')).called(1);
  });

  test('install calls the API and refreshes the catalog', () async {
    when(() => repo.install('whisper'))
        .thenAnswer((_) async => sampleEntries[1]);
    final c = _container(repo);
    c.listen(marketplaceCatalogProvider, (_, _) {});
    await c.read(marketplaceCatalogProvider.future);
    await c.read(marketplaceControllerProvider.notifier).install('whisper');
    await c.read(marketplaceCatalogProvider.future);
    verify(() => repo.install('whisper')).called(1);
    verify(() => repo.list(category: null, query: null)).called(2);
    expect(c.read(marketplaceControllerProvider).installing, isEmpty);
  });

  test('uninstall calls the API and refreshes the catalog', () async {
    when(() => repo.uninstall('docling'))
        .thenAnswer((_) async => sampleEntries[0]);
    final c = _container(repo);
    c.listen(marketplaceCatalogProvider, (_, _) {});
    await c.read(marketplaceCatalogProvider.future);
    await c.read(marketplaceControllerProvider.notifier).uninstall('docling');
    await c.read(marketplaceCatalogProvider.future);
    verify(() => repo.uninstall('docling')).called(1);
    verify(() => repo.list(category: null, query: null)).called(2);
  });
}
