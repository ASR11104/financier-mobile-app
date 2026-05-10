import 'package:injectable/injectable.dart';

import '../../../../core/enums/investment_type.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../../core/services/transaction_ledger_service.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/transactions_dao.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/i_transaction_repository.dart';

@LazySingleton(as: ITransactionRepository)
class TransactionRepositoryImpl implements ITransactionRepository {
  final AppDatabase _db;
  final TransactionsDao _transactionsDao;
  final TransactionLedgerService _ledgerService;

  TransactionRepositoryImpl(
    this._db,
    this._transactionsDao,
    this._ledgerService,
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
    await _db.transaction(() async => _ledgerService.applyTransaction(txn));
  }

  @override
  Future<void> update(TransactionEntity txn) async {
    final existing = await _transactionsDao.getById(txn.id);
    if (existing == null) return;
    await _db.transaction(() async {
      await _ledgerService.reverseTransaction(existing);
      await _ledgerService.applyTransaction(txn);
    });
  }

  @override
  Future<void> delete(String id) async {
    final row = await _transactionsDao.getById(id);
    if (row == null) return;
    await _db.transaction(() async => _ledgerService.reverseTransaction(row));
  }

  TransactionEntity _toEntity(Transaction row,
      {List<String> tagIds = const []}) {
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
      goalId: row.goalId,
    );
  }
}
