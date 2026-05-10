import '../entities/budget_entity.dart';

abstract class IBudgetRepository {
  Stream<List<BudgetEntity>> watchActive();
  Future<BudgetEntity?> getById(String id);
  Future<void> insert(BudgetEntity budget);
  Future<void> update(BudgetEntity budget);
  Future<void> delete(String id);
}
