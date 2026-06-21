import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/features/models/data/catalog_entry.dart';
import 'package:phoenix/features/models/presentation/providers/browse_query.dart';

const _chat = CatalogEntry(
  org: 'qwen',
  modelName: 'qwen2',
  name: 'Qwen2 Chat',
  filename: 'q.gguf',
  url: 'u',
  capability: 'text',
);
const _embed = CatalogEntry(
  org: 'baai',
  modelName: 'bge-large-en',
  name: 'BGE Large',
  filename: 'b.gguf',
  url: 'u',
  capability: 'text',
);
const _vision = CatalogEntry(
  org: 'meta',
  modelName: 'llava',
  name: 'LLaVA',
  filename: 'v.gguf',
  url: 'u',
  capability: 'vision',
);
const _code = CatalogEntry(
  org: 'm',
  modelName: 'cq',
  name: 'CodeQwen',
  filename: 'c.gguf',
  url: 'u',
  capability: 'code',
);

const _all = [_chat, _embed, _vision, _code];

List<String> _names(List<CatalogEntry> e) => e.map((x) => x.name).toList();

void main() {
  group('categoryFor', () {
    test('plain text model is Chat', () {
      expect(categoryFor(_chat), BrowseCategory.chat);
    });
    test('embedding-named text model is reclassified to Embedding', () {
      expect(categoryFor(_embed), BrowseCategory.embedding);
    });
    test('vision and code map directly', () {
      expect(categoryFor(_vision), BrowseCategory.vision);
      expect(categoryFor(_code), BrowseCategory.code);
    });
    test('explicit embedding capability is Embedding', () {
      const e = CatalogEntry(
        org: 'o',
        modelName: 'x',
        name: 'X',
        filename: 'x.gguf',
        url: 'u',
        capability: 'embedding',
      );
      expect(categoryFor(e), BrowseCategory.embedding);
    });
  });

  group('filterSortEntries category', () {
    test('all keeps everything', () {
      final out = filterSortEntries(_all, '', BrowseSortMode.name, true);
      expect(out.length, 4);
    });
    test('chat excludes the embedding text model', () {
      final out = filterSortEntries(_all, '', BrowseSortMode.name, true,
          category: BrowseCategory.chat);
      expect(_names(out), ['Qwen2 Chat']);
    });
    test('embedding selects the bge model', () {
      final out = filterSortEntries(_all, '', BrowseSortMode.name, true,
          category: BrowseCategory.embedding);
      expect(_names(out), ['BGE Large']);
    });
  });
}
