import 'package:flutter/material.dart';

import 'setting_field.dart';

const _versions = <(String, String)>[
  ('Phoenix', '0.9.1 (build 412)'),
  ('llama.cpp engine', 'b3456 · GGUF 3'),
  ('Flutter runtime', '3.22.1 · Dart 3.4.1'),
  ('Platform', 'Linux · on-device'),
];

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingGroup(
          children: [
            for (final v in _versions)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(v.$1, style: Theme.of(context).textTheme.bodyMedium),
                    Text(
                      v.$2,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
          ],
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton(onPressed: () {}, child: const Text('Check for updates')),
            OutlinedButton(onPressed: () {}, child: const Text('View licenses')),
            OutlinedButton(onPressed: () {}, child: const Text('Open log folder')),
          ],
        ),
      ],
    );
  }
}
