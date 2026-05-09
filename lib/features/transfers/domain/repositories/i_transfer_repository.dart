import '../entities/transfer_entity.dart';

abstract class ITransferRepository {
  Stream<List<TransferEntity>> watchAll();
  Future<void> insert(TransferEntity transfer);
}
