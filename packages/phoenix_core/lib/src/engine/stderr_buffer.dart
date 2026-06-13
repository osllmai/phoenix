/// A small bounded ring of the most recent stderr lines, attached to typed
/// engine errors for diagnosis (the engine's only error channel is stderr).
class StderrBuffer {
  StderrBuffer({this.max = 20});

  final int max;
  final _lines = <String>[];

  void add(String line) {
    _lines.add(line);
    if (_lines.length > max) _lines.removeAt(0);
  }

  void clear() => _lines.clear();

  String get tail => _lines.join('\n');
}
