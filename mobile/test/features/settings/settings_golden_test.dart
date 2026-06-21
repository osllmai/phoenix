import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix/app/theme.dart';
import 'package:phoenix/features/settings/presentation/data/settings_repository.dart';
import 'package:phoenix/features/settings/presentation/providers/settings_providers.dart';
import 'package:phoenix/features/settings/presentation/screens/settings_screen.dart';

Widget _settingsAt(Size size) {
  return ProviderScope(
    overrides: [
      settingsRepositoryProvider.overrideWithValue(InMemorySettingsRepository()),
    ],
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: SizedBox.fromSize(
        size: size,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildPhoenixDarkTheme(),
          home: const SettingsScreen(),
        ),
      ),
    ),
  );
}

void main() {
  goldenTest(
    'settings surface adapts across phone, tablet and desktop',
    fileName: 'settings_responsive',
    builder: () => GoldenTestGroup(
      columns: 1,
      children: [
        for (final s in const [Size(390, 720), Size(834, 720), Size(1280, 720)])
          GoldenTestScenario(
            name: '${s.width.toInt()}x${s.height.toInt()}',
            constraints: BoxConstraints.tight(s),
            child: _settingsAt(s),
          ),
      ],
    ),
  );
}
