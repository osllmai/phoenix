import 'package:freezed_annotation/freezed_annotation.dart';

part 'deepsearch_dto.freezed.dart';
part 'deepsearch_dto.g.dart';

@freezed
abstract class SearchStartedDto with _$SearchStartedDto {
  const factory SearchStartedDto({
    required int id,
    required String status,
    @JsonKey(name: 'job_id') required String jobId,
  }) = _SearchStartedDto;

  factory SearchStartedDto.fromJson(Map<String, dynamic> json) =>
      _$SearchStartedDtoFromJson(json);
}

@freezed
abstract class SearchListItemDto with _$SearchListItemDto {
  const factory SearchListItemDto({
    required int id,
    required String query,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _SearchListItemDto;

  factory SearchListItemDto.fromJson(Map<String, dynamic> json) =>
      _$SearchListItemDtoFromJson(json);
}

@freezed
abstract class SearchSourceDto with _$SearchSourceDto {
  const factory SearchSourceDto({
    @JsonKey(name: 'document_id') required int documentId,
    required String title,
    required String snippet,
    required double relevance,
  }) = _SearchSourceDto;

  factory SearchSourceDto.fromJson(Map<String, dynamic> json) =>
      _$SearchSourceDtoFromJson(json);
}

@freezed
abstract class SearchDetailDto with _$SearchDetailDto {
  const factory SearchDetailDto({
    required int id,
    required String query,
    required String scope,
    required String depth,
    required String status,
    @Default('') String answer,
    @Default('') String error,
    @Default(<SearchSourceDto>[]) List<SearchSourceDto> sources,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _SearchDetailDto;

  factory SearchDetailDto.fromJson(Map<String, dynamic> json) =>
      _$SearchDetailDtoFromJson(json);
}
