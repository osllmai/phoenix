import 'inference_port.dart';
import 'protocol.dart';

/// Parses the engine's stdout lines into router events, keeping the line
/// state-machine out of [SubprocessEngine] (file-size + single responsibility).
///
/// Lines that arrive while the engine is not `generating` (e.g. the trailing
/// `Prompt stopped.` after an abort) are dropped — this is the S8 desync fence:
/// stale buffered output can't bleed into the next turn.
class StdoutRouter {
  StdoutRouter({
    required this.onReady,
    required this.onToken,
    required this.onDone,
  });

  final void Function() onReady;
  final void Function(String token) onToken;
  final void Function() onDone;

  /// Feed one stdout [line]; [state] is the engine's current lifecycle state.
  void handle(String line, EngineState state) {
    if (state == EngineState.loadingModel) {
      if (line.trimRight().endsWith(EngineProtocol.loadingFinished)) onReady();
      return;
    }
    if (state != EngineState.generating) return; // drop stray / post-stop lines

    // The end marker may arrive with trailing token text on the same line.
    final idx = line.indexOf(EngineProtocol.done);
    if (idx >= 0) {
      final before = line.substring(0, idx);
      if (before.isNotEmpty) onToken(before);
      onDone();
      return;
    }
    onToken(line);
  }
}
