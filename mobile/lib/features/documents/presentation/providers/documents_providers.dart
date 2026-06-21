import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_client.dart';
import '../data/documents_repository.dart';
import 'document.dart';

part 'documents_providers.g.dart';

@riverpod
DocumentsRepository documentsRepository(Ref ref) =>
    DocumentsRepository(ref.watch(dioProvider));

@riverpod
Future<List<PhoenixDocument>> documentLibrary(Ref ref) =>
    ref.watch(documentsRepositoryProvider).list();

@riverpod
class DocumentFilter extends _$DocumentFilter {
  @override
  String build() => 'All';

  void set(String value) => state = value;
}

@riverpod
class DocumentQuery extends _$DocumentQuery {
  @override
  String build() => '';

  void set(String value) => state = value;
}

@riverpod
class SelectedDocumentId extends _$SelectedDocumentId {
  @override
  String? build() {
    final docs = ref.watch(documentLibraryProvider).value;
    return (docs == null || docs.isEmpty) ? null : docs.first.id;
  }

  void select(String id) => state = id;
  void clear() => state = null;
}

@riverpod
Future<PhoenixDocument?> selectedDocument(Ref ref) async {
  final id = ref.watch(selectedDocumentIdProvider);
  if (id == null) return null;
  return ref.watch(documentsRepositoryProvider).detail(id);
}

bool matchesFilter(PhoenixDocument doc, String filter) {
  switch (filter) {
    case 'PDF':
      return doc.kind == DocKind.pdf;
    case 'Office':
      return doc.kind == DocKind.office;
    case 'Images':
      return doc.kind == DocKind.image;
    case 'Converted':
      return doc.status == DocStatus.converted;
    case 'Embedded':
      return doc.status == DocStatus.embedded;
    default:
      return true;
  }
}

@riverpod
bool libraryIsEmpty(Ref ref) =>
    (ref.watch(documentLibraryProvider).value ?? const []).isEmpty;

@riverpod
List<PhoenixDocument> visibleDocuments(Ref ref) {
  final all = ref.watch(documentLibraryProvider).value ?? const [];
  final filter = ref.watch(documentFilterProvider);
  final query = ref.watch(documentQueryProvider).trim().toLowerCase();
  return all.where((d) {
    if (!matchesFilter(d, filter)) return false;
    if (query.isEmpty) return true;
    return d.title.toLowerCase().contains(query) ||
        d.markdown.toLowerCase().contains(query);
  }).toList();
}
