import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/browse_query.dart';
import 'category_chips.dart';

const _sortLabels = {
  BrowseSortMode.downloads: 'Downloads',
  BrowseSortMode.likes: 'Likes',
  BrowseSortMode.size: 'Size',
  BrowseSortMode.name: 'Name',
  BrowseSortMode.date: 'Date',
};

class BrowseHeader extends ConsumerStatefulWidget {
  const BrowseHeader({super.key, required this.count});

  final int count;

  @override
  ConsumerState<BrowseHeader> createState() => _BrowseHeaderState();
}

class _BrowseHeaderState extends ConsumerState<BrowseHeader> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(browseSearchProvider.notifier).set(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sort = ref.watch(browseSortProvider);
    final ascending = ref.watch(browseAscendingProvider);
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            onChanged: _onChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search name, org, type or capability',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<BrowseSortMode>(
                    showSelectedIcon: false,
                    segments: [
                      for (final e in _sortLabels.entries)
                        ButtonSegment(value: e.key, label: Text(e.value)),
                    ],
                    selected: {sort},
                    onSelectionChanged: (s) =>
                        ref.read(browseSortProvider.notifier).set(s.first),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.outlined(
                tooltip: ascending ? 'Ascending' : 'Descending',
                isSelected: true,
                style: IconButton.styleFrom(
                  foregroundColor: cs.primary,
                  side: BorderSide(color: cs.primary),
                ),
                onPressed: () =>
                    ref.read(browseAscendingProvider.notifier).toggle(),
                icon: Icon(ascending ? Icons.arrow_upward : Icons.arrow_downward),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const CategoryChips(),
          const SizedBox(height: 8),
          Text('${widget.count} models', style: text.labelMedium),
        ],
      ),
    );
  }
}
