import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enums/account_type.dart';
import '../../../core/enums/transaction_type.dart';
import '../../accounts/providers/accounts_providers.dart';
import '../../transactions/providers/transactions_providers.dart';

part 'dashboard_providers.g.dart';

@riverpod
double totalBalance(Ref ref) {
  final accounts = ref.watch(accountsProvider).valueOrNull ?? [];
  return accounts
      .where((a) => a.type != AccountType.creditCard)
      .fold(0.0, (sum, a) => sum + a.balance);
}

@riverpod
double monthlyIncome(Ref ref) {
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  final prefix = _currentMonthPrefix();
  return txns
      .where((t) =>
          t.type == TransactionType.income && t.date.startsWith(prefix))
      .fold(0.0, (sum, t) => sum + t.amount);
}

@riverpod
double monthlyExpense(Ref ref) {
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  final prefix = _currentMonthPrefix();
  return txns
      .where((t) =>
          t.type == TransactionType.expense && t.date.startsWith(prefix))
      .fold(0.0, (sum, t) => sum + t.amount);
}

String _currentMonthPrefix() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}
