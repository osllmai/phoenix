import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/feature/feature_registry.dart';
import '../../../../core/onboarding/onboarding_providers.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../widgets/welcome_card.dart';

/// First-run onboarding. A centered card on every form factor — wider on
/// desktop, compact on phone — over a soft top gradient stage.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key, this.onDone});

  /// Called when the user taps Get Started; defaults to routing into the app.
  final VoidCallback? onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ff = formFactorOf(context);
    final scheme = Theme.of(context).colorScheme;
    final maxWidth = switch (ff) {
      FormFactor.desktop => 960.0,
      FormFactor.tablet => 860.0,
      FormFactor.phone => 440.0,
    };

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -1.4),
            radius: 1.1,
            colors: [
              scheme.primaryContainer.withValues(alpha: 0.35),
              scheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: WelcomeCard(
                  onGetStarted: onDone ?? () => _enter(context, ref),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _enter(BuildContext context, WidgetRef ref) {
    ref.read(onboardingRepositoryProvider).markWelcomeSeen();
    if (context.canPop()) {
      context.pop();
      return;
    }
    final nav = ref.read(featureRegistryProvider).navItems();
    context.go(nav.isNotEmpty ? nav.first.path : '/home');
  }
}
