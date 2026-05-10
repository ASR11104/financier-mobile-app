import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/budgets_table.dart';

part 'budgets_dao.g.dart';

@DriftAccessor(tables: [Budgets])
class BudgetsDao extends DatabaseAccessor<AppDatabase>
    with _$BudgetsDaoMixin {
  BudgetsDao(super.db);

  Stream<List<Budget>> watchAll() {
    return (select(budgets)
          ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
        .watch();
  }

  Stream<List<Budget>> watchActive() {
    return (select(budgets)
          ..where((b) => b.isActive.equals(1))
          ..orderBy([(b) => OrderingTerm.desc(b.createdAt)]))
        .watch();
  }

  Future<Budget?> getById(String id) {
    return (select(budgets)..where((b) => b.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> insertBudget(BudgetsCompanion budget) {
    return into(budgets).insert(budget);
  }

  Future<void> updateBudget(BudgetsCompanion budget) {
    return (update(budgets)..where((b) => b.id.equals(budget.id.value)))
        .write(budget);
  }

  Future<void> deactivateBudget(String id) {
    return (update(budgets)..where((b) => b.id.equals(id)))
        .write(const BudgetsCompanion(isActive: Value(0)));
  }

  Future<void> deleteBudget(String id) {
    return (delete(budgets)..where((b) => b.id.equals(id))).go();
  }
}
