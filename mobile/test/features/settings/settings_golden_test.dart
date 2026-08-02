import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix/app/theme.dart';
import 'package:phoenix/l10n/app_localizations.dart';
import 'package:phoenix/features/models/data/device_capabilities.dart';
import 'package:phoenix/features/settings/presentation/data/settings_repository.dart';
import 'package:phoenix/features/settings/presentation/providers/settings_providers.dart';
import 'package:phoenix/features/settings/presentation/screens/settings_screen.dart';
import 'package:phoenix_core/phoenix_core.dart';

Widget _settingsAt(Size size) {
  return ProviderScope(
    overrides: [
      settingsRepositoryProvider.overrideWithValue(InMemorySettingsRepository()),
      // Pin capabilities so the engine section renders deterministically
      // (CPU-thread max would otherwise vary with the test machine's cores).
      deviceCapabilitiesProvider.overrideWith((ref) async =>
          DeviceCapabilities.cpuOnly(
              platform: 'linux', cpuCores: 8, ramBytes: 16 << 30)),
    ],
    child: MediaQuery(
      data: MediaQueryData(size: size),
      child: SizedBox.fromSize(
        size: size,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildPhoenixDarkTheme(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
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
