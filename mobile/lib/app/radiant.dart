import 'package:flutter/material.dart';

const radiantGap = 12.0;
const radiantPanelRadius = 18.0;

const _shadowStrong = Color(0x73000000);
const _shadowSoft = Color(0x59000000);
const _lightShadow = Color(0x14000000);

bool _isLight(ColorScheme s) => s.brightness == Brightness.light;

/// Lightness-shifted variant of [c] (keeps hue/saturation) — used to derive the
/// panel/backdrop depth from the theme's surface so the frame follows any theme.
Color _shift(Color c, double dl) {
  final h = HSLColor.fromColor(c);
  return h.withLightness((h.lightness + dl).clamp(0.0, 1.0)).toColor();
}

Color _panelBase(ColorScheme s) =>
    _shift(s.surface, _isLight(s) ? 0.045 : 0.05);

/// The gradient backdrop the floating panels sit on — derived from the theme
/// surface so it re-themes with the active color theme / brightness.
BoxDecoration radiantBackdropDecoration(ColorScheme s) => BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: _isLight(s)
            ? [_shift(s.surface, 0.02), s.surface, _shift(s.surface, -0.03)]
            : [
                _shift(s.surface, 0.02),
                s.surface,
                _shift(s.surface, -0.04),
                _shift(s.surface, -0.055),
              ],
      ),
    );

/// A floating card surface, derived from the theme (lighter than the backdrop).
BoxDecoration radiantPanelDecoration(ColorScheme s) {
  final base = _panelBase(s);
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [_shift(base, 0.012), base, _shift(base, -0.02)],
    ),
    border: Border.all(
      color: _isLight(s)
          ? s.outlineVariant
          : s.onSurface.withValues(alpha: 0.06),
    ),
    borderRadius: BorderRadius.circular(radiantPanelRadius),
    boxShadow: _isLight(s)
        ? const [BoxShadow(color: _lightShadow, blurRadius: 24, offset: Offset(0, 10))]
        : const [
            BoxShadow(color: _shadowStrong, blurRadius: 34, offset: Offset(0, 12)),
            BoxShadow(color: _shadowSoft, blurRadius: 8, offset: Offset(0, 2)),
          ],
  );
}

BoxDecoration radiantBackdrop(ColorScheme s) => radiantBackdropDecoration(s);

/// A faint top sheen on dark panels (skipped in light, where it is invisible).
BoxDecoration radiantPanelSheen(ColorScheme s) => _isLight(s)
    ? const BoxDecoration()
    : const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x09FFFFFF), Color(0x00FFFFFF)],
          stops: [0.0, 0.22],
        ),
      );

/// Active highlight tinted by the theme accent (sidebar selection).
BoxDecoration radiantEmberHighlight(ColorScheme s) => BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          s.primary.withValues(alpha: 0.18),
          s.primary.withValues(alpha: 0.08),
        ],
      ),
      border: Border.all(color: s.primary.withValues(alpha: 0.22)),
      borderRadius: BorderRadius.circular(10),
    );

/// Neutral active highlight (section-nav selection) — derived from onSurface.
BoxDecoration radiantNeutralHighlight(ColorScheme s) => BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          s.onSurface.withValues(alpha: 0.07),
          s.onSurface.withValues(alpha: 0.03),
        ],
      ),
      border: Border.all(color: s.onSurface.withValues(alpha: 0.08)),
      borderRadius: BorderRadius.circular(12),
    );

/// Foreground for a selected nav item — the theme accent, readable in any theme.
Color radiantSelectedInk(ColorScheme s) => s.primary;

/// A floating radiant card: theme-derived gradient + sheen + border + shadow.
class RadiantPanel extends StatelessWidget {
  const RadiantPanel({super.key, required this.child, this.width});

  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: radiantPanelDecoration(scheme),
      child: DecoratedBox(decoration: radiantPanelSheen(scheme), child: child),
    );
  }
}

/// The theme-derived gradient backdrop the floating panels sit on.
class RadiantBackdrop extends StatelessWidget {
  const RadiantBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: radiantBackdropDecoration(Theme.of(context).colorScheme),
        child: child,
      );
}
