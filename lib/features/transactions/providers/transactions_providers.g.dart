// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionRepositoryHash() =>
    r'dfd8c92c6688e12053f843a96d89891d0de7cf4a';

/// See also [transactionRepository].
@ProviderFor(transactionRepository)
final transactionRepositoryProvider =
    AutoDisposeProvider<ITransactionRepository>.internal(
      transactionRepository,
      name: r'transactionRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionRepositoryRef =
    AutoDisposeProviderRef<ITransactionRepository>;
String _$transactionsHash() => r'696b3762eafec8f2d5fe420306c55e583b218662';

/// See also [transactions].
@ProviderFor(transactions)
final transactionsProvider =
    AutoDisposeStreamProvider<List<TransactionEntity>>.internal(
      transactions,
      name: r'transactionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionsRef = AutoDisposeStreamProviderRef<List<TransactionEntity>>;
String _$transactionsByTypeHash() =>
    r'04d090d5875db0056a5843592d27efd417686292';

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

/// See also [transactionsByType].
@ProviderFor(transactionsByType)
const transactionsByTypeProvider = TransactionsByTypeFamily();

/// See also [transactionsByType].
class TransactionsByTypeFamily
    extends Family<AsyncValue<List<TransactionEntity>>> {
  /// See also [transactionsByType].
  const TransactionsByTypeFamily();

  /// See also [transactionsByType].
  TransactionsByTypeProvider call(String type) {
    return TransactionsByTypeProvider(type);
  }

  @override
  TransactionsByTypeProvider getProviderOverride(
    covariant TransactionsByTypeProvider provider,
  ) {
    return call(provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'transactionsByTypeProvider';
}

/// See also [transactionsByType].
class TransactionsByTypeProvider
    extends AutoDisposeStreamProvider<List<TransactionEntity>> {
  /// See also [transactionsByType].
  TransactionsByTypeProvider(String type)
    : this._internal(
        (ref) => transactionsByType(ref as TransactionsByTypeRef, type),
        from: transactionsByTypeProvider,
        name: r'transactionsByTypeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$transactionsByTypeHash,
        dependencies: TransactionsByTypeFamily._dependencies,
        allTransitiveDependencies:
            TransactionsByTypeFamily._allTransitiveDependencies,
        type: type,
      );

  TransactionsByTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final String type;

  @override
  Override overrideWith(
    Stream<List<TransactionEntity>> Function(TransactionsByTypeRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransactionsByTypeProvider._internal(
        (ref) => create(ref as TransactionsByTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TransactionEntity>> createElement() {
    return _TransactionsByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionsByTypeProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransactionsByTypeRef
    on AutoDisposeStreamProviderRef<List<TransactionEntity>> {
  /// The parameter `type` of this provider.
  String get type;
}

class _TransactionsByTypeProviderElement
    extends AutoDisposeStreamProviderElement<List<TransactionEntity>>
    with TransactionsByTypeRef {
  _TransactionsByTypeProviderElement(super.provider);

  @override
  String get type => (origin as TransactionsByTypeProvider).type;
}

String _$recentTransactionsHash() =>
    r'c8acc615b897496a6d166d908c2fa82428cfce1f';

/// See also [recentTransactions].
@ProviderFor(recentTransactions)
const recentTransactionsProvider = RecentTransactionsFamily();

/// See also [recentTransactions].
class RecentTransactionsFamily
    extends Family<AsyncValue<List<TransactionEntity>>> {
  /// See also [recentTransactions].
  const RecentTransactionsFamily();

  /// See also [recentTransactions].
  RecentTransactionsProvider call({int limit = 10}) {
    return RecentTransactionsProvider(limit: limit);
  }

  @override
  RecentTransactionsProvider getProviderOverride(
    covariant RecentTransactionsProvider provider,
  ) {
    return call(limit: provider.limit);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recentTransactionsProvider';
}

/// See also [recentTransactions].
class RecentTransactionsProvider
    extends AutoDisposeStreamProvider<List<TransactionEntity>> {
  /// See also [recentTransactions].
  RecentTransactionsProvider({int limit = 10})
    : this._internal(
        (ref) => recentTransactions(ref as RecentTransactionsRef, limit: limit),
        from: recentTransactionsProvider,
        name: r'recentTransactionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$recentTransactionsHash,
        dependencies: RecentTransactionsFamily._dependencies,
        allTransitiveDependencies:
            RecentTransactionsFamily._allTransitiveDependencies,
        limit: limit,
      );

  RecentTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    Stream<List<TransactionEntity>> Function(RecentTransactionsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecentTransactionsProvider._internal(
        (ref) => create(ref as RecentTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TransactionEntity>> createElement() {
    return _RecentTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentTransactionsProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecentTransactionsRef
    on AutoDisposeStreamProviderRef<List<TransactionEntity>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _RecentTransactionsProviderElement
    extends AutoDisposeStreamProviderElement<List<TransactionEntity>>
    with RecentTransactionsRef {
  _RecentTransactionsProviderElement(super.provider);

  @override
  int get limit => (origin as RecentTransactionsProvider).limit;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
