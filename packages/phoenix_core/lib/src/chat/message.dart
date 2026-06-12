/// A single chat message. Faithful port of the legacy `message` table
/// (`core/database/managers/messagemanager.cpp`).
class Message {
  const Message({
    this.id,
    required this.conversationId,
    this.text = '',
    this.fileName,
    required this.date,
    this.icon = '',
    required this.isPrompt,
    this.like = 0,
  });

  /// Null until persisted (SQLite assigns the autoincrement id).
  final int? id;
  final int conversationId;
  final String text;
  final String? fileName;
  final DateTime date;
  final String icon;

  /// True = user prompt, false = model response.
  final bool isPrompt;

  /// -1 disliked · 0 neutral · 1 liked.
  final int like;

  Message copyWith({int? id, String? text, int? like}) => Message(
        id: id ?? this.id,
        conversationId: conversationId,
        text: text ?? this.text,
        fileName: fileName,
        date: date,
        icon: icon,
        isPrompt: isPrompt,
        like: like ?? this.like,
      );

  Map<String, Object?> toRow() => {
        if (id != null) 'id': id,
        'conversation_id': conversationId,
        'text': text,
        'fileName': fileName,
        'date': date.toIso8601String(),
        'icon': icon,
        'isPrompt': isPrompt ? 1 : 0,
        'like': like,
      };

  factory Message.fromRow(Map<String, Object?> r) => Message(
        id: r['id'] as int?,
        conversationId: r['conversation_id'] as int,
        text: (r['text'] as String?) ?? '',
        fileName: r['fileName'] as String?,
        date: DateTime.parse(r['date'] as String),
        icon: (r['icon'] as String?) ?? '',
        isPrompt: (r['isPrompt'] as int) == 1,
        like: (r['like'] as int?) ?? 0,
      );
}
