import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/enums/transaction_type.dart';
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
  final now = DateTime.now();
  if (period == BudgetPeriod.monthly) {
    final month = now.month.toString().padLeft(2, '0');
    return '${now.year}-$month';
  }
  return '${now.year}';
}

/// All active budgets with their current-period spending, computed in-memory
/// from the live transactions stream. Reacts to both budget and transaction
/// changes without any async complexity.
@riverpod
List<BudgetWithSpending> budgetsWithSpending(Ref ref) {
  final budgetList = ref.watch(budgetsProvider).valueOrNull ?? [];
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];

  return budgetList.map((budget) {
    final prefix = budgetDatePrefix(budget.period);
    final spent = txns
        .where((t) =>
            t.type == TransactionType.expense &&
            t.categoryId == budget.categoryId &&
            t.date.startsWith(prefix))
        .fold(0.0, (sum, t) => sum + t.amount);
    return BudgetWithSpending(budget: budget, spent: spent);
  }).toList();
}

