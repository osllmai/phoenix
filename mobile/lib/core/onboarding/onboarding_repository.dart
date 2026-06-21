import 'package:shared_preferences/shared_preferences.dart';

/// Persists whether the first-run welcome wizard has been shown. Once seen, the
/// app boots straight to the workbench instead of onboarding again.
abstract class OnboardingRepository {
  Future<bool> seenWelcome();
  Future<void> markWelcomeSeen();
}

class PrefsOnboardingRepository implements OnboardingRepository {
  PrefsOnboardingRepository([SharedPreferencesAsync? prefs])
      : _prefs = prefs ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _prefs;
  static const _kSeen = 'onboarding.seenWelcome';

  @override
  Future<bool> seenWelcome() async => await _prefs.getBool(_kSeen) ?? false;

  @override
  Future<void> markWelcomeSeen() => _prefs.setBool(_kSeen, true);
}

/// In-memory backing used by widgets/tests so they never touch real storage.
class InMemoryOnboardingRepository implements OnboardingRepository {
  InMemoryOnboardingRepository([this._seen = false]);

  bool _seen;

  @override
  Future<bool> seenWelcome() async => _seen;

  @override
  Future<void> markWelcomeSeen() async => _seen = true;
}
