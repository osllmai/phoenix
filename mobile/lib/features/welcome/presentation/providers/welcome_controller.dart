import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'welcome_stage.dart';
import 'welcome_state.dart';

part 'welcome_controller.g.dart';

/// Drives the onboarding wizard: step navigation, model selection, the
/// telemetry opt-in and a stubbed background model download.
@riverpod
class WelcomeController extends _$WelcomeController {
  Timer? _ticker;

  @override
  WelcomeState build() {
    ref.onDispose(() => _ticker?.cancel());
    return const WelcomeState();
  }

  void goTo(WelcomeStage stage) => state = state.copyWith(stage: stage);
  void next() => goTo(state.stage.next);
  void back() => goTo(state.stage.back);

  void selectModel(String id) => state = state.copyWith(selectedModelId: id);

  void toggleTelemetry(bool on) => state = state.copyWith(telemetry: on);

  /// Stubbed download: ticks progress to 100% over a few seconds. Real GGUF
  /// fetch lands when the models/IndoxHub backend is wired.
  void startDownload() {
    _ticker?.cancel();
    state = state.copyWith(download: DownloadStatus.downloading, progress: 0);
    _ticker = Timer.periodic(const Duration(milliseconds: 400), (_) {
      final p = state.progress + 0.08;
      if (p >= 1.0) {
        _ticker?.cancel();
        state = state.copyWith(download: DownloadStatus.idle, progress: 1.0);
      } else {
        state = state.copyWith(progress: p);
      }
    });
  }

  void cancelDownload() {
    _ticker?.cancel();
    state = state.copyWith(download: DownloadStatus.idle, progress: 0);
  }

  void failDownload() {
    _ticker?.cancel();
    state = state.copyWith(download: DownloadStatus.error);
  }
}
