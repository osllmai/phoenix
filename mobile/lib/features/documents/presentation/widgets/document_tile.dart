import 'package:flutter/material.dart';

import '../providers/document.dart';
import 'doc_chips.dart';

class DocumentTile extends StatelessWidget {
  const DocumentTile({
    super.key,
    required this.doc,
    required this.selected,
    required this.onTap,
  });

  final PhoenixDocument doc;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: selected ? scheme.primaryContainer : scheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? scheme.primary : scheme.outlineVariant,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(docKindIcon(doc.kind), size: 26, color: scheme.onSurface),
              const SizedBox(width: 12),
              Expanded(child: _Body(doc: doc)),
              if (doc.grade != null) _Grade(grade: doc.grade!),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.doc});

  final PhoenixDocument doc;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doc.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.titleSmall,
        ),
        const SizedBox(height: 2),
        Text(doc.meta, style: text.bodySmall?.copyWith(color: scheme.outline)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (doc.badge.isNotEmpty) BadgeChip(label: doc.badge),
            StatusChip(status: doc.status),
          ],
        ),
        if (doc.status == DocStatus.converting) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(value: doc.progress / 100),
          ),
        ],
      ],
    );
  }
}

class _Grade extends StatelessWidget {
  const _Grade({required this.grade});

  final String grade;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text('conf', style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: scheme.outline)),
        Text(grade, style: Theme.of(context).textTheme.titleMedium
            ?.copyWith(color: scheme.primary, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
