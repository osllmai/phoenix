import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The card header: an optional ember badge, a title and an optional subtitle.
class WelcomeHero extends StatelessWidget {
  const WelcomeHero({
    super.key,
    required this.title,
    this.subtitle,
    this.showLogo = false,
    this.emoji,
  });

  final String title;
  final String? subtitle;
  final bool showLogo;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      children: [
        if (emoji != null) ...[
          Text(emoji!, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 12),
        ],
        if (showLogo) ...[
          SvgPicture.asset('assets/phoenix.svg', width: 84, height: 84),
          const SizedBox(height: 16),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: (showLogo ? theme.textTheme.headlineSmall : theme.textTheme.titleLarge)
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant, height: 1.4),
            ),
          ),
        ],
      ],
    );
  }
}
