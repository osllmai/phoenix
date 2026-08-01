import 'package:flutter/material.dart';

import '../../../../../core/responsive/breakpoints.dart';
import '../../providers/welcome_content.dart';
import '../parts/feature_tile.dart';

/// Step 1 content — the four pillars. A single full-width column on phone (so
/// titles never break mid-word in a cramped cell); a 2×2 grid on tablet/desktop.
class IntroStep extends StatelessWidget {
  const IntroStep({super.key});

  @override
  Widget build(BuildContext context) {
    if (formFactorOf(context).isPhone) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < welcomeFeatures.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            FeatureTile(feature: welcomeFeatures[i]),
          ],
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _row(welcomeFeatures[0], welcomeFeatures[1]),
        const SizedBox(height: 12),
        _row(welcomeFeatures[2], welcomeFeatures[3]),
      ],
    );
  }

  Widget _row(WelcomeFeature a, WelcomeFeature b) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: FeatureTile(feature: a)),
            const SizedBox(width: 12),
            Expanded(child: FeatureTile(feature: b)),
          ],
        ),
      );
}
