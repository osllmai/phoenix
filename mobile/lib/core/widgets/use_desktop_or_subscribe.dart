import 'package:flutter/material.dart';

import 'pairing_sheet.dart';
import 'subscribe_sheet.dart';

/// Gate shown on tablet/mobile when the user triggers a desktop-class / premium
/// action (e.g. running a forecast). The UI is a preview here; the action runs
/// either on the paired desktop or via a paid cloud subscription.
Future<void> showUseDesktopOrSubscribe(
  BuildContext context, {
  required String feature,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
      titlePadding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
      title: Row(children: [
        Expanded(
          child: Text('$feature runs on desktop',
              style: const TextStyle(fontSize: 16)),
        ),
        IconButton(
          onPressed: () => Navigator.of(ctx).pop(),
          icon: const Icon(Icons.close, size: 18),
          visualDensity: VisualDensity.compact,
          tooltip: 'Close',
        ),
      ]),
      content: SizedBox(
        width: 280,
        child: Text(
          'Run it on your paired desktop, or subscribe to run in the cloud.',
          style: TextStyle(fontSize: 13, color: Theme.of(ctx).colorScheme.onSurfaceVariant),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            showPairingSheet(context);
          },
          child: const Text('Use desktop'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            showSubscribeSheet(context, feature: feature);
          },
          child: const Text('Subscribe'),
        ),
      ],
    ),
  );
}
