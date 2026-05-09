import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enums/transaction_type.dart';
import '../../categories/providers/categories_providers.dart';
import '../../transactions/providers/transactions_providers.dart';

part 'analytics_providers.g.dart';

class MonthlyTotal {
  final String label;
  final String yearMonth;
  final double income;
  final double expense;

  const MonthlyTotal({
    required this.label,
    required this.yearMonth,
    required this.income,
    required this.expense,
  });
}

class CategorySpend {
  final String categoryId;
  final String name;
  final String color;
  final double total;

  const CategorySpend({
    required this.categoryId,
    required this.name,
    required this.color,
    required this.total,
  });
}

@riverpod
List<MonthlyTotal> monthlyTotals(Ref ref) {
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  final months = _lastSixMonths();

  return months.map((ym) {
    final inMonth = txns.where((t) => t.date.startsWith(ym));
    final income = inMonth
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (s, t) => s + t.amount);
    final expense = inMonth
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (s, t) => s + t.amount);
    return MonthlyTotal(
      label: _monthLabel(ym),
      yearMonth: ym,
      income: income,
      expense: expense,
    );
  }).toList();
}

@riverpod
List<CategorySpend> categorySpending(Ref ref) {
  final txns = ref.watch(transactionsProvider).valueOrNull ?? [];
  final cats = ref.watch(categoriesProvider).valueOrNull ?? [];
  final prefix = _currentMonthPrefix();

  final expenseTxns = txns.where(
      (t) => t.type == TransactionType.expense && t.date.startsWith(prefix));

  final Map<String, double> totals = {};
  for (final t in expenseTxns) {
    totals[t.categoryId] = (totals[t.categoryId] ?? 0) + t.amount;
  }

  return totals.entries.map((e) {
    final cat = cats.firstWhere(
      (c) => c.id == e.key,
      orElse: () => cats.isNotEmpty ? cats.first : throw StateError(''),
    );
    return CategorySpend(
      categoryId: e.key,
      name: cat.name,
      color: cat.color,
      total: e.value,
    );
  }).toList()
    ..sort((a, b) => b.total.compareTo(a.total));
}

List<String> _lastSixMonths() {
  final now = DateTime.now();
  return List.generate(6, (i) {
    final d = DateTime(now.year, now.month - i);
    return '${d.year}-${d.month.toString().padLeft(2, '0')}';
  }).reversed.toList();
}

String _monthLabel(String yearMonth) {
  const months = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final parts = yearMonth.split('-');
  return months[int.parse(parts[1])];
}

String _currentMonthPrefix() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}
