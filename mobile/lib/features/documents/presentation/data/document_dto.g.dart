// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DocumentListItemDto _$DocumentListItemDtoFromJson(Map<String, dynamic> json) =>
    _DocumentListItemDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$DocumentListItemDtoToJson(
  _DocumentListItemDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'status': instance.status,
  'created_at': instance.createdAt.toIso8601String(),
};

_DocumentDetailDto _$DocumentDetailDtoFromJson(Map<String, dynamic> json) =>
    _DocumentDetailDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      markdown: json['markdown'] as String? ?? '',
      error: json['error'] as String? ?? '',
    );

Map<String, dynamic> _$DocumentDetailDtoToJson(_DocumentDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'markdown': instance.markdown,
      'error': instance.error,
    };

_DocumentCreatedDto _$DocumentCreatedDtoFromJson(Map<String, dynamic> json) =>
    _DocumentCreatedDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      status: json['status'] as String,
      jobId: json['job_id'] as String,
    );

Map<String, dynamic> _$DocumentCreatedDtoToJson(_DocumentCreatedDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': instance.status,
      'job_id': instance.jobId,
    };
