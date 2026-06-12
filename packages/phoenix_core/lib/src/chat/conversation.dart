import '../engine/inference_port.dart';

/// A chat session. Faithful port of the legacy `conversation` table — note the
/// generation parameters are stored per-conversation and map onto
/// [InferenceParams] when prompting the engine.
class Conversation {
  const Conversation({
    this.id,
    required this.title,
    this.description = '',
    required this.date,
    this.icon = '',
    this.isPinned = false,
    this.type = 'text',
    this.params = const InferenceParams(),
  });

  final int? id;
  final String title;
  final String description;
  final DateTime date;
  final String icon;
  final bool isPinned;
  final String type;

  /// Per-conversation generation settings (temperature, topK, …).
  final InferenceParams params;

  Conversation copyWith({int? id, String? title, bool? isPinned}) => Conversation(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description,
        date: date,
        icon: icon,
        isPinned: isPinned ?? this.isPinned,
        type: type,
        params: params,
      );

  Map<String, Object?> toRow() => {
        if (id != null) 'id': id,
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'icon': icon,
        'isPinned': isPinned ? 1 : 0,
        'type': type,
        'stream': params.stream ? 1 : 0,
        'promptTemplate': params.promptTemplate,
        'systemPrompt': params.systemPrompt,
        'temperature': params.temperature,
        'topK': params.topK,
        'topP': params.topP,
        'minP': params.minP,
        'repeatPenalty': params.repeatPenalty,
        'promptBatchSize': params.promptBatchSize,
        'maxTokens': params.maxTokens,
        'repeatPenaltyTokens': params.repeatPenaltyTokens,
        'contextLength': params.contextLength,
        'numberOfGPULayers': params.numberOfGpuLayers,
      };

  factory Conversation.fromRow(Map<String, Object?> r) => Conversation(
        id: r['id'] as int?,
        title: r['title'] as String,
        description: (r['description'] as String?) ?? '',
        date: DateTime.parse(r['date'] as String),
        icon: (r['icon'] as String?) ?? '',
        isPinned: (r['isPinned'] as int? ?? 0) == 1,
        type: (r['type'] as String?) ?? 'text',
        params: InferenceParams(
          stream: (r['stream'] as int? ?? 1) == 1,
          promptTemplate: (r['promptTemplate'] as String?) ?? '',
          systemPrompt: (r['systemPrompt'] as String?) ?? '',
          temperature: (r['temperature'] as num?)?.toDouble() ?? 0.7,
          topK: (r['topK'] as int?) ?? 40,
          topP: (r['topP'] as num?)?.toDouble() ?? 0.95,
          minP: (r['minP'] as num?)?.toDouble() ?? 0.05,
          repeatPenalty: (r['repeatPenalty'] as num?)?.toDouble() ?? 1.1,
          promptBatchSize: (r['promptBatchSize'] as int?) ?? 128,
          maxTokens: (r['maxTokens'] as int?) ?? 512,
          repeatPenaltyTokens: (r['repeatPenaltyTokens'] as int?) ?? 64,
          contextLength: (r['contextLength'] as int?) ?? 4096,
          numberOfGpuLayers: (r['numberOfGPULayers'] as int?) ?? 0,
        ),
      );
}
