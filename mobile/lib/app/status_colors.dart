import 'package:flutter/material.dart';

/// Semantic colors that have no ColorScheme slot — status dots, capability
/// badges, provider tones. One source so a change lands once instead of in a
/// dozen widgets; `theme.dart` still owns everything ColorScheme covers.
///
/// Badge pairs are tuned for the dark theme. Light-theme variants are a known
/// gap — see TRACKER P4.6.
class StatusColors {
  const StatusColors._();

  static const secure = Color(0xFF6FCF97);
  static const online = Color(0xFF6FB585);
  static const success = Color(0xFF4E9A6B);
  static const successInk = Color(0xFF2C7048);
  static const warning = Color(0xFFC9911F);
  static const info = Color(0xFF5B8BA5);
  static const infoInk = Color(0xFF8FB6CC);
  static const plum = Color(0xFF8A6CA8);
  static const danger = Color(0xFFE5645A);
  static const neutral = Color(0xFF6B5E50);
  /// Provider brand dot; `ember` in the web accent palette.
  static const ember = Color(0xFFFF8A3D);
}

/// Foreground/background pair for a pill badge.
typedef BadgeTone = ({Color fg, Color bg});

class BadgeTones {
  const BadgeTones._();

  static const runnable = (fg: Color(0xFF84CC9C), bg: Color(0xFF1C2A20));
  static const marginal = (fg: Color(0xFFFFB070), bg: Color(0xFF3A2415));
  static const vision = (fg: Color(0xFF93BBD0), bg: Color(0xFF18242C));
  static const reasoning = (fg: Color(0xFFC6B2D9), bg: Color(0xFF271E33));
  static const tools = (fg: Color(0xFF7FD8C7), bg: Color(0xFF152A26));
}
