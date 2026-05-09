// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfers_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transferRepositoryHash() =>
    r'c855070e71e434a1460eeeed8c587a27410b27e6';

/// See also [transferRepository].
@ProviderFor(transferRepository)
final transferRepositoryProvider =
    AutoDisposeProvider<ITransferRepository>.internal(
      transferRepository,
      name: r'transferRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transferRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransferRepositoryRef = AutoDisposeProviderRef<ITransferRepository>;
String _$transfersHash() => r'ec99dbe85a159f1721256a54fa41e7bc5fe0168c';

/// See also [transfers].
@ProviderFor(transfers)
final transfersProvider =
    AutoDisposeStreamProvider<List<TransferEntity>>.internal(
      transfers,
      name: r'transfersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transfersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransfersRef = AutoDisposeStreamProviderRef<List<TransferEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
