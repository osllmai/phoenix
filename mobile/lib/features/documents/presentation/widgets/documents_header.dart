import 'package:flutter/material.dart';

import '../../../../core/responsive/breakpoints.dart';

class DocumentsHeader extends StatelessWidget {
  const DocumentsHeader({super.key, this.onMenu});

  final VoidCallback? onMenu;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final compact = formFactorOf(context).isPhone;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          if (onMenu != null)
            IconButton(onPressed: onMenu, icon: const Icon(Icons.menu)),
          Expanded(
            child: Text(
              'Documents',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: compact ? text.titleMedium : text.titleLarge,
            ),
          ),
          const SizedBox(width: 8),
          if (compact)
            IconButton.filled(
              onPressed: () {},
              icon: const Icon(Icons.add),
              tooltip: 'Add document',
            )
          else
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add document'),
            ),
        ],
      ),
    );
  }
}

class JobBar extends StatelessWidget {
  const JobBar({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: scheme.surfaceContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: scheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Docling worker online · conversion runs as a backend job',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: scheme.outline),
            ),
          ),
        ],
      ),
    );
  }
}
