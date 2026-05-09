// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryRepositoryHash() =>
    r'6cd1799e9d1bf1aeac138a0bd8f9608a772f9bec';

/// See also [categoryRepository].
@ProviderFor(categoryRepository)
final categoryRepositoryProvider =
    AutoDisposeProvider<ICategoryRepository>.internal(
      categoryRepository,
      name: r'categoryRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryRepositoryRef = AutoDisposeProviderRef<ICategoryRepository>;
String _$categoriesHash() => r'5155dbb02d582758f519d05ab470139c4aa89e03';

/// See also [categories].
@ProviderFor(categories)
final categoriesProvider =
    AutoDisposeStreamProvider<List<CategoryEntity>>.internal(
      categories,
      name: r'categoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesRef = AutoDisposeStreamProviderRef<List<CategoryEntity>>;
String _$categoriesByTypeHash() => r'efddc31a3f3f5efd74805111ba33579cb9b535ba';

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

/// See also [categoriesByType].
@ProviderFor(categoriesByType)
const categoriesByTypeProvider = CategoriesByTypeFamily();

/// See also [categoriesByType].
class CategoriesByTypeFamily extends Family<AsyncValue<List<CategoryEntity>>> {
  /// See also [categoriesByType].
  const CategoriesByTypeFamily();

  /// See also [categoriesByType].
  CategoriesByTypeProvider call(String type) {
    return CategoriesByTypeProvider(type);
  }

  @override
  CategoriesByTypeProvider getProviderOverride(
    covariant CategoriesByTypeProvider provider,
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
  String? get name => r'categoriesByTypeProvider';
}

/// See also [categoriesByType].
class CategoriesByTypeProvider
    extends AutoDisposeStreamProvider<List<CategoryEntity>> {
  /// See also [categoriesByType].
  CategoriesByTypeProvider(String type)
    : this._internal(
        (ref) => categoriesByType(ref as CategoriesByTypeRef, type),
        from: categoriesByTypeProvider,
        name: r'categoriesByTypeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$categoriesByTypeHash,
        dependencies: CategoriesByTypeFamily._dependencies,
        allTransitiveDependencies:
            CategoriesByTypeFamily._allTransitiveDependencies,
        type: type,
      );

  CategoriesByTypeProvider._internal(
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
    Stream<List<CategoryEntity>> Function(CategoriesByTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoriesByTypeProvider._internal(
        (ref) => create(ref as CategoriesByTypeRef),
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
  AutoDisposeStreamProviderElement<List<CategoryEntity>> createElement() {
    return _CategoriesByTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoriesByTypeProvider && other.type == type;
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
mixin CategoriesByTypeRef
    on AutoDisposeStreamProviderRef<List<CategoryEntity>> {
  /// The parameter `type` of this provider.
  String get type;
}

class _CategoriesByTypeProviderElement
    extends AutoDisposeStreamProviderElement<List<CategoryEntity>>
    with CategoriesByTypeRef {
  _CategoriesByTypeProviderElement(super.provider);

  @override
  String get type => (origin as CategoriesByTypeProvider).type;
}

String _$categoryByIdHash() => r'3652a28cabdf896c2b1213805d6f285543993aab';

/// See also [categoryById].
@ProviderFor(categoryById)
const categoryByIdProvider = CategoryByIdFamily();

/// See also [categoryById].
class CategoryByIdFamily extends Family<AsyncValue<CategoryEntity?>> {
  /// See also [categoryById].
  const CategoryByIdFamily();

  /// See also [categoryById].
  CategoryByIdProvider call(String id) {
    return CategoryByIdProvider(id);
  }

  @override
  CategoryByIdProvider getProviderOverride(
    covariant CategoryByIdProvider provider,
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
  String? get name => r'categoryByIdProvider';
}

/// See also [categoryById].
class CategoryByIdProvider extends AutoDisposeFutureProvider<CategoryEntity?> {
  /// See also [categoryById].
  CategoryByIdProvider(String id)
    : this._internal(
        (ref) => categoryById(ref as CategoryByIdRef, id),
        from: categoryByIdProvider,
        name: r'categoryByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$categoryByIdHash,
        dependencies: CategoryByIdFamily._dependencies,
        allTransitiveDependencies:
            CategoryByIdFamily._allTransitiveDependencies,
        id: id,
      );

  CategoryByIdProvider._internal(
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
    FutureOr<CategoryEntity?> Function(CategoryByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryByIdProvider._internal(
        (ref) => create(ref as CategoryByIdRef),
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
  AutoDisposeFutureProviderElement<CategoryEntity?> createElement() {
    return _CategoryByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryByIdProvider && other.id == id;
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
mixin CategoryByIdRef on AutoDisposeFutureProviderRef<CategoryEntity?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _CategoryByIdProviderElement
    extends AutoDisposeFutureProviderElement<CategoryEntity?>
    with CategoryByIdRef {
  _CategoryByIdProviderElement(super.provider);

  @override
  String get id => (origin as CategoryByIdProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
