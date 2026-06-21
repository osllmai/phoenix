import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix/app/theme.dart';
import 'package:phoenix/features/developer/presentation/screens/developer_screen.dart';

Widget _developerAt(Size size) {
  return ProviderScope(
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: SizedBox.fromSize(
        size: size,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildPhoenixDarkTheme(),
          home: const DeveloperScreen(),
        ),
      ),
    ),
  );
}

void main() {
  goldenTest(
    'developer console adapts across phone, tablet and desktop',
    fileName: 'developer_responsive',
    builder: () => GoldenTestGroup(
      columns: 1,
      children: [
        for (final s in const [Size(390, 720), Size(834, 720), Size(1280, 720)])
          GoldenTestScenario(
            name: '${s.width.toInt()}x${s.height.toInt()}',
            constraints: BoxConstraints.tight(s),
            child: _developerAt(s),
          ),
      ],
    ),
  );
}
