import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoenix_core/phoenix_core.dart';

/// The single app-wide [TranscriptionPort]. Swap [StubTranscriber] for a future
/// whisper.cpp engine here without touching any caller — mirrors
/// `core/ai/engine_provider.dart`.
final transcriptionPortProvider = Provider<TranscriptionPort>((ref) {
  final port = StubTranscriber();
  ref.onDispose(port.dispose);
  return port;
});
