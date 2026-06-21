import 'package:flutter/material.dart';

import '../../providers/welcome_content.dart';
import '../parts/feature_tile.dart';

/// Step 1 content — the 2×2 grid of the four pillars (hero is in the pane).
class IntroStep extends StatelessWidget {
  const IntroStep({super.key});

  @override
  Widget build(BuildContext context) {
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
