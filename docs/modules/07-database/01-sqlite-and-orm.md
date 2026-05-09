# SQLite and ORM

## What is SQLite?

SQLite is a database that lives in a single file on the device — no server, no network connection needed. It's used in almost every mobile app: WhatsApp, Firefox, and thousands of other apps store data in SQLite.

In Finsight, all financial data (accounts, transactions, categories, ledger entries) lives in a file called `finsight_db.sqlite` on the user's phone.

SQLite data is organized in **tables** (like spreadsheet sheets) with **rows** (individual records) and **columns** (fields):

```
accounts table:
┌──────────────────────────────────────────────────────┐
│ id          │ name             │ type         │ balance │
├─────────────┼──────────────────┼──────────────┼─────────┤
│ uuid-abc... │ HDFC Savings     │ bank_account │ 25000.0 │
│ uuid-def... │ ICICI Credit     │ credit_card  │ 0.0     │
│ uuid-ghi... │ Cash Wallet      │ cash         │ 5000.0  │
└─────────────┴──────────────────┴──────────────┴─────────┘
```

You normally query SQLite with **SQL** (Structured Query Language):
```sql
SELECT id, name, balance FROM accounts WHERE is_active = 1 ORDER BY name;
```

## What is an ORM?

An ORM (Object-Relational Mapper) lets you work with the database using regular Dart objects instead of writing raw SQL strings.

Without ORM — raw SQL (fragile, verbose):
```dart
final result = await db.rawQuery(
  'SELECT * FROM accounts WHERE is_active = ? ORDER BY name',
  [1],
);
// result is List<Map<String, dynamic>> — must manually extract fields
final name = result[0]['name'] as String;
```

With Drift ORM — type-safe Dart:
```dart
final accounts = await (select(accounts)
      ..where((a) => a.isActive.equals(1))
      ..orderBy([(a) => OrderingTerm.asc(a.name)]))
    .get();
// accounts is List<Account> — a proper Dart object with typed fields
final name = accounts[0].name;  // String, compiler-verified
```

The ORM benefits:
- **Type safety** — compiler catches column name typos and wrong types
- **Refactoring support** — rename a column, IDE updates all references
- **Streams** — Drift can emit new query results whenever the underlying data changes (raw SQL can't do this)

## Drift specifically

Drift (formerly called Moor) is Flutter's most popular ORM. It:
- Uses code generation to create type-safe query builders
- Returns Dart objects (not raw maps)
- Supports reactive queries (`Stream` via `.watch()`)
- Handles migrations (upgrading old database schemas)
- Runs all queries on a background isolate (doesn't block the UI)

## The database file

On Android, `finsight_db.sqlite` is stored in the app's private data directory (`/data/data/com.yourapp.finsight/databases/`). It's not accessible to other apps and is deleted when the app is uninstalled.

---

**Next:** [02-defining-tables.md](02-defining-tables.md)
