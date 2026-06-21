// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(documentsRepository)
final documentsRepositoryProvider = DocumentsRepositoryProvider._();

final class DocumentsRepositoryProvider
    extends
        $FunctionalProvider<
          DocumentsRepository,
          DocumentsRepository,
          DocumentsRepository
        >
    with $Provider<DocumentsRepository> {
  DocumentsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsRepositoryHash();

  @$internal
  @override
  $ProviderElement<DocumentsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DocumentsRepository create(Ref ref) {
    return documentsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentsRepository>(value),
    );
  }
}

String _$documentsRepositoryHash() =>
    r'c68a5bb97177877b1ec0fda323c6793420e3f0f0';

@ProviderFor(documentLibrary)
final documentLibraryProvider = DocumentLibraryProvider._();

final class DocumentLibraryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PhoenixDocument>>,
          List<PhoenixDocument>,
          FutureOr<List<PhoenixDocument>>
        >
    with
        $FutureModifier<List<PhoenixDocument>>,
        $FutureProvider<List<PhoenixDocument>> {
  DocumentLibraryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentLibraryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentLibraryHash();

  @$internal
  @override
  $FutureProviderElement<List<PhoenixDocument>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PhoenixDocument>> create(Ref ref) {
    return documentLibrary(ref);
  }
}

String _$documentLibraryHash() => r'0be0b5801349e6984b0da1d7877efe5b74959c6b';

@ProviderFor(DocumentFilter)
final documentFilterProvider = DocumentFilterProvider._();

final class DocumentFilterProvider
    extends $NotifierProvider<DocumentFilter, String> {
  DocumentFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentFilterHash();

  @$internal
  @override
  DocumentFilter create() => DocumentFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$documentFilterHash() => r'85806bbb2b92032682fddec70e734f487aa3dae6';

abstract class _$DocumentFilter extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(DocumentQuery)
final documentQueryProvider = DocumentQueryProvider._();

final class DocumentQueryProvider
    extends $NotifierProvider<DocumentQuery, String> {
  DocumentQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentQueryHash();

  @$internal
  @override
  DocumentQuery create() => DocumentQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$documentQueryHash() => r'8db1555a730e5bcd333c3b65e2436a17d5033db3';

abstract class _$DocumentQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectedDocumentId)
final selectedDocumentIdProvider = SelectedDocumentIdProvider._();

final class SelectedDocumentIdProvider
    extends $NotifierProvider<SelectedDocumentId, String?> {
  SelectedDocumentIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDocumentIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDocumentIdHash();

  @$internal
  @override
  SelectedDocumentId create() => SelectedDocumentId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedDocumentIdHash() =>
    r'eaeb96cfdaf8b609dde7469471329a3b0fabde2e';

abstract class _$SelectedDocumentId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(selectedDocument)
final selectedDocumentProvider = SelectedDocumentProvider._();

final class SelectedDocumentProvider
    extends
        $FunctionalProvider<
          AsyncValue<PhoenixDocument?>,
          PhoenixDocument?,
          FutureOr<PhoenixDocument?>
        >
    with $FutureModifier<PhoenixDocument?>, $FutureProvider<PhoenixDocument?> {
  SelectedDocumentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDocumentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDocumentHash();

  @$internal
  @override
  $FutureProviderElement<PhoenixDocument?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PhoenixDocument?> create(Ref ref) {
    return selectedDocument(ref);
  }
}

String _$selectedDocumentHash() => r'fef3f47f19374467a94014b182d065b658140185';

@ProviderFor(libraryIsEmpty)
final libraryIsEmptyProvider = LibraryIsEmptyProvider._();

final class LibraryIsEmptyProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  LibraryIsEmptyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryIsEmptyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryIsEmptyHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return libraryIsEmpty(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$libraryIsEmptyHash() => r'7888c3acaf46df12f26f79445ae4cd486bdd4e13';

@ProviderFor(visibleDocuments)
final visibleDocumentsProvider = VisibleDocumentsProvider._();

final class VisibleDocumentsProvider
    extends
        $FunctionalProvider<
          List<PhoenixDocument>,
          List<PhoenixDocument>,
          List<PhoenixDocument>
        >
    with $Provider<List<PhoenixDocument>> {
  VisibleDocumentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visibleDocumentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visibleDocumentsHash();

  @$internal
  @override
  $ProviderElement<List<PhoenixDocument>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<PhoenixDocument> create(Ref ref) {
    return visibleDocuments(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PhoenixDocument> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PhoenixDocument>>(value),
    );
  }
}

String _$visibleDocumentsHash() => r'1ab6fd4f392415493e81b5cfe7f64f2089befae2';
