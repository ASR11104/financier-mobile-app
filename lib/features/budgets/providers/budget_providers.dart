import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/enums/transaction_type.dart';
import '../../../core/utils/formatters.dart';
import '../domain/entities/budget_entity.dart';
import '../domain/repositories/i_budget_repository.dart';
import '../../transactions/providers/transactions_providers.dart';

part 'budget_providers.g.dart';

@riverpod
IBudgetRepository budgetRepository(Ref ref) => getIt<IBudgetRepository>();

@riverpod
Stream<List<BudgetEntity>> budgets(Ref ref) =>
    ref.watch(budgetRepositoryProvider).watchActive();

/// Computes the date prefix for filtering transactions in the current period.
String budgetDatePrefix(BudgetPeriod period) {
  return period == BudgetPeriod.monthly
      ? Formatters.currentMonthPrefix()
      : DateTime.now().year.toString();
}

/// All active budgets with their current-period spending.
///
/// Groups expense transactions into a map once (O(M)) then looks up each
/// budget by category in O(1), giving O(M+N) total instead of O(M×N).
@riverpod
List<BudgetWithSpending> budgetsWithSpending(Ref ref) {
  final budgetList = ref.watch(budgetsProvider).valueOrNull ?? [];
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];

  // Build category → spent map for each period once.
  final monthlySpend = <String, double>{};
  final yearlySpend = <String, double>{};
  final monthPrefix = Formatters.currentMonthPrefix();
  final yearPrefix = DateTime.now().year.toString();

  for (final t in txns) {
    if (t.type != TransactionType.expense) continue;
    if (t.date.startsWith(monthPrefix)) {
      monthlySpend[t.categoryId] =
          (monthlySpend[t.categoryId] ?? 0) + t.amount;
    }
    if (t.date.startsWith(yearPrefix)) {
      yearlySpend[t.categoryId] =
          (yearlySpend[t.categoryId] ?? 0) + t.amount;
    }
  }

  return budgetList.map((budget) {
    final spendMap = budget.period == BudgetPeriod.monthly
        ? monthlySpend
        : yearlySpend;
    return BudgetWithSpending(
      budget: budget,
      spent: spendMap[budget.categoryId] ?? 0,
    );
  }).toList();
}

