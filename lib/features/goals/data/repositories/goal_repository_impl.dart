import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/enums/investment_type.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../../core/services/transaction_ledger_service.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/goals_dao.dart';
import '../../../../database/daos/transactions_dao.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/i_goal_repository.dart';

@LazySingleton(as: IGoalRepository)
class GoalRepositoryImpl implements IGoalRepository {
  final AppDatabase _db;
  final GoalsDao _goalsDao;
  final TransactionsDao _transactionsDao;
  final TransactionLedgerService _ledgerService;

  GoalRepositoryImpl(
    this._db,
    this._goalsDao,
    this._transactionsDao,
    this._ledgerService,
  );

  @override
  Stream<List<GoalEntity>> watchAll() {
    return _goalsDao.watchAll().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Stream<List<GoalEntity>> watchActive() {
    return _goalsDao.watchActive().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<GoalEntity?> getById(String id) async {
    final row = await _goalsDao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<void> insert(GoalEntity goal) {
    return _goalsDao.insertGoal(GoalsCompanion.insert(
      id: goal.id,
      name: goal.name,
      description: Value(goal.description),
      targetAmount: goal.targetAmount,
      currentAmount: Value(goal.currentAmount),
      targetDate: Value(goal.targetDate),
      preferredInvestmentType:
          Value(goal.preferredInvestmentType?.value),
      icon: Value(goal.icon),
      color: Value(goal.color),
    ));
  }

  @override
  Future<void> update(GoalEntity goal) {
    return _goalsDao.updateGoal(GoalsCompanion(
      id: Value(goal.id),
      name: Value(goal.name),
      description: Value(goal.description),
      targetAmount: Value(goal.targetAmount),
      targetDate: Value(goal.targetDate),
      preferredInvestmentType:
          Value(goal.preferredInvestmentType?.value),
      icon: Value(goal.icon),
      color: Value(goal.color),
    ));
  }

  @override
  Future<void> delete(String id) async {
    // Detach linked transactions before deleting the goal
    final linked = await _transactionsDao.getByGoal(id);
    await _db.transaction(() async {
      for (final txn in linked) {
        await _ledgerService.reverseTransaction(txn);
      }
      await _goalsDao.deleteGoal(id);
    });
  }

  @override
  Future<void> addContribution({
    required String goalId,
    required String accountId,
    required String categoryId,
    required double amount,
    required String date,
    required String description,
    required InvestmentType investmentType,
  }) async {
    final txn = TransactionEntity(
      id: const Uuid().v4(),
      type: TransactionType.investment,
      amount: amount,
      accountId: accountId,
      categoryId: categoryId,
      date: date,
      description: description,
      investmentType: investmentType,
      goalId: goalId,
    );
    await _db.transaction(() async => _ledgerService.applyTransaction(txn));
  }

  @override
  Stream<List<TransactionEntity>> watchContributions(String goalId) {
    return _transactionsDao.watchByGoal(goalId).map(
          (rows) => rows
              .map((row) => TransactionEntity(
                    id: row.id,
                    type: TransactionType.fromValue(row.type),
                    amount: row.amount,
                    accountId: row.accountId,
                    categoryId: row.categoryId,
                    date: row.date,
                    description: row.description,
                    investmentType: row.investmentType == null
                        ? null
                        : InvestmentType.fromValue(row.investmentType!),
                    goalId: row.goalId,
                  ))
              .toList(),
        );
  }

  GoalEntity _toEntity(Goal row) {
    return GoalEntity(
      id: row.id,
      name: row.name,
      description: row.description,
      targetAmount: row.targetAmount,
      currentAmount: row.currentAmount,
      targetDate: row.targetDate,
      preferredInvestmentType: row.preferredInvestmentType == null
          ? null
          : InvestmentType.fromValue(row.preferredInvestmentType!),
      icon: row.icon,
      color: row.color,
      isCompleted: row.isCompleted == 1,
    );
  }
}
