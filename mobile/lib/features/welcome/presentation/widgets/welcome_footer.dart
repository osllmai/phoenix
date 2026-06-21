import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/welcome_controller.dart';
import '../providers/welcome_stage.dart';

/// The wizard footer. Its buttons change per step (and per download sub-state).
class WelcomeFooter extends ConsumerWidget {
  const WelcomeFooter({super.key, required this.onGetStarted});

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(welcomeControllerProvider);
    final c = ref.read(welcomeControllerProvider.notifier);

    final children = switch ((state.stage, state.download)) {
      (WelcomeStage.intro, _) => [
          const Spacer(),
          FilledButton(onPressed: c.next, child: const Text('Get started')),
        ],
      (WelcomeStage.chooseModel, DownloadStatus.downloading) => [
          OutlinedButton(onPressed: c.cancelDownload, child: const Text('Cancel')),
          const Spacer(),
          const _Note('You can keep using Phoenix while this finishes'),
        ],
      (WelcomeStage.chooseModel, DownloadStatus.error) => [
          OutlinedButton(
              onPressed: c.cancelDownload, child: const Text('Choose another')),
          const Spacer(),
          FilledButton(onPressed: c.startDownload, child: const Text('Retry download')),
        ],
      (WelcomeStage.chooseModel, _) => [
          OutlinedButton(onPressed: c.back, child: const Text('Back')),
          const Spacer(),
          TextButton(onPressed: c.startDownload, child: const Text('Download')),
          const SizedBox(width: 8),
          FilledButton(onPressed: c.next, child: const Text('Continue')),
        ],
      (WelcomeStage.ready, _) => [
          OutlinedButton(onPressed: c.back, child: const Text('Back')),
          const Spacer(),
          FilledButton(onPressed: onGetStarted, child: const Text('Enter Phoenix')),
        ],
      _ => [
          OutlinedButton(onPressed: c.back, child: const Text('Back')),
          const Spacer(),
          FilledButton(onPressed: c.next, child: const Text('Continue')),
        ],
    };

    return Row(children: children);
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Flexible(
      child: Text(text,
          textAlign: TextAlign.end,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: scheme.onSurfaceVariant)),
    );
  }
}
