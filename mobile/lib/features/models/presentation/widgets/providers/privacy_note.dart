import 'package:flutter/material.dart';
import '../../../../../app/status_colors.dart';

/// The local-keychain reassurance strip shown above the provider list.
class PrivacyNote extends StatelessWidget {
  const PrivacyNote({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, size: 16, color: StatusColors.secure),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
                'Keys are stored locally in the OS keychain — encrypted, never '
                'synced, never hardcoded.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }
}
