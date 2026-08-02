import 'package:flutter/material.dart';

class SettingOptionsDropdown extends StatelessWidget {
  const SettingOptionsDropdown({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<String> options;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final items = {value, ...options}.toList();
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          style: Theme.of(context).textTheme.bodyMedium,
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          items: [
            for (final o in items)
              DropdownMenuItem(value: o, child: Text(o)),
          ],
        ),
      ),
    );
  }
}

class SettingNumberField extends StatefulWidget {
  const SettingNumberField({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1024,
    this.max = 65535,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  State<SettingNumberField> createState() => _SettingNumberFieldState();
}

class _SettingNumberFieldState extends State<SettingNumberField> {
  late final TextEditingController _controller =
      TextEditingController(text: '${widget.value}');

  void _commit(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed == null) return;
    final clamped = parsed.clamp(widget.min, widget.max);
    widget.onChanged(clamped);
    if (clamped != parsed) _controller.text = '$clamped';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
        ),
        onSubmitted: _commit,
        onChanged: _commit,
      ),
    );
  }
}

class SettingStaticText extends StatelessWidget {
  const SettingStaticText({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(fontFamily: 'monospace'),
      ),
    );
  }
}
