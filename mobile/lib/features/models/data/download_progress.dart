import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_progress.freezed.dart';

enum DownloadPhase { downloading, verifying, done, failed }

@freezed
abstract class DownloadProgress with _$DownloadProgress {
  const DownloadProgress._();

  const factory DownloadProgress({
    required DownloadPhase phase,
    @Default(0.0) double fraction,
    String? path,
    String? error,
  }) = _DownloadProgress;

  bool get isActive =>
      phase == DownloadPhase.downloading || phase == DownloadPhase.verifying;
}
