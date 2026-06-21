import 'package:flutter/material.dart';

/// Phoenix dark theme — mirrors `design/pattern/tokens` (ember on warm charcoal).
/// This is the design-token source layer; replace with a generated
/// `app_tokens.g.dart` when the token emitter lands.
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

ThemeData buildPhoenixDarkTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: _accent,
        brightness: Brightness.dark,
      ).copyWith(
        primary: _accent,
        onPrimary: _ink,
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

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: _bg,
    cardColor: _surface,
    fontFamily: 'DMSans',
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
}
