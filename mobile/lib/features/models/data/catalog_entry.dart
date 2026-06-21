import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_entry.freezed.dart';

@freezed
abstract class CatalogEntry with _$CatalogEntry {
  const CatalogEntry._();

  const factory CatalogEntry({
    required String org,
    required String modelName,
    required String name,
    required String filename,
    required String url,
    @Default(0.0) double filesizeGb,
    @Default('') String quant,
    @Default(0) int ramRequired,
    @Default('') String parameters,
    @Default('') String requires,
    @Default('') String md5sum,
    @Default('') String description,
    @Default('') String promptTemplate,
    @Default('') String systemPrompt,
    @Default('') String type,
    @Default(false) bool recommended,
    @Default('') String order,
    @Default(0) int downloadCount,
    @Default(0) int likeCount,
    @Default('') String capability,
    @Default('') String hfLink,
    @Default('') String license,
    @Default(false) bool gpuRequired,
    @Default('') String uploadDate,
  }) = _CatalogEntry;

  factory CatalogEntry.fromJson(String org, Map<String, dynamic> json) {
    return CatalogEntry(
      org: org,
      modelName: json['modelName'] as String? ?? '',
      name: json['name'] as String? ?? json['modelName'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
      url: json['url'] as String? ?? '',
      filesizeGb: (json['filesize'] as num?)?.toDouble() ?? 0.0,
      quant: json['quant'] as String? ?? '',
      ramRequired: (json['ramrequired'] as num?)?.toInt() ?? 0,
      parameters: json['parameters'] as String? ?? '',
      requires: json['requires']?.toString() ?? '',
      md5sum: json['md5sum'] as String? ?? '',
      description: json['description'] as String? ?? '',
      promptTemplate: json['promptTemplate'] as String? ?? '',
      systemPrompt: json['systemPrompt'] as String? ?? '',
      type: json['type'] as String? ?? '',
      recommended: json['recommended'] as bool? ?? false,
      order: json['order']?.toString() ?? '',
    );
  }
}
