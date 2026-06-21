import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/catalog_entry.dart';

part 'browse_query.g.dart';

enum BrowseSource { catalog, huggingFace }

enum BrowseSortMode { downloads, likes, size, name, date }

enum BrowseCategory { all, chat, code, vision, audio, embedding, other }

final _embeddingPattern = RegExp(
  r'embed|bge-|minilm|gte-|e5-|nomic-embed|mxbai|sentence-?transformer',
  caseSensitive: false,
);

BrowseCategory categoryFor(CatalogEntry e) {
  final cap = e.capability.toLowerCase();
  if (cap.contains('vision') || cap.contains('image')) {
    return BrowseCategory.vision;
  }
  if (cap.contains('code')) return BrowseCategory.code;
  if (cap.contains('audio') || cap.contains('speech')) {
    return BrowseCategory.audio;
  }
  if (cap.contains('embed')) return BrowseCategory.embedding;
  if (cap.contains('text') || cap.contains('chat')) {
    if (_embeddingPattern.hasMatch('${e.name} ${e.modelName}')) {
      return BrowseCategory.embedding;
    }
    return BrowseCategory.chat;
  }
  return BrowseCategory.other;
}

@riverpod
class BrowseSearch extends _$BrowseSearch {
  @override
  String build() => '';

  void set(String value) => state = value;
}

@riverpod
class BrowseSort extends _$BrowseSort {
  @override
  BrowseSortMode build() => BrowseSortMode.downloads;

  void set(BrowseSortMode value) => state = value;
}

@riverpod
class BrowseAscending extends _$BrowseAscending {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void set(bool value) => state = value;
}

@riverpod
class BrowseSourceSel extends _$BrowseSourceSel {
  @override
  BrowseSource build() => BrowseSource.catalog;

  void set(BrowseSource value) => state = value;
}

@riverpod
class BrowseCategorySel extends _$BrowseCategorySel {
  @override
  BrowseCategory build() => BrowseCategory.all;

  void set(BrowseCategory value) => state = value;
}

List<CatalogEntry> filterSortEntries(
  List<CatalogEntry> entries,
  String query,
  BrowseSortMode mode,
  bool ascending, {
  BrowseCategory category = BrowseCategory.all,
}) {
  final q = query.trim().toLowerCase();
  final filtered = entries.where((e) {
    if (category != BrowseCategory.all && categoryFor(e) != category) {
      return false;
    }
    return q.isEmpty || _matches(e, q);
  }).toList();

  int cmp(CatalogEntry a, CatalogEntry b) {
    switch (mode) {
      case BrowseSortMode.downloads:
        return a.downloadCount.compareTo(b.downloadCount);
      case BrowseSortMode.likes:
        return a.likeCount.compareTo(b.likeCount);
      case BrowseSortMode.size:
        return a.filesizeGb.compareTo(b.filesizeGb);
      case BrowseSortMode.name:
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      case BrowseSortMode.date:
        return a.uploadDate.compareTo(b.uploadDate);
    }
  }

  filtered.sort((a, b) => ascending ? cmp(a, b) : cmp(b, a));
  return filtered;
}

bool _matches(CatalogEntry e, String q) =>
    e.modelName.toLowerCase().contains(q) ||
    e.name.toLowerCase().contains(q) ||
    e.org.toLowerCase().contains(q) ||
    e.type.toLowerCase().contains(q) ||
    e.capability.toLowerCase().contains(q);
