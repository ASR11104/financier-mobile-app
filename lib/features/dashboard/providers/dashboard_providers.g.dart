// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$totalBalanceHash() => r'343287f1d417940bf924bfdace36ca8ac4be0890';

/// Sum of balances across all non-credit-card accounts (cash, bank, wallet).
///
/// Copied from [totalBalance].
@ProviderFor(totalBalance)
final totalBalanceProvider = AutoDisposeProvider<double>.internal(
  totalBalance,
  name: r'totalBalanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalBalanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalBalanceRef = AutoDisposeProviderRef<double>;
String _$creditCardLiabilityHash() =>
    r'6d1ceca0c4e54a33af58ede08b5139e219cbe05e';

/// Total outstanding amount owed across all credit cards.
///
/// Copied from [creditCardLiability].
@ProviderFor(creditCardLiability)
final creditCardLiabilityProvider = AutoDisposeProvider<double>.internal(
  creditCardLiability,
  name: r'creditCardLiabilityProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$creditCardLiabilityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreditCardLiabilityRef = AutoDisposeProviderRef<double>;
String _$netWorthHash() => r'5ecf8aaf857d245c527847c216bc6e86f9ad05ae';

/// Net worth = liquid assets minus credit card liabilities.
///
/// Copied from [netWorth].
@ProviderFor(netWorth)
final netWorthProvider = AutoDisposeProvider<double>.internal(
  netWorth,
  name: r'netWorthProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$netWorthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NetWorthRef = AutoDisposeProviderRef<double>;
String _$monthlyIncomeHash() => r'e9a05dcef2ad1ddbb616a7b5b30cdcfa7beb84fe';

/// See also [monthlyIncome].
@ProviderFor(monthlyIncome)
final monthlyIncomeProvider = AutoDisposeProvider<double>.internal(
  monthlyIncome,
  name: r'monthlyIncomeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$monthlyIncomeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlyIncomeRef = AutoDisposeProviderRef<double>;
String _$monthlyExpenseHash() => r'49f9d73dbf15d4ef92286e561803dcb9c8c14ca3';

/// See also [monthlyExpense].
@ProviderFor(monthlyExpense)
final monthlyExpenseProvider = AutoDisposeProvider<double>.internal(
  monthlyExpense,
  name: r'monthlyExpenseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$monthlyExpenseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlyExpenseRef = AutoDisposeProviderRef<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
