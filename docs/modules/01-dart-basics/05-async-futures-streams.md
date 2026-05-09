# Async, Futures, and Streams

Mobile apps constantly do things that take time — reading from disk, waiting for user input. Dart handles this without freezing the UI using an async model.

## The problem with blocking

Imagine reading a large file synchronously (blocking):

```dart
// If this takes 2 seconds, the whole UI freezes for 2 seconds
final data = File('big_file.txt').readAsStringSync();  // BLOCKING — bad
```

Dart's solution: mark time-consuming operations as `async` and use `await` to pause only that function — not the whole app.

## Future — one value, delivered later

A `Future<T>` is a promise to return a value of type `T` at some point in the future. Like ordering food — you don't get it immediately, but you will.

```dart
Future<String> fetchUserName() async {
  await Future.delayed(Duration(seconds: 1));  // simulate waiting
  return 'Akhil';
}

// Calling it:
final name = await fetchUserName();  // waits 1 second, then continues
print(name);  // 'Akhil'
```

### Rules of async/await

- A function that uses `await` must be marked `async`.
- An `async` function always returns a `Future`.
- You can only `await` inside an `async` function.

```dart
// This function is async because it uses await
Future<List<Account>> loadAccounts() async {
  final accounts = await accountsDao.getAllActive();  // waits for DB
  return accounts;
}
```

### In Finsight — DAO methods

Open `lib/database/daos/accounts_dao.dart`:

```dart
// Returns Future — fetches data once and done
Future<List<Account>> getAllActive() {
  return (select(accounts)
        ..where((a) => a.isActive.equals(1)))
      .get();   // .get() returns a Future
}

Future<Account?> getById(String id) {
  return (select(accounts)..where((a) => a.id.equals(id)))
      .getSingleOrNull();  // returns null if not found
}
```

## Stream — many values over time

A `Stream<T>` emits a sequence of values over time. Unlike a `Future` (which delivers once), a Stream keeps delivering new values whenever the source changes.

**Analogy**: `Future` is a text message (one response). `Stream` is a live TV channel (continuous updates).

```dart
// A stream that emits a number every second
Stream<int> countUp() async* {
  int i = 0;
  while (true) {
    yield i++;                          // emit a value
    await Future.delayed(Duration(seconds: 1));
  }
}

// Listening to a stream:
countUp().listen((value) {
  print(value);  // prints 0, 1, 2, 3, ... every second
});
```

### In Finsight — watching the database

The most important use of Streams in Finsight is in the DAOs. Drift's `.watch()` method returns a `Stream` that emits a new list every time the table changes:

```dart
// From accounts_dao.dart
Stream<List<Account>> watchAllActive() {
  return (select(accounts)
        ..where((a) => a.isActive.equals(1)))
      .watch();  // .watch() returns a Stream — live updates!
}
```

When connected to a Riverpod `StreamProvider`, this means:
1. User adds a new account → database table changes
2. Drift emits a new `List<Account>` through the stream
3. Riverpod updates the UI automatically

You get real-time UI updates for free — no manual refresh needed.

## `.get()` vs `.watch()` — when to use each

| | `.get()` | `.watch()` |
|---|---|---|
| Returns | `Future<List<T>>` | `Stream<List<T>>` |
| Fires | Once | Every time data changes |
| Use for | Loading a form, one-time read | Displaying lists that must stay current |

### Rule of thumb
- Use `.watch()` for screens that display data (lists, dashboards, account details).
- Use `.get()` for one-time reads inside business logic (e.g., fetching a record before deleting it).

## Handling async results in Flutter

You can't use `await` directly inside a `build()` method. Instead, use `FutureBuilder` or (in Finsight) Riverpod providers:

```dart
// Without Riverpod (raw Flutter):
FutureBuilder<List<Account>>(
  future: accountsDao.getAllActive(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    return AccountsList(accounts: snapshot.data!);
  },
)

// With Riverpod (the Finsight way — much cleaner):
final accountsAsync = ref.watch(accountsProvider);
accountsAsync.when(
  data: (accounts) => AccountsList(accounts: accounts),
  loading: () => CircularProgressIndicator(),
  error: (e, _) => Text('Error: $e'),
)
```

---

## Exercises

1. In `lib/database/daos/transactions_dao.dart`, find all methods that return a `Future` and all that return a `Stream`. What pattern do you notice about which ones return which?
2. In `lib/database/daos/ledger_dao.dart`, `computeBalanceForAccount` uses a loop over a list of entries. Why does it need to be `async`?
3. What happens to the UI if you use `.get()` for a list of accounts instead of `.watch()`? (Think: would a newly added account appear without restarting the app?)

**Next:** [06-dart-special-syntax.md](06-dart-special-syntax.md)
