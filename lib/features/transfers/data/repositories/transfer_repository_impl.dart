import 'dart:math';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../database/app_database.dart';
import '../../../../database/daos/accounts_dao.dart';
import '../../../../database/daos/ledger_dao.dart';
import '../../../../database/daos/transfers_dao.dart';
import '../../domain/entities/transfer_entity.dart';
import '../../domain/repositories/i_transfer_repository.dart';

@LazySingleton(as: ITransferRepository)
class TransferRepositoryImpl implements ITransferRepository {
  final AppDatabase _db;
  final TransfersDao _transfersDao;
  final AccountsDao _accountsDao;
  final LedgerDao _ledgerDao;

  TransferRepositoryImpl(
    this._db,
    this._transfersDao,
    this._accountsDao,
    this._ledgerDao,
  );

  @override
  Stream<List<TransferEntity>> watchAll() {
    return _transfersDao
        .watchAll()
        .map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<TransferEntity?> getById(String id) async {
    final row = await _transfersDao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<void> update(TransferEntity transfer) async {
    final existing = await _transfersDao.getById(transfer.id);
    if (existing == null) return;
    await _db.transaction(() async {
      await _reverseTransfer(existing);
      await _applyTransfer(transfer);
    });
  }

  @override
  Future<void> delete(String id) async {
    final row = await _transfersDao.getById(id);
    if (row == null) return;
    await _db.transaction(() async => _reverseTransfer(row));
  }

  @override
  Future<void> insert(TransferEntity transfer) async {
    await _db.transaction(() async => _applyTransfer(transfer));
  }

  Future<void> _applyTransfer(TransferEntity transfer) async {
    final fromAccount = await _accountsDao.getById(transfer.fromAccountId);
    final toAccount = await _accountsDao.getById(transfer.toAccountId);
    if (fromAccount == null || toAccount == null) {
      throw Exception('One or both accounts not found');
    }

    final amount = transfer.amount;
    final newFromBalance = fromAccount.balance - amount;
    final isToCreditCard = toAccount.type == 'credit_card';
    final newToBalance = isToCreditCard ? toAccount.balance : toAccount.balance + amount;
    final newToAmountUsed = isToCreditCard
        ? max(0.0, (toAccount.amountUsed ?? 0) - amount)
        : null;

    await _transfersDao.insertTransfer(TransfersCompanion.insert(
      id: transfer.id,
      fromAccountId: transfer.fromAccountId,
      toAccountId: transfer.toAccountId,
      amount: amount,
      description: Value(transfer.description),
      date: transfer.date,
    ));

    await _ledgerDao.insertEntry(LedgerEntriesCompanion.insert(
      id: const Uuid().v4(),
      accountId: transfer.fromAccountId,
      transferId: Value(transfer.id),
      entryType: 'debit',
      amount: amount,
      runningBalance: newFromBalance,
      date: transfer.date,
      description: Value('Transfer to ${toAccount.name}'),
    ));

    final toRunningBalance = isToCreditCard ? -(newToAmountUsed ?? 0) : newToBalance;
    await _ledgerDao.insertEntry(LedgerEntriesCompanion.insert(
      id: const Uuid().v4(),
      accountId: transfer.toAccountId,
      transferId: Value(transfer.id),
      entryType: 'credit',
      amount: amount,
      runningBalance: toRunningBalance,
      date: transfer.date,
      description: Value('Transfer from ${fromAccount.name}'),
    ));

    await _accountsDao.updateBalance(transfer.fromAccountId, newFromBalance);
    if (isToCreditCard) {
      await _accountsDao.updateAmountUsed(transfer.toAccountId, newToAmountUsed!);
    } else {
      await _accountsDao.updateBalance(transfer.toAccountId, newToBalance);
    }
  }

  Future<void> _reverseTransfer(Transfer row) async {
    final fromAccount = await _accountsDao.getById(row.fromAccountId);
    final toAccount = await _accountsDao.getById(row.toAccountId);
    if (fromAccount == null || toAccount == null) return;

    final isToCreditCard = toAccount.type == 'credit_card';
    final restoredFromBalance = fromAccount.balance + row.amount;

    await _ledgerDao.deleteByTransferId(row.id);
    await _transfersDao.deleteTransfer(row.id);
    await _accountsDao.updateBalance(row.fromAccountId, restoredFromBalance);

    if (isToCreditCard) {
      final restoredAmountUsed = (toAccount.amountUsed ?? 0) + row.amount;
      await _accountsDao.updateAmountUsed(row.toAccountId, restoredAmountUsed);
    } else {
      await _accountsDao.updateBalance(row.toAccountId, toAccount.balance - row.amount);
    }
  }

  TransferEntity _toEntity(Transfer row) {
    return TransferEntity(
      id: row.id,
      fromAccountId: row.fromAccountId,
      toAccountId: row.toAccountId,
      amount: row.amount,
      date: row.date,
      description: row.description,
    );
  }
}
