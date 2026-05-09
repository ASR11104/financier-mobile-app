# Streams vs Futures in Drift

The key design choice in every DAO method is whether to return a `Future` (fetch once) or a `Stream` (live updates). This decision directly affects how reactive your UI is.

## .get() — returns Future

Executes the query once and returns the result. Does not re-run when the data changes.

```dart
Future<List<Account>> getAllActive() {
  return (select(accounts)
        ..where((a) => a.isActive.equals(1)))
      .get();     // ← .get() = Future
}
```

**Use `.get()` when:**
- Loading data for a form (you need to pre-fill fields once)
- Computing a one-time value (e.g., total balance for a report)
- Checking whether a record exists before inserting
- Inside a `db.transaction()` block

## .watch() — returns Stream

Re-runs the query and emits a new result every time the underlying table data changes.

```dart
Stream<List<Account>> watchAllActive() {
  return (select(accounts)
        ..where((a) => a.isActive.equals(1)))
      .watch();   // ← .watch() = Stream
}
```

**Use `.watch()` when:**
- Displaying a list that must stay current (accounts list, transaction feed)
- Showing a summary that should update in real time (total balance, monthly spend)
- Connecting to a Riverpod `StreamProvider`

## How Drift's reactive streams work

Drift tracks which tables each query touches. When you call `into(accounts).insert(...)` or `update(accounts)...`, Drift knows the `accounts` table changed. It then re-runs all active `.watch()` queries that touch that table and emits new results to their streams.

This means:
- Add a transaction → both `watchAllActive()` (accounts) AND `watchAll()` (transactions) emit new results automatically
- You write nothing extra to keep the UI in sync

## The common misconception

Many beginners use `.get()` everywhere because it feels simpler. The problem:

```dart
// WRONG for a list screen — only loads once
final accountsProvider = FutureProvider((ref) {
  return ref.watch(accountsDaoProvider).getAllActive();  // .get()
});

// Add a new account → the list doesn't update (no re-fetch triggered)
```

```dart
// CORRECT for a list screen — live updates
final accountsProvider = StreamProvider((ref) {
  return ref.watch(accountsDaoProvider).watchAllActive();  // .watch()
});

// Add a new account → stream emits new list → UI rebuilds automatically
```

## Rule of thumb

| Where it's used | Which to use |
|----------------|--------------|
| Displaying a list/screen | `.watch()` → `StreamProvider` |
| Displaying a detail view | `.watch()` → `StreamProvider` |
| One-time data for a form | `.get()` → `FutureProvider` or `await` in a callback |
| Inside `db.transaction()` | `.get()` — streams don't make sense in transactions |
| Computing a report/export | `.get()` — you want a snapshot, not live data |

## `.watchSingleOrNull()` — stream for a single row

For a detail page that watches one record:

```dart
Stream<Account?> watchById(String id) {
  return (select(accounts)..where((a) => a.id.equals(id)))
      .watchSingleOrNull();  // emits Account? — null if deleted
}
```

If the account is deleted while the detail page is open, the stream emits `null` — you can handle this by navigating back.

---

**Next:** [05-migrations-and-transactions.md](05-migrations-and-transactions.md)
