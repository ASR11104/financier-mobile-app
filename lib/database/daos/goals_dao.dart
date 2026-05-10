import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/goals_table.dart';

part 'goals_dao.g.dart';

@DriftAccessor(tables: [Goals])
class GoalsDao extends DatabaseAccessor<AppDatabase>
    with _$GoalsDaoMixin {
  GoalsDao(super.db);

  Stream<List<Goal>> watchAll() {
    return (select(goals)
          ..orderBy([(g) => OrderingTerm.desc(g.createdAt)]))
        .watch();
  }

  Stream<List<Goal>> watchActive() {
    return (select(goals)
          ..where((g) => g.isCompleted.equals(0))
          ..orderBy([(g) => OrderingTerm.desc(g.createdAt)]))
        .watch();
  }

  Future<Goal?> getById(String id) {
    return (select(goals)..where((g) => g.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> insertGoal(GoalsCompanion goal) {
    return into(goals).insert(goal);
  }

  Future<void> updateGoal(GoalsCompanion goal) {
    return (update(goals)..where((g) => g.id.equals(goal.id.value)))
        .write(goal);
  }

  Future<void> updateCurrentAmount(String id, double amount) {
    return (update(goals)..where((g) => g.id.equals(id))).write(
      GoalsCompanion(currentAmount: Value(amount)),
    );
  }

  Future<void> markCompleted(String id, {required bool completed}) {
    return (update(goals)..where((g) => g.id.equals(id))).write(
      GoalsCompanion(isCompleted: Value(completed ? 1 : 0)),
    );
  }

  Future<void> deleteGoal(String id) {
    return (delete(goals)..where((g) => g.id.equals(id))).go();
  }
}
