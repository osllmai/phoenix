import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:phoenix_core/phoenix_core.dart';

import 'reasoning_block.dart';

/// A single chat bubble — user prompts align right (plain text), model
/// responses left (rendered as markdown, with any `<think>` scratchpad
/// collapsed above the answer).
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.text, required this.isPrompt});

  final String text;
  final bool isPrompt;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = isPrompt ? scheme.primaryContainer : scheme.surfaceContainerHighest;
    final split = isPrompt ? null : splitReasoning(text);
    final body = isPrompt
        ? (text.isEmpty ? '…' : text)
        : (split!.answer.isEmpty && !split.hasReasoning ? '…' : split.answer);
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
        child: isPrompt
            ? SelectableText(body)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (split!.hasReasoning)
                    ReasoningBlock(
                      text: split.reasoning,
                      isStreaming: split.answer.isEmpty,
                    ),
                  if (body.isNotEmpty) GptMarkdown(body),
                ],
              ),
      ),
    );
  }
}
