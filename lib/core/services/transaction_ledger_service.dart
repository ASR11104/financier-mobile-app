import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../database/app_database.dart';
import '../../database/daos/accounts_dao.dart';
import '../../database/daos/goals_dao.dart';
import '../../database/daos/ledger_dao.dart';
import '../../database/daos/transactions_dao.dart';
import '../../features/transactions/domain/entities/transaction_entity.dart';
import '../enums/account_type.dart';
import '../enums/transaction_type.dart';

/// Shared service that applies and reverses financial transactions.
///
/// Both [TransactionRepositoryImpl] and [GoalRepositoryImpl] delegate here
/// so that account-balance, ledger, and goal-cache updates stay in sync.
/// All callers must wrap calls inside [AppDatabase.transaction].
@lazySingleton
class TransactionLedgerService {
  final TransactionsDao _transactionsDao;
  final LedgerDao _ledgerDao;
  final AccountsDao _accountsDao;
  final GoalsDao _goalsDao;

  TransactionLedgerService(
    this._transactionsDao,
    this._ledgerDao,
    this._accountsDao,
    this._goalsDao,
  );

  /// Records a transaction, updates the account balance and ledger entry,
  /// and increments the linked goal's cached amount if [txn.goalId] is set.
  Future<void> applyTransaction(TransactionEntity txn) async {
    final account = await _accountsDao.getById(txn.accountId);
    if (account == null) throw Exception('Account not found: ${txn.accountId}');

    final isDebit = txn.type == TransactionType.expense ||
        txn.type == TransactionType.investment;
    final newBalance =
        isDebit ? account.balance - txn.amount : account.balance + txn.amount;

    await _transactionsDao.insertTransaction(TransactionsCompanion.insert(
      id: txn.id,
      type: txn.type.value,
      amount: txn.amount,
      accountId: txn.accountId,
      categoryId: txn.categoryId,
      description: Value(txn.description),
      date: txn.date,
      investmentType: Value(txn.investmentType?.value),
      goalId: Value(txn.goalId),
    ));

    if (txn.tagIds.isNotEmpty) {
      await _transactionsDao.setTagsForTransaction(txn.id, txn.tagIds);
    }

    await _ledgerDao.insertEntry(LedgerEntriesCompanion.insert(
      id: const Uuid().v4(),
      accountId: txn.accountId,
      transactionId: Value(txn.id),
      entryType: isDebit ? 'debit' : 'credit',
      amount: txn.amount,
      runningBalance: newBalance,
      date: txn.date,
      description: Value(
        txn.description.isNotEmpty ? txn.description : txn.type.label,
      ),
    ));

    await _accountsDao.updateBalance(txn.accountId, newBalance);

    if (account.type == AccountType.creditCard.value && isDebit) {
      final newAmountUsed = (account.amountUsed ?? 0) + txn.amount;
      await _accountsDao.updateAmountUsed(txn.accountId, newAmountUsed);
    }

    if (txn.goalId != null) {
      await _updateGoalAmount(txn.goalId!, txn.amount);
    }
  }

  /// Deletes a transaction, restores the account balance, and reverses any
  /// ledger entry and goal-cache change that the original application made.
  Future<void> reverseTransaction(Transaction row) async {
    final account = await _accountsDao.getById(row.accountId);
    if (account == null) return;

    final txnType = TransactionType.fromValue(row.type);
    final wasDebit = txnType == TransactionType.expense ||
        txnType == TransactionType.investment;
    final restoredBalance = wasDebit
        ? account.balance + row.amount
        : account.balance - row.amount;

    if (row.goalId != null) {
      await _updateGoalAmount(row.goalId!, -row.amount);
    }

    await _ledgerDao.deleteByTransactionId(row.id);
    await _transactionsDao.removeAllTagsForTransaction(row.id);
    await _transactionsDao.deleteTransaction(row.id);
    await _accountsDao.updateBalance(row.accountId, restoredBalance);

    if (account.type == AccountType.creditCard.value && wasDebit) {
      final newAmountUsed =
          ((account.amountUsed ?? 0) - row.amount).clamp(0.0, double.infinity);
      await _accountsDao.updateAmountUsed(row.accountId, newAmountUsed);
    }
  }

  Future<void> _updateGoalAmount(String goalId, double delta) async {
    final goal = await _goalsDao.getById(goalId);
    if (goal == null) return;
    final newAmount = (goal.currentAmount + delta).clamp(0.0, double.infinity);
    await _goalsDao.updateCurrentAmount(goalId, newAmount);
    final shouldBeCompleted = newAmount >= goal.targetAmount;
    if ((goal.isCompleted == 1) != shouldBeCompleted) {
      await _goalsDao.markCompleted(goalId, completed: shouldBeCompleted);
    }
  }
}
