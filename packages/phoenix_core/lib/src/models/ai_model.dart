/// An installed local model. Faithful port of the legacy `model` table
/// (`core/database/managers/modelmanager.cpp`).
///
/// [key] is the engine handle — the path passed to `applocal_provider --model`
/// (typically a `.gguf` file path).
class AiModel {
  const AiModel({
    this.id,
    required this.name,
    this.key,
    this.addedAt,
    this.isLiked = false,
  });

  final int? id;
  final String name;
  final String? key;
  final DateTime? addedAt;
  final bool isLiked;

  bool get isInstalled => key != null && key!.isNotEmpty;

  AiModel copyWith({int? id, String? key, bool? isLiked}) => AiModel(
        id: id ?? this.id,
        name: name,
        key: key ?? this.key,
        addedAt: addedAt,
        isLiked: isLiked ?? this.isLiked,
      );

  Map<String, Object?> toRow() => {
        if (id != null) 'id': id,
        'name': name,
        'key': key,
        'add_model_time': addedAt?.toIso8601String(),
        'isLike': isLiked ? 1 : 0,
      };

  factory AiModel.fromRow(Map<String, Object?> r) => AiModel(
        id: r['id'] as int?,
        name: r['name'] as String,
        key: r['key'] as String?,
        addedAt: r['add_model_time'] == null
            ? null
            : DateTime.tryParse(r['add_model_time'] as String),
        isLiked: (r['isLike'] as int? ?? 0) == 1,
      );
}
