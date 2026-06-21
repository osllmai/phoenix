import 'package:freezed_annotation/freezed_annotation.dart';

part 'document.freezed.dart';

enum DocStatus { queued, converting, converted, embedded, failed }

enum DocKind { pdf, office, image, audio, web }

@freezed
abstract class PhoenixDocument with _$PhoenixDocument {
  const factory PhoenixDocument({
    required String id,
    required String title,
    required DocKind kind,
    required DocStatus status,
    required String meta,
    @Default('') String badge,
    @Default('') String pipeline,
    @Default(null) String? grade,
    @Default(0) int progress,
    @Default('') String markdown,
  }) = _PhoenixDocument;
}
