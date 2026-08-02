import 'package:phoenix_core/phoenix_core.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('device_capabilities round-trips through the real schema (v3)', () async {
    final db = await PhoenixDatabase.open(inMemoryDatabasePath, databaseFactoryFfi);
    final repo = SqfliteDeviceCapabilitiesRepository(db);

    expect(await repo.load(), isNull);

    await repo.save(const DeviceCapabilities(
      platform: 'linux',
      cpuCores: 12,
      ramBytes: 34359738368,
      accelerators: [
        Accelerator.cpu,
        Accelerator(
            backend: AcceleratorBackend.cuda,
            name: 'NVIDIA RTX 4090',
            index: 0,
            vramBytes: 25757220864),
      ],
    ));

    final loaded = await repo.load();
    expect(loaded, isNotNull);
    expect(loaded!.cpuCores, 12);
    expect(loaded.ramBytes, 34359738368);
    expect(loaded.hasGpu, isTrue);
    expect(loaded.gpus.single.name, 'NVIDIA RTX 4090');
    expect(loaded.maxVramBytes, 25757220864);

    // save() upserts the single row (no duplicate).
    await repo.save(DeviceCapabilities.cpuOnly(
        platform: 'linux', cpuCores: 4, ramBytes: 8));
    final again = await repo.load();
    expect(again!.cpuCores, 4);
    expect(again.hasGpu, isFalse);

    await db.close();
  });
}
