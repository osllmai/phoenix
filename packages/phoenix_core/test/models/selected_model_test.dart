import 'package:phoenix_core/phoenix_core.dart';
import 'package:test/test.dart';

void main() {
  test('local selection reports local mode and the model name', () {
    const sel = LocalSelection(AiModel(name: 'Llama-3.1-8B', key: '/m.gguf'));
    expect(sel.mode, ComputeMode.local);
    expect(sel.name, 'Llama-3.1-8B');
  });

  test('cloud selection reports cloud mode and the model name', () {
    const sel = CloudSelection(
        CloudModel(id: 'openai/gpt-4o', name: 'GPT-4o', provider: 'OpenAI'));
    expect(sel.mode, ComputeMode.cloud);
    expect(sel.name, 'GPT-4o');
  });

  test('selected model switches exhaustively over its variants', () {
    SelectedModel sel = const CloudSelection(
        CloudModel(id: 'x', name: 'X', provider: 'P'));
    final label = switch (sel) {
      LocalSelection() => 'local',
      CloudSelection() => 'cloud',
    };
    expect(label, 'cloud');
  });
}
