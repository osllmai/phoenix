// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_console_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ServerConsoleController)
final serverConsoleControllerProvider = ServerConsoleControllerProvider._();

final class ServerConsoleControllerProvider
    extends $NotifierProvider<ServerConsoleController, ServerConsoleState> {
  ServerConsoleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverConsoleControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverConsoleControllerHash();

  @$internal
  @override
  ServerConsoleController create() => ServerConsoleController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerConsoleState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerConsoleState>(value),
    );
  }
}

String _$serverConsoleControllerHash() =>
    r'f780279e92c181c29928afcd19a6a9b9c1adec35';

abstract class _$ServerConsoleController extends $Notifier<ServerConsoleState> {
  ServerConsoleState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ServerConsoleState, ServerConsoleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ServerConsoleState, ServerConsoleState>,
              ServerConsoleState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
