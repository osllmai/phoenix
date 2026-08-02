import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phoenix_core/phoenix_core.dart';

import '../../../../app/radiant.dart';
import '../providers/model_providers.dart';
import '../widgets/model_detail_body.dart';

/// One model's load lifecycle: idle · loading · active · no-file · error.
class ModelDetailScreen extends ConsumerStatefulWidget {
  const ModelDetailScreen({super.key, required this.model});

  final AiModel model;

  @override
  ConsumerState<ModelDetailScreen> createState() => _ModelDetailScreenState();
}

class _ModelDetailScreenState extends ConsumerState<ModelDetailScreen> {
  String? _error;

  AiModel get _model => widget.model;

  Future<void> _load() async {
    setState(() => _error = null);
    final messenger = ScaffoldMessenger.of(context);
    final key = _model.key;
    if (key != null && !key.toLowerCase().endsWith('.gguf')) {
      setState(() => _error = 'Not a .gguf file: $key');
      return;
    }
    try {
      await ref.read(modelsControllerProvider.notifier).select(_model);
      messenger.showSnackBar(SnackBar(content: Text('Loaded ${_model.name}')));
    } on ArgumentError {
      setState(() => _error = 'This model has no file to load.');
    } on StateError {
      setState(
        () =>
            _error = 'Another model is still loading — try again in a moment.',
      );
    } on ProcessException catch (e) {
      setState(() => _error = 'Engine binary not found: ${e.executable}');
    } on EngineException catch (e) {
      setState(
        () => _error =
            "Couldn't load — the file may be missing, too large for available RAM, "
            'or an unsupported format. (${e.kind.name})',
      );
    }
  }

  Future<void> _remove() async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Remove model?'),
        content: Text(
          'Remove "${_model.name}" from your catalog? The file on disk is left in place.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(modelsControllerProvider.notifier).remove(_model);
      messenger.showSnackBar(SnackBar(content: Text('Removed ${_model.name}')));
      if (mounted) context.go('/models');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingModelIdProvider) == _model.id;
    final isActive = ref.watch(activeModelProvider)?.id == _model.id;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(_model.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/models'),
        ),
      ),
      body: RadiantBackdrop(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ModelIdentityCard(model: _model),
            const SizedBox(height: 20),
            ModelLifecycle(
              model: _model,
              isLoading: isLoading,
              isActive: isActive,
              error: _error,
              onLoad: _load,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: _remove,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Remove from catalog'),
            ),
          ],
        ),
      ),
    );
  }
}
