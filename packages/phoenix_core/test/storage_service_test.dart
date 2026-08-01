import 'dart:io';

import 'package:phoenix_core/phoenix_core.dart';
import 'package:test/test.dart';

void main() {
  late Directory tmp;

  setUp(() async => tmp = await Directory.systemTemp.createTemp('phx_storage'));
  tearDown(() async {
    if (await tmp.exists()) await tmp.delete(recursive: true);
  });

  test('sizeOfDirectory sums files recursively', () async {
    File('${tmp.path}/a.bin').writeAsBytesSync(List.filled(1000, 0));
    Directory('${tmp.path}/sub').createSync();
    File('${tmp.path}/sub/b.bin').writeAsBytesSync(List.filled(24, 0));
    expect(await const StorageService().sizeOfDirectory(tmp), 1024);
  });

  test('sizeOfFiles skips missing paths', () async {
    final f = '${tmp.path}/model.gguf';
    File(f).writeAsBytesSync(List.filled(2048, 0));
    final total = await const StorageService()
        .sizeOfFiles([f, '${tmp.path}/missing.gguf']);
    expect(total, 2048);
  });

  test('clearDirectory empties contents and returns freed bytes', () async {
    File('${tmp.path}/c.bin').writeAsBytesSync(List.filled(4096, 0));
    final svc = const StorageService();
    final freed = await svc.clearDirectory(tmp);
    expect(freed, 4096);
    expect(await svc.sizeOfDirectory(tmp), 0);
    expect(tmp.existsSync(), isTrue); // dir kept, contents gone
  });

  test('formatBytes is human readable', () {
    expect(formatBytes(0), '0 B');
    expect(formatBytes(512), '512 B');
    expect(formatBytes(2048), '2.0 KB');
    expect(formatBytes(3650722201), '3.4 GB');
  });
}
