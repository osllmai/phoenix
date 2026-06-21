import 'package:shared_preferences/shared_preferences.dart';

import '../providers/settings_state.dart';

abstract class SettingsRepository {
  Future<SettingsState> load();
  Future<void> save(SettingsState state);
}

/// Persists settings via the modern [SharedPreferencesAsync] API. One key per
/// field keeps the store forward-compatible as fields are added.
class PrefsSettingsRepository implements SettingsRepository {
  PrefsSettingsRepository([SharedPreferencesAsync? prefs])
      : _prefs = prefs ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _prefs;

  static const _kTheme = 'settings.theme';
  static const _kFontSize = 'settings.fontSize';
  static const _kAccent = 'settings.accentIndex';
  static const _kContext = 'settings.contextLength';
  static const _kGpuLayers = 'settings.gpuLayers';
  static const _kCpuThreads = 'settings.cpuThreads';
  static const _kTelemetry = 'settings.telemetry';
  static const _kUsageAnalytics = 'settings.usageAnalytics';

  @override
  Future<SettingsState> load() async {
    const d = SettingsState();
    final themeIndex = await _prefs.getInt(_kTheme);
    return SettingsState(
      theme: themeIndex == null
          ? d.theme
          : AppThemeMode.values[themeIndex.clamp(0, AppThemeMode.values.length - 1)],
      fontSize: await _prefs.getDouble(_kFontSize) ?? d.fontSize,
      accentIndex: await _prefs.getInt(_kAccent) ?? d.accentIndex,
      contextLength: await _prefs.getInt(_kContext) ?? d.contextLength,
      gpuLayers: await _prefs.getInt(_kGpuLayers) ?? d.gpuLayers,
      cpuThreads: await _prefs.getInt(_kCpuThreads) ?? d.cpuThreads,
      telemetry: await _prefs.getBool(_kTelemetry) ?? d.telemetry,
      usageAnalytics: await _prefs.getBool(_kUsageAnalytics) ?? d.usageAnalytics,
    );
  }

  @override
  Future<void> save(SettingsState s) async {
    await _prefs.setInt(_kTheme, s.theme.index);
    await _prefs.setDouble(_kFontSize, s.fontSize);
    await _prefs.setInt(_kAccent, s.accentIndex);
    await _prefs.setInt(_kContext, s.contextLength);
    await _prefs.setInt(_kGpuLayers, s.gpuLayers);
    await _prefs.setInt(_kCpuThreads, s.cpuThreads);
    await _prefs.setBool(_kTelemetry, s.telemetry);
    await _prefs.setBool(_kUsageAnalytics, s.usageAnalytics);
  }
}

/// In-memory backing used by widgets/tests so they never touch real storage.
class InMemorySettingsRepository implements SettingsRepository {
  InMemorySettingsRepository([this._state = const SettingsState()]);

  SettingsState _state;

  @override
  Future<SettingsState> load() async => _state;

  @override
  Future<void> save(SettingsState state) async => _state = state;
}
