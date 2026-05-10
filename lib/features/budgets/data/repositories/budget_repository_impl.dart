import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../database/app_database.dart';
import '../../../../database/daos/budgets_dao.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/i_budget_repository.dart';

@LazySingleton(as: IBudgetRepository)
class BudgetRepositoryImpl implements IBudgetRepository {
  final BudgetsDao _dao;

  BudgetRepositoryImpl(this._dao);

  @override
  Stream<List<BudgetEntity>> watchActive() {
    return _dao.watchActive().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<BudgetEntity?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<void> insert(BudgetEntity budget) {
    return _dao.insertBudget(BudgetsCompanion.insert(
      id: budget.id,
      categoryId: budget.categoryId,
      amount: budget.amount,
      period: Value(budget.period.value),
      isRecurring: Value(budget.isRecurring ? 1 : 0),
      startDate: budget.startDate,
    ));
  }

  @override
  Future<void> update(BudgetEntity budget) {
    return _dao.updateBudget(BudgetsCompanion(
      id: Value(budget.id),
      categoryId: Value(budget.categoryId),
      amount: Value(budget.amount),
      period: Value(budget.period.value),
      isRecurring: Value(budget.isRecurring ? 1 : 0),
      startDate: Value(budget.startDate),
      isActive: Value(budget.isActive ? 1 : 0),
    ));
  }

  @override
  Future<void> delete(String id) {
    return _dao.deleteBudget(id);
  }

  BudgetEntity _toEntity(Budget row) {
    return BudgetEntity(
      id: row.id,
      categoryId: row.categoryId,
      amount: row.amount,
      period: BudgetPeriod.fromValue(row.period),
      isRecurring: row.isRecurring == 1,
      startDate: row.startDate,
      isActive: row.isActive == 1,
    );
  }
}
