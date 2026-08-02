import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void notify(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<void> copyValue(
    BuildContext context, String value, String confirmation) async {
  await Clipboard.setData(ClipboardData(text: value));
  if (context.mounted) notify(context, confirmation);
}
