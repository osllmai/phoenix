import 'package:flutter/material.dart';

import 'fonts.dart';

const _bg = Color(0xFFF5EFE6);
const _surface = Color(0xFFFFFDF9);
const _input = Color(0xFFFFFFFF);
const _border = Color(0xFFE3D7C3);
const _accentSubtle = Color(0xFFFBE7D6);
const _accentInk = Color(0xFFB0480C);
const _textPrimary = Color(0xFF2A2017);
const _textTertiary = Color(0xFF897A65);
const _onAccent = Color(0xFFFFFDF9);
const _error = Color(0xFFC15B52);
const _errorBg = Color(0xFFFBEDEB);
const _errorInk = Color(0xFFA8362E);

ThemeData buildPhoenixLightTheme(Color accent, [String fontFamily = 'DMSans']) {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: accent,
        brightness: Brightness.light,
      ).copyWith(
        primary: accent,
        onPrimary: _onAccent,
        primaryContainer: _accentSubtle,
        onPrimaryContainer: _accentInk,
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
    brightness: Brightness.light,
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
