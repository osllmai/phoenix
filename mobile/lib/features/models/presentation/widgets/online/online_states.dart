import 'package:flutter/material.dart';

/// Centred non-success states for the Online screen (empty / error / denied)
/// plus the first-run connect form and the loading skeletons.
class OnlineCenterState extends StatelessWidget {
  const OnlineCenterState({
    super.key,
    required this.emoji,
    required this.title,
    required this.body,
    this.errorBox,
    this.actions = const [],
  });

  final String emoji;
  final String title;
  final String body;
  final String? errorBox;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 44)),
              const SizedBox(height: 12),
              Text(title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(body,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant)),
              if (errorBox != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: scheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: scheme.error),
                  ),
                  child: Text(errorBox!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: scheme.onErrorContainer)),
                ),
              ],
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(spacing: 8, alignment: WrapAlignment.center, children: actions),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// First-run "Connect IndoxHub" API-key form.
class ConnectIndoxHubForm extends StatelessWidget {
  const ConnectIndoxHubForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('☁', style: TextStyle(fontSize: 44)),
              const SizedBox(height: 12),
              Text('Connect IndoxHub',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                  'IndoxHub is a cloud LLM gateway — one key routes to OpenAI, '
                  'Anthropic, Google, Mistral and more. Prompts leave your machine.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 20),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'IndoxHub API key',
                  hintText: 'ir-…',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                    child: Text('BYOK — supply your own provider key',
                        style: theme.textTheme.bodySmall)),
                Switch(value: false, onChanged: (_) {}),
              ]),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {}, child: const Text('Connect')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Loading skeleton grid while the catalog fetches.
class OnlineLoading extends StatelessWidget {
  const OnlineLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(strokeWidth: 3)),
            const SizedBox(width: 12),
            Text('Fetching model catalog from IndoxHub…',
                style: TextStyle(color: scheme.onSurfaceVariant)),
          ]),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                for (var i = 0; i < 4; i++)
                  Container(
                      decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
