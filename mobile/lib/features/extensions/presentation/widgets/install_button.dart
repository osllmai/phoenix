import 'package:flutter/material.dart';

import '../providers/extension_entry.dart';

class InstallButton extends StatelessWidget {
  const InstallButton({
    super.key,
    required this.entry,
    required this.installing,
    required this.onInstall,
    required this.onUninstall,
  });

  final ExtensionEntry entry;
  final bool installing;
  final VoidCallback onInstall;
  final VoidCallback onUninstall;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (installing) {
      return const SizedBox(
        width: 88,
        height: 36,
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (entry.installed) {
      return OutlinedButton.icon(
        onPressed: onUninstall,
        style: OutlinedButton.styleFrom(foregroundColor: scheme.tertiary),
        icon: const Icon(Icons.check, size: 16),
        label: const Text('Installed'),
      );
    }
    return FilledButton(onPressed: onInstall, child: const Text('Install'));
  }
}
