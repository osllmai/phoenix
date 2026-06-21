import 'package:freezed_annotation/freezed_annotation.dart';

import 'welcome_stage.dart';

part 'welcome_state.freezed.dart';

/// UI state for the first-run onboarding wizard: which step is showing, the
/// chosen model, the (stubbed) download progress and the telemetry opt-in.
@freezed
abstract class WelcomeState with _$WelcomeState {
  const factory WelcomeState({
    @Default(WelcomeStage.intro) WelcomeStage stage,
    @Default('llama-3.2-3b') String selectedModelId,
    @Default(DownloadStatus.idle) DownloadStatus download,
    @Default(0.0) double progress,
    @Default(false) bool telemetry,
  }) = _WelcomeState;

  const WelcomeState._();

  bool get isDownloading => download == DownloadStatus.downloading;
  bool get hasError => download == DownloadStatus.error;
  int get percent => (progress * 100).round();
}
