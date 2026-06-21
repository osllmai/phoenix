import 'package:flutter/material.dart';
import 'package:phoenix_core/phoenix_core.dart';

import 'pulsing_dot.dart';

/// Banner at the top of the catalog showing the currently loaded/active model.
class ActiveModelBanner extends StatelessWidget {
  const ActiveModelBanner({super.key, required this.model});

  final AiModel model;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      color: cs.primaryContainer,
      child: ListTile(
        leading: const SizedBox(
          width: 24,
          height: 24,
          child: Center(child: PulsingDot(size: 12)),
        ),
        title: Text(
          model.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: cs.onPrimaryContainer,
          ),
        ),
        subtitle: Text(
          'Active — loaded in the engine',
          style: TextStyle(color: cs.onPrimaryContainer),
        ),
        trailing: const Chip(label: Text('Active')),
      ),
    );
  }
}
