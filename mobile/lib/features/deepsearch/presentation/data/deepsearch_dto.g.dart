// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deepsearch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchStartedDto _$SearchStartedDtoFromJson(Map<String, dynamic> json) =>
    _SearchStartedDto(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String,
      jobId: json['job_id'] as String,
    );

Map<String, dynamic> _$SearchStartedDtoToJson(_SearchStartedDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'job_id': instance.jobId,
    };

_SearchListItemDto _$SearchListItemDtoFromJson(Map<String, dynamic> json) =>
    _SearchListItemDto(
      id: (json['id'] as num).toInt(),
      query: json['query'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SearchListItemDtoToJson(_SearchListItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'query': instance.query,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
    };

_SearchSourceDto _$SearchSourceDtoFromJson(Map<String, dynamic> json) =>
    _SearchSourceDto(
      documentId: (json['document_id'] as num).toInt(),
      title: json['title'] as String,
      snippet: json['snippet'] as String,
      relevance: (json['relevance'] as num).toDouble(),
    );

Map<String, dynamic> _$SearchSourceDtoToJson(_SearchSourceDto instance) =>
    <String, dynamic>{
      'document_id': instance.documentId,
      'title': instance.title,
      'snippet': instance.snippet,
      'relevance': instance.relevance,
    };

_SearchDetailDto _$SearchDetailDtoFromJson(Map<String, dynamic> json) =>
    _SearchDetailDto(
      id: (json['id'] as num).toInt(),
      query: json['query'] as String,
      scope: json['scope'] as String,
      depth: json['depth'] as String,
      status: json['status'] as String,
      answer: json['answer'] as String? ?? '',
      error: json['error'] as String? ?? '',
      sources:
          (json['sources'] as List<dynamic>?)
              ?.map((e) => SearchSourceDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SearchSourceDto>[],
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SearchDetailDtoToJson(_SearchDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'query': instance.query,
      'scope': instance.scope,
      'depth': instance.depth,
      'status': instance.status,
      'answer': instance.answer,
      'error': instance.error,
      'sources': instance.sources,
      'created_at': instance.createdAt.toIso8601String(),
    };
