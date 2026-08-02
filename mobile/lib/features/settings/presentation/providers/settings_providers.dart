import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_repository.dart';

/// Settings persistence. Overridden in `main()` with a
/// [JsonFileSettingsRepository] (settings.json); defaults to in-memory so
/// widgets/tests work standalone.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return InMemorySettingsRepository();
});
