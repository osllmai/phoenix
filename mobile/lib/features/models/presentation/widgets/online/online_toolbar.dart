import 'package:flutter/material.dart';

const _filters = ['All', 'Recommended', 'Vision', 'Tools', 'Cheapest', 'Long context'];

/// Search field + filter pills + sort dropdown for the Online catalog.
class OnlineToolbar extends StatelessWidget {
  const OnlineToolbar({
    super.key,
    required this.active,
    required this.onFilter,
    required this.onSearch,
  });

  final String active;
  final ValueChanged<String> onFilter;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 240,
            child: TextField(
              onChanged: onSearch,
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'Search models, e.g. claude, vision, 200k…',
                prefixIcon: Icon(Icons.search, size: 18),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          for (final f in _filters)
            _Pill(label: f, on: f == active, onTap: () => onFilter(f)),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.on, required this.onTap});

  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: on ? scheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: on ? scheme.onPrimaryContainer : scheme.outline),
        ),
        child: Text(label,
            style: theme.textTheme.labelMedium?.copyWith(
                color: on ? scheme.onPrimaryContainer : scheme.onSurfaceVariant)),
      ),
    );
  }
}
