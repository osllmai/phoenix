import 'package:flutter/material.dart';

import '../data/fleet_sample.dart';

class FleetMergeBanner extends StatefulWidget {
  const FleetMergeBanner({super.key, required this.merge});

  final FleetMerge merge;

  @override
  State<FleetMergeBanner> createState() => _FleetMergeBannerState();
}

class _FleetMergeBannerState extends State<FleetMergeBanner> {
  late String _branch = widget.merge.branches.first;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final onC = scheme.onPrimaryContainer;
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
              Icon(Icons.back_hand_outlined, size: 18, color: onC),
              const SizedBox(width: 8),
              Text(
                'Merge needs your OK',
                style: theme.textTheme.titleSmall?.copyWith(color: onC),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.merge.summary,
            style: theme.textTheme.bodySmall?.copyWith(color: onC),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: scheme.tertiary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  widget.merge.badge,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.tertiary,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'merge to',
                    style: theme.textTheme.labelSmall?.copyWith(color: onC),
                  ),
                  const SizedBox(width: 6),
                  DropdownButton<String>(
                    value: _branch,
                    isDense: true,
                    underline: const SizedBox.shrink(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                    items: [
                      for (final b in widget.merge.branches)
                        DropdownMenuItem(value: b, child: Text(b)),
                    ],
                    onChanged: (v) => setState(() => _branch = v ?? _branch),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  child: Text('Merge ${widget.merge.winner} ✓'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: () {}, child: const Text('Not yet')),
            ],
          ),
        ],
      ),
    );
  }
}
