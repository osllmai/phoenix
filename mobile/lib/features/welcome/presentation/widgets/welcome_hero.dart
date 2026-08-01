import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/responsive/breakpoints.dart';

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
    final phone = formFactorOf(context).isPhone;
    final logo = phone ? 64.0 : 84.0;
    final titleStyle = phone
        ? theme.textTheme.titleLarge
        : (showLogo ? theme.textTheme.headlineSmall : theme.textTheme.titleLarge);
    return Column(
      children: [
        if (emoji != null) ...[
          Text(emoji!, style: TextStyle(fontSize: phone ? 44 : 52)),
          const SizedBox(height: 12),
        ],
        if (showLogo) ...[
          SvgPicture.asset('assets/phoenix.svg', width: logo, height: logo),
          SizedBox(height: phone ? 12 : 16),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: titleStyle?.copyWith(fontWeight: FontWeight.w600),
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
