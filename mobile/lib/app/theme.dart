import 'package:flutter/material.dart';

import '../features/settings/presentation/providers/settings_state.dart';
import 'fonts.dart';
import 'named_themes.dart';
import 'theme_light.dart';

const kAccentColors = [
  Color(0xFFFF8A3D),
  Color(0xFF7FB069),
  Color(0xFF5AA9E6),
  Color(0xFFB57EDC),
  Color(0xFFE6B95A),
];

const _bg = Color(0xFF17120E);
const _surface = Color(0xFF221A13);
const _input = Color(0xFF2B2018);
const _border = Color(0xFF3A2C20);
const _ink = Color(0xFF1A130D);
const _accent = Color(0xFFFF8A3D);
const _accentSubtle = Color(0xFF3A2415);
const _accentInk = Color(0xFFFFB070);
const _textPrimary = Color(0xFFF5EFE8);
const _textTertiary = Color(0xFF9C8B78);
const _error = Color(0xFFE5645A);
const _errorBg = Color(0xFF2E1A17);
const _errorInk = Color(0xFFF0938A);

int _safeAccent(int i) => (i >= 0 && i < kAccentColors.length) ? i : 0;

ThemeData buildPhoenixTheme({
  required AppThemeMode mode,
  required int accentIndex,
  String colorTheme = 'phoenix',
  String fontFamily = 'DMSans',
}) {
  final brightness =
      mode == AppThemeMode.light ? Brightness.light : Brightness.dark;
  final named = colorTheme == 'phoenix' ? null : namedThemeById(colorTheme);
  if (named != null) {
    return buildNamedTheme(named, brightness, fontFamily);
  }
  if (mode == AppThemeMode.light) {
    return buildPhoenixLightTheme(
      kAccentColors[_safeAccent(accentIndex)],
      fontFamily,
    );
  }
  return _buildDark(accentIndex, fontFamily);
}

ThemeData _buildDark(int accentIndex, String fontFamily) {
  final seed = accentIndex == 0
      ? _accent
      : kAccentColors[_safeAccent(accentIndex)];
  final scheme =
      ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      ).copyWith(
        primary: seed,
        onPrimary: _ink,
        primaryContainer: accentIndex == 0 ? _accentSubtle : null,
        onPrimaryContainer: accentIndex == 0 ? _accentInk : null,
        surface: _bg,
        onSurface: _textPrimary,
        surfaceContainerHighest: _input,
        onSurfaceVariant: _textTertiary,
        error: _error,
        errorContainer: _errorBg,
        onErrorContainer: _errorInk,
        outline: _border,
      );

  final data = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: _bg,
    cardColor: _surface,
    fontFamily: isBundledFont(fontFamily) ? fontFamily : null,
    appBarTheme: const AppBarTheme(
      backgroundColor: _bg,
      foregroundColor: _textPrimary,
      elevation: 0,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: _input,
      border: OutlineInputBorder(),
    ),
  );
  return data.copyWith(textTheme: applyFontFamily(data.textTheme, fontFamily));
}

ThemeData buildPhoenixDarkTheme() =>
    buildPhoenixTheme(mode: AppThemeMode.dark, accentIndex: 0);
