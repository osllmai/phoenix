import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Desktop-class platforms run the full workbench; mobile (Android/iOS) is a
/// companion, so desktop-only features (server console, DeepSearch) gate to a
/// "best on desktop" panel regardless of screen width.
bool get isDesktopPlatform =>
    defaultTargetPlatform == TargetPlatform.linux ||
    defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.windows;

/// The three form factors every Phoenix surface targets. Features switch layout
/// on these (not on raw pixels) so all screens break at the same thresholds.
enum FormFactor { phone, tablet, desktop }

/// Width thresholds in logical pixels. Below [tablet] = phone; [tablet] up to
/// [desktop] = tablet; [desktop] and wider = desktop.
abstract final class Breakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;
}

FormFactor formFactorForWidth(double width) {
  if (width >= Breakpoints.desktop) return FormFactor.desktop;
  if (width >= Breakpoints.tablet) return FormFactor.tablet;
  return FormFactor.phone;
}

FormFactor formFactorOf(BuildContext context) =>
    formFactorForWidth(MediaQuery.sizeOf(context).width);

extension FormFactorX on FormFactor {
  bool get isPhone => this == FormFactor.phone;
  bool get isDesktop => this == FormFactor.desktop;

  /// Tablet and desktop show side-by-side panes; phone is single-pane + drawer.
  bool get hasSidePane => this != FormFactor.phone;
}
