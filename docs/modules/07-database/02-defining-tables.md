# Defining Tables

In Drift, you define tables as Dart classes that extend `Table`. The code generator reads these and creates the SQLite table structure.

## Basic table structure

Open `lib/database/tables/accounts_table.dart`:

```dart
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()();
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  RealColumn get creditLimit => real().nullable()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
```

Each getter defines a column. The double `()()` at the end is Drift's builder pattern — the first `()` configures the column, the second `()` builds it.

## Column types

| Dart type | Drift builder | SQLite type |
|-----------|---------------|-------------|
| `String` | `TextColumn text()` | TEXT |
| `int` | `IntColumn integer()` | INTEGER |
| `double` | `RealColumn real()` | REAL |
| `bool` | `BoolColumn boolean()` | INTEGER (0/1) |
| `DateTime` | `DateTimeColumn dateTime()` | INTEGER (unix timestamp) |
| `Uint8List` | `BlobColumn blob()` | BLOB |

## Column modifiers

```dart
text()                              // required TEXT
text().nullable()                   // nullable TEXT (can be NULL)
text().withLength(min: 1, max: 100) // length validation
text().withDefault(Constant(''))    // default value
integer().withDefault(Constant(1))  // default = 1
real().withDefault(Constant(0.0))   // default = 0.0
dateTime().withDefault(currentDateAndTime)  // default = now
```

## Primary key

By default, Drift creates an `id` integer autoincrement. To use a UUID text primary key (as Finsight does):

```dart
@override
Set<Column> get primaryKey => {id};
```

This tells Drift to use the `id` column as the primary key instead of generating one.

## Foreign keys (references)

Open `lib/database/tables/transactions_table.dart`:

```dart
TextColumn get accountId =>
    text().references(Accounts, #id)();

TextColumn get categoryId =>
    text().references(Categories, #id)();
```

`.references(Accounts, #id)` means:
- This column links to the `Accounts` table
- Specifically to the `id` column (the `#id` is a Dart symbol)
- SQLite enforces this: you can't insert a transaction with an `accountId` that doesn't exist in `Accounts`

## The 8 tables in Finsight

| Table class | Generated data class | Purpose |
|-------------|----------------------|---------|
| `Accounts` | `Account` | Bank accounts, credit cards, cash |
| `Transactions` | `Transaction` | Expenses, income, investments |
| `Transfers` | `Transfer` | Money moved between accounts |
| `LedgerEntries` | `LedgerEntry` | Double-entry bookkeeping (source of truth) |
| `Categories` | `Category` | Transaction categories |
| `Tags` | `Tag` | User labels for transactions |
| `TransactionTags` | `TransactionTag` | Many-to-many: transactions ↔ tags |
| `UserPreferences` | `UserPreference` | App settings (singleton row) |

Drift generates the **data class** (e.g., `Account`) from the table class (`Accounts`). The data class is what you work with in your Dart code.

## Companion objects

For inserting or partially updating, Drift generates a **Companion** class:

```dart
// AccountsCompanion — for insert/update
AccountsCompanion(
  id: Value('some-uuid'),           // set this field
  name: Value('HDFC Savings'),      // set this field
  type: Value('bank_account'),      // set this field
  // balance not set = use column's default (0.0)
)
```

`Value<T>` wraps a value to indicate "I'm explicitly setting this". Fields not included use their defaults. This is important for partial updates:

```dart
// Only update the balance — leave everything else unchanged
AccountsCompanion(
  balance: Value(newBalance),
  updatedAt: Value(DateTime.now()),
  // id, name, type, etc. NOT included = unchanged
)
```

---

**Next:** [03-daos-and-queries.md](03-daos-and-queries.md)
