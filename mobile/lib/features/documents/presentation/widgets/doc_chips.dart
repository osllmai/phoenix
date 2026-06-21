import 'package:flutter/material.dart';

import '../providers/document.dart';

IconData docKindIcon(DocKind kind) {
  switch (kind) {
    case DocKind.pdf:
      return Icons.picture_as_pdf_outlined;
    case DocKind.office:
      return Icons.description_outlined;
    case DocKind.image:
      return Icons.image_outlined;
    case DocKind.audio:
      return Icons.graphic_eq;
    case DocKind.web:
      return Icons.public;
  }
}

String docStatusLabel(DocStatus status) {
  switch (status) {
    case DocStatus.queued:
      return 'Queued';
    case DocStatus.converting:
      return 'Converting…';
    case DocStatus.converted:
      return 'Converted';
    case DocStatus.embedded:
      return 'Embedded';
    case DocStatus.failed:
      return 'Failed';
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final DocStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ok = status == DocStatus.embedded;
    final warn = status == DocStatus.converting || status == DocStatus.failed;
    final color = ok
        ? scheme.primary
        : warn
            ? scheme.tertiary
            : scheme.outline;
    return _Pill(label: docStatusLabel(status), color: color);
  }
}

class BadgeChip extends StatelessWidget {
  const BadgeChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return _Pill(label: label, color: Theme.of(context).colorScheme.secondary);
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color),
      ),
    );
  }
}
