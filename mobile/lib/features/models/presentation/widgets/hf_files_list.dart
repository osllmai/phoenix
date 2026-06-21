import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/catalog_entry.dart';
import '../../data/hf_repository.dart';
import 'catalog_entry_action.dart';

class HfFilesList extends ConsumerWidget {
  const HfFilesList({super.key, required this.repoId});

  final String repoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(hfModelFilesProvider(repoId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Available files',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 8),
        files.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('Could not load files: $e'),
          data: (list) => list.isEmpty
              ? const Text('No .gguf files found in this repository.')
              : Column(children: [for (final f in list) _fileRow(f)]),
        ),
      ],
    );
  }

  Widget _fileRow(CatalogEntry e) {
    final size =
        e.filesizeGb > 0 ? ' · ${e.filesizeGb.toStringAsFixed(2)} GB' : '';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(e.filename, overflow: TextOverflow.ellipsis),
      subtitle: Text('${e.quant}$size'),
      trailing: CatalogEntryAction(entry: e),
    );
  }
}
