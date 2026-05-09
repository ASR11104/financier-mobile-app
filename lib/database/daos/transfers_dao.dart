import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/transfers_table.dart';

part 'transfers_dao.g.dart';

/// Data Access Object for the [Transfers] table.
@DriftAccessor(tables: [Transfers])
class TransfersDao extends DatabaseAccessor<AppDatabase>
    with _$TransfersDaoMixin {
  TransfersDao(super.db);

  /// Watch all transfers ordered by date (newest first).
  Stream<List<Transfer>> watchAll() {
    return (select(transfers)
          ..orderBy([
            (t) => OrderingTerm.desc(t.date),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  /// Get a single transfer by ID.
  Future<Transfer?> getById(String id) {
    return (select(transfers)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Insert a new transfer.
  Future<void> insertTransfer(TransfersCompanion transfer) {
    return into(transfers).insert(transfer);
  }

  /// Delete a transfer by ID.
  Future<int> deleteTransfer(String id) {
    return (delete(transfers)..where((t) => t.id.equals(id))).go();
  }
}
