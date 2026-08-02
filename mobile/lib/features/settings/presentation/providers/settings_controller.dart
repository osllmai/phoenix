import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'settings_providers.dart';
import 'settings_state.dart';

part 'settings_controller.g.dart';

/// Loads persisted preferences on build and writes each change back through the
/// [SettingsRepository]. `activeSection` is transient UI state (not persisted).
@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<SettingsState> build() => ref.watch(settingsRepositoryProvider).load();

  Future<void> _update(SettingsState next) async {
    state = AsyncData(next);
    await ref.read(settingsRepositoryProvider).save(next);
  }

  SettingsState get _current => state.value ?? const SettingsState();

  Future<void> setTheme(AppThemeMode theme) =>
      _update(_current.copyWith(theme: theme));
  Future<void> setFontSize(double v) =>
      _update(_current.copyWith(fontSize: v));
  Future<void> setAccent(int i) => _update(_current.copyWith(accentIndex: i));
  Future<void> setColorTheme(String id) =>
      _update(_current.copyWith(colorTheme: id));
  Future<void> setFontFamily(String f) =>
      _update(_current.copyWith(fontFamily: f));
  Future<void> setChatModel(String v) =>
      _update(_current.copyWith(chatModel: v));
  Future<void> setEmbedModel(String v) =>
      _update(_current.copyWith(embedModel: v));
  Future<void> setAccelerator(String v) =>
      _update(_current.copyWith(accelerator: v));
  Future<void> setContextLength(int v) =>
      _update(_current.copyWith(contextLength: v));
  Future<void> setGpuLayers(int v) =>
      _update(_current.copyWith(gpuLayers: v));
  Future<void> setCpuThreads(int v) =>
      _update(_current.copyWith(cpuThreads: v));
  Future<void> setTelemetry(bool v) =>
      _update(_current.copyWith(telemetry: v));
  Future<void> setUsageAnalytics(bool v) =>
      _update(_current.copyWith(usageAnalytics: v));
  Future<void> setLanguage(String v) =>
      _update(_current.copyWith(language: v));
  Future<void> setStartupView(String v) =>
      _update(_current.copyWith(startupView: v));
  Future<void> setDefaultModel(String v) =>
      _update(_current.copyWith(defaultModel: v));
  Future<void> setLaunchAtLogin(bool v) =>
      _update(_current.copyWith(launchAtLogin: v));
  Future<void> setDatabase(String v) =>
      _update(_current.copyWith(database: v));
  Future<void> setDatabaseUrl(String v) =>
      _update(_current.copyWith(databaseUrl: v));
  Future<void> setDataLocation(String v) =>
      _update(_current.copyWith(dataLocation: v));
  Future<void> setServerPort(int v) =>
      _update(_current.copyWith(serverPort: v));

  void openSection(String id) =>
      state = AsyncData(_current.copyWith(activeSection: id));
}
