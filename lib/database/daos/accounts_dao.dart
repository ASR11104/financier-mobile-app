import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/accounts_table.dart';

part 'accounts_dao.g.dart';

/// Data Access Object for the [Accounts] table.
@DriftAccessor(tables: [Accounts])
class AccountsDao extends DatabaseAccessor<AppDatabase>
    with _$AccountsDaoMixin {
  AccountsDao(super.db);

  /// Watch all active accounts, ordered by name.
  Stream<List<Account>> watchAllActive() {
    return (select(accounts)
          ..where((a) => a.isActive.equals(1))
          ..orderBy([(a) => OrderingTerm.asc(a.name)]))
        .watch();
  }

  /// Get all active accounts.
  Future<List<Account>> getAllActive() {
    return (select(accounts)
          ..where((a) => a.isActive.equals(1))
          ..orderBy([(a) => OrderingTerm.asc(a.name)]))
        .get();
  }

  /// Get a single account by ID.
  Future<Account?> getById(String id) {
    return (select(accounts)..where((a) => a.id.equals(id)))
        .getSingleOrNull();
  }

  /// Watch a single account by ID.
  Stream<Account?> watchById(String id) {
    return (select(accounts)..where((a) => a.id.equals(id)))
        .watchSingleOrNull();
  }

  /// Insert a new account.
  Future<void> insertAccount(AccountsCompanion account) {
    return into(accounts).insert(account);
  }

  /// Update an existing account.
  Future<void> updateAccount(AccountsCompanion account) {
    return (update(accounts)..where((a) => a.id.equals(account.id.value)))
        .write(account);
  }

  /// Update only the balance of an account (used during ledger operations).
  Future<void> updateBalance(String id, double newBalance) {
    return (update(accounts)..where((a) => a.id.equals(id))).write(
      AccountsCompanion(
        balance: Value(newBalance),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update the amount used on a credit card.
  Future<void> updateAmountUsed(String id, double newAmountUsed) {
    return (update(accounts)..where((a) => a.id.equals(id))).write(
      AccountsCompanion(
        amountUsed: Value(newAmountUsed),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Archive an account (soft delete).
  Future<void> archiveAccount(String id) {
    return (update(accounts)..where((a) => a.id.equals(id))).write(
      AccountsCompanion(
        isActive: const Value(0),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
