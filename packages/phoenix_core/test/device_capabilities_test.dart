import 'package:phoenix_core/phoenix_core.dart';
import 'package:test/test.dart';

class _ProbeEngine implements AcceleratorProbe {
  _ProbeEngine(this.accels);
  final List<Accelerator> accels;
  @override
  Future<List<Accelerator>> availableAccelerators() async => accels;
}

void main() {
  group('parseAcceleratorList', () {
    test('always includes CPU and parses a GPU line with vram', () {
      final out = 'device: backend=cuda index=0 name="NVIDIA RTX 4090" vram=25757220864';
      final list = parseAcceleratorList(out);
      expect(list.first.backend, AcceleratorBackend.cpu);
      final gpu = list.firstWhere((a) => a.isGpu);
      expect(gpu.backend, AcceleratorBackend.cuda);
      expect(gpu.name, 'NVIDIA RTX 4090');
      expect(gpu.vramBytes, 25757220864);
      expect(gpu.id, 'cuda:0');
    });

    test('CPU-only output yields just CPU', () {
      expect(parseAcceleratorList('no devices here').single.backend,
          AcceleratorBackend.cpu);
    });
  });

  group('DeviceCapabilities', () {
    const cuda = Accelerator(
        backend: AcceleratorBackend.cuda, name: 'GPU', vramBytes: 8 << 30);
    test('hasGpu + maxVramBytes', () {
      const caps = DeviceCapabilities(
          platform: 'linux',
          cpuCores: 8,
          ramBytes: 16 << 30,
          accelerators: [Accelerator.cpu, cuda]);
      expect(caps.hasGpu, isTrue);
      expect(caps.maxVramBytes, 8 << 30);
    });
    test('cpuOnly has no GPU', () {
      final caps = DeviceCapabilities.cpuOnly(
          platform: 'linux', cpuCores: 4, ramBytes: 8 << 30);
      expect(caps.hasGpu, isFalse);
      expect(caps.maxVramBytes, isNull);
    });
  });

  group('InferenceParams.clampedTo', () {
    final params = const InferenceParams(numberOfGpuLayers: 32, contextLength: 32768);
    test('forces 0 GPU layers on a CPU-only device', () {
      final caps = DeviceCapabilities.cpuOnly(
          platform: 'linux', cpuCores: 4, ramBytes: 8 << 30);
      expect(params.clampedTo(caps).numberOfGpuLayers, 0);
    });
    test('keeps GPU layers when a GPU is present, caps context', () {
      const caps = DeviceCapabilities(
          platform: 'linux',
          cpuCores: 8,
          ramBytes: 16 << 30,
          accelerators: [
            Accelerator.cpu,
            Accelerator(backend: AcceleratorBackend.cuda, name: 'g'),
          ]);
      final clamped = params.clampedTo(caps, maxContext: 8192);
      expect(clamped.numberOfGpuLayers, 32);
      expect(clamped.contextLength, 8192);
    });
  });

  group('CapabilityDetector', () {
    test('non-probe engine is treated as CPU-only', () async {
      final caps = await const CapabilityDetector().detect(ramBytesOverride: 1 << 30);
      expect(caps.hasGpu, isFalse);
      expect(caps.cpuCores, greaterThan(0));
      expect(caps.ramBytes, 1 << 30);
    });
    test('probe engine accelerators are used (CPU prepended if missing)', () async {
      final engine = _ProbeEngine(
          const [Accelerator(backend: AcceleratorBackend.metal, name: 'M')]);
      final caps = await const CapabilityDetector()
          .detect(engine: engine, ramBytesOverride: 1 << 30);
      expect(caps.hasGpu, isTrue);
      expect(caps.accelerators.first.backend, AcceleratorBackend.cpu);
    });
  });
}
