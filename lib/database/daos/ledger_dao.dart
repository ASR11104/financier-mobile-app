import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/ledger_entries_table.dart';

part 'ledger_dao.g.dart';

/// Data Access Object for the [LedgerEntries] table.
///
/// The ledger is the source of truth for all account balances.
/// Every money movement creates entries here.
@DriftAccessor(tables: [LedgerEntries])
class LedgerDao extends DatabaseAccessor<AppDatabase>
    with _$LedgerDaoMixin {
  LedgerDao(super.db);

  /// Watch all ledger entries for an account, ordered by date (newest first).
  Stream<List<LedgerEntry>> watchByAccount(String accountId) {
    return (select(ledgerEntries)
          ..where((e) => e.accountId.equals(accountId))
          ..orderBy([
            (e) => OrderingTerm.desc(e.date),
            (e) => OrderingTerm.desc(e.createdAt),
          ]))
        .watch();
  }

  /// Get the latest ledger entry for an account (to read running balance).
  Future<LedgerEntry?> getLatestForAccount(String accountId) {
    return (select(ledgerEntries)
          ..where((e) => e.accountId.equals(accountId))
          ..orderBy([(e) => OrderingTerm.desc(e.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Get all ledger entries for a specific transaction.
  Future<List<LedgerEntry>> getByTransactionId(String transactionId) {
    return (select(ledgerEntries)
          ..where((e) => e.transactionId.equals(transactionId)))
        .get();
  }

  /// Get all ledger entries for a specific transfer.
  Future<List<LedgerEntry>> getByTransferId(String transferId) {
    return (select(ledgerEntries)
          ..where((e) => e.transferId.equals(transferId)))
        .get();
  }

  /// Insert a new ledger entry.
  Future<void> insertEntry(LedgerEntriesCompanion entry) {
    return into(ledgerEntries).insert(entry);
  }

  /// Delete ledger entries for a specific transaction.
  Future<int> deleteByTransactionId(String transactionId) {
    return (delete(ledgerEntries)
          ..where((e) => e.transactionId.equals(transactionId)))
        .go();
  }

  /// Delete ledger entries for a specific transfer.
  Future<int> deleteByTransferId(String transferId) {
    return (delete(ledgerEntries)
          ..where((e) => e.transferId.equals(transferId)))
        .go();
  }

  /// Compute the balance for an account by summing ledger entries.
  /// This can be used to verify the cached balance on the account.
  ///
  /// Returns the computed balance (credits - debits).
  Future<double> computeBalanceForAccount(String accountId) async {
    final entries = await (select(ledgerEntries)
          ..where((e) => e.accountId.equals(accountId)))
        .get();

    double balance = 0;
    for (final entry in entries) {
      if (entry.entryType == 'credit') {
        balance += entry.amount;
      } else {
        balance -= entry.amount;
      }
    }
    return balance;
  }
}
