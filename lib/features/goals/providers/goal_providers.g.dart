// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$goalRepositoryHash() => r'f1295eccb4926ea36e2e59a730e9b7cd0ec0e615';

/// See also [goalRepository].
@ProviderFor(goalRepository)
final goalRepositoryProvider = AutoDisposeProvider<IGoalRepository>.internal(
  goalRepository,
  name: r'goalRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$goalRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoalRepositoryRef = AutoDisposeProviderRef<IGoalRepository>;
String _$goalsHash() => r'a4a11562b90b79e31f633ad8d4ace8dd1478de4e';

/// See also [goals].
@ProviderFor(goals)
final goalsProvider = AutoDisposeStreamProvider<List<GoalEntity>>.internal(
  goals,
  name: r'goalsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$goalsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoalsRef = AutoDisposeStreamProviderRef<List<GoalEntity>>;
String _$activeGoalsHash() => r'fcc5a14305a860a345629d39270c6d32213321cf';

/// See also [activeGoals].
@ProviderFor(activeGoals)
final activeGoalsProvider =
    AutoDisposeStreamProvider<List<GoalEntity>>.internal(
      activeGoals,
      name: r'activeGoalsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeGoalsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveGoalsRef = AutoDisposeStreamProviderRef<List<GoalEntity>>;
String _$goalContributionsHash() => r'42c01e1459f2ae9c9917c67c8a0864df157f3677';

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

/// See also [goalContributions].
@ProviderFor(goalContributions)
const goalContributionsProvider = GoalContributionsFamily();

/// See also [goalContributions].
class GoalContributionsFamily
    extends Family<AsyncValue<List<TransactionEntity>>> {
  /// See also [goalContributions].
  const GoalContributionsFamily();

  /// See also [goalContributions].
  GoalContributionsProvider call(String goalId) {
    return GoalContributionsProvider(goalId);
  }

  @override
  GoalContributionsProvider getProviderOverride(
    covariant GoalContributionsProvider provider,
  ) {
    return call(provider.goalId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'goalContributionsProvider';
}

/// See also [goalContributions].
class GoalContributionsProvider
    extends AutoDisposeStreamProvider<List<TransactionEntity>> {
  /// See also [goalContributions].
  GoalContributionsProvider(String goalId)
    : this._internal(
        (ref) => goalContributions(ref as GoalContributionsRef, goalId),
        from: goalContributionsProvider,
        name: r'goalContributionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$goalContributionsHash,
        dependencies: GoalContributionsFamily._dependencies,
        allTransitiveDependencies:
            GoalContributionsFamily._allTransitiveDependencies,
        goalId: goalId,
      );

  GoalContributionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.goalId,
  }) : super.internal();

  final String goalId;

  @override
  Override overrideWith(
    Stream<List<TransactionEntity>> Function(GoalContributionsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GoalContributionsProvider._internal(
        (ref) => create(ref as GoalContributionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        goalId: goalId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<TransactionEntity>> createElement() {
    return _GoalContributionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GoalContributionsProvider && other.goalId == goalId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, goalId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GoalContributionsRef
    on AutoDisposeStreamProviderRef<List<TransactionEntity>> {
  /// The parameter `goalId` of this provider.
  String get goalId;
}

class _GoalContributionsProviderElement
    extends AutoDisposeStreamProviderElement<List<TransactionEntity>>
    with GoalContributionsRef {
  _GoalContributionsProviderElement(super.provider);

  @override
  String get goalId => (origin as GoalContributionsProvider).goalId;
}

String _$goalProgressHash() => r'ad83d8342bfba19264c869ae6a66c5c0fa11f557';

/// See also [goalProgress].
@ProviderFor(goalProgress)
const goalProgressProvider = GoalProgressFamily();

/// See also [goalProgress].
class GoalProgressFamily extends Family<GoalProgress> {
  /// See also [goalProgress].
  const GoalProgressFamily();

  /// See also [goalProgress].
  GoalProgressProvider call(String goalId) {
    return GoalProgressProvider(goalId);
  }

  @override
  GoalProgressProvider getProviderOverride(
    covariant GoalProgressProvider provider,
  ) {
    return call(provider.goalId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'goalProgressProvider';
}

/// See also [goalProgress].
class GoalProgressProvider extends AutoDisposeProvider<GoalProgress> {
  /// See also [goalProgress].
  GoalProgressProvider(String goalId)
    : this._internal(
        (ref) => goalProgress(ref as GoalProgressRef, goalId),
        from: goalProgressProvider,
        name: r'goalProgressProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$goalProgressHash,
        dependencies: GoalProgressFamily._dependencies,
        allTransitiveDependencies:
            GoalProgressFamily._allTransitiveDependencies,
        goalId: goalId,
      );

  GoalProgressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.goalId,
  }) : super.internal();

  final String goalId;

  @override
  Override overrideWith(
    GoalProgress Function(GoalProgressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GoalProgressProvider._internal(
        (ref) => create(ref as GoalProgressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        goalId: goalId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<GoalProgress> createElement() {
    return _GoalProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GoalProgressProvider && other.goalId == goalId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, goalId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GoalProgressRef on AutoDisposeProviderRef<GoalProgress> {
  /// The parameter `goalId` of this provider.
  String get goalId;
}

class _GoalProgressProviderElement
    extends AutoDisposeProviderElement<GoalProgress>
    with GoalProgressRef {
  _GoalProgressProviderElement(super.provider);

  @override
  String get goalId => (origin as GoalProgressProvider).goalId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
