import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_entity.freezed.dart';

enum BudgetPeriod {
  monthly,
  yearly;

  String get value => name;
  String get label => switch (this) {
        BudgetPeriod.monthly => 'Monthly',
        BudgetPeriod.yearly => 'Yearly',
      };

  static BudgetPeriod fromValue(String v) =>
      BudgetPeriod.values.firstWhere((e) => e.value == v);
}

@freezed
class BudgetEntity with _$BudgetEntity {
  const factory BudgetEntity({
    required String id,
    required String categoryId,
    required double amount,
    @Default(BudgetPeriod.monthly) BudgetPeriod period,
    @Default(true) bool isRecurring,
    required DateTime startDate,
    @Default(true) bool isActive,
  }) = _BudgetEntity;
}

/// View model combining a budget with its computed spending for the current period.
class BudgetWithSpending {
  final BudgetEntity budget;
  final double spent;

  BudgetWithSpending({required this.budget, required this.spent});

  double get remaining => (budget.amount - spent).clamp(0, double.infinity);
  double get percentUsed =>
      budget.amount > 0 ? (spent / budget.amount).clamp(0, double.infinity) : 0;
  bool get isOverBudget => spent > budget.amount;
  double get overrun => (spent - budget.amount).clamp(0, double.infinity);
}
