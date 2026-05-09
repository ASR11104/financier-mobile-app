import '../entities/transfer_entity.dart';

abstract class ITransferRepository {
  Stream<List<TransferEntity>> watchAll();
  Future<TransferEntity?> getById(String id);
  Future<void> insert(TransferEntity transfer);
  Future<void> update(TransferEntity transfer);
  Future<void> delete(String id);
}
