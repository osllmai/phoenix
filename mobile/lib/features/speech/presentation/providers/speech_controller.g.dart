// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the speech surface: record → transcribe → idle, surfacing the result
/// and appending it to history. Calls the core [TranscriptionPort]; mirrors the
/// `@riverpod` Notifier pattern in `chat_controller.dart`.

@ProviderFor(SpeechController)
final speechControllerProvider = SpeechControllerProvider._();

/// Drives the speech surface: record → transcribe → idle, surfacing the result
/// and appending it to history. Calls the core [TranscriptionPort]; mirrors the
/// `@riverpod` Notifier pattern in `chat_controller.dart`.
final class SpeechControllerProvider
    extends $NotifierProvider<SpeechController, SpeechState> {
  /// Drives the speech surface: record → transcribe → idle, surfacing the result
  /// and appending it to history. Calls the core [TranscriptionPort]; mirrors the
  /// `@riverpod` Notifier pattern in `chat_controller.dart`.
  SpeechControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speechControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speechControllerHash();

  @$internal
  @override
  SpeechController create() => SpeechController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpeechState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpeechState>(value),
    );
  }
}

String _$speechControllerHash() => r'd6ed24943e801b2c1ace037f505af6180ccaf994';

/// Drives the speech surface: record → transcribe → idle, surfacing the result
/// and appending it to history. Calls the core [TranscriptionPort]; mirrors the
/// `@riverpod` Notifier pattern in `chat_controller.dart`.

abstract class _$SpeechController extends $Notifier<SpeechState> {
  SpeechState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SpeechState, SpeechState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SpeechState, SpeechState>,
              SpeechState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
