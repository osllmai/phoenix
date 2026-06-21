import 'package:flutter/material.dart';

Future<bool?> confirmTooLargeDownload(
  BuildContext context,
  double neededGb,
  double deviceGb,
) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Model may not fit'),
      content: Text(
        'This model needs ~${neededGb.ceil()} GB RAM; your device has '
        '~${deviceGb.floor()} GB. It likely won\'t load. Download anyway?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Download anyway'),
        ),
      ],
    ),
  );
}

void warnTightDownload(BuildContext context, double neededGb) {
  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
    SnackBar(
      content: Text('This model is a tight fit (~${neededGb.ceil()} GB RAM).'),
    ),
  );
}
