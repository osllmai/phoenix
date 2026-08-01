import 'package:flutter/material.dart';

const _presets = [2048, 4096, 8192, 16384, 32768];
const _min = 256;
const _max = 1048576;

/// Context length control: a manual number field plus quick-pick preset chips.
/// Typing any value or tapping a chip both flow through [onChanged]; the field
/// stays in sync when the value changes from a chip.
class ContextLengthField extends StatefulWidget {
  const ContextLengthField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  State<ContextLengthField> createState() => _ContextLengthFieldState();
}

class _ContextLengthFieldState extends State<ContextLengthField> {
  late final TextEditingController _controller =
      TextEditingController(text: '${widget.value}');

  void _commit(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed == null) return;
    widget.onChanged(parsed.clamp(_min, _max));
  }

  @override
  void didUpdateWidget(ContextLengthField old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value && '${widget.value}' != _controller.text) {
      _controller.text = '${widget.value}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _label(int p) => p >= 1024 ? '${p ~/ 1024}K' : '$p';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 160,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
              suffixText: 'tokens',
              border: OutlineInputBorder(),
            ),
            onChanged: _commit,
            onSubmitted: _commit,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final p in _presets)
              ChoiceChip(
                label: Text(_label(p)),
                selected: widget.value == p,
                onSelected: (_) => widget.onChanged(p),
              ),
          ],
        ),
      ],
    );
  }
}
