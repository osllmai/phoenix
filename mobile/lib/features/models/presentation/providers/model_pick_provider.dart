import 'package:file_selector/file_selector.dart';

/// Opens the desktop file picker for a `.gguf` model and returns its path
/// (null if the user cancels). The catalog stores the path as-is — no copy.
Future<String?> pickGgufPath() async {
  const group = XTypeGroup(
    label: 'GGUF model',
    extensions: ['gguf'],
    mimeTypes: ['application/octet-stream'],
  );
  final file = await openFile(acceptedTypeGroups: [group]);
  return file?.path;
}
