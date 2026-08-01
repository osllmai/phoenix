import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../providers/welcome_controller.dart';
import '../providers/welcome_stage.dart';
import '../providers/welcome_state.dart';
import 'steps/choose_model_step.dart';
import 'steps/intro_step.dart';
import 'steps/privacy_step.dart';
import 'steps/ready_step.dart';
import 'welcome_footer.dart';
import 'welcome_hero.dart';
import 'welcome_step_indicator.dart';

/// The onboarding card. The step rail + caption sit on top; below, the hero and
/// the step body are side-by-side on tablet/desktop and stacked on phone.
class WelcomeCard extends ConsumerWidget {
  const WelcomeCard({super.key, this.onGetStarted});

  final VoidCallback? onGetStarted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(welcomeControllerProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final twoPane = formFactorOf(context).hasSidePane;

    final hero = _heroFor(state.stage);
    final body = switch (state.stage) {
      WelcomeStage.intro => const IntroStep(),
      WelcomeStage.chooseModel => const ChooseModelStep(),
      WelcomeStage.privacy => const PrivacyStep(),
      WelcomeStage.ready => const ReadyStep(),
    };

    final content = twoPane
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 300, child: hero),
              const SizedBox(width: 40),
              Expanded(child: body),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [hero, const SizedBox(height: 20), body],
          );

    return Card(
      elevation: 0,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: scheme.outline),
      ),
      child: Padding(
        padding: twoPane
            ? const EdgeInsets.fromLTRB(28, 28, 28, 20)
            : const EdgeInsets.fromLTRB(20, 22, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WelcomeStepIndicator(stage: state.stage, error: state.hasError),
            const SizedBox(height: 10),
            Text(_labelFor(state).toUpperCase(),
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: scheme.onSurfaceVariant, letterSpacing: 1.2)),
            const SizedBox(height: 24),
            content,
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),
            WelcomeFooter(onGetStarted: onGetStarted ?? () {}),
          ],
        ),
      ),
    );
  }

  WelcomeHero _heroFor(WelcomeStage stage) => switch (stage) {
        WelcomeStage.intro => const WelcomeHero(
            showLogo: true,
            title: 'Welcome to Phoenix',
            subtitle: 'Run AI entirely on your own machine. Private by default — '
                'nothing leaves your computer.'),
        WelcomeStage.chooseModel => const WelcomeHero(
            title: 'Pick your first model',
            subtitle: 'Downloaded once and kept on disk — runs fully on-device.'),
        WelcomeStage.privacy => const WelcomeHero(
            title: 'Your data stays on-device',
            subtitle: "Everything runs locally — here's what that means."),
        WelcomeStage.ready => const WelcomeHero(
            emoji: '🔥',
            title: "You're all set",
            subtitle: 'Phoenix is ready. Your models run entirely on this '
                'machine — nothing leaves.'),
      };

  String _labelFor(WelcomeState state) => switch ((state.stage, state.download)) {
        (WelcomeStage.chooseModel, DownloadStatus.downloading) => 'Downloading model',
        (WelcomeStage.chooseModel, DownloadStatus.error) => 'Download failed',
        (WelcomeStage.intro, _) => 'Welcome',
        (WelcomeStage.chooseModel, _) => 'Choose a model',
        (WelcomeStage.privacy, _) => 'Privacy',
        (WelcomeStage.ready, _) => 'All set',
      };
}
