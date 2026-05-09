# DAOs and Queries

A DAO (Data Access Object) is a class that groups all database operations for a specific table. It keeps query logic in one place, separate from business logic and UI.

## DAO structure

Open `lib/database/daos/accounts_dao.dart`:

```dart
@DriftAccessor(tables: [Accounts])        // which tables this DAO uses
class AccountsDao extends DatabaseAccessor<AppDatabase>
    with _$AccountsDaoMixin {             // generated mixin with table accessors

  AccountsDao(super.db);                 // receives the database instance

  // Methods go here
}
```

`_$AccountsDaoMixin` (generated) gives you the `accounts` variable (a reference to the `Accounts` table) and query helpers.

## SELECT queries

```dart
// Get all accounts (returns Future)
Future<List<Account>> getAllActive() {
  return (select(accounts)
        ..where((a) => a.isActive.equals(1))
        ..orderBy([(a) => OrderingTerm.asc(a.name)]))
      .get();
}

// Get single account (returns null if not found)
Future<Account?> getById(String id) {
  return (select(accounts)..where((a) => a.id.equals(id)))
      .getSingleOrNull();
}

// With limit
Future<List<Transaction>> getRecent({int limit = 10}) {
  return (select(transactions)
        ..orderBy([(t) => OrderingTerm.desc(t.date)])
        ..limit(limit))
      .get();
}
```

## WHERE conditions

```dart
..where((a) => a.isActive.equals(1))           // isActive = 1
..where((a) => a.type.equals('credit_card'))   // type = 'credit_card'
..where((a) => a.balance.isBiggerThan(0))      // balance > 0
..where((a) => a.name.contains('HDFC'))        // LIKE '%HDFC%'

// Multiple conditions (AND):
..where((a) => a.isActive.equals(1) & a.type.equals('cash'))

// OR:
..where((a) => a.type.equals('cash') | a.type.equals('wallet'))
```

## ORDER BY

```dart
..orderBy([(a) => OrderingTerm.asc(a.name)])    // ascending
..orderBy([(t) => OrderingTerm.desc(t.date)])   // descending

// Multiple sort criteria:
..orderBy([
  (t) => OrderingTerm.desc(t.date),
  (t) => OrderingTerm.desc(t.createdAt),  // tiebreaker
])
```

## INSERT

```dart
Future<void> insertAccount(AccountsCompanion account) {
  return into(accounts).insert(account);
}

// Replace on conflict (upsert):
Future<void> upsertAccount(AccountsCompanion account) {
  return into(accounts).insertOnConflictUpdate(account);
}
```

## UPDATE

```dart
// Update specific fields
Future<void> updateBalance(String id, double newBalance) {
  return (update(accounts)..where((a) => a.id.equals(id))).write(
    AccountsCompanion(
      balance: Value(newBalance),
      updatedAt: Value(DateTime.now()),
    ),
  );
}

// Update entire row
Future<void> updateAccount(AccountsCompanion account) {
  return (update(accounts)..where((a) => a.id.equals(account.id.value)))
      .write(account);
}
```

## DELETE

```dart
// Delete by condition
Future<int> deleteTransaction(String id) {
  return (delete(transactions)..where((t) => t.id.equals(id))).go();
}
```

**Important**: Finsight never deletes accounts or categories (financial integrity). Only transactions can be deleted, and only with corresponding ledger entry cleanup in the same DB transaction.

## Tags — many-to-many pattern

Open `lib/database/daos/transactions_dao.dart`. The `setTagsForTransaction` method handles the many-to-many relationship between transactions and tags:

```dart
Future<void> setTagsForTransaction(String transactionId, List<String> tagIds) async {
  // 1. Delete existing tags for this transaction
  await (delete(transactionTags)
        ..where((tt) => tt.transactionId.equals(transactionId)))
      .go();

  // 2. Insert the new set of tags
  for (final tagId in tagIds) {
    await into(transactionTags).insert(
      TransactionTagsCompanion.insert(
        transactionId: transactionId,
        tagId: tagId,
      ),
    );
  }
}
```

Delete-all-then-reinsert is the simplest correct approach for many-to-many updates.

---

**Next:** [04-streams-vs-futures.md](04-streams-vs-futures.md)
