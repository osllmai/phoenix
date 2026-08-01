import 'dart:convert';
import 'dart:io';

import '../providers/settings_state.dart';

abstract class SettingsRepository {
  Future<SettingsState> load();
  Future<void> save(SettingsState state);
}

/// Persists settings as a single, human-readable `settings.json` file — the
/// portable source of truth (easy to back up, sync, or hand-edit). `activeSection`
/// is transient UI state and is intentionally not written.
class JsonFileSettingsRepository implements SettingsRepository {
  JsonFileSettingsRepository(this._file);

  final File _file;

  @override
  Future<SettingsState> load() async {
    if (!await _file.exists()) return const SettingsState();
    try {
      final map = jsonDecode(await _file.readAsString()) as Map<String, Object?>;
      return _fromJson(map);
    } catch (_) {
      return const SettingsState();
    }
  }

  @override
  Future<void> save(SettingsState s) async {
    await _file.parent.create(recursive: true);
    await _file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(_toJson(s)));
  }

  static Map<String, Object?> _toJson(SettingsState s) => {
        'theme': s.theme.name,
        'fontSize': s.fontSize,
        'accentIndex': s.accentIndex,
        'colorTheme': s.colorTheme,
        'fontFamily': s.fontFamily,
        'chatModel': s.chatModel,
        'embedModel': s.embedModel,
        'accelerator': s.accelerator,
        'contextLength': s.contextLength,
        'gpuLayers': s.gpuLayers,
        'cpuThreads': s.cpuThreads,
        'telemetry': s.telemetry,
        'usageAnalytics': s.usageAnalytics,
        'language': s.language,
        'startupView': s.startupView,
        'defaultModel': s.defaultModel,
        'launchAtLogin': s.launchAtLogin,
        'database': s.database,
        'databaseUrl': s.databaseUrl,
        'dataLocation': s.dataLocation,
        'serverPort': s.serverPort,
      };

  static SettingsState _fromJson(Map<String, Object?> m) {
    const d = SettingsState();
    return SettingsState(
      theme: _theme(m['theme'], d.theme),
      fontSize: (m['fontSize'] as num?)?.toDouble() ?? d.fontSize,
      accentIndex: m['accentIndex'] as int? ?? d.accentIndex,
      colorTheme: m['colorTheme'] as String? ?? d.colorTheme,
      fontFamily: m['fontFamily'] as String? ?? d.fontFamily,
      chatModel: m['chatModel'] as String? ?? d.chatModel,
      embedModel: m['embedModel'] as String? ?? d.embedModel,
      accelerator: m['accelerator'] as String? ?? d.accelerator,
      contextLength: m['contextLength'] as int? ?? d.contextLength,
      gpuLayers: m['gpuLayers'] as int? ?? d.gpuLayers,
      cpuThreads: m['cpuThreads'] as int? ?? d.cpuThreads,
      telemetry: m['telemetry'] as bool? ?? d.telemetry,
      usageAnalytics: m['usageAnalytics'] as bool? ?? d.usageAnalytics,
      language: m['language'] as String? ?? d.language,
      startupView: m['startupView'] as String? ?? d.startupView,
      defaultModel: m['defaultModel'] as String? ?? d.defaultModel,
      launchAtLogin: m['launchAtLogin'] as bool? ?? d.launchAtLogin,
      database: m['database'] as String? ?? d.database,
      databaseUrl: m['databaseUrl'] as String? ?? d.databaseUrl,
      dataLocation: m['dataLocation'] as String? ?? d.dataLocation,
      serverPort: m['serverPort'] as int? ?? d.serverPort,
    );
  }

  static AppThemeMode _theme(Object? value, AppThemeMode fallback) {
    if (value == 'cream') return AppThemeMode.light;
    for (final mode in AppThemeMode.values) {
      if (mode.name == value) return mode;
    }
    return fallback;
  }
}

/// In-memory backing used by widgets/tests so they never touch the filesystem.
class InMemorySettingsRepository implements SettingsRepository {
  InMemorySettingsRepository([this._state = const SettingsState()]);

  SettingsState _state;

  @override
  Future<SettingsState> load() async => _state;

  @override
  Future<void> save(SettingsState state) async => _state = state;
}
