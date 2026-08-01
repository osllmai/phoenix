import 'package:flutter/material.dart';

import '../../../../app/named_themes.dart';

class _GalleryEntry {
  const _GalleryEntry(this.id, this.name, this.bg, this.surface, this.accent);

  final String id;
  final String name;
  final Color bg;
  final Color surface;
  final Color accent;
}

const _phoenix = _GalleryEntry(
  'phoenix',
  'Phoenix',
  Color(0xFF17120E),
  Color(0xFF221A13),
  Color(0xFFFF8A3D),
);

List<_GalleryEntry> _entries() => [
      _phoenix,
      for (final t in kNamedThemes)
        _GalleryEntry(
          t.id,
          t.name,
          t.dark.background,
          t.dark.surface,
          t.dark.primary,
        ),
    ];

class ThemeGallery extends StatelessWidget {
  const ThemeGallery({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final cols = (constraints.maxWidth / 160).floor().clamp(2, 4);
        final cardWidth = (constraints.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final e in _entries())
              SizedBox(
                width: cardWidth,
                child: _ThemeCard(
                  entry: e,
                  selected: e.id == selected,
                  onTap: () => onSelected(e.id),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final _GalleryEntry entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outline,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Preview(entry: entry),
            const SizedBox(height: 8),
            Text(
              entry.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: selected ? scheme.primary : scheme.onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.entry});

  final _GalleryEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: entry.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: entry.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: entry.surface,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
