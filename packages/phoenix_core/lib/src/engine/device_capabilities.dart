/// What the host machine can actually run, as reported by the engine + system.
///
/// The engine is the source of truth for [accelerators] (it enumerates the
/// backends it was built with and that are present). Settings/UI must gate to
/// these so a user can never select a capability the device lacks.
library;

/// A hardware backend the engine can offload to.
enum AcceleratorBackend { cpu, cuda, metal, vulkan, rocm }

/// One available compute device reported by the engine.
class Accelerator {
  const Accelerator({
    required this.backend,
    required this.name,
    this.index = 0,
    this.vramBytes,
  });

  final AcceleratorBackend backend;
  final String name;
  final int index;

  /// Device memory in bytes, when the engine reports it (null = unknown/CPU).
  final int? vramBytes;

  bool get isGpu => backend != AcceleratorBackend.cpu;

  /// A stable label for persistence + display, e.g. `cuda:0 · RTX 4090`.
  String get id => '${backend.name}:$index';

  Map<String, Object?> toJson() => {
        'backend': backend.name,
        'name': name,
        'index': index,
        'vramBytes': vramBytes,
      };

  static Accelerator fromJson(Map<String, Object?> m) => Accelerator(
        backend: AcceleratorBackend.values.firstWhere(
          (b) => b.name == m['backend'],
          orElse: () => AcceleratorBackend.cpu,
        ),
        name: (m['name'] as String?) ?? 'CPU',
        index: (m['index'] as num?)?.toInt() ?? 0,
        vramBytes: (m['vramBytes'] as num?)?.toInt(),
      );

  /// The always-present CPU device.
  static const cpu = Accelerator(backend: AcceleratorBackend.cpu, name: 'CPU');
}

/// The detected capabilities of the host device.
class DeviceCapabilities {
  const DeviceCapabilities({
    required this.platform,
    required this.cpuCores,
    required this.ramBytes,
    required this.accelerators,
    this.detectedAt,
  });

  /// `linux` · `macos` · `windows` · `android` · `ios`.
  final String platform;
  final int cpuCores;
  final int ramBytes;

  /// Always includes CPU; GPU entries only when the engine reports them.
  final List<Accelerator> accelerators;
  final DateTime? detectedAt;

  bool get hasGpu => accelerators.any((a) => a.isGpu);

  List<Accelerator> get gpus =>
      accelerators.where((a) => a.isGpu).toList(growable: false);

  /// Largest reported VRAM across GPUs, or null when CPU-only/unknown.
  int? get maxVramBytes {
    final g = gpus.where((a) => a.vramBytes != null).map((a) => a.vramBytes!);
    return g.isEmpty ? null : g.reduce((a, b) => a > b ? a : b);
  }

  /// CPU-only fallback used before/without engine detection.
  static DeviceCapabilities cpuOnly({
    required String platform,
    required int cpuCores,
    required int ramBytes,
  }) =>
      DeviceCapabilities(
        platform: platform,
        cpuCores: cpuCores,
        ramBytes: ramBytes,
        accelerators: const [Accelerator.cpu],
      );
}

/// Optional capability an engine may implement to report the backends it can
/// actually use on this host. Engines that don't implement it are treated as
/// CPU-only. Kept separate from [InferencePort] so test/cloud fakes need not
/// implement it.
abstract interface class AcceleratorProbe {
  /// Backends the engine can offload to here (always includes CPU).
  Future<List<Accelerator>> availableAccelerators();
}

/// Parses an engine `--list-devices` dump into accelerators (CPU always first).
/// Recognised device lines look like:
///   `device: backend=cuda index=0 name="NVIDIA RTX 4090" vram=25757220864`
List<Accelerator> parseAcceleratorList(String output) {
  final accelerators = <Accelerator>[Accelerator.cpu];
  final re = RegExp(
    r'backend=(\w+)\s+index=(\d+)\s+name="([^"]*)"(?:\s+vram=(\d+))?',
  );
  for (final m in re.allMatches(output)) {
    final backend = AcceleratorBackend.values.firstWhere(
      (b) => b.name == m.group(1)!.toLowerCase(),
      orElse: () => AcceleratorBackend.cpu,
    );
    if (backend == AcceleratorBackend.cpu) continue;
    accelerators.add(Accelerator(
      backend: backend,
      index: int.parse(m.group(2)!),
      name: m.group(3)!,
      vramBytes: m.group(4) == null ? null : int.parse(m.group(4)!),
    ));
  }
  return accelerators;
}
