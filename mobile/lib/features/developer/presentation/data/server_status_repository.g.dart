// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_status_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(serverStatusRepository)
final serverStatusRepositoryProvider = ServerStatusRepositoryProvider._();

final class ServerStatusRepositoryProvider
    extends
        $FunctionalProvider<
          ServerStatusRepository,
          ServerStatusRepository,
          ServerStatusRepository
        >
    with $Provider<ServerStatusRepository> {
  ServerStatusRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverStatusRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverStatusRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServerStatusRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServerStatusRepository create(Ref ref) {
    return serverStatusRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerStatusRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerStatusRepository>(value),
    );
  }
}

String _$serverStatusRepositoryHash() =>
    r'845970eb0903c01719a5d80b912589dac6730028';
