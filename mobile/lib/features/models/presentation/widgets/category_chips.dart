import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/browse_query.dart';
import 'catalog_entry_badges.dart';

const _categoryLabels = {
  BrowseCategory.all: 'All',
  BrowseCategory.chat: 'Chat',
  BrowseCategory.code: 'Code',
  BrowseCategory.vision: 'Vision',
  BrowseCategory.audio: 'Audio',
  BrowseCategory.embedding: 'Embedding',
};

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(browseCategorySelProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final e in _categoryLabels.entries) ...[
            _CategoryChip(category: e.key, label: e.value, selected: selected),
            const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends ConsumerWidget {
  const _CategoryChip({
    required this.category,
    required this.label,
    required this.selected,
  });

  final BrowseCategory category;
  final String label;
  final BrowseCategory selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accent = capabilityColors(context, label);
    final isOn = selected == category;
    return ChoiceChip(
      label: Text(label),
      selected: isOn,
      showCheckmark: false,
      selectedColor: accent.bg,
      labelStyle: TextStyle(
        color: isOn ? accent.fg : null,
        fontWeight: FontWeight.w600,
      ),
      side: isOn ? BorderSide(color: accent.fg.withValues(alpha: 0.6)) : null,
      onSelected: (_) =>
          ref.read(browseCategorySelProvider.notifier).set(category),
    );
  }
}
