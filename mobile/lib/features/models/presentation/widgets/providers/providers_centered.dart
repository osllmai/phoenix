import 'package:flutter/material.dart';

/// Empty: no providers configured yet.
class ProvidersEmpty extends StatelessWidget {
  const ProvidersEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔌', style: TextStyle(fontSize: 44)),
            const SizedBox(height: 12),
            Text('No providers configured',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Text(
                  'Add a provider key or connect IndoxHub to use cloud models. '
                  'Prompts leave your machine only when you call a cloud provider.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant)),
            ),
            const SizedBox(height: 20),
            Wrap(spacing: 12, children: [
              FilledButton(onPressed: () {}, child: const Text('Connect IndoxHub')),
              OutlinedButton(
                  onPressed: () {}, child: const Text('Add provider key (BYOK)')),
            ]),
          ],
        ),
      ),
    );
  }
}

/// First-run: choose IndoxHub gateway or BYOK.
class ProvidersFirstRun extends StatelessWidget {
  const ProvidersFirstRun({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('☁', style: TextStyle(fontSize: 44)),
            const SizedBox(height: 12),
            Text('Add your first provider',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Text(
                  'Use IndoxHub for instant access to every provider with one key, '
                  'or add individual BYOK keys and pay providers directly.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant)),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _path(theme, scheme, '🔀', 'IndoxHub',
                    'One key routes to OpenAI, Anthropic, Google, Mistral and more. '
                        'Pay with IndoxHub credits.',
                    'Connect IndoxHub', true),
                _path(theme, scheme, '🔑', 'BYOK — your own keys',
                    'Add a key (or a custom OpenAI-compatible base URL) per provider. '
                        'You pay the provider directly.',
                    'Add provider key', false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _path(ThemeData theme, ColorScheme scheme, String icon, String title,
      String body, String cta, bool primary) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 10),
          Text(title,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(body,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant, height: 1.35)),
          const SizedBox(height: 14),
          primary
              ? FilledButton(onPressed: () {}, child: Text(cta))
              : OutlinedButton(onPressed: () {}, child: Text(cta)),
        ],
      ),
    );
  }
}
