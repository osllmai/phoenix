// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_health_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resolves to reachable/unreachable rather than erroring, so the UI has a single
/// data state to render (any failure → unreachable).

@ProviderFor(serverHealth)
final serverHealthProvider = ServerHealthProvider._();

/// Resolves to reachable/unreachable rather than erroring, so the UI has a single
/// data state to render (any failure → unreachable).

final class ServerHealthProvider
    extends
        $FunctionalProvider<
          AsyncValue<ServerHealth>,
          ServerHealth,
          FutureOr<ServerHealth>
        >
    with $FutureModifier<ServerHealth>, $FutureProvider<ServerHealth> {
  /// Resolves to reachable/unreachable rather than erroring, so the UI has a single
  /// data state to render (any failure → unreachable).
  ServerHealthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverHealthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverHealthHash();

  @$internal
  @override
  $FutureProviderElement<ServerHealth> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ServerHealth> create(Ref ref) {
    return serverHealth(ref);
  }
}

String _$serverHealthHash() => r'e0642b2e80c16728983889a7e8745127fbc9fed2';
