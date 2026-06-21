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

  void openSection(String id) =>
      state = AsyncData(_current.copyWith(activeSection: id));
}
