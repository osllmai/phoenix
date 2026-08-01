import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/presentation/providers/settings_controller.dart';
import '../features/settings/presentation/providers/settings_state.dart';
import '../l10n/app_localizations.dart';
import 'locale.dart';
import 'router.dart';
import 'theme.dart';

class PhoenixApp extends ConsumerWidget {
  const PhoenixApp({super.key});

  ThemeMode _themeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(settingsControllerProvider).value ?? const SettingsState();
    final accent = settings.accentIndex;
    final colorTheme = settings.colorTheme;
    final scale = settings.fontSize / 15.0;

    return MaterialApp.router(
      title: 'Phoenix',
      theme: buildPhoenixTheme(
        mode: AppThemeMode.light,
        accentIndex: accent,
        colorTheme: colorTheme,
        fontFamily: settings.fontFamily,
      ),
      darkTheme: buildPhoenixTheme(
        mode: AppThemeMode.dark,
        accentIndex: accent,
        colorTheme: colorTheme,
        fontFamily: settings.fontFamily,
      ),
      themeMode: _themeMode(settings.theme),
      locale: ref.watch(localeProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: TextScaler.linear(scale)),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
