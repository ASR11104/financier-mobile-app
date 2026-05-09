import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/enums/account_type.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/accounts_dao.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/repositories/i_account_repository.dart';

@LazySingleton(as: IAccountRepository)
class AccountRepositoryImpl implements IAccountRepository {
  final AccountsDao _dao;

  AccountRepositoryImpl(this._dao);

  @override
  Stream<List<AccountEntity>> watchAllActive() {
    return _dao.watchAllActive().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Stream<AccountEntity?> watchById(String id) {
    return _dao.watchById(id).map((row) => row == null ? null : _toEntity(row));
  }

  @override
  Future<AccountEntity?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<void> insert(AccountEntity account) {
    return _dao.insertAccount(AccountsCompanion.insert(
      id: account.id,
      name: account.name,
      type: account.type.value,
      balance: Value(account.balance),
      creditLimit: Value(account.creditLimit),
      amountUsed: Value(account.amountUsed),
      icon: Value(account.icon),
      color: Value(account.color),
      notes: Value(account.notes),
    ));
  }

  @override
  Future<void> update(AccountEntity account) {
    return _dao.updateAccount(AccountsCompanion(
      id: Value(account.id),
      name: Value(account.name),
      type: Value(account.type.value),
      balance: Value(account.balance),
      creditLimit: Value(account.creditLimit),
      amountUsed: Value(account.amountUsed),
      icon: Value(account.icon),
      color: Value(account.color),
      notes: Value(account.notes),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> updateBalance(String id, double newBalance) {
    return _dao.updateBalance(id, newBalance);
  }

  @override
  Future<void> archive(String id) {
    return _dao.archiveAccount(id);
  }

  AccountEntity _toEntity(Account row) {
    return AccountEntity(
      id: row.id,
      name: row.name,
      type: AccountType.fromValue(row.type),
      balance: row.balance,
      creditLimit: row.creditLimit,
      amountUsed: row.amountUsed,
      icon: row.icon,
      color: row.color,
      isActive: row.isActive == 1,
      notes: row.notes,
      createdAt: row.createdAt,
    );
  }
}
