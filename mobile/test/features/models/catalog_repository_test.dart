import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:phoenix/features/models/data/catalog_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('parses the real bundled offline_models assets grouped by org', () async {
    final byOrg = await CatalogRepository(rootBundle).loadByOrg();

    expect(byOrg, isNotEmpty);
    expect(byOrg.containsKey('qwen'), isTrue);

    final qwen = byOrg['qwen']!;
    expect(qwen, isNotEmpty);

    final entry = qwen.firstWhere(
      (e) => e.url.contains('huggingface.co'),
      orElse: () => qwen.first,
    );
    expect(entry.url, contains('huggingface.co'));
    expect(entry.filename, endsWith('.gguf'));
    expect(entry.name, isNotEmpty);
    expect(entry.org, 'qwen');
  });
}
