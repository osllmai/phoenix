import 'package:flutter/material.dart';

import 'dashboard_card.dart';

class _Tip {
  const _Tip(this.icon, this.title, this.subtitle);
  final String icon;
  final String title;
  final String subtitle;
}

const _tips = [
  _Tip('⌘', 'Quick switch', 'Press ⌘K to jump to any model, chat, or document.'),
  _Tip('🔌', 'Use the API', 'Point any OpenAI/Anthropic client at your local server.'),
  _Tip('📄', 'Chat with docs', 'Add a PDF, then ask questions grounded in its content.'),
];

class TipsStrip extends StatelessWidget {
  const TipsStrip({super.key, this.stacked = false});

  final bool stacked;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'Tips & getting started',
      child: stacked
          ? Column(
              children: [
                for (final t in _tips)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _TipTile(tip: t),
                  ),
              ],
            )
          : Row(
              children: [
                for (final t in _tips) ...[
                  Expanded(child: _TipTile(tip: t)),
                  if (t != _tips.last) const SizedBox(width: 12),
                ],
              ],
            ),
    );
  }
}

class _TipTile extends StatelessWidget {
  const _TipTile({required this.tip});

  final _Tip tip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tip.icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            tip.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            tip.subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
