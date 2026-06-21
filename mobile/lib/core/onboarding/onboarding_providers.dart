import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'onboarding_repository.dart';

/// The onboarding store. Overridden in `main()` with the prefs-backed impl and
/// in tests with the in-memory fake.
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return PrefsOnboardingRepository();
});

/// Whether the welcome wizard has already been shown. Read once at startup and
/// injected via override so the router can branch synchronously. Defaults to
/// `true` (skip onboarding) when not overridden, so tests never route to it
/// unexpectedly.
final seenWelcomeProvider = Provider<bool>((ref) => true);
