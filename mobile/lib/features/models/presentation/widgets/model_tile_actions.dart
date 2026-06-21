import 'package:flutter/material.dart';
import 'package:phoenix_core/phoenix_core.dart';

import '../providers/model_providers.dart';

Future<void> runModelLoad(
  ScaffoldMessengerState messenger,
  ModelsController ctrl,
  AiModel model,
) async {
  void snack(String msg, {VoidCallback? retry}) => messenger.showSnackBar(
    SnackBar(
      content: Text(msg),
      action: retry == null
          ? null
          : SnackBarAction(label: 'Retry', onPressed: retry),
    ),
  );
  try {
    await ctrl.select(model);
    snack('Loaded ${model.name}');
  } on ArgumentError {
    snack('This model has no file to load.');
  } on StateError {
    snack('Another model is still loading — try again in a moment.');
  } on EngineException {
    snack(
      "Couldn't load — file may be missing, too large for RAM, or unsupported.",
      retry: () => runModelLoad(messenger, ctrl, model),
    );
  }
}

Future<void> confirmModelDelete(
  BuildContext context,
  ModelsController ctrl,
  AiModel model,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Remove model?'),
      content: Text(
        'Remove "${model.name}" from your catalog? The file on disk is left in place.',
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
  if (ok != true) return;
  await ctrl.remove(model);
  messenger.showSnackBar(
    SnackBar(
      content: Text('Removed ${model.name}'),
      action: model.isInstalled
          ? SnackBarAction(
              label: 'Undo',
              onPressed: () => ctrl.addLocal(name: model.name, path: model.key!),
            )
          : null,
    ),
  );
}
