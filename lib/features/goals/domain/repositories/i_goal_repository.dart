import '../../../../core/enums/investment_type.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../entities/goal_entity.dart';

abstract class IGoalRepository {
  Stream<List<GoalEntity>> watchAll();
  Stream<List<GoalEntity>> watchActive();
  Future<GoalEntity?> getById(String id);
  Future<void> insert(GoalEntity goal);
  Future<void> update(GoalEntity goal);
  Future<void> delete(String id);

  /// Records a contribution: creates an investment transaction (debiting the
  /// account and writing a ledger entry), then updates the goal's cached total.
  Future<void> addContribution({
    required String goalId,
    required String accountId,
    required String categoryId,
    required double amount,
    required String date,
    required String description,
    required InvestmentType investmentType,
  });

  Stream<List<TransactionEntity>> watchContributions(String goalId);
}
