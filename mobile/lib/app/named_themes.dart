import 'package:flutter/material.dart';

import 'fonts.dart';
import 'named_themes_data.dart';

export 'named_themes_data.dart' show kNamedThemes;

class NamedThemePalette {
  const NamedThemePalette({
    required this.primary,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.onPrimary,
    required this.error,
    required this.divider,
  });

  final Color primary;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color onPrimary;
  final Color error;
  final Color divider;
}

class NamedTheme {
  const NamedTheme({
    required this.id,
    required this.name,
    required this.light,
    required this.dark,
  });

  final String id;
  final String name;
  final NamedThemePalette light;
  final NamedThemePalette dark;
}

NamedTheme? namedThemeById(String id) {
  for (final t in kNamedThemes) {
    if (t.id == id) return t;
  }
  return null;
}

ThemeData buildNamedTheme(NamedTheme theme, Brightness brightness,
    [String fontFamily = 'DMSans']) {
  final p = brightness == Brightness.dark ? theme.dark : theme.light;
  final scheme = ColorScheme.fromSeed(
    seedColor: p.primary,
    brightness: brightness,
  ).copyWith(
    primary: p.primary,
    onPrimary: p.onPrimary,
    surface: p.background,
    onSurface: p.textPrimary,
    surfaceContainerHighest: p.surfaceVariant,
    onSurfaceVariant: p.textSecondary,
    error: p.error,
    outline: p.divider,
  );

  final data = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: p.background,
    cardColor: p.surface,
    fontFamily: isBundledFont(fontFamily) ? fontFamily : null,
    appBarTheme: AppBarTheme(
      backgroundColor: p.background,
      foregroundColor: p.textPrimary,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.surfaceVariant,
      border: const OutlineInputBorder(),
    ),
  );
  return data.copyWith(textTheme: applyFontFamily(data.textTheme, fontFamily));
}
