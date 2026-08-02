/// Splits a model reply into its chain-of-thought and the answer proper.
///
/// Reasoning models (Qwen3, DeepSeek-R1, …) wrap their scratchpad in
/// `<think>…</think>`. Hosts render [reasoning] collapsed and [answer] as the
/// message body. While a reply is still streaming the closing tag has not
/// arrived yet, so an unterminated block is reasoning with an empty answer.
class ReasoningSplit {
  const ReasoningSplit({required this.reasoning, required this.answer});

  final String reasoning;
  final String answer;

  bool get hasReasoning => reasoning.isNotEmpty;
}

const _open = '<think>';
const _close = '</think>';

ReasoningSplit splitReasoning(String text) {
  final reasoning = StringBuffer();
  final answer = StringBuffer();
  var rest = text;

  while (true) {
    final start = rest.indexOf(_open);
    if (start < 0) {
      answer.write(rest);
      break;
    }
    answer.write(rest.substring(0, start));
    final body = rest.substring(start + _open.length);
    final end = body.indexOf(_close);
    if (end < 0) {
      reasoning.write(body);
      break;
    }
    reasoning.write(body.substring(0, end));
    rest = body.substring(end + _close.length);
  }

  return ReasoningSplit(
    reasoning: reasoning.toString().trim(),
    answer: answer.toString().trim(),
  );
}
