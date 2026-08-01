import 'dart:io';

/// One labelled slice of on-device storage usage.
class StorageEntry {
  const StorageEntry(this.label, this.bytes);
  final String label;
  final int bytes;
}

/// Computes real on-device storage usage and clears caches. Pure Dart — callers
/// (Flutter/CLI) supply the directories (resolved via path_provider on mobile).
class StorageService {
  const StorageService();

  /// Recursive byte size of [dir] (0 if missing). Unreadable entries are skipped.
  Future<int> sizeOfDirectory(Directory dir) async {
    if (!await dir.exists()) return 0;
    var total = 0;
    await for (final e in dir.list(recursive: true, followLinks: false)) {
      if (e is File) {
        try {
          total += await e.length();
        } on Object {
          continue;
        }
      }
    }
    return total;
  }

  /// Total size of the given files (skips missing/unreadable). Used for the set
  /// of installed model files referenced by path.
  Future<int> sizeOfFiles(Iterable<String> paths) async {
    var total = 0;
    for (final path in paths) {
      try {
        final f = File(path);
        if (await f.exists()) total += await f.length();
      } on Object {
        continue;
      }
    }
    return total;
  }

  /// Deletes the contents of [dir] (keeping the directory); returns bytes freed.
  Future<int> clearDirectory(Directory dir) async {
    if (!await dir.exists()) return 0;
    final freed = await sizeOfDirectory(dir);
    await for (final e in dir.list(followLinks: false)) {
      try {
        await e.delete(recursive: true);
      } on Object {
        continue;
      }
    }
    return freed;
  }
}

/// Human-readable byte size, e.g. `0 B`, `812 KB`, `3.4 GB`.
String formatBytes(int bytes) {
  if (bytes <= 0) return '0 B';
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var value = bytes.toDouble();
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  final decimals = (unit == 0 || value >= 100) ? 0 : 1;
  return '${value.toStringAsFixed(decimals)} ${units[unit]}';
}
