import 'package:flutter/material.dart';

import 'named_themes.dart';
import 'named_themes_data_extra.dart';

const _copper = NamedTheme(
  id: 'copper',
  name: 'Copper',
  light: NamedThemePalette(
    primary: Color(0xFFB87333),
    background: Color(0xFFFFFBF7),
    surface: Color(0xFFFAF5EF),
    surfaceVariant: Color(0xFFFAF5EF),
    textPrimary: Color(0xFF1C1210),
    textSecondary: Color(0xFF78716C),
    textHint: Color(0xFFA8A29E),
    onPrimary: Color(0xFFFFFFFF),
    error: Color(0xFFDC2626),
    divider: Color(0xFFF5F0EB),
  ),
  dark: NamedThemePalette(
    primary: Color(0xFFD4915A),
    background: Color(0xFF110E0C),
    surface: Color(0xFF1A1614),
    surfaceVariant: Color(0xFF1A1614),
    textPrimary: Color(0xFFF5F0EB),
    textSecondary: Color(0xFFA8A29E),
    textHint: Color(0xFF78716C),
    onPrimary: Color(0xFFFFFFFF),
    error: Color(0xFFDC2626),
    divider: Color(0xFF302824),
  ),
);

const _indox = NamedTheme(
  id: 'indox',
  name: 'Indox',
  light: NamedThemePalette(
    primary: Color(0xFF1F3AB3),
    background: Color(0xFFFBFBFF),
    surface: Color(0xFFFBFBFF),
    surfaceVariant: Color(0xFFEEF0F5),
    textPrimary: Color(0xFF252525),
    textSecondary: Color(0xFF434D5A),
    textHint: Color(0xFF9BA3AE),
    onPrimary: Color(0xFFFFFFFF),
    error: Color(0xFFF00500),
    divider: Color(0xFFCDD0D8),
  ),
  dark: NamedThemePalette(
    primary: Color(0xFF4989FF),
    background: Color(0xFF081125),
    surface: Color(0xFF081125),
    surfaceVariant: Color(0xFF0C204E),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF9BA3AE),
    textHint: Color(0xFF434D5A),
    onPrimary: Color(0xFF081125),
    error: Color(0xFFF00500),
    divider: Color(0xFF1A3B8B),
  ),
);

const _obsidian = NamedTheme(
  id: 'obsidian',
  name: 'Obsidian',
  light: NamedThemePalette(
    primary: Color(0xFF334155),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF1F5F9),
    surfaceVariant: Color(0xFFF1F5F9),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF64748B),
    textHint: Color(0xFF94A3B8),
    onPrimary: Color(0xFFFFFFFF),
    error: Color(0xFFDC2626),
    divider: Color(0xFFE2E8F0),
  ),
  dark: NamedThemePalette(
    primary: Color(0xFF94A3B8),
    background: Color(0xFF0F172A),
    surface: Color(0xFF1E293B),
    surfaceVariant: Color(0xFF1E293B),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    textHint: Color(0xFF64748B),
    onPrimary: Color(0xFFFFFFFF),
    error: Color(0xFFDC2626),
    divider: Color(0xFF334155),
  ),
);

const kNamedThemes = <NamedTheme>[
  _copper,
  _indox,
  _obsidian,
  kIndigoTheme,
  kStudioTheme,
  kPencillyTheme,
  kNewsTheme,
];
