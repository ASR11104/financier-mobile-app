// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$budgetRepositoryHash() => r'e328ee8bf5403ef1e6c1d68c12f93ac8342d837c';

/// See also [budgetRepository].
@ProviderFor(budgetRepository)
final budgetRepositoryProvider =
    AutoDisposeProvider<IBudgetRepository>.internal(
      budgetRepository,
      name: r'budgetRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$budgetRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetRepositoryRef = AutoDisposeProviderRef<IBudgetRepository>;
String _$budgetsHash() => r'9feb5b1eedc12b9d2ed6b8cef167ee7e8ee2404f';

/// See also [budgets].
@ProviderFor(budgets)
final budgetsProvider = AutoDisposeStreamProvider<List<BudgetEntity>>.internal(
  budgets,
  name: r'budgetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetsRef = AutoDisposeStreamProviderRef<List<BudgetEntity>>;
String _$budgetsWithSpendingHash() =>
    r'669ffa532b58fb94681457ffaac6b23361718a08';

/// All active budgets with their current-period spending.
///
/// Groups expense transactions into a map once (O(M)) then looks up each
/// budget by category in O(1), giving O(M+N) total instead of O(M×N).
///
/// Copied from [budgetsWithSpending].
@ProviderFor(budgetsWithSpending)
final budgetsWithSpendingProvider =
    AutoDisposeProvider<List<BudgetWithSpending>>.internal(
      budgetsWithSpending,
      name: r'budgetsWithSpendingProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$budgetsWithSpendingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetsWithSpendingRef =
    AutoDisposeProviderRef<List<BudgetWithSpending>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
