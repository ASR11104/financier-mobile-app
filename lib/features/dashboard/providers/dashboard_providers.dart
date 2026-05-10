import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enums/account_type.dart';
import '../../../core/enums/transaction_type.dart';
import '../../../core/utils/formatters.dart';
import '../../accounts/providers/accounts_providers.dart';
import '../../transactions/providers/transactions_providers.dart';

part 'dashboard_providers.g.dart';

/// Sum of balances across all non-credit-card accounts (cash, bank, wallet).
@riverpod
double totalBalance(Ref ref) {
  final accounts = ref.watch(accountsProvider).valueOrNull ?? [];
  return accounts
      .where((a) => a.type != AccountType.creditCard)
      .fold(0.0, (sum, a) => sum + a.balance);
}

/// Total outstanding amount owed across all credit cards.
@riverpod
double creditCardLiability(Ref ref) {
  final accounts = ref.watch(accountsProvider).valueOrNull ?? [];
  return accounts
      .where((a) => a.type == AccountType.creditCard)
      .fold(0.0, (sum, a) => sum + (a.amountUsed ?? 0));
}

/// Net worth = liquid assets minus credit card liabilities.
@riverpod
double netWorth(Ref ref) =>
    ref.watch(totalBalanceProvider) - ref.watch(creditCardLiabilityProvider);

@riverpod
double monthlyIncome(Ref ref) {
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  final prefix = Formatters.currentMonthPrefix();
  return txns
      .where((t) =>
          t.type == TransactionType.income && t.date.startsWith(prefix))
      .fold(0.0, (sum, t) => sum + t.amount);
}

@riverpod
double monthlyExpense(Ref ref) {
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  final prefix = Formatters.currentMonthPrefix();
  return txns
      .where((t) =>
          t.type == TransactionType.expense && t.date.startsWith(prefix))
      .fold(0.0, (sum, t) => sum + t.amount);
}
