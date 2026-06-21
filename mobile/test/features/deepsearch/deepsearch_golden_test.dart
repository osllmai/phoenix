import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix/app/theme.dart';
import 'package:phoenix/features/deepsearch/presentation/providers/deepsearch_controller.dart';
import 'package:phoenix/features/deepsearch/presentation/providers/deepsearch_state.dart';
import 'package:phoenix/features/deepsearch/presentation/screens/deepsearch_screen.dart';

const _answer = '''
Local retrieval matched several documents. Speculative decoding uses a small
draft model to propose tokens the large model verifies in one pass `[1]`, while
4-bit KV-cache quantization shrinks the per-token memory read `[2]`.
''';

const _seeded = DeepSearchState(
  query: 'Techniques for reducing LLM inference latency',
  answer: _answer,
  hasResult: true,
  sources: [
    SearchSource(
      rank: 1,
      title: 'Speculative decoding notes',
      domain: 'Local document · #12',
      relevance: 96,
      snippet: 'A small draft model proposes tokens the large model verifies.',
      isLocal: true,
    ),
    SearchSource(
      rank: 2,
      title: 'KV-cache quantization benchmarks',
      domain: 'Local document · #18',
      relevance: 78,
      snippet: '4-bit KV-cache cuts per-token memory reads ~3.8x on-device.',
      isLocal: true,
    ),
  ],
);

class _SeededController extends DeepSearchController {
  @override
  Future<DeepSearchState> build() async => _seeded;
}

Widget _searchAt(Size size) {
  return ProviderScope(
    overrides: [
      deepSearchControllerProvider.overrideWith(_SeededController.new),
    ],
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: SizedBox.fromSize(
        size: size,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildPhoenixDarkTheme(),
          home: const DeepSearchScreen(),
        ),
      ),
    ),
  );
}

void main() {
  goldenTest(
    'deepsearch surface adapts across phone, tablet and desktop',
    fileName: 'deepsearch_responsive',
    builder: () => GoldenTestGroup(
      columns: 1,
      children: [
        for (final s in const [Size(390, 720), Size(834, 720), Size(1280, 720)])
          GoldenTestScenario(
            name: '${s.width.toInt()}x${s.height.toInt()}',
            constraints: BoxConstraints.tight(s),
            child: _searchAt(s),
          ),
      ],
    ),
  );
}
