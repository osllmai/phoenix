import 'package:flutter/material.dart';

Future<void> showAddProviderDialog(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const AddProviderDialog());

/// The "Add provider" flow: pick a provider, optional base URL, API key, and a
/// set-as-default toggle. Keys are described as keychain-stored.
class AddProviderDialog extends StatefulWidget {
  const AddProviderDialog({super.key});

  @override
  State<AddProviderDialog> createState() => _AddProviderDialogState();
}

class _AddProviderDialogState extends State<AddProviderDialog> {
  static const _providers = [
    'OpenAI', 'Anthropic', 'Google · Gemini', 'Ollama (local network)',
    'Custom · OpenAI-compatible', 'Mistral AI', 'Groq', 'Together AI',
  ];
  String _provider = 'Custom · OpenAI-compatible';
  bool _obscure = true;
  bool _default = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AlertDialog(
      title: const Text('Add provider'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _provider,
                decoration: const InputDecoration(labelText: 'Provider'),
                items: [
                  for (final p in _providers)
                    DropdownMenuItem(value: p, child: Text(p)),
                ],
                onChanged: (v) => setState(() => _provider = v ?? _provider),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Base URL (custom / self-hosted)',
                  hintText: 'https://api.provider.com/v1',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'API key',
                  hintText: 'paste your secret key',
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Set as default provider for new chats'),
                value: _default,
                onChanged: (v) => setState(() => _default = v),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline, size: 16, color: Color(0xFF6FCF97)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                          'Stored encrypted in your OS keychain on this device '
                          'only — never in plaintext, never synced.',
                          style: theme.textTheme.labelSmall
                              ?.copyWith(color: scheme.onSurfaceVariant)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Test & Save')),
      ],
    );
  }
}
