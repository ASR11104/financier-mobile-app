import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/enums/investment_type.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/accounts_dao.dart';
import '../../../../database/daos/ledger_dao.dart';
import '../../../../database/daos/transactions_dao.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/i_transaction_repository.dart';

@LazySingleton(as: ITransactionRepository)
class TransactionRepositoryImpl implements ITransactionRepository {
  final AppDatabase _db;
  final TransactionsDao _transactionsDao;
  final LedgerDao _ledgerDao;
  final AccountsDao _accountsDao;

  TransactionRepositoryImpl(
    this._db,
    this._transactionsDao,
    this._ledgerDao,
    this._accountsDao,
  );

  @override
  Stream<List<TransactionEntity>> watchAll() {
    return _transactionsDao
        .watchAll()
        .map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Stream<List<TransactionEntity>> watchByType(String type) {
    return _transactionsDao
        .watchByType(type)
        .map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<List<TransactionEntity>> getRecent({int limit = 10}) async {
    final rows = await _transactionsDao.getRecent(limit: limit);
    return rows.map(_toEntity).toList();
  }

  @override
  Future<TransactionEntity?> getById(String id) async {
    final row = await _transactionsDao.getById(id);
    if (row == null) return null;
    final tagRows = await _transactionsDao.getTagsForTransaction(id);
    return _toEntity(row, tagIds: tagRows.map((t) => t.tagId).toList());
  }

  @override
  Future<void> insert(TransactionEntity txn) async {
    final account = await _accountsDao.getById(txn.accountId);
    if (account == null) throw Exception('Account not found');

    final isDebit = txn.type == TransactionType.expense ||
        txn.type == TransactionType.investment;
    final entryType = isDebit ? 'debit' : 'credit';
    final newBalance = isDebit
        ? account.balance - txn.amount
        : account.balance + txn.amount;

    await _db.transaction(() async {
      await _transactionsDao.insertTransaction(TransactionsCompanion.insert(
        id: txn.id,
        type: txn.type.value,
        amount: txn.amount,
        accountId: txn.accountId,
        categoryId: txn.categoryId,
        description: Value(txn.description),
        date: txn.date,
        investmentType: Value(txn.investmentType?.value),
      ));

      if (txn.tagIds.isNotEmpty) {
        await _transactionsDao.setTagsForTransaction(txn.id, txn.tagIds);
      }

      await _ledgerDao.insertEntry(LedgerEntriesCompanion.insert(
        id: const Uuid().v4(),
        accountId: txn.accountId,
        transactionId: Value(txn.id),
        entryType: entryType,
        amount: txn.amount,
        runningBalance: newBalance,
        date: txn.date,
        description: Value(
          txn.description.isNotEmpty ? txn.description : txn.type.label,
        ),
      ));

      await _accountsDao.updateBalance(txn.accountId, newBalance);
    });
  }

  @override
  Future<void> delete(String id) async {
    final row = await _transactionsDao.getById(id);
    if (row == null) return;

    final account = await _accountsDao.getById(row.accountId);
    if (account == null) return;

    final isDebit = row.type == TransactionType.expense.value ||
        row.type == TransactionType.investment.value;
    final reversedBalance = isDebit
        ? account.balance + row.amount
        : account.balance - row.amount;

    await _db.transaction(() async {
      await _ledgerDao.deleteByTransactionId(id);
      await _transactionsDao.removeAllTagsForTransaction(id);
      await _transactionsDao.deleteTransaction(id);
      await _accountsDao.updateBalance(row.accountId, reversedBalance);
    });
  }

  TransactionEntity _toEntity(Transaction row, {List<String> tagIds = const []}) {
    return TransactionEntity(
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
      tagIds: tagIds,
    );
  }
}
