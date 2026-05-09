# Migrations and Atomic Transactions

Two of the most important database concepts for a finance app: how to evolve the schema safely, and how to ensure multiple operations succeed or fail together.

## Schema Migrations

When you ship version 1 of the app with schema version 1, users install it and data accumulates. When you release version 2 with a new column (e.g., `notes` on accounts), existing users already have the old database — you can't just create fresh tables.

**Migrations** define how to upgrade the old schema to the new one.

### In Finsight (`app_database.dart`):

```dart
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 1;   // ← increment this when you change tables

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();   // first install — create all tables from scratch
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Runs when an existing user upgrades — 'from' is their current version
      if (from < 2) {
        // Adding a new 'notes' column to accounts in version 2
        await m.addColumn(accounts, accounts.notes);
      }
      if (from < 3) {
        // Creating a new table in version 3
        await m.createTable(budgets);
      }
    },
  );
}
```

### Migration rules
1. **Increment `schemaVersion`** when you add/remove/change any table or column.
2. **Always add to `onUpgrade`** — describe how to upgrade from the previous version.
3. **Test migrations** — create a test database at version N, run migrations, verify the result.
4. **Never remove columns** from existing tables (breaks old app installs if an upgrade fails mid-way). Mark them as deprecated instead.

### What you cannot do in SQLite migrations
- Rename a column (SQLite doesn't support `ALTER TABLE RENAME COLUMN` in all versions)
- Remove a column
- Change a column type

Workarounds: create a new table, copy data, drop old table — or just add new columns and stop using the old ones.

## Atomic Transactions

An atomic transaction is a group of database operations that either **all succeed** or **all fail together**. It's the most critical concept for financial data integrity.

**The problem without transactions:**

```dart
// WRONG — if the app crashes after step 1 but before step 3:
await transactionsDao.insertTransaction(txn);   // ✓ saved
await ledgerDao.insertEntry(ledgerEntry);         // ← crash here
await accountsDao.updateBalance(accountId, bal); // ✗ never runs
// Result: transaction exists but ledger entry and balance are wrong
```

**The solution — wrap in `db.transaction()`:**

```dart
// CORRECT — all succeed or all fail
await db.transaction(() async {
  await transactionsDao.insertTransaction(txn);
  await ledgerDao.insertEntry(ledgerEntry);
  await accountsDao.updateBalance(accountId, bal);
  // If any of these throw, ALL changes are rolled back
});
```

If anything throws an error inside `db.transaction()`, SQLite **rolls back** all changes — as if none of them happened. This prevents partial state that would corrupt the ledger.

### Finsight's integrity rule

Every operation that changes an account balance must follow this pattern:

```dart
// Adding a transaction
await db.transaction(() async {
  // 1. Insert the transaction record
  await db.transactionsDao.insertTransaction(transactionCompanion);

  // 2. Create the ledger entry
  await db.ledgerDao.insertEntry(ledgerEntryCompanion);

  // 3. Update the cached balance
  await db.accountsDao.updateBalance(accountId, newBalance);
});
```

```dart
// Deleting a transaction (reverse all effects)
await db.transaction(() async {
  // 1. Delete the ledger entry
  await db.ledgerDao.deleteByTransactionId(transactionId);

  // 2. Recalculate and update the balance
  final newBalance = await db.ledgerDao.computeBalanceForAccount(accountId);
  await db.accountsDao.updateBalance(accountId, newBalance);

  // 3. Delete the transaction
  await db.transactionsDao.deleteTransaction(transactionId);
});
```

```dart
// Transfer between accounts (affects two accounts)
await db.transaction(() async {
  await db.transfersDao.insertTransfer(transferCompanion);

  // Debit from source account
  await db.ledgerDao.insertEntry(debitEntry);
  await db.accountsDao.updateBalance(fromAccountId, newFromBalance);

  // Credit to destination account
  await db.ledgerDao.insertEntry(creditEntry);
  await db.accountsDao.updateBalance(toAccountId, newToBalance);
});
```

### Why the ledger exists

`LedgerEntries` is the double-entry bookkeeping table. Every money movement creates an entry here. The `runningBalance` field on each entry means you can reconstruct the exact account balance at any point in time — even if the cached `balance` column on `Accounts` ever gets out of sync, you can recompute it from ledger entries via `LedgerDao.computeBalanceForAccount()`.

---

## Exercises

1. What happens to the database if you change a table column type without incrementing `schemaVersion`?
2. In `lib/database/daos/ledger_dao.dart`, find `computeBalanceForAccount`. How does it work? When would you call it?
3. Write the pseudocode for adding an income transaction: what 3 operations must be in the `db.transaction()` call, and in what order?

**You've completed Module 07!** Move on to [Module 08 — Code Generation](../08-code-generation/README.md).
