import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/documents_providers.dart';

const _filters = <String>['All', 'PDF', 'Office', 'Converted', 'Embedded'];

class LibraryToolbar extends ConsumerWidget {
  const LibraryToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(documentFilterProvider);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            onChanged: ref.read(documentQueryProvider.notifier).set,
            decoration: const InputDecoration(
              isDense: true,
              prefixIcon: Icon(Icons.search),
              hintText: 'Search converted text…',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final f in _filters)
                FilterChip(
                  label: Text(f),
                  selected: f == active,
                  onSelected: (_) =>
                      ref.read(documentFilterProvider.notifier).set(f),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
