import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_dto.freezed.dart';
part 'document_dto.g.dart';

@freezed
abstract class DocumentListItemDto with _$DocumentListItemDto {
  const factory DocumentListItemDto({
    required int id,
    required String title,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _DocumentListItemDto;

  factory DocumentListItemDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentListItemDtoFromJson(json);
}

@freezed
abstract class DocumentDetailDto with _$DocumentDetailDto {
  const factory DocumentDetailDto({
    required int id,
    required String title,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default('') String markdown,
    @Default('') String error,
  }) = _DocumentDetailDto;

  factory DocumentDetailDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentDetailDtoFromJson(json);
}

@freezed
abstract class DocumentCreatedDto with _$DocumentCreatedDto {
  const factory DocumentCreatedDto({
    required int id,
    required String title,
    required String status,
    @JsonKey(name: 'job_id') required String jobId,
  }) = _DocumentCreatedDto;

  factory DocumentCreatedDto.fromJson(Map<String, dynamic> json) =>
      _$DocumentCreatedDtoFromJson(json);
}
