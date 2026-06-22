import 'package:flutter/material.dart';

import '../data/maestro_sample.dart';

class MaestroApprovalBanner extends StatelessWidget {
  const MaestroApprovalBanner({super.key, required this.approval});

  final MaestroApproval approval;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.back_hand_outlined,
                  size: 18, color: scheme.onPrimaryContainer),
              const SizedBox(width: 8),
              Text(
                approval.title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: scheme.onPrimaryContainer),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            approval.detail,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: scheme.onPrimaryContainer),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  child: const Text('Approve ✓'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Decline'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
