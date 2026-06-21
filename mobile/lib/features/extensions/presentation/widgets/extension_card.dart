import 'package:flutter/material.dart';

import '../providers/extension_entry.dart';
import 'extension_tags.dart';
import 'install_button.dart';

class ExtensionCard extends StatelessWidget {
  const ExtensionCard({
    super.key,
    required this.entry,
    required this.selected,
    required this.installing,
    required this.onTap,
    required this.onInstall,
    required this.onUninstall,
  });

  final ExtensionEntry entry;
  final bool selected;
  final bool installing;
  final VoidCallback onTap;
  final VoidCallback onInstall;
  final VoidCallback onUninstall;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Icon(emoji: entry.icon),
            const SizedBox(width: 12),
            Expanded(child: _Body(entry: entry, text: text, scheme: scheme)),
            const SizedBox(width: 8),
            InstallButton(
              entry: entry,
              installing: installing,
              onInstall: onInstall,
              onUninstall: onUninstall,
            ),
          ],
        ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({required this.emoji});
  final String emoji;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 20)),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.entry, required this.text, required this.scheme});
  final ExtensionEntry entry;
  final TextTheme text;
  final ColorScheme scheme;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(entry.name,
                  style: text.titleSmall, overflow: TextOverflow.ellipsis),
            ),
            if (entry.verified)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(Icons.verified, size: 14, color: scheme.primary),
              ),
          ],
        ),
        const SizedBox(height: 2),
        Text(entry.publisher,
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(entry.description,
            style: text.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 8),
        ExtensionTags(entry: entry),
      ],
    );
  }
}
