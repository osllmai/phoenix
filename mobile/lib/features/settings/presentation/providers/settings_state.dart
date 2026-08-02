import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

enum AppThemeMode { dark, light, system }

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(AppThemeMode.dark) AppThemeMode theme,
    @Default(15.0) double fontSize,
    @Default(0) int accentIndex,
    @Default('phoenix') String colorTheme,
    @Default('DMSans') String fontFamily,
    @Default('Llama-3.1-8B-Instruct · Q4_K_M') String chatModel,
    @Default('nomic-embed-text-v1.5') String embedModel,
    @Default('CPU only') String accelerator,
    @Default(8192) int contextLength,
    @Default(32) int gpuLayers,
    @Default(8) int cpuThreads,
    @Default(false) bool telemetry,
    @Default(false) bool usageAnalytics,
    @Default('English (US)') String language,
    @Default('Home dashboard') String startupView,
    @Default('Llama-3.1-8B-Instruct · Q4_K_M') String defaultModel,
    @Default(false) bool launchAtLogin,
    @Default('SQLite (on-device)') String database,
    @Default('') String databaseUrl,
    @Default('~/.local/share/Phoenix') String dataLocation,
    @Default(16000) int serverPort,
    @Default('general') String activeSection,
  }) = _SettingsState;
}
