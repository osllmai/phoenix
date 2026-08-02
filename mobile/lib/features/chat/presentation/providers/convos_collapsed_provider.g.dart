// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convos_collapsed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the conversation column is collapsed to the narrow rail. `null` means
/// the user has not chosen, so the side-pane falls back to its form-factor
/// default (tablet collapses, desktop expands). Persisted across reloads.

@ProviderFor(ConvosCollapsed)
final convosCollapsedProvider = ConvosCollapsedProvider._();

/// Whether the conversation column is collapsed to the narrow rail. `null` means
/// the user has not chosen, so the side-pane falls back to its form-factor
/// default (tablet collapses, desktop expands). Persisted across reloads.
final class ConvosCollapsedProvider
    extends $AsyncNotifierProvider<ConvosCollapsed, bool?> {
  /// Whether the conversation column is collapsed to the narrow rail. `null` means
  /// the user has not chosen, so the side-pane falls back to its form-factor
  /// default (tablet collapses, desktop expands). Persisted across reloads.
  ConvosCollapsedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'convosCollapsedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$convosCollapsedHash();

  @$internal
  @override
  ConvosCollapsed create() => ConvosCollapsed();
}

String _$convosCollapsedHash() => r'4232908f326c4def5032db39be44c67066308b73';

/// Whether the conversation column is collapsed to the narrow rail. `null` means
/// the user has not chosen, so the side-pane falls back to its form-factor
/// default (tablet collapses, desktop expands). Persisted across reloads.

abstract class _$ConvosCollapsed extends $AsyncNotifier<bool?> {
  FutureOr<bool?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool?>, bool?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool?>, bool?>,
              AsyncValue<bool?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
