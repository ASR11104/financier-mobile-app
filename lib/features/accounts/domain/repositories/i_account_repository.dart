import '../entities/account_entity.dart';

abstract class IAccountRepository {
  Stream<List<AccountEntity>> watchAllActive();
  Stream<AccountEntity?> watchById(String id);
  Future<AccountEntity?> getById(String id);
  Future<void> insert(AccountEntity account);
  Future<void> update(AccountEntity account);
  Future<void> updateBalance(String id, double newBalance);
  Future<void> archive(String id);
}
