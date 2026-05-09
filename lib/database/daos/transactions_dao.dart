import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/transaction_tags_table.dart';
import '../tables/transactions_table.dart';

part 'transactions_dao.g.dart';

/// Data Access Object for the [Transactions] and [TransactionTags] tables.
@DriftAccessor(tables: [Transactions, TransactionTags])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  /// Watch all transactions ordered by date (newest first).
  Stream<List<Transaction>> watchAll() {
    return (select(transactions)
          ..orderBy([
            (t) => OrderingTerm.desc(t.date),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  /// Watch transactions filtered by type.
  Stream<List<Transaction>> watchByType(String type) {
    return (select(transactions)
          ..where((t) => t.type.equals(type))
          ..orderBy([
            (t) => OrderingTerm.desc(t.date),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  /// Watch transactions for a specific account.
  Stream<List<Transaction>> watchByAccount(String accountId) {
    return (select(transactions)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.date),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  /// Get recent transactions (limited count).
  Future<List<Transaction>> getRecent({int limit = 10}) {
    return (select(transactions)
          ..orderBy([
            (t) => OrderingTerm.desc(t.date),
            (t) => OrderingTerm.desc(t.createdAt),
          ])
          ..limit(limit))
        .get();
  }

  /// Get a single transaction by ID.
  Future<Transaction?> getById(String id) {
    return (select(transactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Insert a new transaction.
  Future<void> insertTransaction(TransactionsCompanion txn) {
    return into(transactions).insert(txn);
  }

  /// Update an existing transaction.
  Future<void> updateTransaction(TransactionsCompanion txn) {
    return (update(transactions)..where((t) => t.id.equals(txn.id.value)))
        .write(txn);
  }

  /// Delete a transaction by ID.
  Future<int> deleteTransaction(String id) {
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  /// Get tags for a specific transaction.
  Future<List<TransactionTag>> getTagsForTransaction(String transactionId) {
    return (select(transactionTags)
          ..where((tt) => tt.transactionId.equals(transactionId)))
        .get();
  }

  /// Set tags for a transaction (replaces existing).
  Future<void> setTagsForTransaction(
    String transactionId,
    List<String> tagIds,
  ) async {
    await (delete(transactionTags)
          ..where((tt) => tt.transactionId.equals(transactionId)))
        .go();

    for (final tagId in tagIds) {
      await into(transactionTags).insert(
        TransactionTagsCompanion.insert(
          transactionId: transactionId,
          tagId: tagId,
        ),
      );
    }
  }

  /// Remove all tags for a transaction.
  Future<void> removeAllTagsForTransaction(String transactionId) {
    return (delete(transactionTags)
          ..where((tt) => tt.transactionId.equals(transactionId)))
        .go();
  }
}
