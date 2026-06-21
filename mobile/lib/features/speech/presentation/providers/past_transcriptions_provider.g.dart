// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'past_transcriptions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pastTranscriptions)
final pastTranscriptionsProvider = PastTranscriptionsProvider._();

final class PastTranscriptionsProvider
    extends
        $FunctionalProvider<
          List<PastTranscription>,
          List<PastTranscription>,
          List<PastTranscription>
        >
    with $Provider<List<PastTranscription>> {
  PastTranscriptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pastTranscriptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pastTranscriptionsHash();

  @$internal
  @override
  $ProviderElement<List<PastTranscription>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<PastTranscription> create(Ref ref) {
    return pastTranscriptions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PastTranscription> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PastTranscription>>(value),
    );
  }
}

String _$pastTranscriptionsHash() =>
    r'a49b4167469294482d82ed5a4bca9665527ba04e';
