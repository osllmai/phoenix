/// Barrel for the engine-agnostic inference layer.
///
/// The rest of the app imports `package:phoenix/core/ai/ai.dart` and never the
/// concrete engine files directly.
library;

export 'inference_port.dart';
export 'protocol.dart';
export 'subprocess_engine.dart';
export 'engine_provider.dart';
