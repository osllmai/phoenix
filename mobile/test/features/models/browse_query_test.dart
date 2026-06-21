import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/features/models/data/catalog_entry.dart';
import 'package:phoenix/features/models/presentation/providers/browse_query.dart';

const _a = CatalogEntry(
  org: 'Qwen',
  modelName: 'Qwen2',
  name: 'Qwen2 Small',
  filename: 'q.gguf',
  url: 'u',
  filesizeGb: 0.9,
  downloadCount: 100,
  likeCount: 5,
  type: 'text-generation',
  capability: 'chat',
  uploadDate: '2024-01-01',
);
const _b = CatalogEntry(
  org: 'meta',
  modelName: 'Llama',
  name: 'Llama 3 Big',
  filename: 'l.gguf',
  url: 'u',
  filesizeGb: 4.7,
  downloadCount: 9000,
  likeCount: 50,
  type: 'text-generation',
  capability: 'vision',
  uploadDate: '2024-03-01',
);
const _c = CatalogEntry(
  org: 'mistral',
  modelName: 'Mistral',
  name: 'Mistral 7B',
  filename: 'm.gguf',
  url: 'u',
  filesizeGb: 4.1,
  downloadCount: 500,
  likeCount: 200,
  type: 'code',
  capability: 'code',
  uploadDate: '2024-02-01',
);

const _all = [_a, _b, _c];

List<String> _names(List<CatalogEntry> e) => e.map((x) => x.name).toList();

void main() {
  group('search', () {
    test('matches modelName and org case-insensitively', () {
      expect(_names(filterSortEntries(_all, 'qwen', BrowseSortMode.name, true)),
          ['Qwen2 Small']);
      expect(_names(filterSortEntries(_all, 'META', BrowseSortMode.name, true)),
          ['Llama 3 Big']);
    });

    test('matches type and capability', () {
      expect(
          _names(filterSortEntries(_all, 'vision', BrowseSortMode.name, true)),
          ['Llama 3 Big']);
      final code = filterSortEntries(_all, 'code', BrowseSortMode.name, true);
      expect(_names(code), ['Mistral 7B']);
    });
  });

  group('sort desc (default direction)', () {
    test('downloads', () {
      expect(_names(filterSortEntries(_all, '', BrowseSortMode.downloads, false)),
          ['Llama 3 Big', 'Mistral 7B', 'Qwen2 Small']);
    });
    test('likes', () {
      expect(_names(filterSortEntries(_all, '', BrowseSortMode.likes, false)),
          ['Mistral 7B', 'Llama 3 Big', 'Qwen2 Small']);
    });
    test('size', () {
      expect(_names(filterSortEntries(_all, '', BrowseSortMode.size, false)),
          ['Llama 3 Big', 'Mistral 7B', 'Qwen2 Small']);
    });
    test('name', () {
      expect(_names(filterSortEntries(_all, '', BrowseSortMode.name, false)),
          ['Qwen2 Small', 'Mistral 7B', 'Llama 3 Big']);
    });
    test('date', () {
      expect(_names(filterSortEntries(_all, '', BrowseSortMode.date, false)),
          ['Llama 3 Big', 'Mistral 7B', 'Qwen2 Small']);
    });
  });

  group('sort asc', () {
    test('downloads', () {
      expect(_names(filterSortEntries(_all, '', BrowseSortMode.downloads, true)),
          ['Qwen2 Small', 'Mistral 7B', 'Llama 3 Big']);
    });
    test('likes', () {
      expect(_names(filterSortEntries(_all, '', BrowseSortMode.likes, true)),
          ['Qwen2 Small', 'Llama 3 Big', 'Mistral 7B']);
    });
    test('size', () {
      expect(_names(filterSortEntries(_all, '', BrowseSortMode.size, true)),
          ['Qwen2 Small', 'Mistral 7B', 'Llama 3 Big']);
    });
    test('name', () {
      expect(_names(filterSortEntries(_all, '', BrowseSortMode.name, true)),
          ['Llama 3 Big', 'Mistral 7B', 'Qwen2 Small']);
    });
    test('date', () {
      expect(_names(filterSortEntries(_all, '', BrowseSortMode.date, true)),
          ['Qwen2 Small', 'Mistral 7B', 'Llama 3 Big']);
    });
  });
}
