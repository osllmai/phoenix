import 'dart:convert';

import 'package:sqflite_common/sqlite_api.dart';

import '../storage/database.dart';
import 'device_capabilities.dart';
import 'device_capabilities_repository.dart';

/// SQLite-backed [DeviceCapabilitiesRepository] — a single upserted row (id=1)
/// in the `device_capabilities` table, with accelerators stored as JSON.
class SqfliteDeviceCapabilitiesRepository
    implements DeviceCapabilitiesRepository {
  SqfliteDeviceCapabilitiesRepository(this._db);

  final PhoenixDatabase _db;

  @override
  Future<DeviceCapabilities?> load() async {
    final rows =
        await _db.db.query('device_capabilities', where: 'id = 1', limit: 1);
    if (rows.isEmpty) return null;
    final r = rows.first;
    final accels = (jsonDecode(r['accelerators'] as String) as List)
        .map((e) => Accelerator.fromJson((e as Map).cast<String, Object?>()))
        .toList(growable: false);
    final detected = r['detected_at'] as String?;
    return DeviceCapabilities(
      platform: r['platform'] as String,
      cpuCores: r['cpu_cores'] as int,
      ramBytes: r['ram_bytes'] as int,
      accelerators: accels.isEmpty ? const [Accelerator.cpu] : accels,
      detectedAt: detected == null ? null : DateTime.tryParse(detected),
    );
  }

  @override
  Future<void> save(DeviceCapabilities caps) => _db.db.insert(
        'device_capabilities',
        {
          'id': 1,
          'platform': caps.platform,
          'cpu_cores': caps.cpuCores,
          'ram_bytes': caps.ramBytes,
          'accelerators':
              jsonEncode(caps.accelerators.map((a) => a.toJson()).toList()),
          'detected_at': (caps.detectedAt ?? DateTime.now()).toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
}
