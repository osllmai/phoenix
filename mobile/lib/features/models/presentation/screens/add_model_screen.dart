import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;

import '../providers/model_pick_provider.dart';
import '../providers/model_providers.dart';

/// Registers a local `.gguf` by name + path. Two inputs only — the core API
/// stores the path as-is (no metadata parse). Empty name/path → inline errors.
class AddModelScreen extends ConsumerStatefulWidget {
  const AddModelScreen({super.key});

  @override
  ConsumerState<AddModelScreen> createState() => _AddModelScreenState();
}

class _AddModelScreenState extends ConsumerState<AddModelScreen> {
  final _name = TextEditingController();
  final _path = TextEditingController();
  String? _nameError;
  String? _pathError;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _path.dispose();
    super.dispose();
  }

  Future<void> _browse() async {
    final picked = await pickGgufPath();
    if (picked == null) return;
    setState(() {
      _path.text = picked;
      _pathError = null;
      if (_name.text.trim().isEmpty) {
        _name.text = p.basenameWithoutExtension(picked);
      }
    });
  }

  Future<void> _submit() async {
    setState(() {
      _nameError = _name.text.trim().isEmpty ? 'Name is required' : null;
      _pathError = _path.text.trim().isEmpty ? 'Choose a .gguf file' : null;
    });
    if (_nameError != null || _pathError != null) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final name = _name.text.trim();
    try {
      await ref
          .read(modelsControllerProvider.notifier)
          .addLocal(name: name, path: _path.text.trim());
      messenger.showSnackBar(SnackBar(content: Text('Added $name')));
      if (mounted) context.go('/models');
    } on ArgumentError {
      setState(() {
        _saving = false;
        _pathError = 'Could not add this model — check the name and path.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a local model')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Register a .gguf file you already have on disk. Phoenix runs it '
                'entirely on-device — nothing is uploaded.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _name,
                decoration: InputDecoration(
                  labelText: 'Display name',
                  hintText: 'My Llama 3.1 8B',
                  errorText: _nameError,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _path,
                readOnly: true,
                onTap: _browse,
                decoration: InputDecoration(
                  labelText: 'File path',
                  hintText: '/home/you/models/model.gguf',
                  errorText: _pathError,
                  suffixIcon: TextButton(
                    onPressed: _browse,
                    child: const Text('Browse…'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _saving ? null : () => context.go('/models'),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _saving ? null : _submit,
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Add to catalog'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
