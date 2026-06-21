import 'package:flutter/material.dart';

/// A friendly "best on desktop" panel for features gated to the desktop
/// workbench (e.g. the server console, DeepSearch) on tablet/phone.
class DesktopOnlyPanel extends StatelessWidget {
  const DesktopOnlyPanel({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 40, color: scheme.primary),
                      ),
                      const SizedBox(height: 20),
                      Text(title,
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      Text(message,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: scheme.onSurfaceVariant),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.qr_code_scanner, size: 18),
                        label: const Text('Pair with your desktop'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
