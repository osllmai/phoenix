import 'package:flutter/material.dart';

import '../data/maestro_sample.dart';

class MaestroPairBar extends StatelessWidget {
  const MaestroPairBar({super.key, required this.pair});

  final MaestroPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: scheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  pair.label,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: scheme.onPrimaryContainer),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            pair.host,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
