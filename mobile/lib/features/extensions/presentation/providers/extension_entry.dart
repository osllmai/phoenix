import 'package:freezed_annotation/freezed_annotation.dart';

part 'extension_entry.freezed.dart';

enum ExtensionCategory { document, speech, search, developer, evaluator, flows }

@freezed
abstract class ExtensionEntry with _$ExtensionEntry {
  const ExtensionEntry._();

  const factory ExtensionEntry({
    required int id,
    required String slug,
    required String name,
    required String publisher,
    required String icon,
    required ExtensionCategory category,
    required String version,
    @Default('') String description,
    @Default(false) bool verified,
    @Default(false) bool installed,
    @Default(0.0) double rating,
    @Default(0) int installsCount,
  }) = _ExtensionEntry;

  factory ExtensionEntry.fromJson(Map<String, dynamic> json) {
    return ExtensionEntry(
      id: json['id'] as int,
      slug: json['slug'] as String,
      name: json['name'] as String,
      publisher: json['publisher'] as String,
      icon: json['icon'] as String,
      category: categoryFromKey(json['category'] as String),
      version: json['version'] as String,
      description: json['description'] as String? ?? '',
      verified: json['verified'] as bool? ?? false,
      installed: json['installed'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      installsCount: json['installs_count'] as int? ?? 0,
    );
  }

  String get size => 'v$version';

  String get installs =>
      installsCount > 0 ? '$installsCount installs' : '';
}

ExtensionCategory categoryFromKey(String key) {
  return ExtensionCategory.values.firstWhere(
    (c) => c.name == key,
    orElse: () => ExtensionCategory.developer,
  );
}

extension ExtensionCategoryX on ExtensionCategory {
  String get label => switch (this) {
        ExtensionCategory.document => 'Document processing',
        ExtensionCategory.speech => 'Speech',
        ExtensionCategory.search => 'Search & research',
        ExtensionCategory.developer => 'Developer',
        ExtensionCategory.evaluator => 'Evaluator',
        ExtensionCategory.flows => 'Flows',
      };
}
