/// The four onboarding steps, in order.
enum WelcomeStage { intro, chooseModel, privacy, ready }

/// Download sub-state of the choose-model step (stubbed until models/IndoxHub).
enum DownloadStatus { idle, downloading, error }

extension WelcomeStageX on WelcomeStage {
  int get index1 => index + 1;
  bool get isFirst => this == WelcomeStage.intro;
  bool get isLast => this == WelcomeStage.ready;

  WelcomeStage get next =>
      isLast ? this : WelcomeStage.values[index + 1];
  WelcomeStage get back =>
      isFirst ? this : WelcomeStage.values[index - 1];
}
