import 'package:flutter/material.dart';

/// The message input row: a text field plus a send/stop button.
class ChatComposer extends StatelessWidget {
  const ChatComposer({
    super.key,
    required this.controller,
    required this.isGenerating,
    required this.onSubmit,
    required this.onStop,
  });

  final TextEditingController controller;
  final bool isGenerating;
  final VoidCallback onSubmit;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: const Key('chatComposer'),
              controller: controller,
              minLines: 1,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                hintText: 'Message Phoenix…',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          isGenerating
              ? IconButton.filled(onPressed: onStop, icon: const Icon(Icons.stop))
              : IconButton.filled(onPressed: onSubmit, icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
