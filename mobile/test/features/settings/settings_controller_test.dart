import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/features/settings/presentation/data/settings_repository.dart';
import 'package:phoenix/features/settings/presentation/providers/settings_controller.dart';
import 'package:phoenix/features/settings/presentation/providers/settings_providers.dart';
import 'package:phoenix/features/settings/presentation/providers/settings_state.dart';

ProviderContainer _containerWith(SettingsRepository repo) {
  final c = ProviderContainer(
    overrides: [settingsRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  test('loads persisted preferences on build', () async {
    final repo = InMemorySettingsRepository(
      const SettingsState(theme: AppThemeMode.cream, cpuThreads: 4),
    );
    final container = _containerWith(repo);

    final loaded = await container.read(settingsControllerProvider.future);

    expect(loaded.theme, AppThemeMode.cream);
    expect(loaded.cpuThreads, 4);
  });

  test('each toggle/select writes through the repository', () async {
    final repo = InMemorySettingsRepository();
    final container = _containerWith(repo);
    await container.read(settingsControllerProvider.future);
    final ctrl = container.read(settingsControllerProvider.notifier);

    await ctrl.setTheme(AppThemeMode.system);
    await ctrl.setTelemetry(true);
    await ctrl.setContextLength(16384);

    final state = container.read(settingsControllerProvider).requireValue;
    expect(state.theme, AppThemeMode.system);
    expect(state.telemetry, isTrue);
    expect(state.contextLength, 16384);

    final persisted = await repo.load();
    expect(persisted.theme, AppThemeMode.system);
    expect(persisted.telemetry, isTrue);
    expect(persisted.contextLength, 16384);
  });

  test('persisted values survive a fresh controller (restart)', () async {
    final repo = InMemorySettingsRepository();
    final first = _containerWith(repo);
    await first.read(settingsControllerProvider.future);
    await first.read(settingsControllerProvider.notifier).setGpuLayers(50);

    final second = _containerWith(repo);
    final reloaded = await second.read(settingsControllerProvider.future);
    expect(reloaded.gpuLayers, 50);
  });

  test('openSection updates transient state without persisting', () async {
    final repo = InMemorySettingsRepository();
    final container = _containerWith(repo);
    await container.read(settingsControllerProvider.future);

    container.read(settingsControllerProvider.notifier).openSection('engine');

    expect(
      container.read(settingsControllerProvider).requireValue.activeSection,
      'engine',
    );
    expect((await repo.load()).activeSection, 'appearance');
  });
}
