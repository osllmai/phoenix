import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phoenix/app/theme.dart';
import 'package:phoenix/features/extensions/presentation/data/extensions_repository.dart';
import 'package:phoenix/features/extensions/presentation/screens/extensions_screen.dart';

import 'extensions_test_support.dart';

Widget _extensionsAt(Size size) {
  final repo = MockExtensionsRepository();
  when(() => repo.list(category: any(named: 'category'), query: any(named: 'query')))
      .thenAnswer((_) async => sampleEntries);
  return ProviderScope(
    overrides: [extensionsRepositoryProvider.overrideWithValue(repo)],
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: SizedBox.fromSize(
        size: size,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildPhoenixDarkTheme(),
          home: const ExtensionsScreen(),
        ),
      ),
    ),
  );
}

void main() {
  goldenTest(
    'extensions marketplace adapts across phone, tablet and desktop',
    fileName: 'extensions_responsive',
    builder: () => GoldenTestGroup(
      columns: 1,
      children: [
        for (final s in const [Size(390, 720), Size(834, 720), Size(1280, 720)])
          GoldenTestScenario(
            name: '${s.width.toInt()}x${s.height.toInt()}',
            constraints: BoxConstraints.tight(s),
            child: _extensionsAt(s),
          ),
      ],
    ),
  );
}
