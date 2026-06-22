import 'package:flutter/material.dart';

import '../../../data/online_catalog_stub.dart';

const _green = Color(0xFF6FB585);

/// A hosted-model card on the Online screen: icon, name + id, badges, a pricing/
/// latency meta grid, a comment and the select / default / use-for-chat footer.
class OnlineModelCard extends StatelessWidget {
  const OnlineModelCard({
    super.key,
    required this.model,
    required this.selected,
    required this.isDefault,
    required this.onToggle,
    required this.onSetDefault,
  });

  final OnlineModel model;
  final bool selected;
  final bool isDefault;
  final ValueChanged<bool> onToggle;
  final VoidCallback onSetDefault;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final border = selected
        ? scheme.primary
        : isDefault
            ? _green
            : scheme.outlineVariant;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: selected ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _top(theme),
          const SizedBox(height: 8),
          _badges(scheme),
          const SizedBox(height: 8),
          _meta(theme),
          const SizedBox(height: 8),
          Text(model.comment,
              style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant, fontStyle: FontStyle.italic)),
          const SizedBox(height: 10),
          _footer(theme),
        ],
      ),
    );
  }

  Widget _top(ThemeData theme) {
    final scheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(value: selected, onChanged: (v) => onToggle(v ?? false)),
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(8)),
          child: Text(model.icon, style: const TextStyle(fontSize: 16)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Flexible(
                    child: Text(model.name,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600))),
                if (isDefault) _chip(theme, 'Default', _green, scheme.onPrimary),
              ]),
              Text(model.id,
                  style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant, fontFamily: 'monospace')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _badges(ColorScheme scheme) => Wrap(spacing: 4, runSpacing: 4, children: [
        if (model.recBadge != null)
          _badge(model.recBadge!, _green.withValues(alpha: 0.18), _green),
        if (model.vision)
          _badge('Vision', const Color(0xFF5B8BA5).withValues(alpha: 0.18),
              const Color(0xFF8FB6CC)),
        if (model.tools)
          _badge('Tools', scheme.primaryContainer, scheme.onPrimaryContainer),
      ]);

  Widget _meta(ThemeData theme) {
    final items = [
      ('Context', model.ctx),
      ('Input', '${model.input}/1M'),
      ('Output', '${model.output}/1M'),
      ('Latency', model.latency),
      ('Tput', '${model.tput} tok/s'),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        for (final (label, val) in items)
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            Text(val,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w500)),
          ]),
      ],
    );
  }

  Widget _footer(ThemeData theme) {
    final scheme = theme.colorScheme;
    return OverflowBar(
      spacing: 6,
      overflowSpacing: 6,
      alignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(onPressed: () {}, child: const Text('Details')),
        TextButton(
            onPressed: onSetDefault,
            child: Text(isDefault ? '★ Default' : 'Set default')),
        FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.cloud_outlined, size: 16),
            label: const Text('Use'),
            style: FilledButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary)),
      ],
    );
  }

  Widget _badge(String text, Color bg, Color fg) => _chip(null, text, bg, fg);

  Widget _chip(ThemeData? theme, String text, Color bg, Color fg) => Container(
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
            color: bg, borderRadius: BorderRadius.circular(999)),
        child: Text(text,
            style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w500)),
      );
}
