import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/documents_providers.dart';
import 'document_tile.dart';
import 'library_states.dart';
import 'library_toolbar.dart';

class DocumentLibrary extends ConsumerWidget {
  const DocumentLibrary({super.key, this.onSelected});

  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(documentLibraryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const LibraryToolbar(),
        const Divider(height: 1),
        Expanded(
          child: library.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => LibraryError(
              message: '$e',
              onRetry: () => ref.invalidate(documentLibraryProvider),
            ),
            data: (_) => _List(onSelected: onSelected),
          ),
        ),
      ],
    );
  }
}

class _List extends ConsumerWidget {
  const _List({this.onSelected});

  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(libraryIsEmptyProvider)) return const LibraryFirstRun();
    final docs = ref.watch(visibleDocumentsProvider);
    final selectedId = ref.watch(selectedDocumentIdProvider);
    if (docs.isEmpty) return const LibraryFilteredEmpty();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: docs.length,
      itemBuilder: (context, i) {
        final doc = docs[i];
        return DocumentTile(
          doc: doc,
          selected: doc.id == selectedId,
          onTap: () {
            ref.read(selectedDocumentIdProvider.notifier).select(doc.id);
            onSelected?.call();
          },
        );
      },
    );
  }
}
