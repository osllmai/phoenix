import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

/// A single chat bubble — user prompts align right (plain text), model
/// responses left (rendered as markdown for code blocks, lists, etc.).
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.text, required this.isPrompt});

  final String text;
  final bool isPrompt;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = isPrompt ? scheme.primaryContainer : scheme.surfaceContainerHighest;
    final body = text.isEmpty ? '…' : text;
    return Align(
      alignment: isPrompt ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: const BoxConstraints(maxWidth: 640),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: isPrompt ? SelectableText(body) : GptMarkdown(body),
      ),
    );
  }
}
