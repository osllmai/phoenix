import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_repository.dart';

/// Settings persistence. Defaults to [PrefsSettingsRepository]
/// (SharedPreferencesAsync); overridden with an in-memory fake in tests.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return PrefsSettingsRepository();
});
