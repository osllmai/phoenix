import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The Models sub-nav: Local · Hugging Face · Online · Providers. Mirrors the
/// in-page 4-tab row from the models mocks.
class ModelsTabBar extends StatelessWidget {
  const ModelsTabBar({super.key, required this.activePath});

  final String activePath;

  static const _tabs = [
    ('Local', '/models'),
    ('Hugging Face', '/models/browse'),
    ('Online · IndoxHub', '/models/online'),
    ('Providers', '/models/providers'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Row(
          children: [
            for (final t in _tabs) _tab(context, scheme, t.$1, t.$2),
          ],
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, ColorScheme scheme, String label, String path) {
    final active = path == activePath;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        onTap: active ? null : () => context.go(path),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: active ? Theme.of(context).cardColor : Colors.transparent,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(
                color: active ? scheme.outlineVariant : Colors.transparent),
          ),
          child: Text(label,
              style: TextStyle(
                  color: active ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
