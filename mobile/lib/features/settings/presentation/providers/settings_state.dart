import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

enum AppThemeMode { dark, cream, system }

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(AppThemeMode.dark) AppThemeMode theme,
    @Default(15.0) double fontSize,
    @Default(0) int accentIndex,
    @Default(8192) int contextLength,
    @Default(32) int gpuLayers,
    @Default(8) int cpuThreads,
    @Default(false) bool telemetry,
    @Default(false) bool usageAnalytics,
    @Default('appearance') String activeSection,
  }) = _SettingsState;
}
