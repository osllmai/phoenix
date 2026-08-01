import 'package:flutter/material.dart';

class SettingTextField extends StatefulWidget {
  const SettingTextField({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.hint,
  });

  final String value;
  final bool enabled;
  final String? hint;
  final ValueChanged<String> onChanged;

  @override
  State<SettingTextField> createState() => _SettingTextFieldState();
}

class _SettingTextFieldState extends State<SettingTextField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.value);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextField(
        controller: _controller,
        enabled: widget.enabled,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.hint,
          border: const OutlineInputBorder(),
        ),
        onChanged: widget.onChanged,
        onSubmitted: widget.onChanged,
      ),
    );
  }
}
