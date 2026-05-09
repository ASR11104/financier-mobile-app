import '../entities/transaction_entity.dart';

abstract class ITransactionRepository {
  Stream<List<TransactionEntity>> watchAll();
  Stream<List<TransactionEntity>> watchByType(String type);
  Future<List<TransactionEntity>> getRecent({int limit = 10});
  Future<TransactionEntity?> getById(String id);
  Future<void> insert(TransactionEntity transaction);
  Future<void> delete(String id);
}
