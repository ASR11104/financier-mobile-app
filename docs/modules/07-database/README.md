# Module 07 — Database with Drift

Finsight stores all data locally on the device using SQLite via the **Drift** ORM. This module explains the database layer in detail.

## Topics in this module

| File | What it covers |
|------|----------------|
| [01-sqlite-and-orm.md](01-sqlite-and-orm.md) | What SQLite is, what an ORM does |
| [02-defining-tables.md](02-defining-tables.md) | Drift table classes, column types, relationships |
| [03-daos-and-queries.md](03-daos-and-queries.md) | DAOs, select/insert/update/delete queries |
| [04-streams-vs-futures.md](04-streams-vs-futures.md) | .watch() vs .get(), when to use each |
| [05-migrations-and-transactions.md](05-migrations-and-transactions.md) | Schema migrations, atomic DB transactions |

## Project files to read alongside this module

- `lib/database/app_database.dart` — main database class
- `lib/database/tables/accounts_table.dart` — a simple table
- `lib/database/tables/transactions_table.dart` — table with foreign keys
- `lib/database/daos/accounts_dao.dart` — full DAO example
- `lib/database/daos/ledger_dao.dart` — the integrity-critical DAO

## Exercise for this module

Add a new DAO method to `AccountsDao`:

```dart
/// Returns all credit card accounts.
Future<List<Account>> getCreditCards() {
  return (select(accounts)
        ..where((a) => a.type.equals('credit_card'))
        ..where((a) => a.isActive.equals(1)))
      .get();
}
```

Run `flutter analyze` to verify the code is correct. (You don't need to run build_runner for this — DAO methods don't require code generation.)
