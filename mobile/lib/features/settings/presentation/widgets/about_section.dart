import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_info.dart';
import 'setting_field.dart';
import 'settings_actions.dart';

class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final info = ref.watch(appInfoProvider).value;

    final rows = <(String, String)>[
      ('Phoenix', info == null ? '…' : '${info.version} (build ${info.build})'),
      ('Platform', info?.platform ?? '…'),
      ('Runtime', info?.runtime ?? '…'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingGroup(
          children: [
            for (final r in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(r.$1, style: Theme.of(context).textTheme.bodyMedium),
                    Text(
                      r.$2,
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
            FilledButton(
              onPressed: info == null
                  ? null
                  : () => notify(context,
                      "You're on Phoenix ${info.version} (build ${info.build})"),
              child: const Text('Check for updates'),
            ),
            OutlinedButton(
              onPressed: () => showLicensePage(
                context: context,
                applicationName: 'Phoenix',
                applicationVersion: info?.version,
              ),
              child: const Text('View licenses'),
            ),
            OutlinedButton(
              onPressed: info == null
                  ? null
                  : () => copyValue(context, info.logPath, 'Log path copied'),
              child: const Text('Open log folder'),
            ),
          ],
        ),
      ],
    );
  }
}
