// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountRepositoryHash() => r'a0e68931adb608223cf735be530b689583b16af5';

/// See also [accountRepository].
@ProviderFor(accountRepository)
final accountRepositoryProvider =
    AutoDisposeProvider<IAccountRepository>.internal(
      accountRepository,
      name: r'accountRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accountRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountRepositoryRef = AutoDisposeProviderRef<IAccountRepository>;
String _$accountsHash() => r'a1ab5f8c24715c8511b04db24f934e00c97ca408';

/// See also [accounts].
@ProviderFor(accounts)
final accountsProvider =
    AutoDisposeStreamProvider<List<AccountEntity>>.internal(
      accounts,
      name: r'accountsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accountsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountsRef = AutoDisposeStreamProviderRef<List<AccountEntity>>;
String _$accountByIdHash() => r'e7d1ef5499690d3d8d30a3bf186800282c9a0a60';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [accountById].
@ProviderFor(accountById)
const accountByIdProvider = AccountByIdFamily();

/// See also [accountById].
class AccountByIdFamily extends Family<AsyncValue<AccountEntity?>> {
  /// See also [accountById].
  const AccountByIdFamily();

  /// See also [accountById].
  AccountByIdProvider call(String id) {
    return AccountByIdProvider(id);
  }

  @override
  AccountByIdProvider getProviderOverride(
    covariant AccountByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'accountByIdProvider';
}

/// See also [accountById].
class AccountByIdProvider extends AutoDisposeStreamProvider<AccountEntity?> {
  /// See also [accountById].
  AccountByIdProvider(String id)
    : this._internal(
        (ref) => accountById(ref as AccountByIdRef, id),
        from: accountByIdProvider,
        name: r'accountByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$accountByIdHash,
        dependencies: AccountByIdFamily._dependencies,
        allTransitiveDependencies: AccountByIdFamily._allTransitiveDependencies,
        id: id,
      );

  AccountByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<AccountEntity?> Function(AccountByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountByIdProvider._internal(
        (ref) => create(ref as AccountByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<AccountEntity?> createElement() {
    return _AccountByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountByIdRef on AutoDisposeStreamProviderRef<AccountEntity?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _AccountByIdProviderElement
    extends AutoDisposeStreamProviderElement<AccountEntity?>
    with AccountByIdRef {
  _AccountByIdProviderElement(super.provider);

  @override
  String get id => (origin as AccountByIdProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
