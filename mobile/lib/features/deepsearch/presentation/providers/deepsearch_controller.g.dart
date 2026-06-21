// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deepsearch_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives a research session against the live backend: POSTs the query, then
/// polls the run until it is `ready` or `failed`, exposing idle/searching/
/// ready/error via [AsyncValue].

@ProviderFor(DeepSearchController)
final deepSearchControllerProvider = DeepSearchControllerProvider._();

/// Drives a research session against the live backend: POSTs the query, then
/// polls the run until it is `ready` or `failed`, exposing idle/searching/
/// ready/error via [AsyncValue].
final class DeepSearchControllerProvider
    extends $AsyncNotifierProvider<DeepSearchController, DeepSearchState> {
  /// Drives a research session against the live backend: POSTs the query, then
  /// polls the run until it is `ready` or `failed`, exposing idle/searching/
  /// ready/error via [AsyncValue].
  DeepSearchControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deepSearchControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deepSearchControllerHash();

  @$internal
  @override
  DeepSearchController create() => DeepSearchController();
}

String _$deepSearchControllerHash() =>
    r'74abdef900480fc25c26bf09dc5e3f045a0ed438';

/// Drives a research session against the live backend: POSTs the query, then
/// polls the run until it is `ready` or `failed`, exposing idle/searching/
/// ready/error via [AsyncValue].

abstract class _$DeepSearchController extends $AsyncNotifier<DeepSearchState> {
  FutureOr<DeepSearchState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DeepSearchState>, DeepSearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DeepSearchState>, DeepSearchState>,
              AsyncValue<DeepSearchState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
